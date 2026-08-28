@echo off
setlocal

REM Render Quarto Project

Rscript -e "targets::tar_make()"

echo Render complete.
endlocal
