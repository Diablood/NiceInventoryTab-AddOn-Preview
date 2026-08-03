@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check-project-consistency.ps1" %*
