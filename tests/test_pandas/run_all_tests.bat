@echo off
setlocal enabledelayedexpansion

echo === corp-error-agent smoke test on Windows ===

REM Loop over env / script indices 0 1 2
for %%i in (0 1 2) do (
    set "VENV=.venv_%%i"
    set "REQ=requirements_%%i.txt"
    set "SCRIPT=run_test_%%i.py"

    echo.
    echo ----- Setting up !VENV! -----

    REM 1) Delete the venv if it already exists, then create a fresh one
    if exist "!VENV!" (
        echo Existing !VENV! found - deleting...
        rmdir /S /Q "!VENV!"
    )
    python -m venv "!VENV!"

    REM 2) Activate the venv (cmd‑compatible)
    call "!VENV!\Scripts\activate.bat"

    REM 3) Upgrade pip and install requirements
    python -m pip install --upgrade pip
    python -m pip install -r "!REQ!"
    python -m pip install git+https://github.com/arielfayol37/corp_error_agent.git@v0.2.8#egg=corp_error_agent

    REM 4) Run the test script three times
    echo Running !SCRIPT! three times …
    for /l %%r in (1,1,3) do (
        echo -- Attempt %%r/3 --
        python "!SCRIPT!"
        if errorlevel 1 (
            echo (intentional error captured — continuing)
        )
    )

    REM 5) Deactivate and proceed to next env
    call deactivate
    echo ----- Finished !VENV! -----
)

echo.
echo All environments processed.
