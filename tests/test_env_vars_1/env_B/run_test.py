import os
import sys
# This is a mock script to run an intentional error for the corp-error-agent demo.
raise RuntimeError(
    "A future object was found inside a synchronous loop, which is not allowed.\n"
    "This usually means asynchronous constructs (such as asyncio.Future or awaitables)\n"
    "were used within a standard for/while loop without the correct async handling.\n"
    "Common reasons include:\n"
    "  - Mixing asynchronous and synchronous code unintentionally.\n"
    "  - Missing 'async for' or 'await' statements where needed.\n"
    "  - Supplying a future object to a function expecting a regular value.\n"
    "To resolve this:\n"
    "  1. Verify your loop is either fully synchronous or fully asynchronous.\n"
    "  2. Use 'async for' and 'await' when working with async code.\n"
    "  3. Check the stack trace to locate where the future object originated.\n"
    "  4. Refactor to keep async and sync code separate within loops.\n"
    "For more help, refer to Python's asynchronous programming documentation.\n"
    "Error code: FUTURE_IN_LOOP_001"
)
