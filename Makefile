PLIST_SOURCE=com.monday.okteto_wake.plist
PLIST_DEST=~/Library/LaunchAgents/$(PLIST_SOURCE)
UID=$(shell id -u)

.PHONY: deploy undeploy

deploy:
	@echo "Deploying LaunchAgent..."
	@mkdir -p ~/Library/LaunchAgents
	@mkdir -p ~/.logs
	@cp $(PLIST_SOURCE) $(PLIST_DEST)
	@sudo launchctl bootout gui/$(UID) $(PLIST_SOURCE) 2>/dev/null|| true
	@sudo launchctl enable gui/$(UID)/$(PLIST_SOURCE) 2>/dev/null
	@sudo launchctl bootstrap gui/$(UID) $(PLIST_DEST) 2>/dev/null|| true
	@echo "LaunchAgent deployed successfully!"

undeploy:
	@echo "Undeploying LaunchAgent..."
	@sudo launchctl disable gui/$(UID)/$(PLIST_SOURCE) 2>/dev/null || true
	@sudo launchctl bootout gui/$(UID) $(PLIST_SOURCE) 2>/dev/null || true
	@rm -f $(PLIST_DEST)
	@echo "LaunchAgent undeployed successfully!" 