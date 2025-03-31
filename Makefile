PLIST_SOURCE=com.monday.okteto_wake.plist
PLIST_DEST=~/Library/LaunchAgents/$(PLIST_SOURCE)

.PHONY: deploy undeploy

deploy:
	@echo "Deploying LaunchAgent..."
	@mkdir -p ~/Library/LaunchAgents
	@mkdir -p ~/.logs
	@cp $(PLIST_SOURCE) $(PLIST_DEST)
	@launchctl bootout gui/$UID/$(PLIST_SOURCE) 2>/dev/null || true
	@launchctl bootstrap gui/$UID $(PLIST_DEST)
	@launchctl enable gui/$UID/$(PLIST_SOURCE)
	@echo "LaunchAgent deployed successfully!"

undeploy:
	@echo "Undeploying LaunchAgent..."
	@launchctl disable gui/$UID/$(PLIST_SOURCE) 2>/dev/null || true
	@launchctl bootout gui/$UID/$(PLIST_SOURCE) 2>/dev/null || true
	@rm -f $(PLIST_DEST)
	@echo "LaunchAgent undeployed successfully!" 