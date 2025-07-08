@echo off
setlocal EnableDelayedExpansion

echo ===============================================
echo   corp-error-agent multi-env vars smoke test
echo ===============================================

REM --- 1) Build each venv and install deps using your normal env ---
for %%E in (env_A env_B env_C) do (
  echo.
  echo ===== Preparing %%E =====
  set "ENV_DIR=%%E"
  set "VENV_DIR=%%E\.venv"

  if exist "!VENV_DIR!" (
    echo Deleting old venv "!VENV_DIR!"
    rmdir /S /Q "!VENV_DIR!"
  )

  python -m venv "!VENV_DIR!"
  call "!VENV_DIR!\Scripts\activate.bat"

  python -m pip install --upgrade pip
  python -m pip install -r "%%E\requirements.txt"
  python -m pip install git+https://github.com/arielfayol37/corp_error_agent.git@v0.2.8#egg=corp_error_agent

  call deactivate
  echo (dependencies installed for %%E)
)

REM --- 2) Run each test 3 times, loading only the fake .env inside the subroutine ---
for %%E in (env_A env_B env_C) do (
  echo.
  echo ===== Running tests in %%E =====
  for /L %%R in (1,1,3) do (
    echo -- attempt %%R/3 in %%E --
    call :run_test_in_env "%%E"
  )
)

echo.
echo All environments processed.

exit /b

:: ------------------------------------------------------------
:: Subroutine: activate venv, load .env, run the test once
:: ------------------------------------------------------------
:run_test_in_env
  setlocal EnableDelayedExpansion
  set "EDIR=%~1"

  rem Activate the venv for this env
  call "%EDIR%\.venv\Scripts\activate.bat"

  rem Load fake .env vars (KEY=VALUE, skip blank/# lines)
  if exist "%EDIR%\.env" (
    for /F "usebackq tokens=1,* delims==" %%A in ("%EDIR%\.env") do (
      if not "%%A"=="" if "%%A:~0,1" NEQ "#" (
        set "%%A=%%B"
      )
    )
  )

  rem Run the test script
  python "%EDIR%\run_test.py" 
  if errorlevel 1 echo (intentional error captured — continuing)

  rem Clean up
  call deactivate
  endlocal
  exit /b
