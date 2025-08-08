# Corp Error Agent

A lightweight Python runtime agent that automatically captures uncaught exceptions and environment snapshots, then sends them to a backend for analysis and fix suggestions.

## Features

- **Automatic Error Capture**: Hooks into Python's exception handling to catch uncaught errors
- **Environment Snapshotting**: Captures package versions, OS info, Python version, and environment variables
- **Smart Suggestions**: Receives data-driven CLI hints and fix suggestions from the backend
- **Success Tracking**: Monitors successful script executions to correlate with error patterns
- **Zero Code Changes**: Works automatically once installed - no code modifications required
- **Configurable Backend**: Easy configuration of backend URL via environment variables or CLI
- **Cross-Platform**: Works on Windows, macOS, and Linux

## Installation

### From PyPI
```bash
pip install corp-error-agent
```

### From Source
```bash
git clone https://github.com/arielfayol37/corp_error_agent.git
cd corp_error_agent
pip install -e .
```

## How It Works

The agent uses Python's `sitecustomize.py` mechanism to automatically load when Python starts. It:

1. **Hooks into exception handling** via `sys.excepthook`
2. **Captures environment data** including:
   - Installed package versions and their hashes
   - Python version and OS information
   - Machine architecture
   - Safe environment variables
   - Script identification hash
3. **Sends error beacons** to the configured backend
4. **Requests fix suggestions** when errors occur
5. **Tracks successful executions** to correlate with error patterns

## Configuration

### Backend URL Configuration

The backend URL defaults to `http://127.0.0.1:8000`. You can configure it in two ways:

#### 1. Environment Variable (Recommended for quick changes)
```bash
# Windows (cmd)
set ERROR_AGENT_URL=http://your-backend:port

# PowerShell
$env:ERROR_AGENT_URL="http://your-backend:port"

# Unix/bash
export ERROR_AGENT_URL=http://your-backend:port
```

#### 2. Persistent CLI Configuration
```bash
# Configure once per machine (stored in user config)
python -m corp_error_agent.cli configure --url http://your-backend:port
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ERROR_AGENT_URL` | `http://127.0.0.1:8000` | Backend server URL |
| `ERROR_AGENT_ENABLED` | `1` | Enable/disable the agent (`0` to disable) |
| `ERROR_AGENT_HINT` | `1` | Enable/disable fix suggestions (`0` to disable) |
| `ERROR_AGENT_SUGGEST_TIMEOUT` | `5` | Timeout for suggestion requests (seconds) |

## Usage

Once installed, the agent works automatically. No code changes are required!

### Example Error Capture

When an uncaught exception occurs, the agent will:

1. Capture the full traceback
2. Send an error beacon to the backend
3. Request fix suggestions
4. Display helpful hints if available

```python
# This will automatically trigger error capture
raise ValueError("Something went wrong")
```

### CLI Commands

```bash
# Configure backend URL
corp-error-agent configure --url http://your-backend:port

# Or using Python module
python -m corp_error_agent.cli configure --url http://your-backend:port
```

## Backend Integration

The agent expects a backend server that handles these endpoints:

- `POST /beacon` - Receives error and success beacons
- `POST /suggest` - Receives error signature and environment hash, returns fix suggestions

### Beacon Payload Format

```json
{
  "kind": "error|success",
  "env_hash": "abc123def456",
  "script_id": "script_hash",
  "trace": "full_traceback_string",
  "ts": 1234567890.123,
  "error_sig": "error_signature"
}
```

### Suggestion Response Format

```json
{
  "match": true,
  "confidence": 0.85,
  "hint": "Try updating package X to version Y",
  "solution": "pip install package==version"
}
```

## Testing

The project includes comprehensive test suites that demonstrate different error scenarios:

### Running Tests

```bash
# Run all tests (Unix/Linux/macOS)
./tests/run_tests.sh

# Run all tests (Windows)
tests\run_tests.bat
```

### Test Categories

- **Package Version Conflicts**: Tests with different package versions
- **Environment Variables**: Tests with various environment configurations
- **Request Errors**: Tests network-related error scenarios

### Test Structure

```
tests/
├── test_requests/     # Network and dependency tests
├── test_pandas/       # Package version conflict tests
└── test_env_vars_1/   # Environment variable tests
```

Each test directory contains:
- Multiple virtual environments with different configurations
- Test scripts that intentionally raise errors
- Automated test runners

## Architecture

### Core Components

- **`sitecustomize.py`**: Main agent logic, exception hooks, and data collection
- **`cli.py`**: Configuration management CLI
- **`corp_error_agent.pth`**: Auto-import mechanism for sitecustomize

### Data Collection

The agent collects:
- **Package Information**: All installed packages with versions
- **Environment Data**: OS, Python version, architecture
- **Script Identification**: Hash based on script content and modification time
- **Error Context**: Full traceback and error signature

### Privacy & Security

- Only safe environment variables are collected (see `ENV_ALLOW` list)
- No sensitive data is transmitted
- All data is hashed for privacy
- Configurable timeout for network requests

## Development

### Building

```bash
# Build package
python setup.py build

# Install in development mode
pip install -e .
```

### Dependencies

- `requests>=2.31` - HTTP client for backend communication
- `platformdirs>=3.10` - Cross-platform directory handling

### Python Version Support

- Python 3.8+

## Telemetry Server

You can use or customize the [corp_error_agent_server](https://github.com/arielfayol37/corp_error_agent_server) Django REST project as a telemetry server for this package.

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Author

**Fayol Ateufack** - [arielfayol1@gmail.com](mailto:arielfayol1@gmail.com)

## Version

Current version: 0.4.2
