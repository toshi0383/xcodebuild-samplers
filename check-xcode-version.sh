#!/bin/bash
case $1 in
    6) target=6D1002;;
    7) target=7D1014;;
    *) echo "Invalid Parameter $1"; exit 1;;
esac

build=`xcodebuild -version | grep Build | awk '{print $3}'`
if [ $build != $target ];then
    echo Wrong Xcode version. Switch to the right Xcode.
    echo Your build number: $build
    echo Expected build number: $target
    exit 1
fi
echo Xcode version check passed !
