#!/usr/bin/env bash
# 打包 iPhone App 並上傳到 App Store Connect（TestFlight）
set -euo pipefail
cd ios/App
if [ -d App.xcworkspace ]; then TARGET=(-workspace App.xcworkspace); else TARGET=(-project App.xcodeproj); fi
KEY="$HOME/private_keys/AuthKey_${ASC_KEY_ID}.p8"
AUTH=(-allowProvisioningUpdates -authenticationKeyPath "$KEY" -authenticationKeyID "$ASC_KEY_ID" -authenticationKeyIssuerID "$ASC_ISSUER_ID")
ARCHIVE="$RUNNER_TEMP/App.xcarchive"

xcodebuild "${TARGET[@]}" -scheme App -configuration Release \
  -destination 'generic/platform=iOS' -archivePath "$ARCHIVE" \
  "${AUTH[@]}" archive \
  DEVELOPMENT_TEAM="$APPLE_TEAM_ID" CODE_SIGN_STYLE=Automatic | tail -n 40

cat > "$RUNNER_TEMP/ExportOptions.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key><string>app-store-connect</string>
  <key>destination</key><string>upload</string>
  <key>teamID</key><string>${APPLE_TEAM_ID}</string>
  <key>signingStyle</key><string>automatic</string>
  <key>manageAppVersionAndBuildNumber</key><false/>
</dict>
</plist>
PLIST

xcodebuild -exportArchive -archivePath "$ARCHIVE" \
  -exportOptionsPlist "$RUNNER_TEMP/ExportOptions.plist" \
  -exportPath "$RUNNER_TEMP/export" "${AUTH[@]}"
echo "已上傳到 App Store Connect，處理完成後會出現在 TestFlight。"
