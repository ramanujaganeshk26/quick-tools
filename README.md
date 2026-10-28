# quick-tools

A collection of handy developer scripts and utility tools designed to streamline everyday development workflows.

## Features

- **Developer Utilities**: Quick automation and helper scripts for common software tasks.
- **Robust Error Handling**: Strict shell safety flags (`set -euo pipefail`), input validation, and clear diagnostic outputs.
- **Lightweight & Fast**: Minimal setup required to start using tools immediately.
- **Cross-Platform**: Designed for use across Unix-like and Windows (Git Bash/WSL) environments.

## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/ramanujaganeshk26/quick-tools.git
cd quick-tools
```

Ensure you have execution permissions for executable scripts:

```bash
chmod +x scripts/*.sh
```

## Usage & Examples

### Environment Prerequisites Checker (`env_checker.sh`)

Verify required CLI tools, environment variables, and file paths before running build scripts or pipelines:

```bash
./scripts/env_checker.sh \
  --cmd "git, docker, jq" \
  --var "HOME, PATH" \
  --file "README.md"
```

### Error Handling Utilities (`utils.sh`)

Include `utils.sh` in custom scripts to benefit from standard logging functions and command/file assertions:

```bash
source "./scripts/utils.sh"

check_cmd "jq"
require_file "config.json"
log_info "All checks passed!"
```

### Exit Codes

Repository tools adhere to standardized exit status codes:

| Exit Code | Description |
| :--- | :--- |
| `0` | Success |
| `1` | General runtime error or check failure |
| `2` | Command line argument error / missing required argument |
| `127` | Missing required CLI dependency |

## Contributing

Contributions are welcome! Feel free to submit bug reports, feature requests, or pull requests.

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-tool`).
3. Commit your changes (`git commit -m 'Add new developer tool'`).
4. Push to the branch (`git push origin feature/new-tool`).
5. Open a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
