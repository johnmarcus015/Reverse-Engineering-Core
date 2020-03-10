#!/bin/bash
#Get name of app
read -p "Enter the name of app: " APP_NAME
echo $APP_NAME

#Get package name of app
echo "I: Searching package of app..."
PACKAGE_NAME=$(adb shell pm list packages | grep -i $APP_NAME)
PACKAGE_NAME="${PACKAGE_NAME:8}"

#Get base path of .apk
echo "I: Searching the base apk..."
BASE_APK=$(adb shell pm path $PACKAGE_NAME | grep base.apk)
BASE_APK="${BASE_APK:8}"

#Get .apk from device
echo "I: Extracting .apk to computer..."
adb pull $BASE_APK
mv base.apk $APP_NAME.apk

#Decode .apk
echo "I: Decoding .apk..."
java -jar apktool.jar d -m $APP_NAME.apk

#Convert .apk to .jar
echo "I: Converting .apk to .jar..."
chmod +x dex2jar-2.0/*
./dex2jar-2.0/d2j-dex2jar.sh $APP_NAME.apk

#Organize files
echo -i "I: Organizing files..."
ROOT_FILE=reverse-engineering-of-$APP_NAME
mkdir $ROOT_FILE

DEX_FILE=$APP_NAME-dex2jar.jar
mv $DEX_FILE $ROOT_FILE/$DEX_FILE

ERROR_FILE=$APP_NAME-error.zip
mv $ERROR_FILE $ROOT_FILE/$ERROR_FILE

mv $APP_NAME $ROOT_FILE/$APP_NAME

APK_FILE=$APP_NAME.apk
mv $APK_FILE $ROOT_FILE/$APK_FILE

#Open decompiled code
echo "I: Open your project in JD-GUI to see codes"
java -jar jd-gui.jar