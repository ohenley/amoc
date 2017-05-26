-----------------------------------------------------------------------
--
--  File:        nt_console.adb
--  Description: Win95/NT console support
--  Rev:         0.3
--  Date:        08-june-1999
--  Author:      Jerry van Dijk
--  Mail:        jdijk@acm.org
--
--  Copyright (c) Jerry van Dijk, 1997, 1998, 1999
--  Billie Holidaystraat 28
--  2324 LK  LEIDEN
--  THE NETHERLANDS
--  tel int + 31 71 531 43 65
--
--  Permission granted to use for any purpose, provided this copyright
--  remains attached and unmodified.
--
--  THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
--  IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
--  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--
-----------------------------------------------------------------------

pragma C_Pass_By_Copy (128);

with Interfaces; use Interfaces;

package body NT_Console is

   pragma Linker_Options ("-luser32");

   ---------------------
   -- WIN32 INTERFACE --
   ---------------------

   Beep_Error            : exception;
   Fill_Char_Error       : exception;
   Cursor_Get_Error      : exception;
   Cursor_Set_Error      : exception;
   Cursor_Pos_Error      : exception;
   Buffer_Info_Error     : exception;
   Set_Attribute_Error   : exception;
   Invalid_Handle_Error  : exception;
   Fill_Attribute_Error  : exception;
   Cursor_Position_Error : exception;

   subtype DWORD  is  Unsigned_32;
   subtype HANDLE is  Unsigned_32;
   subtype WORD   is  Unsigned_16;
   subtype SHORT  is  Short_Integer;
   subtype WINBOOL is Integer;

   type LPDWORD is access all DWORD;
   pragma Convention (C, LPDWORD);

   type Nibble is mod 2 ** 4;
   for Nibble'Size use 4;

   type Attribute is
      record
         Foreground : Nibble;
         Background : Nibble;
         Reserved   : Unsigned_8 := 0;
      end record;

   for Attribute use
      record
         Foreground at 0 range 0 .. 3;
         Background at 0 range 4 .. 7;
         Reserved   at 1 range 0 .. 7;
      end record;

   for Attribute'Size use 16;
   pragma Convention (C, Attribute);

   type COORD is
      record
         X : SHORT;
         Y : SHORT;
      end record;
   pragma Convention (C, COORD);

   type SMALL_RECT is
      record
         Left   : SHORT;
         Top    : SHORT;
         Right  : SHORT;
         Bottom : SHORT;
      end record;
   pragma Convention (C, SMALL_RECT);

   type CONSOLE_SCREEN_BUFFER_INFO is
      record
         Size       : COORD;
         Cursor_Pos : COORD;
         Attrib     : Attribute;
         Window     : SMALL_RECT;
         Max_Size   : COORD;
      end record;
   pragma Convention (C, CONSOLE_SCREEN_BUFFER_INFO);

   type PCONSOLE_SCREEN_BUFFER_INFO is access all CONSOLE_SCREEN_BUFFER_INFO;
   pragma Convention (C, PCONSOLE_SCREEN_BUFFER_INFO);

   type CONSOLE_CURSOR_INFO is
      record
         Size    : DWORD;
         Visible : WINBOOL;
      end record;
   pragma Convention (C, CONSOLE_CURSOR_INFO);

   type PCONSOLE_CURSOR_INFO is access all CONSOLE_CURSOR_INFO;
   pragma Convention (C, PCONSOLE_CURSOR_INFO);

   function GetCh return Integer;
   pragma Import (C, GetCh, "_getch");

   function KbHit return Integer;
   pragma Import (C, KbHit, "_kbhit");

   function MessageBeep (Kind : DWORD) return DWORD;
   pragma Import (StdCall, MessageBeep, "MessageBeep");

   function GetStdHandle (Value : DWORD) return HANDLE;
   pragma Import (StdCall, GetStdHandle, "GetStdHandle");

   function GetConsoleCursorInfo (Buffer : HANDLE; Cursor : PCONSOLE_CURSOR_INFO) return WINBOOL;
   pragma Import (StdCall, GetConsoleCursorInfo, "GetConsoleCursorInfo");

   function SetConsoleCursorInfo (Buffer : HANDLE; Cursor : PCONSOLE_CURSOR_INFO) return WINBOOL;
   pragma Import (StdCall, SetConsoleCursorInfo, "SetConsoleCursorInfo");

   function SetConsoleCursorPosition (Buffer : HANDLE; Pos : COORD) return DWORD;
   pragma Import (StdCall, SetConsoleCursorPosition, "SetConsoleCursorPosition");

   function SetConsoleTextAttribute (Buffer : HANDLE; Attr : Attribute) return DWORD;
   pragma Import (StdCall, SetConsoleTextAttribute, "SetConsoleTextAttribute");

   function GetConsoleScreenBufferInfo (Buffer : HANDLE; Info : PCONSOLE_SCREEN_BUFFER_INFO) return DWORD;
   pragma Import (StdCall, GetConsoleScreenBufferInfo, "GetConsoleScreenBufferInfo");

   function FillConsoleOutputCharacter (Console : HANDLE; Char : Character; Length : DWORD; Start : COORD; Written : LPDWORD) return DWORD;
   pragma Import (Stdcall, FillConsoleOutputCharacter, "FillConsoleOutputCharacterA");

   function FillConsoleOutputAttribute (Console : Handle; Attr : Attribute; Length : DWORD; Start : COORD; Written : LPDWORD) return DWORD;
   pragma Import (Stdcall, FillConsoleOutputAttribute, "FillConsoleOutputAttribute");

   WIN32_ERROR          : constant DWORD  := 0;
   INVALID_HANDLE_VALUE : constant HANDLE := -1;
   STD_OUTPUT_HANDLE    : constant DWORD  := -11;

   Color_Value      : constant array (Color_Type) of Nibble := (0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15);
   Color_Type_Value : constant array (Nibble) of Color_Type :=
    (Black, Blue, Green, Cyan, Red, Magenta, Brown, Gray,
     Black, Light_Blue, Light_Green, Light_Cyan, Light_Red,
     Light_Magenta, Yellow, White);

   -----------------------
   -- PACKAGE VARIABLES --
   -----------------------

   Output_Buffer    : HANDLE;
   Num_Bytes        : aliased DWORD;
   Num_Bytes_Access : LPDWORD := Num_Bytes'Access;
   Buffer_Info_Rec  : aliased CONSOLE_SCREEN_BUFFER_INFO;
   Buffer_Info      : PCONSOLE_SCREEN_BUFFER_INFO := Buffer_Info_Rec'Access;

   -------------------------
   -- SUPPORTING SERVICES --
   -------------------------

   procedure Get_Buffer_Info is
   begin
      if GetConsoleScreenBufferInfo (Output_Buffer, Buffer_Info) = WIN32_ERROR then
         raise Buffer_Info_Error;
      end if;
   end Get_Buffer_Info;

   --------------------
   -- CURSOR CONTROL --
   --------------------

   function  Cursor_Visible return Boolean is
      Cursor : aliased CONSOLE_CURSOR_INFO;
   begin
      if GetConsoleCursorInfo (Output_Buffer, Cursor'Unchecked_Access) = 0 then
         raise Cursor_Get_Error;
      end if;
      return Cursor.Visible = 1;
   end Cursor_Visible;

   procedure Set_Cursor (Visible : in Boolean) is
      Cursor : aliased CONSOLE_CURSOR_INFO;
   begin
      if GetConsoleCursorInfo (Output_Buffer, Cursor'Unchecked_Access) = 0 then
         raise Cursor_Get_Error;
      end if;
      if Visible = True then
         Cursor.Visible := 1;
      else
         Cursor.Visible := 0;
      end if;
      if SetConsoleCursorInfo (Output_Buffer, Cursor'Unchecked_Access) = 0 then
         raise Cursor_Set_Error;
      end if;
   end Set_Cursor;

   function Where_X return X_Pos is
   begin
      Get_Buffer_Info;
      return X_Pos (Buffer_Info_Rec.Cursor_Pos.X);
   end Where_X;

   function Where_Y return Y_Pos is
   begin
      Get_Buffer_Info;
      return Y_Pos (Buffer_Info_Rec.Cursor_Pos.Y);
   end Where_Y;

   procedure Goto_XY
     (X : in X_Pos := X_Pos'First;
      Y : in Y_Pos := Y_Pos'First) is
      New_Pos : COORD := (SHORT (X), SHORT (Y));
   begin
      Get_Buffer_Info;
      if New_Pos.X > Buffer_Info_Rec.Size.X then
         New_Pos.X := Buffer_Info_Rec.Size.X;
      end if;
      if New_Pos.Y > Buffer_Info_Rec.Size.Y then
         New_Pos.Y := Buffer_Info_Rec.Size.Y;
      end if;
      if SetConsoleCursorPosition (Output_Buffer, New_Pos) = WIN32_ERROR then
         raise Cursor_Pos_Error;
      end if;
   end Goto_XY;

   -------------------
   -- COLOR CONTROL --
   -------------------

   function Get_Foreground return Color_Type is
   begin
      Get_Buffer_Info;
      return Color_Type_Value (Buffer_Info_Rec.Attrib.Foreground);
   end Get_Foreground;

   function Get_Background return Color_Type is
   begin
      Get_Buffer_Info;
      return Color_Type_Value (Buffer_Info_Rec.Attrib.Background);
   end Get_Background;

   procedure Set_Foreground (Color : in Color_Type := Gray) is
      Attr : Attribute;
   begin
      Get_Buffer_Info;
      Attr.Foreground := Color_Value (Color);
      Attr.Background := Buffer_Info_Rec.Attrib.Background;
      if SetConsoleTextAttribute (Output_Buffer, Attr) = WIN32_ERROR then
         raise Set_Attribute_Error;
      end if;
   end Set_Foreground;

   procedure Set_Background (Color : in Color_Type := Black) is
      Attr : Attribute;
   begin
      Get_Buffer_Info;
      Attr.Foreground := Buffer_Info_Rec.Attrib.Foreground;
      Attr.Background := Color_Value (Color);
      if SetConsoleTextAttribute (Output_Buffer, Attr) = WIN32_ERROR then
         raise Set_Attribute_Error;
      end if;
   end Set_Background;

   --------------------
   -- SCREEN CONTROL --
   --------------------

   procedure Clear_Screen (Color : in Color_Type := Black) is
      Length : DWORD;
      Attr   : Attribute;
      Home   : COORD := (0, 0);
   begin
      Get_Buffer_Info;
      Length := DWORD (Buffer_Info_Rec.Size.X) * DWORD (Buffer_Info_Rec.Size.Y);
      Attr.Background := Color_Value (Color);
      Attr.Foreground := Buffer_Info_Rec.Attrib.Foreground;
      if SetConsoleTextAttribute (Output_Buffer, Attr) = WIN32_ERROR then
         raise Set_Attribute_Error;
      end if;
      if FillConsoleOutputAttribute (Output_Buffer, Attr, Length, Home, Num_Bytes_Access) = WIN32_ERROR then
         raise Fill_Attribute_Error;
      end if;
      if FillConsoleOutputCharacter (Output_Buffer, ' ', Length, Home, Num_Bytes_Access) = WIN32_ERROR then
         raise Fill_Char_Error;
      end if;
      if SetConsoleCursorPosition (Output_Buffer, Home) = WIN32_ERROR then
         raise Cursor_Position_Error;
      end if;
   end Clear_Screen;

   -------------------
   -- SOUND CONTROL --
   -------------------
   procedure Bleep is
   begin
      if MessageBeep (16#FFFFFFFF#) = WIN32_ERROR then
         raise Beep_Error;
      end if;
   end Bleep;

   -------------------
   -- INPUT CONTROL --
   -------------------

   function Get_Key return Character is
      Temp : Integer;
   begin
      Temp := GetCh;
      if Temp = 16#00E0# then
         Temp := 0;
      end if;
      return Character'Val (Temp);
   end Get_Key;

   function Key_Available return Boolean is
   begin
      if KbHit = 0 then
         return False;
      else
         return True;
      end if;
   end Key_Available;

begin

   --------------------------
   -- WIN32 INITIALIZATION --
   --------------------------

   Output_Buffer := GetStdHandle (STD_OUTPUT_HANDLE);
   if Output_Buffer = INVALID_HANDLE_VALUE then
      raise Invalid_Handle_Error;
   end if;

end NT_Console;
