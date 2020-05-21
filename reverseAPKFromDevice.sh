#!/bin/bash

#Get adb path
getAdbPath() {
    if hash adb 2>/dev/null; then
        #Test adb showing devices
        adb devices
    else
        #Set adb path as variable of terminal
        read -p "Enter the path of adb: " ADB_PATH
        eval echo 'export PATH=$PATH:$ADB_PATH' >> ~/.bash_profile
        source ~/.bash_profile
    fi
}

#Get name of app
readAppName() {
    read -p "Enter the name of app: " APP_NAME
}

#Get package name of app
getAppPackage() {
    read -p "Enter the package of app: " PACKAGE_NAME
    echo "I: Searching package of app..."
    echo $PACKAGE_NAME
    #Commented, because this method is not eficiently to all cases
    # PACKAGE_NAME=$(adb shell pm list packages | grep -i $APP_NAME)
    # PACKAGE_NAME="${PACKAGE_NAME:8}"
}

#Get base path of .apk
getBasePath() {
    echo "I: Searching the base apk..."
    BASE_APK=$(adb shell pm path $PACKAGE_NAME | grep base.apk)
    echo $BASE_APK
    BASE_APK="${BASE_APK:8}"
    echo $BASE_APK
}

#Get .apk from device
getAPKFromDevice() {
    echo "I: Extracting .apk to computer..."
    adb pull $BASE_APK
    mv base.apk $APP_NAME.apk
}

#Decode .apk
decodeAPK() {
    echo "I: Decoding .apk..."
    java -jar apktool.jar d -m $APP_NAME.apk
}

#Convert .apk to .jar
convertAPK2Jar() {
    echo "I: Converting .apk to .jar..."
    chmod +x dex2jar-2.0/*
    ./dex2jar-2.0/d2j-dex2jar.sh $APP_NAME.apk
}

#Organize files
organizeFiles() {
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
}

#Show logo of reverse engineering core
showLogo() {
    echo " ______     ______     ______     ______     ______   __  __    "
    echo "/\  == \   /\  ___\   /\  ___\   /\  __ \   /\  == \ /\ \/ /    "
    echo "\ \  __<   \ \  __\   \ \ \____  \ \  __ \  \ \  _-/ \ \  _\"-.  "
    echo " \ \_\ \_\  \ \_____\  \ \_____\  \ \_\ \_\  \ \_\    \ \_\ \_\ "
    echo "  \/_/ /_/   \/_____/   \/_____/   \/_/\/_/   \/_/     \/_/\/_/ "
    echo ""
    echo "                                               by johnmarcus015 "
}

#Show menu on terminal
showMenu() {
    TEXT_EXTRACT_IMAGES="Extract all images"
    TEXT_EXTRACT_COLORS="Extract all colors"
    TEXT_EXTRACT_STRINGS="Extract strings.xml"
    TEXT_EXTRACT_ALL_OPTIONS="Extract all"
    TEXT_OPEN_JDGUI="Open JD-GUI"
    TEXT_QUIT="Quit"

    printf "\n[1] $TEXT_EXTRACT_IMAGES\n[2] $TEXT_EXTRACT_COLORS \n[3] $TEXT_EXTRACT_STRINGS\n[4] $TEXT_EXTRACT_ALL_OPTIONS\n[5] $TEXT_OPEN_JDGUI\n[q] $TEXT_QUIT\n\n"
    read -p ">> Select an action: " ACTION

    case $ACTION in
    "1") extractAPK && extractImages && nautilus $ROOT_IMAGES || xdg-open $ROOT_IMAGES ;;
    "2") extractAPK && extractColors && nautilus $ROOT_COLORS || xdg-open $ROOT_COLORS ;;
    "3") extractAPK && extractStrings && nautilus $ROOT_STRINGS || xdg-open $ROOT_STRINGS ;;
    "4") extractAPK && extractAll && nautilus $ROOT_FILE || xdg-open $ROOT_FILE ;;
    "5") nautilus $ROOT_FILE || xdg-open $ROOT_FILE && openJDGui ;;
    "q") exit 0 ;;
    *) echo "Invalid option" && showMenu ;;
    esac
}

#Extract all files necessary to make reverse engineering
extractAPK() {
    getAppPackage
    getBasePath
    getAPKFromDevice
    decodeAPK
    convertAPK2Jar
    organizeFiles
}

#Extract all images from .apk
extractImages() {
    ROOT_IMAGES=$ROOT_FILE/all_images/
    mkdir $ROOT_IMAGES
    find $ROOT_FILE/ -regex '.*\(jpg\|jpeg\|png\|gif\)' -exec cp "{}" $ROOT_IMAGES \;
}

#Extract all colors from .apk
extractColors() {
    ROOT_COLORS=$ROOT_FILE/all_colors/
    mkdir $ROOT_COLORS
    find $ROOT_FILE/ -type f -name "colors.xml" -exec cp "{}" $ROOT_COLORS \;
}

#Extract all strings from .apk
extractStrings() {
    ROOT_STRINGS=$ROOT_FILE/all_strings/
    mkdir $ROOT_STRINGS
    find $ROOT_FILE/ -type f -name "strings.xml" -exec cp "{}" $ROOT_STRINGS \;
}

#Extract codes, images, colors and strings from .apk
extractAll() {
    extractImages
    extractColors
    extractStrings
}

#Open JD-GUI
openJDGui() {
    echo "I: Open your project in JD-GUI to see codes"
    java -jar jd-gui.jar
}

#StartProgram
main() {
    getAdbPath
    clear
    showLogo
    readAppName
    showMenu
}

main
