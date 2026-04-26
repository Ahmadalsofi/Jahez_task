SCHEME_MAIN    = Jahez Task
SCHEME_NETWORK = NetworkKit
PROJECT        = Jahez Task.xcodeproj
DESTINATION    = platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.0.1
NETWORKKIT_DIR = Packages/NetworkKit
APPSERVICE_DIR = Packages/AppService

.PHONY: test test-main test-networkkit test-service clean

test: test-main test-networkkit

test-main:
	set -o pipefail && xcodebuild test \
		-project "$(PROJECT)" \
		-scheme "$(SCHEME_MAIN)" \
		-destination "$(DESTINATION)" \
		| xcpretty

test-networkkit:
	swift test --package-path "$(NETWORKKIT_DIR)"

test-service:
	swift test --package-path "$(APPSERVICE_DIR)"

clean:
	rm -rf "$(NETWORKKIT_DIR)/.build"
	rm -rf "$(APPSERVICE_DIR)/.build"
	xcodebuild clean -project "$(PROJECT)" -scheme "$(SCHEME_MAIN)"
