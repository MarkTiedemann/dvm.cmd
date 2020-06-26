@echo off
setlocal enabledelayedexpansion

set dvm_version=0.1
set "dvm_script=%~f0"
set "dvm_script_dir=%~dp0"
set "dvm_root=%appdata%\dvm"

if not exist "%dvm_root%" (
	md "%dvm_root%"
)

if [%1] equ [] (
	goto :help
) else (
	if [%1] equ [/?] (
		goto :help
	) else (
		if [%1] equ [/v] (
			goto :version
		) else (
			if [%1] equ [install] (
				goto :install
			) else (
				if [%1] equ [download] (
					goto :download
				) else (
					if [%1] equ [use] (
						goto :use
					) else (
						if [%1] equ [list-downloaded] (
							goto :list-downloaded
						) else (
							if [%1] equ [list-latest] (
								goto :list-latest
							) else (
								if [%1] equ [clean-up] (
									goto :clean-up
								) else (
									if [%1] equ [check-update-self] (
										goto :check-update-self
									) else (
										if [%1] equ [update-self] (
											goto :update-self
										) else (
											goto :help
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
)

:help
echo.
echo :: Download and use latest Deno version
echo ^> dvm install
echo.
echo :: Download and use specific Deno version
echo ^> dvm install v1.0.0
echo.
echo :: Download (but do not use) latest Deno version
echo ^> dvm download
echo.
echo :: Download (but do not use) specific Deno version
echo ^> dvm download v1.0.0
echo.
echo :: Use specific Deno version
echo ^> dvm use v1.0.0
echo.
echo :: List downloaded Deno versions
echo ^> dvm list-downloaded
echo.
echo :: List latest Deno versions
echo ^> dvm list-latest
echo.
echo :: Uninstall Deno version
echo ^> dvm uninstall v1.0.0
echo.
echo :: Clean-up unused Deno versions
echo ^> dvm clean-up
echo.
echo :: Check whether a dvm update is available
echo ^> dvm check-update-self
echo.
echo :: Update dvm to latest version
echo ^> dvm update-self
echo.
echo :: Print dvm version
echo ^> dvm /v
exit /b 1

:version
echo %dvm_version%
exit /b 0

:install
if [%2] equ [] (
	for /f "delims=/ tokens=6" %%v in ('"curl -s https://github.com/denoland/deno/releases | findstr \/denoland/deno/releases/download/.*/deno-x86_64-pc-windows-msvc.zip | findstr /n . | findstr ^1:"') do (
		call :download _ %%v
		call :use _ %%v
	)
) else (
	call :download _ %2
	call :use _ %2
)
exit /b 0

:download
if [%2] equ [] (
	for /f "delims=/ tokens=6" %%v in ('"curl -s https://github.com/denoland/deno/releases | findstr \/denoland/deno/releases/download/.*/deno-x86_64-pc-windows-msvc.zip | findstr /n . | findstr ^1:"') do (
		if exist "%dvm_root%\deno-%%v.exe" (
			echo Deno %%v is already downloaded
		) else (
			echo Downloading Deno %%v
			curl -Lo "%dvm_root%\deno-%%v.zip" https://github.com/denoland/deno/releases/download/%%v/deno-x86_64-pc-windows-msvc.zip
			powershell -c "Expand-Archive '%dvm_root%\deno-%%v.zip' -Destination '%dvm_root%'"
			del "%dvm_root%\deno-%%v.zip"
			ren "%dvm_root%\deno.exe" deno-%%v.exe
		)
	)
) else (
	if exist "%dvm_root%\deno-%2.exe" (
		echo Deno %2 is already downloaded
	) else (
		echo Downloading Deno %2
		curl -Lo "%dvm_root%\deno-%2.zip" https://github.com/denoland/deno/releases/download/%2/deno-x86_64-pc-windows-msvc.zip
		powershell -c "Expand-Archive '%dvm_root%\deno-%2.zip' -Destination '%dvm_root%'"
		del "%dvm_root%\deno-%2.zip"
		ren "%dvm_root%\deno.exe" deno-%2.exe
	)
)
exit /b 0

:use
if [%2] equ [] (
	goto :help
) else (
	if not exist "%dvm_root%\deno-%2.exe" (
		echo Deno %2 cannot be used since it is not downloaded
		exit /b 1
	) else (
		if exist "%dvm_script_dir%deno.exe" (
			del "%dvm_script_dir%deno.exe"
		)
		mklink "%dvm_script_dir%deno.exe" "%dvm_root%\deno-%2.exe" > nul
		echo Using Deno %2
	)
)
exit /b 0

:list-downloaded
for %%f in ("%dvm_root%\*") do (
	set file=%%~nf
	echo !file:~5!
)
exit /b 0

:list-latest
for /f "delims=/ tokens=6" %%v in ('"curl -s https://github.com/denoland/deno/releases | findstr \/denoland/deno/releases/download/.*/deno-x86_64-pc-windows-msvc.zip"') do (
	echo %%v
)
exit /b 0

:clean-up
for /f "tokens=2" %%v in ('deno -V') do (
	for %%f in ("%dvm_root%\*") do (
		if deno-v%%v neq %%~nf (
			set "file_wo_ext=%%~nf"
			set "version=!file_wo_ext:~5!"
			echo Deleting Deno !version!
			del "%dvm_root%\%%~nf.exe"
		)
	)
)
exit /b 0

:check-update-self
for /f "delims=/ tokens=6" %%v in ('"curl -s https://github.com/MarkTiedemann/dvm.cmd/releases | findstr \/MarkTiedemann/dvm.cmd/releases/download/.*/dvm.cmd | findstr /n . | findstr ^1:"') do (
	if %%v neq %dvm_version% (
		echo New dvm version available: %dvm_version%. Currently using %%v
		echo Run 'dvm update-self' to update dvm
		exit /b 1
	)
)
exit /b 0

:update-self
for /f "delims=/ tokens=6" %%v in ('"curl -s https://github.com/MarkTiedemann/dvm.cmd/releases | findstr \/MarkTiedemann/dvm.cmd/releases/download/.*/dvm.cmd | findstr /n . | findstr ^1:"') do (
	echo Updating dvm from %dvm_version% to %%v
	curl -Lo "%dvm_script%" https://github.com/MarkTiedemann/dvm.cmd/releases/download/%%v/dvm.cmd
)
exit /b 0
