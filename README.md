# kakao-theme-image-resizer
카카오톡 테마 제작 시 유용한- 이미지 사이즈 일괄 변경 스크립트 파일


# Intro
카카오톡 테마 제작할 때
이미지 사이즈 변경하는 작업이 너무 번거로워서 만듦


# Pre-use checks
[Windows OS]
1. magick.exe 다운로드
- https://imagemagick.org/script/download.php
  - [ImageMagick-7.1.0-55-portable-Q16-x64.zip] 다운로드
    - 압축 풀어서 resizer.bat와 동일한 경로에 [magick.exe] 파일 복사
2. 이미지 수정
- [img/res], [img/theme], [img/theme/land] 폴더 생성
  - 아래 이미지 파일 수정
  
    [img/res] ic_launcher.png ic_launcher_background.png ic_launcher_foreground.png ic_launcher_round.png
    
    [img/theme]
    theme_background_image.png theme_chatroom_background_image.png theme_maintab_cell_image.png theme_maintab_ico_call_focused_image.png theme_maintab_ico_call_image.png theme_maintab_ico_chats_focused_image.png theme_maintab_ico_chats_image.png theme_maintab_ico_find_focused_image.png theme_maintab_ico_find_image.png theme_maintab_ico_friends_focused_image.png theme_maintab_ico_friends_image.png theme_maintab_ico_game_focused_image.png theme_maintab_ico_game_image.png theme_maintab_ico_more_focused_image.png theme_maintab_ico_more_image.png theme_maintab_ico_piccoma_focused_image.png theme_maintab_ico_piccoma_image.png theme_maintab_ico_shopping_focused_image.png theme_maintab_ico_shopping_image.png theme_maintab_ico_view_focused_image.png theme_maintab_ico_view_image.png theme_passcode_background_image.png theme_splash_image.png
    theme_find_add_friend_button_image.png theme_find_add_friend_button_pressed_image.png theme_passcode_01_checked_image.png theme_passcode_01_image.png theme_passcode_02_checked_image.png theme_passcode_02_image.png theme_passcode_03_checked_image.png theme_passcode_03_image.png theme_passcode_04_checked_image.png theme_passcode_04_image.png theme_profile_01_image.png
    
    [img/theme/land] theme_splash_image.png
    
- github에 commit된 [img] 폴더를 복사해서 사용해도 무관함


# Description
- img/ : 사이즈 변경할 이미지 샘플
  - res/ : ic_launcher 관련 이미지
  - theme/ : theme 관련 이미지
    - land/ : land 관련 이미지
- README.md : 보세요
- resizer.bat : 이미지 사이즈 일괄 변경 스크립트 파일(안드로이드 카카오톡 테마 전용)

# Usage
```
resizer.bat --help

resizer.bat backup [PACKAGE_DIR_PATH]
  ex. resizer.bat backup C:\apeach-9.9.5-source

resizer.bat resize [PACKAGE_DIR_PATH] [IMG_DIR_PATH]
  ex. resizer.bat resize C:\apeach-9.9.5-source C:\img
```


# Reference
https://www.kakaocorp.com/page/service/service/KakaoTalk
https://t1.kakaocdn.net/kakaocorp/Service/Theme/KakaoTalk/Theme_Guide_220928.zip
https://t1.kakaocdn.net/kakaocorp/Service/Theme/KakaoTalk/Android_Sample_Theme_220928.zip
