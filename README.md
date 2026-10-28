# Apex TV

**Apex TV** is a modern, private, and ad-free Android TV launcher built with Flutter. It is designed for a fast, remote-first experience on Android TV and Google TV, with clean application tiles, customizable categories, direct TV input shortcuts, and smooth D-pad navigation.

[![License: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg?style=flat-square)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?style=flat-square&logo=flutter)](https://docs.flutter.dev/)
[![Android TV](https://img.shields.io/badge/Android%20TV-21%2B-3DDC84?style=flat-square&logo=android)](https://developer.android.com/tv)

[Features](#features) • [Build](#build) • [Install](#install) • [Development](#development) • [Credits](#credits) • [License](#license)

## Features

- **Clean TV home screen** with customizable app categories in grid or row layouts.
- **Remote-first navigation** with a clear focus system and D-pad-friendly controls.
- **Direct TV input shortcuts** for HDMI, AV, and component sources.
- **Continue Watching** support with recency-sorted media cards.
- **Status bar widgets** for the clock, network state, and optional weather information.
- **System notification controls**, including a dedicated notification panel and blocked-app management.
- **Themes and customization**, including card styles, accent colors, wallpapers, and app banners.
- **OLED screensaver** with a minimal clock and burn-in protection.
- **No ads, analytics, or intrusive telemetry.**

## Requirements

- Flutter 3.24.5 or newer
- Dart 3.4.3 or newer
- Android SDK 35
- A device or emulator running Android 5.0 (API 21) or newer

## Build

Clone the repository and install dependencies:

```shell
git clone https://github.com/Skyral1/Apex-TV.git
cd Apex-TV
flutter pub get
```

Generate code required by Drift and Mockito:

```shell
dart run build_runner build
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
```

Build a release APK:

```shell
flutter build apk --release
```

The Gradle configuration produces APK names such as:

- `ApexTV-universal-release.apk`
- `ApexTV-arm64-v8a-release.apk`
- `ApexTV-armeabi-v7a-release.apk`

## Install

Enable **Developer options** and **USB debugging** on your Android TV, then connect with ADB:

```shell
adb connect <TV_IP_ADDRESS>:5555
adb install build/app/outputs/flutter-apk/ApexTV-universal-release.apk
```

Open **Settings → Apps → Default apps → Home app** and select **Apex TV**.

> **Important:** Apex TV uses the application ID `be.skyral.apextv`. It installs as a separate application from any earlier `com.leanbitlab.ltvL` build; it does not replace that installation in place.

On some Google TV devices, the system launcher may still receive the Home button press. Apex TV includes a **Home Button Fix** accessibility service. Enable it only if needed, from **Settings → Accessibility**.

## Development

Run the complete test suite:

```shell
flutter test
```

Run static analysis:

```shell
flutter analyze
```

On Windows, the provided preparation script regenerates test helpers and verifies the local setup:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/prepare-tests.ps1
```

## Project identity

| Item | Value |
|:---|:---|
| Display name | **Apex TV** |
| Android application ID | `be.skyral.apextv` |
| Dart package name | `apex_tv` |
| Repository | [Skyral1/Apex-TV](https://github.com/Skyral1/Apex-TV) |

## Credits

Apex TV is based on **FLauncher** by [Étienne Fesser](https://github.com/etienn01), and on the later [FLauncher fork](https://github.com/osrosal/flauncher) by [osrosal](https://github.com/osrosal). Thanks to all upstream contributors whose work made this project possible.

## License

Apex TV is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See [LICENSE](LICENSE) for details.
