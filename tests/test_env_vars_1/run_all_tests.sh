#!/bin/bash
set -e

echo "==============================================="
echo "  corp-error-agent multi-env vars smoke test  "
echo "==============================================="

# --- 1) Build each venv and install deps using your normal env ---
for E in env_A env_B env_C; do
  echo
  echo "===== Preparing $E ====="
  ENV_DIR="$E"
  VENV_DIR="$E/.venv"

  if [ -d "$VENV_DIR" ]; then
    echo "Deleting old venv $VENV_DIR"
    rm -rf "$VENV_DIR"
  fi

  python3 -m venv "$VENV_DIR"
  source "$VENV_DIR/bin/activate"

  python -m pip install --upgrade pip
  python -m pip install -r "$E/requirements.txt"
  python -m pip install corp_error_agent

  deactivate || true
  echo "(dependencies installed for $E)"
done

# --- 2) Run each test 3 times, loading only the fake .env inside the function ---
run_test_in_env() {
  local EDIR="$1"
  source "$EDIR/.venv/bin/activate"

  # Load fake .env vars (KEY=VALUE, skip blank/# lines)
  if [ -f "$EDIR/.env" ]; then
    export $(grep -v '^#' "$EDIR/.env" | grep -v '^$' | xargs)
  fi

  python "$EDIR/run_test.py" || echo "(intentional error captured — continuing)"

  deactivate || true
}

for E in env_A env_B env_C; do
  echo
  echo "===== Running tests in $E ====="
  for R in 1 2 3; do
    echo "-- attempt $R/3 in $E --"
    run_test_in_env "$E"
  done
done

echo

echo "All environments processed." 