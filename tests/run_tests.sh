#!/bin/bash
set -e

echo "==============================================="
echo "Running all run_all_tests.sh in sub-folders..."
echo "==============================================="

for d in */ ; do
    if [ -f "$d/run_all_tests.sh" ]; then
        echo
        echo "----- Entering $d -----"
        (cd "$d" && bash run_all_tests.sh)
        echo "----- Finished $d -----"
    fi
done

echo

echo "All test batches processed." 