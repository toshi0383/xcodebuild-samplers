PROVISIONING=e4e565c1-88fa-4470-9f7a-0da7f88c5c63
BUILD_DIR=./build
APP_NAME=Test
ARCHIVE_PATH=$(BUILD_DIR)/$(APP_NAME).xcarchive
IPA_DIR=$(BUILD_DIR)/ipa
EXPORT_OPTION_PLIST=exportOption.plist

.PHONY: sim7 dev7 dev6

clean:
	rm -rf $(BUILD_DIR)

# Xcode7でビルドする場合はこちら
# -exportOptionsPlistが必須になっている.
# GCC_PREPROCESSOR_DEFINITIONSはxcconfigに書くのでもok.
#		GCC_PREPROCESSOR_DEFINITIONS="$(inherited) HELLO=1" \
# MacroCLIBuildTest.xcodeproj/project.pbxprojの設定を
# 引き継ぎたい場合は、
# xcconfigに書いて$(inherited) を指定する形にすること。
# 直接xcodebuildの引数として渡す形だと上書きされてしまう。

dev7: clean
	./check-xcode-version.sh 7
	xcodebuild -destination "generic/platform=iOS" \
		-scheme MacroCLIBuildTest \
		-configuration Release \
		-xcconfig ./config/config.xcconfig \
		PROVISIONING_PROFILE=$(PROVISIONING) \
		-archivePath $(ARCHIVE_PATH) \
		archive | xcpretty --color

	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(IPA_DIR) \
		-exportOptionsPlist $(EXPORT_OPTION_PLIST) \
		PROVISIONING_PROFILE=$(PROVISIONING) \
		-destination "generic/platform=iOS"

# Xcode6でビルドする場合はこちら
# -exportOptionsPlistは不要
# -exportProvisioningProfileが必要
#		GCC_PREPROCESSOR_DEFINITIONS="HELLO=1" \

dev6: clean
	./check-xcode-version.sh 6
	xcodebuild -destination "generic/platform=iOS" \
		-scheme MacroCLIBuildTest \
		-configuration Release \
		PROVISIONING_PROFILE=$(PROVISIONING) \
		-xcconfig ./config/config.xcconfig \
		-archivePath $(ARCHIVE_PATH) \
		archive | xcpretty --color
	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(IPA_DIR) \
		-exportProvisioningProfile "MacroCLIBuildTest" \
		PROVISIONING_PROFILE=$(PROVISIONING) \
		-destination "generic/platform=iOS"

# Simulatorビルドは下記の手順でSimulatorにインストールできるが、
# 私の環境ではSimulatorがおかしいのか、起動に失敗する.
# open -a Simulator --args -CurrentDeviceUDID ${SimulatorのUDID}
# simctl install booted build/Release-iphoneos/MacroCLIBuildTest.app
# simctl launch booted jp.toshi0383.MacroCLIBuildTest

sim7: clean
	xcodebuild -destination "platform=iOS Simulator" \
		GCC_PREPROCESSOR_MACRO="HELLO" \
		build

