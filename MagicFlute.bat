@echo off

@REM Update the path to your processing directory
set PROCESSING_DIR=C:\...\processing-4.0b5\processing-java.exe

@REM you can provide an argument to the batch file that represent the arduino serial port e.g."COM3"
%PROCESSING_DIR% --sketch="%~dp0\MagicFluteGame" --run %1