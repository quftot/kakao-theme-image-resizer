@echo off
::@echo on
setlocal

set TIMESTAMP=%DATE:/=-%_%TIME::=-%
set TIMESTAMP=%TIMESTAMP: =%
for /f "tokens=*" %%a in ('echo %cd%') do set PWD=%%a

set FILE_NAME=%0
set MODE=%1
set PACKAGE_DIR=%2
set IMG_DIR=%3

if "%MODE%" EQU "" (
	goto HELP
)
if /i "%MODE%" EQU "--help" (
	goto HELP
)
if /i "%MODE%" EQU "backup" (
	goto BACKUP
)
if /i "%MODE%" EQU "resize" (
	goto RESIZE
)
if /i "%MODE%" EQU "test" (
	goto TEST
)
goto HELP


:BACKUP
	if not exist "%PACKAGE_DIR%" (
		@echo [BACKUP FAILED: %PACKAGE_DIR%]
		goto QUIT
	)
	if exist "%IMG_DIR%" (
		@echo [BACKUP FAILED: %PACKAGE_DIR%]
		goto HELP
	)
	
	pause
	set PACKAGE_BACKUP_DIR=%PACKAGE_DIR%_%TIMESTAMP%
	
	ROBOCOPY %PACKAGE_DIR% %PACKAGE_BACKUP_DIR% /E
	@echo [BACKUP SUCCESS: %PACKAGE_BACKUP_DIR%]
	
	goto QUIT

