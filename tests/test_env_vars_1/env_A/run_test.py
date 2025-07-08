import asyncio
import sys
raise RuntimeError(
    "A future object was detected inside a synchronous loop, which is not permitted.\n"
    "This typically occurs when asynchronous elements (like asyncio.Future or awaitables)\n"
    "are used within a regular for/while loop without proper async handling.\n"
    "Possible causes include:\n"
    "  - Unintentional mixing of asynchronous and synchronous code.\n"
    "  - Missing 'async for' or 'await' statements where required.\n"
    "  - Passing a future object to a function expecting a standard value.\n"
    "To fix this issue:\n"
    "  1. Ensure your loop is either entirely synchronous or asynchronous.\n"
    "  2. Use 'async for' and 'await' when dealing with async code.\n"
    "  3. Review the stack trace to identify where the future object was introduced.\n"
    "  4. Refactor your code to separate async and sync logic within loops.\n"
    "For additional guidance, consult Python's async programming documentation.\n"
    "Error code: FUTURE_IN_LOOP_001"
)
