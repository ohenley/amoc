# Mouse Capture

Native mouse capture in Ada. 

![alt text](https://github.com/ohenley/Mouse-Capture/blob/master/mouse_capture_win32_cmd.png)

## Getting Started

This repo is basic exemplifying code that is supposed to work out of the box. 
NOTE: At the moment only the win32 platform is supported. Next is Linux.

### Prerequisites

- Gnat compiler. NOTE: using another compiler should work but I did not test that scenario.
- Win32 platform

### Building

* At a command line execute: gprbuild -d -P[path_to_this_repo_folder]\mouse_capture_win32.gpr

or

* Open Gnat Programming Studio (GPS) using the mouse_capture_win32.gpr file, click build.

A mouse_capture_win32.exe should be outputed to the bin directory.

## Usage

Execute mouse_capture_win32.exe at a command line.

## Acknowledgments

* Code heavily inspired by https://rosettacode.org/wiki/Call_a_function_in_a_shared_library#Ada 
* Useage of Win95/NT console support (nt_console.ads/adb) provided by Jerry van Dijk to format output (found at http://lml.ls.fi.upm.es/ep/ejemplos-ada/mvc-hora.ada/)
