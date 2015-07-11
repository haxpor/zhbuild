#!/bin/bash

## A simple shell script to build Zombie Hero Project from command line
## It involves using the following programs
##
## 1. xcodebuild
## 2. ios-deploy
##
## Commands support (*specific for this script and project)
##
## 1. zhxcode build
##    Build Debug-build    
##
## 2. zhxcode clean
##    Clean the whole project
##
## 3. zhxcode xcconfig
##    Create an xcconfig file for Debug configuration of 'ZombieHero - Fast Build' scheme
##
## 4. zhxcode debug ipad
##    Build, deploy and debug Debug-build on ipad device. Build process is the same as in 1.
##
## 5. zhxcode debug
##    Build, deploy and debug Debug-build on ipod touch device. Build process is the same as in 1.

# setting for Zombie Hero Project
WPATH="/Users/haxpor/Data/Projects/ZombieHero/zombie-hero/"
FASTDEBUG_XCCONFIG_PATH="../xcconfig/zh-fastbuild.xcconfig"
XCODEPROJ_NAME="ZombieHero.xcodeproj"
PRODUCT_PATH="/Users/haxpor/Library/Developer/Xcode/DerivedData/ZombieHero-erdynsruzgedcidywngbikwfyczm/Build/Products/Debug-iphoneos/Zombie\ Hero\ -\ Fast\ Build.app"

# check the command

# 'build'
if [ "$1" == "build" ]; then

    # build Zombie Hero (fixed and default to 'Zombie Hero - Fast Build' for now
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iOS,name=iPod touch" -verbose)

# 'clean'
elif [ "$1" == "clean" ]; then

    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME clean -verbose)

# 'xcconfig'
elif [ "$1" == "xcconfig" ]; then

    cd $WPATH
    xcodebuild -project $XCODEPROJ_NAME -scheme "ZombieHero - Fast Build" -configuration Debug -showBuildSettings | tail -n +2 > $FASTDEBUG_XCCONFIG_PATH
    echo "Generated $FASTDEBUG_XCCONFIG_PATH successfully."

# 'debug' with iPad
elif [[ "$1" == "debug" ]] && [[ "$2" == "ipad" ]]; then

    echo "Building onto iPad ..."
    #build the project first
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iOS,name=haxpor’s iPad" -verbose)

    # Check exit status
    if [ $? != 0 ]; then
        echo -e "Build failed.\nExit now.\n"

        # exit with the last command status
        exit $?
    fi

    echo "Deploying ..."
    # deploy
    # deploy to the fixed path; see path in xcconfig file of this project
    (ios-deploy --debug --bundle /Users/haxpor/Library/Developer/Xcode/DerivedData/ZombieHero-erdynsruzgedcidywngbikwfyczm/Build/Products/Debug-iphoneos/Zombie\ Hero\ -\ Fast\ Build.app -v -i 12052c824186f4dc4820a5712baeb835f7d85ff1)

# 'debug'
elif [ "$1" == "debug" ]; then
    echo "Building ..."
    # build the project first
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iOS,name=iPod touch" -verbose)

    # Check exit status
    if [ $? != 0 ]; then
        echo -e "Build failed.\nExit now.\n"

        # exit with the last command status
        exit $?
    fi

    # if all else okay, then continue deploying to device
    echo "Deploying ..."
    # deploy
    # deploy to the fixed path; see path in xcconfig file of this project
    (ios-deploy --debug --bundle /Users/haxpor/Library/Developer/Xcode/DerivedData/ZombieHero-erdynsruzgedcidywngbikwfyczm/Build/Products/Debug-iphoneos/Zombie\ Hero\ -\ Fast\ Build.app -v -i 46feafc8d86d42adac26bab589b46e26540568d0)
 
fi