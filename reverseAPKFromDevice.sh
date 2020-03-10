#!/bin/bash
#Get name of app
read -p "Enter the name of app: " APP_NAME
echo $APP_NAME

#Get package name of app
PACKAGE_NAME=$(adb shell pm list packages | grep -i $APP_NAME)
PACKAGE_NAME="${PACKAGE_NAME:8}"
echo $PACKAGE_NAME

#Get base path of .apk
BASE_APK=$(adb shell pm path $PACKAGE_NAME | grep base.apk)
BASE_APK="${BASE_APK:8}"
echo $BASE_APK

#Get .apk from device
adb pull $BASE_APK
mv base.apk $APP_NAME.apk

#Decode .apk
java -jar apktool.jar d -m $APP_NAME.apk
rm -r *error*

#Convert .apk to .jar
chmod +x dex2jar-2.0/*
./dex2jar-2.0/d2j-dex2jar.sh $APP_NAME.apk

#Open decompiled code
java -jar jd-gui.jar