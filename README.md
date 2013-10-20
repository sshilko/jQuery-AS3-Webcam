```
/**
 * jQuery AS3 Webcam
 * Copyright (c) 2012, Sergey Shilko (sergey.shilko@gmail.com)
 * @author Sergey Shilko
 * @see https://github.com/sshilko/jQuery-AS3-Webcam
 * @see http://sshilko.github.io/examples/jQuery-AS3-Webcam/example.html
 */
```

## Demo
http://sshilko.github.io/examples/jQuery-AS3-Webcam/example.html

## Overview

* jQuery AS3 Webcam, you will be able to make JPEG captures of web camera, all interactions are made thru javascript.
* Javascript callback will receive base64 encoded JPEG image from webcamera.
* Support different webcam resolutions (320x240, 640x480, any).
* Adaptive stage scaling, align options 

SWF external interface:
```
webcam.save() - get base64 encoded JPEG image
webcam.getCameraList() - get list of available cams
webcam.setCamera(i) - set camera, camera index retrieved with getCameraList
webcam.getResolution() - retrieve actual web camera resolution (set width may not equal result width etc)
```


External triggers on events:
```
webcam.isClientReady() - you respond to SWF with true (by default) meaning javascript is ready to accept callbacks
webcam.cameraConnected() - camera connected callback from SWF
webcam.noCameraFound() - SWF response that it cannot find any suitable camera
webcam.cameraEnabled() - SWF response when camera tracking is enabled (this is called multiple times, use isCameraEnabled flag)
webcam.cameraDisabled()- SWF response, user denied usage of camera
webcam.swfApiFail()    - Javascript failed to make call to SWF
webcam.debug()         - debug callback used from SWF and can be used from javascript side too
```
and more...

## Why another library?

* Because i could not find an Action Script 3 library for capturing images, there simply was non available.
* Action Script 2 library (i.e. http://www.xarg.org/project/jquery-webcam-plugin/) are slow
