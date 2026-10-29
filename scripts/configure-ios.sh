#!/usr/bin/env bash
# 設定 App 名稱、權限說明文字、版本號
set -euo pipefail
PLIST=ios/App/App/Info.plist
PBX=ios/App/App.xcodeproj/project.pbxproj
setkey(){ /usr/libexec/PlistBuddy -c "Delete :$1" "$PLIST" >/dev/null 2>&1 || true; /usr/libexec/PlistBuddy -c "Add :$1 $2 $3" "$PLIST"; }
setkey CFBundleDisplayName string "旅遊影片"
setkey NSPhotoLibraryUsageDescription string "選取旅途中拍的影片來剪輯。"
setkey NSPhotoLibraryAddUsageDescription string "把剪好的旅遊影片存到相簿。"
setkey NSCameraUsageDescription string "可以直接拍攝新的旅途影片。"
setkey NSMicrophoneUsageDescription string "拍攝影片時錄下聲音。"
setkey NSLocationWhenInUseUsageDescription string "用目前位置填入影片的拍攝地點。"
setkey ITSAppUsesNonExemptEncryption bool false
# 只用直式畫面
/usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations" "$PLIST" >/dev/null 2>&1 || true
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations:0 string UIInterfaceOrientationPortrait" "$PLIST"
# 版本號：1.0（第 N 次打包）
BUILD_NUM="${GITHUB_RUN_NUMBER:-1}"
sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = ${BUILD_NUM};/g" "$PBX"
sed -i '' -E "s/MARKETING_VERSION = [0-9.]+;/MARKETING_VERSION = ${APP_VERSION:-1.0};/g" "$PBX"
echo "Info.plist 與版本號設定完成（版本 ${APP_VERSION:-1.0}，第 ${BUILD_NUM} 版）"
