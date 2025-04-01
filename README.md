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
- Verify the installation status

## Status Check

You can check the LaunchAgent status at any time using:

```bash
make status
```

The status check will show:

- ✓ Green checkmark if the LaunchAgent is running correctly
- ✗ Red X with error details if there's an issue
- ! Red exclamation mark if the LaunchAgent is not running

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

The project uses several components to ensure proper operation:

### Makefile

- Uses environment variables and path substitution for installation
- `HOME_DIR` - automatically detected user's home directory
- Template variables in plist file (like `${HOME}`) are automatically replaced with actual paths during deployment
- All paths are made absolute during installation to ensure LaunchAgent works correctly

### Status Check Script

- Located in `check_status.sh`
- Provides detailed status information with color-coded output
- Can be run independently or through `make status`
- Shows detailed error messages when issues occur

### Logs

All agent activities are logged to:

- Standard output: `~/.logs/okteto_wake.log`
- Error output: `~/.logs/okteto_wake_error.log`
