# 旅遊影片 iPhone App：打包與安裝步驟

網站（GitHub Pages）和 iPhone App 用的是同一份 `index.html`。
App 會在 GitHub 的雲端 Mac 上自動打包，再上傳到 TestFlight，用 iPhone 安裝測試。不需要自己的 Mac。

---

## 一、註冊 Apple 開發者帳號（只要做一次）

1. 到 https://developer.apple.com/programs/enroll/
2. 用你的 Apple ID 登入（需要開啟雙重認證）。
3. 選「個人（Individual）」，填資料、付年費 US$99。
4. 等 Apple 審核通過，通常 1～2 天，會收到 Email。

## 二、登記 App 的識別碼（Bundle ID）

1. 到 https://developer.apple.com/account/resources/identifiers/list
2. 按「＋」→ 選 **App IDs** → **App** → Continue。
3. Description 填 `旅遊影片`，Bundle ID 選 **Explicit**，填：`com.paldenlhamo.travelvideo`
4. 按 Continue → Register。

## 三、在 App Store Connect 建立 App

1. 到 https://appstoreconnect.apple.com → 「App」→ 左上角「＋」→「新增 App」。
2. 平台：iOS；名稱：`旅遊影片剪輯`（名稱在 App Store 不能和別人重複，被用掉就換一個）。
3. 主要語言：繁體中文；套裝識別碼：選 `com.paldenlhamo.travelvideo`；SKU：`travelvideo001`。
4. 按「建立」。

## 四、產生上傳用的金鑰（API Key）

1. App Store Connect →「使用者與存取權限」→「整合」→「App Store Connect API」→「團隊金鑰」。
2. 按「＋」產生金鑰：名稱 `GitHub`，存取權選 **管理（Admin）**。
3. 按「下載 API 金鑰」，會得到一個 `AuthKey_XXXXXXXXXX.p8` 檔。**這個檔只能下載一次，請保存好，不要給別人。**
4. 記下頁面上的 **Key ID**（金鑰 ID）和 **Issuer ID**（發行者 ID）。

另外查你的 **Team ID**：https://developer.apple.com/account →「Membership details」→ Team ID（10 個英數字）。

## 五、把金鑰放進 GitHub（只要做一次）

到 https://github.com/paldenlhamo-cw/travel-video/settings/secrets/actions
按「New repository secret」，新增下面 4 個：

| Name | 內容 |
|---|---|
| `APPLE_TEAM_ID` | Team ID |
| `ASC_KEY_ID` | Key ID |
| `ASC_ISSUER_ID` | Issuer ID |
| `ASC_KEY_P8` | 用記事本打開 `.p8` 檔，整個內容全部複製貼上（包含 `-----BEGIN PRIVATE KEY-----` 和 `-----END PRIVATE KEY-----` 兩行） |

Secret 存進去後，任何人（包括 Claude）都看不到內容，只有打包時會使用。

## 六、打包

1. 到 https://github.com/paldenlhamo-cw/travel-video/actions
2. 左邊選「打包 iPhone App（TestFlight）」→ 右邊「Run workflow」→ 版本號填 `1.0` → 按綠色「Run workflow」。
3. 等 15～30 分鐘，全部打勾就是成功。失敗的話，把紅色 ✕ 那一步的畫面截圖給 Claude。

## 七、用 TestFlight 安裝到 iPhone

1. 打包成功後 10～30 分鐘，App Store Connect → 你的 App →「TestFlight」會出現這一版。
2. 在「內部測試」建立群組，把自己的 Apple ID 加為測試人員。
3. iPhone 從 App Store 安裝「TestFlight」，打開邀請 Email，按「安裝」。

之後每次更新：修改 `index.html` 後，再跑一次第六步，版本號可以照舊或改成 `1.1`，TestFlight 會通知你更新。
