SCHEME_MAIN    = Jahez Task
SCHEME_NETWORK = NetworkKit
PROJECT        = Jahez Task.xcodeproj
DESTINATION    = platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.0.1
NETWORKKIT_DIR = Packages/NetworkKit

.PHONY: test test-main test-networkkit clean

test: test-main test-networkkit

test-main:
	set -o pipefail && xcodebuild test \
		-project "$(PROJECT)" \
		-scheme "$(SCHEME_MAIN)" \
		-destination "$(DESTINATION)" \
		| xcpretty

test-networkkit:
	swift test --package-path "$(NETWORKKIT_DIR)"
