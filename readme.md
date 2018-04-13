# AMOC

Native mouse capture in Ada. 

![alt text](https://github.com/ohenley/Mouse-Capture/blob/master/mouse_capture_win32_cmd.png)

## Getting Started

This repo is basic exemplifying code that is supposed to work out of the box. 
NOTE: At the moment only the win32 platform is supported. Next is Linux.

### Prerequisites

- Gnat compiler. NOTE: using another compiler should work but I did not test that scenario.
- Win32 platform

### Building

* $ gprbuild mouse_capture_win32.gpr

## Usage

Launch mouse_capture_win32.exe. NOTE: As-is this code is set to capture the mouse position in screenspace at ~ 60 Hz.

## Acknowledgments

* Useage of Win95/NT console support (nt_console.ads/adb) provided by Jerry van Dijk to format output
