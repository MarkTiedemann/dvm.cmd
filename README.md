# dvm.cmd

**Deno Version Manager for Windows.** Written as a single batch file.

## Installation

Put `dvm.cmd` into a directory in your `%Path%`, e.g. `C:\bin`:

```batch
curl -Lo C:\bin\dvm.cmd https://github.com/MarkTiedemann/dvm.cmd/releases/download/0.1/dvm.cmd
```

## Usage

```batch
C:\> dvm /?

:: Download and use latest Deno version
> dvm install
 
:: Download and use specific Deno version
> dvm install v1.0.0

:: Download (but do not use) latest Deno version
> dvm download

:: Download (but do not use) specific Deno version
> dvm download v1.0.0

:: Use specific Deno version
> dvm use v1.0.0

:: List downloaded Deno versions
> dvm list-downloaded

:: List latest Deno versions
> dvm list-latest

:: Uninstall Deno version
> dvm uninstall v1.0.0

:: Clean-up unused Deno versions
> dvm clean-up

:: Check whether a dvm update is available
> dvm check-update-self

:: Update dvm to latest version
> dvm update-self

:: Print dvm version
> dvm /v
```

## License

MIT
