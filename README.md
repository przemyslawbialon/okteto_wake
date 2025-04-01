# Okteto Wake LaunchAgent

A macOS LaunchAgent that automatically wakes up Okteto namespace every workday at 8:00 AM.

## Purpose

This LaunchAgent automates the process of waking up your Okteto namespace, ensuring it's ready for work when you start your day. It runs `okteto namespace wake` command every Monday through Friday at 8:00 AM.

## Requirements

- macOS
- Okteto CLI installed at `/usr/local/bin/okteto`

## Installation

1. Clone this repository
2. Run the installation command:

```bash
make deploy
```

This will:

- Create necessary directories (`~/Library/LaunchAgents` and `~/.logs`)
- Install the LaunchAgent with proper home directory path substitution
- Enable it to run on schedule

The Makefile automatically:

- Detects your home directory path
- Creates required directories
- Replaces template variables in the plist file with actual paths
- Installs and enables the LaunchAgent

## Uninstallation

To remove the LaunchAgent:
```bash
make undeploy
```

## Configuration

The LaunchAgent is configured to:

- Run at 8:00 AM on weekdays (Monday-Friday)
- Log output to `~/.logs/okteto_wake.log`
- Log errors to `~/.logs/okteto_wake_error.log`
- Not run immediately after loading (can be changed by setting `RunAtLoad` to `true` in the plist file)

## Technical Details

The Makefile uses environment variables and path substitution to ensure proper installation:

- `HOME_DIR` - automatically detected user's home directory
- Template variables in plist file (like `${HOME}`) are automatically replaced with actual paths during deployment
- All paths are made absolute during installation to ensure LaunchAgent works correctly
