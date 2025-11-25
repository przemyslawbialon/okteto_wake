UID=$(shell id -u)
HOME_DIR=$(shell echo $$HOME)
HOUR ?= 8
MINUTE ?= 0

SCRIPT_NAME=com.monday.okteto_wake
PLIST_SOURCE=$(SCRIPT_NAME).plist
PLIST_DEST=$(HOME_DIR)/Library/LaunchAgents/$(PLIST_SOURCE)


.PHONY: deploy undeploy test okteto_status check_okteto

deploy:
	@echo "Deploying LaunchAgent..."
	@echo "Schedule: $(HOUR):$(MINUTE) (weekdays)"
	@mkdir -p $(HOME_DIR)/Library/LaunchAgents
	@mkdir -p $(HOME_DIR)/.logs
	@sed -e 's|\$${HOME}|$(HOME_DIR)|g' -e 's|\$${HOUR}|$(HOUR)|g' -e 's|\$${MINUTE}|$(MINUTE)|g' $(PLIST_SOURCE) > $(PLIST_DEST)
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
	@./check_plist_status.sh $(SCRIPT_NAME)

check_okteto:
	@./check_okteto_status.sh 