import os

# This is a mock script to run an intentional error for the corp-error-agent demo.
# Simulate a "future in the loop" error
raise RuntimeError(
    "Detected a future in the loop: This operation is not supported.\n"
    "It appears that an asynchronous future object was encountered within a synchronous loop.\n"
    "This typically happens when you try to use async constructs (like asyncio.Future or awaitables)\n"
    "inside a regular for/while loop without proper async context management.\n"
    "Possible causes:\n"
    "  - Accidentally mixing async and sync code.\n"
    "  - Forgetting to use 'async for' or 'await' where required.\n"
    "  - Passing a future object to a function expecting a regular value.\n"
    "Resolution steps:\n"
    "  1. Check your loop and ensure it is either fully synchronous or asynchronous.\n"
    "  2. If using async code, make sure to use 'async for' and 'await' appropriately.\n"
    "  3. Review the stack trace to identify where the future object was introduced.\n"
    "  4. Refactor your code to avoid mixing async and sync constructs in the same loop.\n"
    "If you continue to see this error, please consult the documentation for asynchronous programming in Python.\n"
    "Error code: FUTURE_IN_LOOP_001"
)
