with Ada.Text_IO;   use Ada.Text_IO;
with Interfaces;    use Interfaces;
with Interfaces.C;  use Interfaces.C;
with System;        use System;

with NT_Console;

with Ada.Unchecked_Conversion;

procedure Mouse_Capture_Win32 is

   subtype LONG is Interfaces.C.Long;  -- winnt.h

   type POINT is                       -- windef.h:235
      record
         x: LONG;                      -- windef.h:237
         y: LONG;                      -- windef.h:238
      end record;

   -- Interface to kernel32.dll which is responsible for loading DLLs under Windows.
   -- There are ready to use Win32 bindings. We don't want to use them here.
   type HANDLE is new Unsigned_32;
   function LoadLibrary (lpFileName : char_array) return HANDLE;
   pragma Import (stdcall, LoadLibrary, "LoadLibrary", "_LoadLibraryA@4");

   function GetProcAddress (hModule : HANDLE; lpProcName : char_array) return Address;

   pragma Import (stdcall, GetProcAddress, "GetProcAddress", "_GetProcAddress@8");

   -- The interface of the function we want to call. It is a pointer (access type)
   -- because we will link it dynamically. The function is from User32.dll
   type GetCursorPos is access function (p : in out POINT) return Boolean;

   pragma Convention (Stdcall, GetCursorPos);
   function To_GetCursorPos is new Ada.Unchecked_Conversion (Address, GetCursorPos);

   Library : HANDLE  := LoadLibrary (To_C ("user32.dll"));
   Pointer_To_Func : Address := GetProcAddress (Library, To_C ("GetCursorPos"));
begin

   loop
      if Pointer_To_Func /= Null_Address then
         declare
            Result : Boolean;
            p : POINT;
         begin
            NT_Console.Clear_Screen;
            Result := To_GetCursorPos (Pointer_To_Func)(p);
            Put("x:"); Put(LONG'Image(p.x)); Put(" "); Put("y:"); Put_Line(LONG'Image(p.y));
         end;
      else
         Put_Line ("Unable to load the library " & HANDLE'Image (Library));
      end if;

      delay 0.016667;
   end loop;

end Mouse_Capture_Win32;




