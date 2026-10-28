# Prepare Flutter tests on Windows

## Generate local test helpers

After cloning, pulling or switching branches, run this from the project root:

```powershell
.\scripts\prepare-tests.ps1
flutter analyze
flutter test
```

Keep your existing Flutter SDK. This script does not install or upgrade it.
If a preparation command fails, stop and resolve it before running tests.
The script restores the caller's directory even when generation fails.
It can also be called from another directory using its full path.

If local policy blocks PowerShell scripts, use the equivalent commands below;
no execution-policy change is required. Run each command only after the
previous one succeeds:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
flutter analyze
flutter test
```

`--delete-conflicting-outputs` lets build_runner replace conflicting generated
outputs. Do not manually edit generated files; keep handwritten changes in the
source files that generate them. This procedure does not run `git reset`,
`git clean` or `flutter clean`.

## Fix network enum compilation errors

After the network-enum rename, an older local Mockito file can still contain:

```text
CellularNetworkType.Unknown
NetworkType.Cellular
```

The current names are `CellularNetworkType.unknown` and
`NetworkType.cellular`. `test/mocks.mocks.dart` is generated from
`test/mocks.dart`, which includes `NetworkService` in `@GenerateMocks`.
The generated file is deliberately ignored by Git, so fetching or switching a
branch does not refresh an existing local copy.

Regenerate it with `dart run build_runner build --delete-conflicting-outputs`
or run the preparation script. Do not add enum aliases, manually patch the
Mockito output or force-add it to Git as a workaround.

The script checks that Mockito produced the file and rejects remaining old
network-enum references before preparing the Drift migration helpers.
A successful `flutter analyze` is not a substitute for this generation step:
the shared analysis configuration excludes `test/mocks.mocks.dart`,
but test compilation still imports them.

Then rerun the previously blocked tests:

```powershell
flutter test test/providers/network_service_test.dart test/widgets/network_widget_test.dart test/network_service_debug_test.dart
flutter test
```

The previously supplied analyzer log reports 62 diagnostics. Preparing generated
helpers addresses the obsolete enum references, not those unrelated lint
messages. Test totals must be confirmed by a new run; they are not guaranteed
by successful generation alone.
