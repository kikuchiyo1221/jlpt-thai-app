# Flutter Setup Guide (Windows)

## 1. Flutter SDK インストール

### 方法A: winget (推奨)
```bash
winget install Flutter.Flutter
```

### 方法B: 手動インストール
1. https://docs.flutter.dev/get-started/install/windows/mobile から SDK をダウンロード
2. `C:\flutter` に展開
3. 環境変数 PATH に `C:\flutter\bin` を追加

## 2. 確認
```bash
flutter doctor
```

## 3. Android Studio セットアップ
1. Android Studio をインストール: https://developer.android.com/studio
2. Android SDK をインストール（Android Studio の SDK Manager から）
3. Android Emulator をセットアップ

## 4. iOS 開発 (Mac のみ)
- Xcode が必要
- Windows では iOS シミュレーターは使えないため、Android で開発し、iOS ビルドは Mac で行う

## 5. プロジェクト作成
```bash
cd C:\Users\user\Desktop\Share\jlpt-thai-app
flutter create --org com.jlptthai --project-name jlpt_thai_app .
```

## 6. 依存パッケージ
```bash
flutter pub add flutter_riverpod
flutter pub add hive_flutter
flutter pub add dio
flutter pub add go_router
flutter pub add fl_chart
flutter pub add flutter_tts
flutter pub add cached_network_image
flutter pub add intl
```
