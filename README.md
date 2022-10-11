# Keep Document

A Flutter Application for securely storing your personal data in your mobile application. Useful for storing personal identities and other important documents that you may need at the click of a button.

Available on: [Play Store](https://play.google.com/store/apps/details?id=com.semikolan.datamanager.passmanager)


## Join Us

Be a part of the SemiKolan Developer's Community by joining our [Discord Server](https://discord.semikolan.co). Here you can discuss about the project or ask any other queries and there will be a lot of folks to help

[![](https://img.shields.io/discord/849036512045039637?color=5865F2&logo=Discord&style=flat-square)](https://discord.semikolan.co)

## File Structure

```


│
├── android\
│   ├── app\
│   │   ├── src\
│   │   │   ├── debug\
│   │   │   │   └── AndroidManifest.xml
│   │   │   ├── main\
│   │   │   │   ├── kotlin\
│   │   │   │   │   └── com\
│   │   │   │   │       └── semikolan\
│   │   │   │   │           └── datamanager\
│   │   │   │   │               └── passmanager\
│   │   │   │   │                   └── MainActivity.kt
│   │   │   │   ├── res\
│   │   │   │   │   ├── drawable\
│   │   │   │   │   │   ├── background.png
│   │   │   │   │   │   └── launch_background.xml
│   │   │   │   │   │
│   │   │   │   │   ├── drawable-v21\
│   │   │   │   │   │   ├── background.png
│   │   │   │   │   │   └── launch_background.xml
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-anydpi-v26\
│   │   │   │   │   │   └── ic_launcher.xml
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-hdpi\
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-mdpi\
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-xhdpi\
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-xxhdpi\
│   │   │   │   │   │
│   │   │   │   │   ├── mipmap-xxxhdpi\
│   │   │   │   │   │
│   │   │   │   │   ├── values\
│   │   │   │   │   │   └── styles.xml
│   │   │   │   │   ├── values-night\
│   │   │   │   │   │   └── styles.xml
│   │   │   │   │   └── values-v31\
│   │   │   │   │       └── styles.xml
│   │   │   │   └── AndroidManifest.xml
│   │   │   │
│   │   │   └── profile\
│   │   │       └── AndroidManifest.xml
│   │   └── build.gradle
│   │
│   ├── gradle\
│   │   └── wrapper\
│   │       └── gradle-wrapper.properties
│   ├── build.gradle
│   ├── gradle.properties
│   └── settings.gradle
│
├── assets\
│   ├── emptyall.json
│   ├── emptysearch.json
│   ├── intro1.png
│   ├── intro2.png
│   └── splash.png
│
├── ios\
│   ├── Flutter\
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   └── Release.xcconfig
│   │
│   ├── Runner\
│   │   ├── Assets.xcassets\
│   │   │   ├── AppIcon.appiconset\
│   │   │   │   ├── Contents.json
│   │   │   │
│   │   │   ├── BrandingImage.imageset\
│   │   │   │   └── Contents.json
│   │   │   │
│   │   │   ├── LaunchBackground.imageset\
│   │   │   │   ├── Contents.json
│   │   │   │   └── background.png
│   │   │   │
│   │   │   └── LaunchImage.imageset\
│   │   │       ├── Contents.json
│   │   │       └── README.md
│   │   ├── Base.lproj\
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   │
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── Runner-Bridging-Header.h
│   │
│   ├── Runner.xcodeproj\
│   │   ├── project.xcworkspace\
│   │   │   ├── xcshareddata\
│   │   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   │   └── WorkspaceSettings.xcsettings
│   │   │   └── contents.xcworkspacedata
│   │   │
│   │   ├── xcshareddata\
│   │   │   └── xcschemes\
│   │   │       └── Runner.xcscheme
│   │   └── project.pbxproj
│   │
│   ├── Runner.xcworkspace\
│   │   ├── xcshareddata\
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── WorkspaceSettings.xcsettings
│   │   └── contents.xcworkspacedata
│   └── .gitignore
│
├── lib\
│   ├── models\
│   │   ├── additem.dart
│   │   ├── dataitem.dart
│   │   └── sharedpref.dart
│   │
│   ├── screens\
│   │   ├── adddata.dart
│   │   ├── datascreen.dart
│   │   ├── edit_data.dart
│   │   ├── homepage.dart
│   │   ├── image_full_screen.dart
│   │   ├── introscreen.dart
│   │   └── takepicture.dart
│   │
│   ├── utils\
│   │   ├── colors.dart
│   │   └── storage.dart
│   │
│   ├── widgets\
│   │   ├── custom_alert.dart
│   │   ├── deleteconfirmation.dart
│   │   └── drawer.dart
│   └── main.dart
│
├── windows\
│   │
│   ├── flutter\
│   │   ├── CMakeLists.txt
│   │   ├── generated_plugin_registrant.cc
│   │   ├── generated_plugin_registrant.h
│   │   └── generated_plugins.cmake
│   │
│   ├── runner\
│   │   ├── resources\
│   │   ├── CMakeLists.txt
│   │   ├── Runner.rc
│   │   ├── flutter_window.cpp
│   │   ├── flutter_window.h
│   │   ├── main.cpp
│   │   ├── resource.h
│   │   ├── runner.exe.manifest
│   │   ├── utils.cpp
│   │   ├── utils.h
│   │   ├── win32_window.cpp
│   │   └── win32_window.h
│   │
│   ├── .gitignore
│   └── CMakeLists.txt
│
├── .gitignore
├── .metadata
├── README.md
├── analysis_options.yaml
├── pubspec.lock
└── pubspec.yaml
```


## Code Contributers

This project exists thanks to all the people who contribute.

<a href="https://github.com/semikolan-co/keep-document/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=semikolan-co/keep-document" />
</a>

# Project Images
![image](https://user-images.githubusercontent.com/76143659/195167923-f3428767-ed9c-4e2e-bc61-7eb1868d7818.png)
![image](https://user-images.githubusercontent.com/76143659/195167947-e1aede55-9865-487e-9784-a201475b55df.png)
![image](https://user-images.githubusercontent.com/76143659/195167969-cfcc0230-1935-4bae-8010-f822b7419e7b.png)
![image](https://user-images.githubusercontent.com/76143659/195167982-0cda4bf1-a7ff-4c05-a0fe-c85cf0c84e82.png)
![image](https://user-images.githubusercontent.com/76143659/195167999-ded2c84f-c3de-4e55-9def-4d3b45051a12.png)
![image](https://user-images.githubusercontent.com/76143659/195168017-7aca0396-4b98-4abe-b790-dde28e788ace.png)
![image](https://user-images.githubusercontent.com/76143659/195168029-5443c166-e8ec-47bd-b37f-1bc61713654c.png)
![image](https://user-images.githubusercontent.com/76143659/195168036-6d71bb24-1c19-47d6-8163-4ee50472ba1b.png)
![image](https://user-images.githubusercontent.com/76143659/195168040-84acacb6-b00e-4caf-b3d5-6b74aea3d15d.png)
