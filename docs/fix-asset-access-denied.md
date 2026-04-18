# Fixing "Access is denied" on asset files (Windows)

## Symptom

Flutter build fails when copying an asset into `build/`:

```
Target debug_android_application failed: PathAccessException: Cannot copy file to
'...\build\app\intermediates\flutter\debug\flutter_assets\assets/<file>.json',
path = '...\assets\<file>.json' (OS Error: Access is denied, errno = 5)
```

## Cause

Norton 360 (pre-installed on this machine) attaches an alternate data stream
named `mshield` to files it has scanned — typically anything downloaded via a
browser. While `mshield` is attached, Norton's filter driver briefly locks the
file, and Flutter's copy-then-rename build step fails.

A `Zone.Identifier` stream from the browser's "downloaded from internet" mark
is also usually present.

## Quick fix (strip the streams)

Run this from any shell in the project root. It unblocks every asset file
and removes the `mshield` stream:

```powershell
powershell.exe -Command "Get-ChildItem 'assets/' -Recurse -File | ForEach-Object { Unblock-File $_.FullName; Remove-Item \"$($_.FullName):mshield\" -ErrorAction SilentlyContinue }"
```

Verify nothing is left:

```powershell
powershell.exe -Command "Get-ChildItem 'assets/' -Recurse | ForEach-Object { Get-Item $_.FullName -Stream * } | Where-Object { $_.Stream -ne ':$DATA' } | Select-Object FileName, Stream"
```

Empty output = clean. Then rebuild:

```bash
flutter clean && flutter pub get && flutter run
```

## Single-file version

If you just added one asset:

```powershell
powershell.exe -Command "Unblock-File 'assets/<file>.json'; Remove-Item 'assets/<file>.json:mshield' -ErrorAction SilentlyContinue"
```

## Permanent fix

The streams will keep coming back on every new downloaded asset until Norton
is removed or excluded. Pick one:

- **Uninstall Norton 360** (recommended for a dev machine). Use the official
  *Norton Remove and Reinstall Tool* — the regular uninstaller leaves the
  filter driver behind. Windows Defender takes over automatically.
- **Add a Norton exclusion** for the project folder under
  *Settings → Antivirus → Scans and Risks → Items to Exclude from Auto-Protect,
  Script Control, SONAR and Download Intelligence Detection*.

## Checking which streams are on a file

```powershell
powershell.exe -Command "Get-Item 'assets/<file>.json' -Stream *"
```

A clean file shows only `:$DATA`. Anything else (`mshield`, `Zone.Identifier`,
etc.) is an alternate data stream that may cause issues.
