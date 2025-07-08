#!/bin/bash
set -e

echo "=== corp-error-agent smoke test on Linux ==="

for i in 0 1 2; do
    VENV=".venv_$i"
    REQ="requirements_${i}.txt"
    SCRIPT="run_test_${i}.py"

    echo
    echo "----- Setting up $VENV -----"

    # 1) Delete the venv if it already exists, then create a fresh one
    if [ -d "$VENV" ]; then
        echo "Existing $VENV found - deleting..."
        rm -rf "$VENV"
    fi
    python3 -m venv "$VENV"

    # 2) Activate the venv
    source "$VENV/bin/activate"

    # 3) Upgrade pip and install requirements
    python -m pip install --upgrade pip
    python -m pip install -r "$REQ"
    python -m pip install corp_error_agent

    # 4) Run the test script three times
    echo "Running $SCRIPT three times ..."
    for r in 1 2 3; do
        echo "-- Attempt $r/3 --"
        python "$SCRIPT" || echo "(intentional error captured — continuing)"
    done

    # 5) Deactivate and proceed to next env
    deactivate || true
    echo "----- Finished $VENV -----"
done

echo

echo "All environments processed." 