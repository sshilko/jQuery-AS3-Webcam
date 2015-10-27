#!/bin/sh

echo " "
echo "jQuery AS3 Web Camera by Sergey Shilko"
echo "To make you need open-source Adobe FLEX SDK version 3.6+ with flash player 9 libraries and Java 6"

#http://www.adobe.com/devnet/flex/flex-sdk-download.html
echo "Flex SDK 3.6: http://download.macromedia.com/pub/flex/sdk/flex_sdk_3.6a.zip"

echo "Compilation is made with native AS3 compiler 'mxmlc'"
echo " "

#ME="`whoami`"
#FLEX_SDK_HOME="~/$ME/FlexSDK"

FLEX_SDK_HOME="$HOME/FlexSDK"
#JAVA6_PATH="/usr/lib/jvm/java-6-sun/bin/java"
JAVA6_PATH=`whereis java`
MAKE="$JAVA6_PATH -jar $FLEX_SDK_HOME/lib/mxmlc.jar -as3=true -creator=sshilko -description='jquery-as3-webcam' -headless-server=true -compatibility-version=3.0.0 -target-player=9 -title='jquery-as3-webcam' +flexlib=$FLEX_SDK_HOME/frameworks sAS3Cam.as"

echo "Executing:"
echo $MAKE
echo " "
echo `$MAKE`
