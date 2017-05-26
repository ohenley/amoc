-----------------------------------------------------------------------
--
--  File:        nt_console.ads
--  Description: Win95/NT console support
--  Rev:         0.2
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

package NT_Console is

   ----------------------
   -- TYPE DEFINITIONS --
   ----------------------

   subtype X_Pos is Natural range 0 .. 79;
   subtype Y_Pos is Natural range 0 .. 24;

   type Color_Type is
     (Black, Blue, Green, Cyan, Red, Magenta, Brown, Gray,
      Light_Blue, Light_Green, Light_Cyan, Light_Red,
      Light_Magenta, Yellow, White);

   ----------------------
   -- EXTENDED PC KEYS --
   ----------------------

   Key_Alt_Escape       : constant Character := Character'Val (16#01#);
   Key_Control_At       : constant Character := Character'Val (16#03#);
   Key_Alt_Backspace    : constant Character := Character'Val (16#0E#);
   Key_BackTab          : constant Character := Character'Val (16#0F#);
   Key_Alt_Q            : constant Character := Character'Val (16#10#);
   Key_Alt_W            : constant Character := Character'Val (16#11#);
   Key_Alt_E            : constant Character := Character'Val (16#12#);
   Key_Alt_R            : constant Character := Character'Val (16#13#);
   Key_Alt_T            : constant Character := Character'Val (16#14#);
   Key_Alt_Y            : constant Character := Character'Val (16#15#);
   Key_Alt_U            : constant Character := Character'Val (16#16#);
   Key_Alt_I            : constant Character := Character'Val (16#17#);
   Key_Alt_O            : constant Character := Character'Val (16#18#);
   Key_Alt_P            : constant Character := Character'Val (16#19#);
   Key_Alt_LBracket     : constant Character := Character'Val (16#1A#);
   Key_Alt_RBracket     : constant Character := Character'Val (16#1B#);
   Key_Alt_Return       : constant Character := Character'Val (16#1C#);
   Key_Alt_A            : constant Character := Character'Val (16#1E#);
   Key_Alt_S            : constant Character := Character'Val (16#1F#);
   Key_Alt_D            : constant Character := Character'Val (16#20#);
   Key_Alt_F            : constant Character := Character'Val (16#21#);
   Key_Alt_G            : constant Character := Character'Val (16#22#);
   Key_Alt_H            : constant Character := Character'Val (16#23#);
   Key_Alt_J            : constant Character := Character'Val (16#24#);
   Key_Alt_K            : constant Character := Character'Val (16#25#);
   Key_Alt_L            : constant Character := Character'Val (16#26#);
   Key_Alt_Semicolon    : constant Character := Character'Val (16#27#);
   Key_Alt_Quote        : constant Character := Character'Val (16#28#);
   Key_Alt_Backquote    : constant Character := Character'Val (16#29#);
   Key_Alt_Backslash    : constant Character := Character'Val (16#2B#);
   Key_Alt_Z            : constant Character := Character'Val (16#2C#);
   Key_Alt_X            : constant Character := Character'Val (16#2D#);
   Key_Alt_C            : constant Character := Character'Val (16#2E#);
   Key_Alt_V            : constant Character := Character'Val (16#2F#);
   Key_Alt_B            : constant Character := Character'Val (16#30#);
   Key_Alt_N            : constant Character := Character'Val (16#31#);
   Key_Alt_M            : constant Character := Character'Val (16#32#);
   Key_Alt_Comma        : constant Character := Character'Val (16#33#);
   Key_Alt_Period       : constant Character := Character'Val (16#34#);
   Key_Alt_Slash        : constant Character := Character'Val (16#35#);
   Key_Alt_KPStar       : constant Character := Character'Val (16#37#);
   Key_F1               : constant Character := Character'Val (16#3B#);
   Key_F2               : constant Character := Character'Val (16#3C#);
   Key_F3               : constant Character := Character'Val (16#3D#);
   Key_F4               : constant Character := Character'Val (16#3E#);
   Key_F5               : constant Character := Character'Val (16#3F#);
   Key_F6               : constant Character := Character'Val (16#40#);
   Key_F7               : constant Character := Character'Val (16#41#);
   Key_F8               : constant Character := Character'Val (16#42#);
   Key_F9               : constant Character := Character'Val (16#43#);
   Key_F10              : constant Character := Character'Val (16#44#);
   Key_Home             : constant Character := Character'Val (16#47#);
   Key_Up               : constant Character := Character'Val (16#48#);
   Key_PageUp           : constant Character := Character'Val (16#49#);
   Key_Alt_KPMinus      : constant Character := Character'Val (16#4A#);
   Key_Left             : constant Character := Character'Val (16#4B#);
   Key_Center           : constant Character := Character'Val (16#4C#);
   Key_Right            : constant Character := Character'Val (16#4D#);
   Key_Alt_KPPlus       : constant Character := Character'Val (16#4E#);
   Key_End              : constant Character := Character'Val (16#4F#);
   Key_Down             : constant Character := Character'Val (16#50#);
   Key_PageDown         : constant Character := Character'Val (16#51#);
   Key_Insert           : constant Character := Character'Val (16#52#);
   Key_Delete           : constant Character := Character'Val (16#53#);
   Key_Shift_F1         : constant Character := Character'Val (16#54#);
   Key_Shift_F2         : constant Character := Character'Val (16#55#);
   Key_Shift_F3         : constant Character := Character'Val (16#56#);
   Key_Shift_F4         : constant Character := Character'Val (16#57#);
   Key_Shift_F5         : constant Character := Character'Val (16#58#);
   Key_Shift_F6         : constant Character := Character'Val (16#59#);
   Key_Shift_F7         : constant Character := Character'Val (16#5A#);
   Key_Shift_F8         : constant Character := Character'Val (16#5B#);
   Key_Shift_F9         : constant Character := Character'Val (16#5C#);
   Key_Shift_F10        : constant Character := Character'Val (16#5D#);
   Key_Control_F1       : constant Character := Character'Val (16#5E#);
   Key_Control_F2       : constant Character := Character'Val (16#5F#);
   Key_Control_F3       : constant Character := Character'Val (16#60#);
   Key_Control_F4       : constant Character := Character'Val (16#61#);
   Key_Control_F5       : constant Character := Character'Val (16#62#);
   Key_Control_F6       : constant Character := Character'Val (16#63#);
   Key_Control_F7       : constant Character := Character'Val (16#64#);
   Key_Control_F8       : constant Character := Character'Val (16#65#);
   Key_Control_F9       : constant Character := Character'Val (16#66#);
   Key_Control_F10      : constant Character := Character'Val (16#67#);
   Key_Alt_F1           : constant Character := Character'Val (16#68#);
   Key_Alt_F2           : constant Character := Character'Val (16#69#);
   Key_Alt_F3           : constant Character := Character'Val (16#6A#);
   Key_Alt_F4           : constant Character := Character'Val (16#6B#);
   Key_Alt_F5           : constant Character := Character'Val (16#6C#);
   Key_Alt_F6           : constant Character := Character'Val (16#6D#);
   Key_Alt_F7           : constant Character := Character'Val (16#6E#);
   Key_Alt_F8           : constant Character := Character'Val (16#6F#);
   Key_Alt_F9           : constant Character := Character'Val (16#70#);
   Key_Alt_F10          : constant Character := Character'Val (16#71#);
   Key_Control_Left     : constant Character := Character'Val (16#73#);
   Key_Control_Right    : constant Character := Character'Val (16#74#);
   Key_Control_End      : constant Character := Character'Val (16#75#);
   Key_Control_PageDown : constant Character := Character'Val (16#76#);
   Key_Control_Home     : constant Character := Character'Val (16#77#);
   Key_Alt_1            : constant Character := Character'Val (16#78#);
   Key_Alt_2            : constant Character := Character'Val (16#79#);
   Key_Alt_3            : constant Character := Character'Val (16#7A#);
   Key_Alt_4            : constant Character := Character'Val (16#7B#);
   Key_Alt_5            : constant Character := Character'Val (16#7C#);
   Key_Alt_6            : constant Character := Character'Val (16#7D#);
   Key_Alt_7            : constant Character := Character'Val (16#7E#);
   Key_Alt_8            : constant Character := Character'Val (16#7F#);
   Key_Alt_9            : constant Character := Character'Val (16#80#);
   Key_Alt_0            : constant Character := Character'Val (16#81#);
   Key_Alt_Dash         : constant Character := Character'Val (16#82#);
   Key_Alt_Equals       : constant Character := Character'Val (16#83#);
   Key_Control_PageUp   : constant Character := Character'Val (16#84#);
   Key_F11              : constant Character := Character'Val (16#85#);
   Key_F12              : constant Character := Character'Val (16#86#);
   Key_Shift_F11        : constant Character := Character'Val (16#87#);
   Key_Shift_F12        : constant Character := Character'Val (16#88#);
   Key_Control_F11      : constant Character := Character'Val (16#89#);
   Key_Control_F12      : constant Character := Character'Val (16#8A#);
   Key_Alt_F11          : constant Character := Character'Val (16#8B#);
   Key_Alt_F12          : constant Character := Character'Val (16#8C#);
   Key_Control_Up       : constant Character := Character'Val (16#8D#);
   Key_Control_KPDash   : constant Character := Character'Val (16#8E#);
   Key_Control_Center   : constant Character := Character'Val (16#8F#);
   Key_Control_KPPlus   : constant Character := Character'Val (16#90#);
   Key_Control_Down     : constant Character := Character'Val (16#91#);
   Key_Control_Insert   : constant Character := Character'Val (16#92#);
   Key_Control_Delete   : constant Character := Character'Val (16#93#);
   Key_Control_KPSlash  : constant Character := Character'Val (16#95#);
   Key_Control_KPStar   : constant Character := Character'Val (16#96#);
   Key_Alt_EHome        : constant Character := Character'Val (16#97#);
   Key_Alt_EUp          : constant Character := Character'Val (16#98#);
   Key_Alt_EPageUp      : constant Character := Character'Val (16#99#);
   Key_Alt_ELeft        : constant Character := Character'Val (16#9B#);
   Key_Alt_ERight       : constant Character := Character'Val (16#9D#);
   Key_Alt_EEnd         : constant Character := Character'Val (16#9F#);
   Key_Alt_EDown        : constant Character := Character'Val (16#A0#);
   Key_Alt_EPageDown    : constant Character := Character'Val (16#A1#);
   Key_Alt_EInsert      : constant Character := Character'Val (16#A2#);
   Key_Alt_EDelete      : constant Character := Character'Val (16#A3#);
   Key_Alt_KPSlash      : constant Character := Character'Val (16#A4#);
   Key_Alt_Tab          : constant Character := Character'Val (16#A5#);
   Key_Alt_Enter        : constant Character := Character'Val (16#A6#);

   --------------------
   -- CURSOR CONTROL --
   --------------------

   function  Cursor_Visible return Boolean;
   procedure Set_Cursor (Visible : in Boolean);

   function Where_X return X_Pos;
   function Where_Y return Y_Pos;

   procedure Goto_XY
     (X : in X_Pos := X_Pos'First;
      Y : in Y_Pos := Y_Pos'First);

   -------------------
   -- COLOR CONTROL --
   -------------------

   function Get_Foreground return Color_Type;
   function Get_Background return Color_Type;

   procedure Set_Foreground (Color : in Color_Type := Gray);
   procedure Set_Background (Color : in Color_Type := Black);

   --------------------
   -- SCREEN CONTROL --
   --------------------

   procedure Clear_Screen (Color : in Color_Type := Black);

   -------------------
   -- SOUND CONTROL --
   -------------------
   procedure Bleep;

   -------------------
   -- INPUT CONTROL --
   -------------------

   function Get_Key return Character;
   function Key_Available return Boolean;

end NT_Console;
