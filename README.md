# Reverse Engineering Core - Android apps
## Important
To run scripts, you need to have an Android SDK installed and adb command in terminal 
```shell
# path Android`s SDK on MacOS
~/Library/Android/sdk/platform-tools/
```
To test adb command
```shell
adb devices
```

## Getting started
```shell
git clone https://github.com/johnmarcus015/Reverse-Engineering-Core.git
cd Reverse-Engineering-Core/
chmod +x reverseAPKFromDevice.sh
```

## How to use
1. Plug a device to computer
2. Install app from play store
3. Continue via terminal
```shell
./reverseAPKFromDevice.sh
```
4. Type the app`s name
```shell
Enter the name of app: 
```
5. Select an option to extract files easily directly from apk
```shell
[1] Extract all images
[2] Extract all colors 
[3] Extract strings.xml
[4] Extract all
[5] Open JD-GUI
[q] Quit

>> Select an action: 
```

6. Type the package`s name of app 

**OBS:** After execution of shellscript, you will have a file with name like:  

```reverse-engineering-of-<app_name>```

This directory contains all files resources, images, decoded files, etc...
## Rebuild app
To remake a app with your modifications, you need to use apktool: 
```shell
java -jar apktool.jar b <file_with_modifications>
```

### How it work
- APK TOOLS (Version 2.4.1)
Tool to decode .apk to files with res, colos, etc...
- DEX2JAR
Tool to convert .dex to .class
- JD-GUI (Version 1.6.6)
Tool to decompile .class to .java and see smali