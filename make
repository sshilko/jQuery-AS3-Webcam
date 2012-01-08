#!/bin/sh

echo " "
echo "jQuery AS3 Web Camera by Sergey Shilko"
echo "To make you need open-source Adobe FLEX SDK version 3.6+ with flash player 9 libraries and Java 6"
echo "Compilation is made with native AS3 compiler 'mxmlc'"
echo " "

ME="`whoami`"
FLEX_SDK_HOME="/home/$ME/FlexSDK"
JAVA6_PATH="/usr/lib/jvm/java-6-sun/bin/java"
MAKE="$JAVA6_PATH -jar $FLEX_SDK_HOME/lib/mxmlc.jar +flexlib=$FLEX_SDK_HOME/frameworks sAS3Cam.as"

echo "Executing:"
echo $MAKE
echo " "
echo `$MAKE`