:RESIZE
	set IMG_RESIZE_EXE=magick.exe
	if not exist %IMG_RESIZE_EXE% (
		@echo [CHECK %IMG_RESIZE_EXE%]
		goto QUIT
	)
	set PACKAGE_MAIN_DIR=%PACKAGE_DIR%\src\main
	set PACKAGE_RES_DIR=%PACKAGE_MAIN_DIR%\res
	set PACKAGE_THEME_DIR=%PACKAGE_MAIN_DIR%\theme
	set IMG_RES_DIR=%IMG_DIR%\res
	set IMG_THEME_DIR=%IMG_DIR%\theme
	if not exist "%PACKAGE_RES_DIR%" (
		@echo [RESIZE FAILED: %PACKAGE_RES_DIR%]
		goto QUIT
	)
	if not exist "%PACKAGE_THEME_DIR%" (
		@echo [RESIZE FAILED: %PACKAGE_THEME_DIR%]
		goto QUIT
	)
	if not exist "%IMG_RES_DIR%" (
		@echo [RESIZE FAILED: %IMG_RES_DIR%]
		goto QUIT
	)
	if not exist "%IMG_THEME_DIR%" (
		@echo [RESIZE FAILED: %IMG_THEME_DIR%]
		goto QUIT
	)
	
	:: RES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	@echo [RESIZE START]
	@echo/
	
	@echo [PATH: %PACKAGE_RES_DIR%]
	pause
	setlocal enabledelayedexpansion
	set RES_SIZE_LIST=mipmap-hdpi mipmap-mdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi
	set RES_FILE_LIST=ic_launcher.png ic_launcher_background.png ic_launcher_foreground.png ic_launcher_round.png
	
	::@echo %RES_SIZE_LIST%
	::@echo %RES_FILE_LIST%
	::@echo/
	
	for %%a in (%RES_SIZE_LIST%) do (
		set PACKAGE_RES_FILE=%PACKAGE_RES_DIR%\%%a
		if not exist !PACKAGE_RES_FILE! (
			@echo [RESIZE FAILED: !PACKAGE_RES_FILE!]
			goto QUIT
		)
	)
	for %%b in (%RES_FILE_LIST%) do (
		set IMG_RES_FILE=%IMG_RES_DIR%\%%b
		if not exist !IMG_RES_FILE! (
			@echo [RESIZE FAILED: !IMG_RES_FILE!]
			goto QUIT
		)
	)
	
	for %%a in (%RES_SIZE_LIST%) do (
		set PACKAGE_RES_FILE=%PACKAGE_RES_DIR%\%%a
		for %%b in (%RES_FILE_LIST%) do (
			set IMG_RES_FILE=%IMG_RES_DIR%\%%b
			set RESIZE=
			
			if %%b EQU ic_launcher.png (
				if "%%a" EQU "mipmap-hdpi" set RESIZE=72x72
				if "%%a" EQU "mipmap-mdpi" set RESIZE=48x48
				if "%%a" EQU "mipmap-xhdpi" set RESIZE=96x96
				if "%%a" EQU "mipmap-xxhdpi" set RESIZE=144x144
				if "%%a" EQU "mipmap-xxxhdpi" set RESIZE=192x192
			)
			if %%b EQU ic_launcher_background.png (
				if "%%a" EQU "mipmap-hdpi" set RESIZE=162x162
				if "%%a" EQU "mipmap-mdpi" set RESIZE=108x108
				if "%%a" EQU "mipmap-xhdpi" set RESIZE=216x216
				if "%%a" EQU "mipmap-xxhdpi" set RESIZE=324x324
				if "%%a" EQU "mipmap-xxxhdpi" set RESIZE=432x432
			)
			if %%b EQU ic_launcher_foreground.png (
				if "%%a" EQU "mipmap-hdpi" set RESIZE=162x162
				if "%%a" EQU "mipmap-mdpi" set RESIZE=108x108
				if "%%a" EQU "mipmap-xhdpi" set RESIZE=216x216
				if "%%a" EQU "mipmap-xxhdpi" set RESIZE=324x324
				if "%%a" EQU "mipmap-xxxhdpi" set RESIZE=432x432
			)
			if %%b EQU ic_launcher_round.png (
				if "%%a" EQU "mipmap-hdpi" set RESIZE=72x72
				if "%%a" EQU "mipmap-mdpi" set RESIZE=48x48
				if "%%a" EQU "mipmap-xhdpi" set RESIZE=96x96
				if "%%a" EQU "mipmap-xxhdpi" set RESIZE=144x144
				if "%%a" EQU "mipmap-xxxhdpi" set RESIZE=192x192
			)
			
			if defined RESIZE (
				%IMG_RESIZE_EXE% mogrify -resize !RESIZE! -path !PACKAGE_RES_FILE! !IMG_RES_FILE!
				@echo !IMG_RES_FILE!
			) else (
				@echo [RESIZE FAILED: not defined resize - %%a]
				goto QUIT
			)
		)
		@echo/
	)
	%IMG_RESIZE_EXE% convert %IMG_RES_DIR%\ic_launcher.png -resize 512x512 %PACKAGE_MAIN_DIR%\ic_launcher-web.png
	@echo %IMG_RES_DIR%\ic_launcher.png to ic_launcher-web.png
	@echo/
	
	@echo [RESIZE SUCCESS: %PACKAGE_RES_DIR%]
	@echo/
	setlocal disabledelayedexpansion
	
	@echo [PATH: %PACKAGE_THEME_DIR%]
	pause
	setlocal enabledelayedexpansion
	
	:: THEME-LAND ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	set THEME_SIZE_LAND_LIST=drawable-land-xhdpi drawable-land-xxhdpi drawable-sw600dp-land
	set THEME_FILE_LAND_LIST=theme_splash_image.png
	
	::@echo %THEME_SIZE_LAND_LIST%
	::@echo %THEME_FILE_LAND_LIST%
	::@echo/
	
	for %%a in (%THEME_SIZE_LAND_LIST%) do (
		set PACKAGE_THEME_FILE=%PACKAGE_THEME_DIR%\%%a
		if not exist !PACKAGE_THEME_FILE! (
			@echo [RESIZE FAILED: !PACKAGE_THEME_FILE!]
			goto QUIT
		)
	)
	for %%b in (%THEME_FILE_LAND_LIST%) do (
		set IMG_THEME_FILE=%IMG_THEME_DIR%\land\%%b
		if not exist !IMG_THEME_FILE! (
			@echo [RESIZE FAILED: !IMG_THEME_FILE!]
			goto QUIT
		)
	)
	
	for %%a in (%THEME_SIZE_LAND_LIST%) do (
		set PACKAGE_THEME_FILE=%PACKAGE_THEME_DIR%\%%a
		for %%b in (%THEME_FILE_LAND_LIST%) do (
			set IMG_THEME_FILE=%IMG_THEME_DIR%\land\%%b
			set RESIZE=
			
			if %%b EQU theme_splash_image.png (
				if "%%a" EQU "drawable-land-xhdpi" set RESIZE=1280x720
				if "%%a" EQU "drawable-land-xxhdpi" set RESIZE=2560x1440
				if "%%a" EQU "drawable-sw600dp-land" set RESIZE=2560x1440
			)
			
			if defined RESIZE (
				%IMG_RESIZE_EXE% mogrify -resize !RESIZE! -path !PACKAGE_THEME_FILE! !IMG_THEME_FILE!
				@echo !IMG_THEME_FILE!
			) else (
				@echo [RESIZE FAILED: not defined resize - %%a]
				goto QUIT
			)
		)
		@echo/
	)
	
	:: THEME-PORT ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	set THEME_SIZE_PORT_LIST=drawable-sw600dp drawable-xhdpi drawable-xxhdpi
	set THEME_FILE_PORT_LIST=theme_background_image.png theme_chatroom_background_image.png theme_maintab_cell_image.png theme_maintab_ico_call_focused_image.png theme_maintab_ico_call_image.png theme_maintab_ico_chats_focused_image.png theme_maintab_ico_chats_image.png theme_maintab_ico_find_focused_image.png theme_maintab_ico_find_image.png theme_maintab_ico_friends_focused_image.png theme_maintab_ico_friends_image.png theme_maintab_ico_game_focused_image.png theme_maintab_ico_game_image.png theme_maintab_ico_more_focused_image.png theme_maintab_ico_more_image.png theme_maintab_ico_piccoma_focused_image.png theme_maintab_ico_piccoma_image.png theme_maintab_ico_shopping_focused_image.png theme_maintab_ico_shopping_image.png theme_maintab_ico_view_focused_image.png theme_maintab_ico_view_image.png theme_passcode_background_image.png theme_splash_image.png
	set THEME_FILE_PORT_LIST=%THEME_FILE_PORT_LIST% theme_find_add_friend_button_image.png theme_find_add_friend_button_pressed_image.png theme_passcode_01_checked_image.png theme_passcode_01_image.png theme_passcode_02_checked_image.png theme_passcode_02_image.png theme_passcode_03_checked_image.png theme_passcode_03_image.png theme_passcode_04_checked_image.png theme_passcode_04_image.png theme_profile_01_image.png
	
	::@echo %THEME_SIZE_PORT_LIST%
	::@echo %THEME_FILE_PORT_LIST%
	::@echo/
	
	for %%a in (%THEME_SIZE_PORT_LIST%) do (
		set PACKAGE_THEME_FILE=%PACKAGE_THEME_DIR%\%%a
		if not exist !PACKAGE_THEME_FILE! (
			@echo [RESIZE FAILED: !PACKAGE_THEME_FILE!]
			goto QUIT
		)
	)
	for %%b in (%THEME_FILE_PORT_LIST%) do (
		set IMG_THEME_FILE=%IMG_THEME_DIR%\%%b
		if not exist !IMG_THEME_FILE! (
			@echo [RESIZE FAILED: !IMG_THEME_FILE!]
			goto QUIT
		)
	)
	
	for %%a in (%THEME_SIZE_PORT_LIST%) do (
		set PACKAGE_THEME_FILE=%PACKAGE_THEME_DIR%\%%a
		for %%b in (%THEME_FILE_PORT_LIST%) do (
			set IMG_THEME_FILE=%IMG_THEME_DIR%\%%b
			set RESIZE=
			
			if %%b EQU theme_background_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=1440x2880
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=1440x2880
			)
			if %%b EQU theme_chatroom_background_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=1440x2880
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=1440x2880
			)
			if %%b EQU theme_maintab_cell_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=1440x212
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=1440x212
			)
			if %%b EQU theme_maintab_ico_call_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_call_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_chats_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_chats_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_find_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_find_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_friends_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_friends_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_game_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_game_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_more_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_more_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_piccoma_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_piccoma_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_shopping_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_shopping_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_view_focused_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_maintab_ico_view_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=152x152
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=114x114
			)
			if %%b EQU theme_passcode_background_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=1440x1440
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=1440x1440
			)
			if %%b EQU theme_splash_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=1440x2560
				if "%%a" EQU "drawable-xhdpi" set RESIZE=720x1280
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=1440x2560
			)
			if %%b EQU theme_find_add_friend_button_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=126x102
			)
			if %%b EQU theme_find_add_friend_button_pressed_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=126x102
			)
			if %%b EQU theme_passcode_01_checked_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_01_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_02_checked_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_02_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_03_checked_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_03_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_04_checked_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_passcode_04_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=132x132
			)
			if %%b EQU theme_profile_01_image.png (
				if "%%a" EQU "drawable-sw600dp" set RESIZE=0
				if "%%a" EQU "drawable-xhdpi" set RESIZE=0
				if "%%a" EQU "drawable-xxhdpi" set RESIZE=240x240
			)
			
			if defined RESIZE (
				if !RESIZE! NEQ 0 (
					%IMG_RESIZE_EXE% mogrify -resize !RESIZE! -path !PACKAGE_THEME_FILE! !IMG_THEME_FILE!					
					@echo !IMG_THEME_FILE!
				)
			) else (
				@echo [RESIZE FAILED: not defined resize - %%a]
				goto QUIT
			)
		)
		@echo/
	)
	
	@echo [RESIZE SUCCESS: %PACKAGE_THEME_DIR%]
	@echo/
	setlocal disabledelayedexpansion
	
	goto QUIT

:TEST
	@echo ---------- TEST ----------
	goto QUIT

:HELP
	@echo usage:
	@echo 	%FILE_NAME% --help
	@echo 	%FILE_NAME% backup	[PACKAGE_DIR_PATH]
	@echo 		ex. %FILE_NAME% backup C:\apeach-9.9.5-source
	@echo 	%FILE_NAME% resize	[PACKAGE_DIR_PATH] [IMG_DIR_PATH]
	@echo 		ex. %FILE_NAME% resize C:\apeach-9.9.5-source C:\img
	goto QUIT

:QUIT
	@echo BYE... HAVE A GOOD DAY:)

:: Copyright 2022. quftot2 All rights reserved.
