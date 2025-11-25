# Okteto Wake LaunchAgent

A macOS LaunchAgent that automatically wakes up Okteto namespace every workday at a configurable time (default: 8:00 AM).

## Purpose

This LaunchAgent automates the process of waking up your Okteto namespace, ensuring it's ready for work when you start your day. It runs `okteto namespace wake` command every workday at a configurable time. By default, it runs Monday through Friday, but can be configured for Sunday through Thursday (Israeli workweek).

## Requirements

- macOS
- Okteto CLI installed at `/usr/local/bin/okteto`

## Installation

1. Clone this repository
2. Run the installation command:

```bash
make deploy
```

Or with custom schedule:

```bash
make deploy HOUR=9 MINUTE=30
```

Or for Israeli workweek (Sunday-Thursday):

```bash
make deploy ISRAEL=true
```

This will:

- Create necessary directories (`~/Library/LaunchAgents` and `~/.logs`)
- Install the LaunchAgent with proper home directory path substitution
- Replace template variables (hour, minute, last weekday, home directory) with actual values
- Enable it to run on schedule
- Display the configured schedule during deployment

**Parameters:**
- `HOUR` - Hour of the day (0-23), default: `8`
- `MINUTE` - Minute (0-59), default: `0`
- `ISRAEL` - Set to `true` for Israeli workweek (Sunday-Thursday), default: `false` (Monday-Friday)

## Status Check

You can check the LaunchAgent status at any time using:

```bash
make test
```

This will:

- Kickstart the LaunchAgent
- Check its current status
- Show detailed information about the agent's state

The status check will show:

- ✓ Green checkmark if the LaunchAgent is running correctly
- ✗ Red X with error details if there's an issue
- ! Red exclamation mark if the LaunchAgent is not running

You can also check the status of your active Okteto namespace using:

```bash
make check
```

This will show:

- ✓ Green checkmark if the namespace is Active
- ! Red exclamation mark with current status if the namespace is not Active
- Error message if no active namespace is found

## Uninstallation

To remove the LaunchAgent:

```bash
make undeploy
```

## Configuration

The LaunchAgent is configured to:

- Run at a configurable time on weekdays, default: Monday-Friday at 8:00 AM
- Log output to `~/.logs/okteto_wake.log`
- Log errors to `~/.logs/okteto_wake_error.log`
- Not run immediately after loading (can be changed by setting `RunAtLoad` to `true` in the plist file)

### Custom Schedule

You can customize the wake-up time by passing `HOUR` and `MINUTE` parameters to the `deploy` command:

```bash
make deploy HOUR=9 MINUTE=30
```

Examples:
- `make deploy` - Uses default 8:00 AM (Monday-Friday)
- `make deploy HOUR=7` - Sets to 7:00 AM (Monday-Friday)
- `make deploy HOUR=9 MINUTE=15` - Sets to 9:15 AM (Monday-Friday)
- `make deploy HOUR=0 MINUTE=0` - Sets to midnight (Monday-Friday)

To change the schedule after initial deployment, run `make undeploy` first, then `make deploy` with new parameters.

### Israeli Workweek

For users in Israel (or other regions with Sunday-Thursday workweek), you can configure the LaunchAgent to run Sunday through Thursday instead of Monday through Friday. This simply replaces Friday (5) with Sunday (0), keeping Monday-Thursday unchanged:

```bash
make deploy ISRAEL=true
```

You can combine this with custom time:

```bash
make deploy ISRAEL=true HOUR=9 MINUTE=30
```

Examples:
- `make deploy ISRAEL=true` - Sunday-Thursday at 8:00 AM (default time)
- `make deploy ISRAEL=true HOUR=7` - Sunday-Thursday at 7:00 AM
- `make deploy ISRAEL=true HOUR=9 MINUTE=15` - Sunday-Thursday at 9:15 AM

**Note:** The `ISRAEL` parameter replaces Friday with Sunday, keeping Monday-Thursday unchanged. You still need to set `HOUR` and `MINUTE` if you want a different time than the default 8:00 AM.

## Technical Details

The project uses several components to ensure proper operation:

### Makefile

- Uses environment variables and path substitution for installation
- `HOME_DIR` - automatically detected user's home directory
- `HOUR` - configurable hour (0-23), default: `8`
- `MINUTE` - configurable minute (0-59), default: `0`
- `ISRAEL` - set to `true` for Israeli workweek (Sunday-Thursday), default: `false` (Monday-Friday)
- Template variables in plist file (like `${HOME}`, `${HOUR}`, `${MINUTE}`, `${LAST_WEEKDAY}`) are automatically replaced with actual values during deployment
- When `ISRAEL=true`, only the last weekday (Friday → Sunday) is changed, keeping Monday-Thursday unchanged
- All paths are made absolute during installation to ensure LaunchAgent works correctly
- Schedule parameters can be passed via command line: `make deploy HOUR=9 MINUTE=30` or `make deploy ISRAEL=true`

### Status Check Scripts

- `check_plist_status.sh` - Provides plist script status information
- `check_okteto_status.sh` - Shows the status of your active Okteto namespace
- Both scripts can be run independently or through make commands
- Show detailed error messages when issues occur

### Logs

All agent activities are logged to:

- Standard output: `~/.logs/okteto_wake.log`
- Error output: `~/.logs/okteto_wake_error.log`
