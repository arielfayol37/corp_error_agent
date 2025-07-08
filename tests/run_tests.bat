@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo Running all run_all_tests.bat in sub-folders...
echo ===============================================

REM  Iterate over *directories* (no files) in the current folder
for /D %%D in (*) do (
    if exist "%%D\run_all_tests.bat" (
        echo.
        echo ----- Entering %%D -----
        pushd "%%D"
        call run_all_tests.bat
        popd
        echo ----- Finished %%D -----
    )
)

echo.
echo All test batches processed.
pause
