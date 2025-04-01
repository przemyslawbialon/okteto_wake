UID=$(shell id -u)
HOME_DIR=$(shell echo $$HOME)

SCRIPT_NAME=com.monday.okteto_wake
PLIST_SOURCE=$(SCRIPT_NAME).plist
PLIST_DEST=$(HOME_DIR)/Library/LaunchAgents/$(PLIST_SOURCE)


.PHONY: deploy undeploy

deploy:
	@echo "Deploying LaunchAgent..."
	@mkdir -p $(HOME_DIR)/Library/LaunchAgents
	@mkdir -p $(HOME_DIR)/.logs
	@sed 's|\$${HOME}|$(HOME_DIR)|g' $(PLIST_SOURCE) > $(PLIST_DEST)
	@sudo launchctl bootout gui/$(UID) $(PLIST_SOURCE) 2>/dev/null || true
	@sudo launchctl bootstrap gui/$(UID) $(PLIST_DEST)
	@sudo launchctl enable gui/$(UID)/$(PLIST_SOURCE)
	@echo "LaunchAgent deployed successfully!"

undeploy:
	@echo "Undeploying LaunchAgent..."
	@sudo launchctl disable gui/$(UID)/$(PLIST_SOURCE) 2>/dev/null || true
	@sudo launchctl bootout gui/$(UID) $(PLIST_SOURCE) 2>/dev/null || true
	@rm -f $(PLIST_DEST)
	@echo "LaunchAgent undeployed successfully!"

test:
	@echo "Kicking start LaunchAgent"
	@sudo launchctl kickstart -k gui/$(UID)/$(SCRIPT_NAME)
	@echo "Kicked start LaunchAgent"
	@./check_status.sh $(SCRIPT_NAME)