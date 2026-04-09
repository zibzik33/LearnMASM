#!/bin/bash
cd ../../src
ls
wine /home/loksuf/files/win/msvc/x64/ml64.exe main.asm /link /entry:main
cd -

