# Reverse Engineering Core - Android apps
## How to use
1. Plug a device to computer
2. Install app from play store
3. Continue via terminal
```shell
git clone http://github.com/johnmarcus015/reverse-engineering-core
cd reverse-engineering-core
chmod +x reverseAPKFromDevice.sh
./reverseAPKFromDevice.sh
```
## Observation
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
Tool to decompile .class to .java