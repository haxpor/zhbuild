#!/bin/bash

## A simple shell script to build Zombie Hero Project from command line
## See README.md

# setting for Zombie Hero Project
WPATH="/Users/haxpor/Data/Projects/ZombieHero/zombie-hero/"
FASTDEBUG_XCCONFIG_PATH="../xcconfig/zh-fastbuild.xcconfig"
FASTDEBUG_SIM_XCCONFIG_PATH="../xcconfig/zh-fastbuild-sim.xcconfig"
XCODEPROJ_NAME="ZombieHero.xcodeproj"
PRODUCT_PATH="/Users/haxpor/Library/Developer/Xcode/DerivedData/ZombieHero-erdynsruzgedcidywngbikwfyczm/Build/Products/Debug-iphoneos/Zombie\ Hero\ -\ Fast\ Build.app"
PRODUCT_NAME="Zombie Hero - Fast Build"
ARCHIVE_PATH="~/Desktop/ZombieHero.xarchive"
EXPORT_PATH="~/Desktop/ZombieHero.ipa"
PROVISIONING_PROFILE_NAME="10ffa923-c4cc-4cb6-82e1-503ce585d53e"
SIMULATOR_DEVICETYPEID="iPhone-6-Plus, 8.4"
IOS_SIM_TMP_LOG="/tmp/ios-sim-log"

# check the command

# 'build'
if [ "$1" == "build" ]; then

    # build Zombie Hero (fixed and default to 'Zombie Hero - Fast Build' for now
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iOS,name=iPod touch" -verbose)

# 'build-sim'
elif [ "$1" == "build-sim" ]; then
    # build Zombie Hero for ios simulator
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_SIM_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iphonesimulator,OS=8.4,id=3CD97526-5E6A-4670-A89F-D68A446BDF66" -verbose)

# 'archive'
elif [ "$1" == "archive" ]; then
    # archive the proejct
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -scheme "ZombieHero Beta" archivePath $ARCHIVE_PATH archive -verbose)

# 'export'
elif [ "$1" == "export" ]; then
    # export into .ipa file from archive resulted of 'archive' command
    (cd $WPATH && exec xcodebuild -exportArchive -archivePath $ARCHIVE_PATH.xcarchive -exportPath $EXPORT_PATH -exportFormat ipa -exportProvisioningProfile $PROVISIONING_PROFILE_NAME)

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

# 'debug' with simulator
elif [[ "$1" == "debug" ]] && [[ "$2" == "sim" ]]; then
    echo "Building onto simulator ..."
    #buid the project first
    (cd $WPATH && exec xcodebuild -project $XCODEPROJ_NAME -xcconfig $FASTDEBUG_SIM_XCCONFIG_PATH -scheme "ZombieHero - Fast Build" -configuration Debug -destination "platform=iphonesimulator,OS=8.4,id=3CD97526-5E6A-4670-A89F-D68A446BDF66" -verbose)

    # Check exit status
    if [ $? != 0 ]; then
        echo -e "Build failed.\nExit now.\n"

        # exit with the last command status
        exit $?
    fi

    echo "Remove the previous log ..."
    rm -rf $IOS_SIM_TMP_LOG
    echo "Running simulator with log ..."
    ios-sim launch /Users/haxpor/Library/Developer/Xcode/DerivedData/ZombieHero-erdynsruzgedcidywngbikwfyczm/Build/Products/Debug-iphonesimulator/Zombie\ Hero\ -\ Fast\ Build.app --devicetypeid $SIMULATOR_DEVICETYPEID --log ./.ios-sim-log &
    echo "Launching lldb and wait for the process to attach ..."
    lldb -n "$PRODUCT_NAME" -w

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
