/**
* jQuery AS3 Webcam
*
* Copyright (c) 2012, Sergey Shilko (sergey.shilko@gmail.com)
* 
* Date: 08/01/2012
*
* @author Sergey Shilko
* @version 1.0
*
**/

/* SWF external interface:
 * webcam.save() - get base64 encoded JPEG image 
 * webcam.getCameraList() - get list of available cams
 * webcam.setCamera(i) - set camera, camera index retrieved with getCameraList
 * */

/* External triggers on events:
 * webcam.isClientReady() - you respond to SWF with true (by default) meaning javascript is ready to accept callbacks
 * webcam.cameraConnected() - camera connected callback from SWF
 * webcam.noCameraFound() - SWF response that it cannot find any suitable camera
 * webcam.cameraEnabled() - SWF response when camera tracking is enabled (this is called multiple times, use isCameraEnabled flag)
 * webcam.cameraDisabled()- SWF response, user denied usage of camera
 * webcam.swfApiFail()    - Javascript failed to make call to SWF
 * webcam.debug()         - debug callback used from SWF and can be used from javascript side too
 * */

package {
    
    import flash.system.Security;
    import flash.external.ExternalInterface;

    import flash.display.Sprite;
    import flash.media.Camera;
    import flash.media.Video;
    import flash.display.BitmapData;
    import flash.events.*;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    import flash.display.StageAlign;
    import flash.display.StageScaleMode;    

    import com.adobe.images.JPGEncoder;
    import Base64;

    public class sAS3Cam extends Sprite {

	private var camera:Camera  = null;
        private var video:Video    = null;
        private var bmd:BitmapData = null;

        private var camBandwidth:int = 0; // Specifies the maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second. To specify that Flash Player video can use as much bandwidth as needed to maintain the value of quality , pass 0 for bandwidth . The default value is 16384.
        private var camQuality:int = 100; // this value is 0-100 with 1 being the lowest quality. Pass 0 if you want the quality to vary to keep better framerates
        private var camFrameRate:int = 24;

        private function setupCamera(useCamera:Camera):void {
            useCamera.setMode(stage.stageWidth, stage.stageHeight, camFrameRate);
            useCamera.setQuality(camBandwidth, camQuality);
            useCamera.addEventListener(StatusEvent.STATUS, statusHandler);
            useCamera.setMotionLevel(100); //disable motion detection
        }
        
        private function setVideoCamera(useCamera:Camera):void {
            video = new Video();
            video.smoothing = false;
            video.attachCamera(useCamera);
            addChild(video);
        }
        
	public function sAS3Cam():void {
            flash.system.Security.allowDomain("*");
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            camera = Camera.getCamera();
            
            if (null != camera) {
                if (ExternalInterface.available) {
                    bmd = new BitmapData(stage.stageWidth, stage.stageHeight);

                    setupCamera(camera);
                    setVideoCamera(camera);
                    
                    try { 
                        var containerReady:Boolean = isContainerReady(); 
                        if (containerReady) {                     
                            setupCallbacks();
                        }  else { 
                            var readyTimer:Timer = new Timer(100); 
                            readyTimer.addEventListener(TimerEvent.TIMER, timerHandler); 
                            readyTimer.start(); 
                        }
                    } catch (err:Error) { } finally { }
                } else {
                    
                }
                
            } else {
                extCall('noCameraFound');
            }
	}

        private function statusHandler(event:StatusEvent):void {
            if (event.code == "Camera.Unmuted") {
                camera.removeEventListener(StatusEvent.STATUS, statusHandler);
                extCall('cameraEnabled');
            } else {
                extCall('cameraDisabled');
            }
        }
        
        private function extCall(func:String):Boolean {
            var target:String = this.loaderInfo.parameters["callTarget"];
            return ExternalInterface.call(target + "." + func);
        }

        private function isContainerReady():Boolean { 
            var result:Boolean = extCall("isClientReady");
            return result;
        }
        
        private function setupCallbacks():void {
            ExternalInterface.addCallback("save", save);
            ExternalInterface.addCallback("setCamera", setCamera);
            ExternalInterface.addCallback("getCameraList", getCameraList);
            extCall('cameraConnected');
            /* when we have pernament accept policy --> */
            if (!camera.muted) {
                extCall('cameraEnabled');
            }
            /* when we have pernament accept policy <-- */
        }

        private function timerHandler(event:TimerEvent):void {
            var isReady:Boolean = isContainerReady();
            if (isReady) {
                Timer(event.target).stop();
                setupCallbacks();
            }
        }

	public function getCameraList():Array {
            var list:Array = Camera.names;
            list.reverse();
            return list;
	}

	public function setCamera(id:Number):Boolean {
            var newcam:Camera = Camera.getCamera(id.toString());
            if (newcam) {
                camera = newcam;
                setupCamera(camera);
                setVideoCamera(camera);
                return true;
            }
            return false;
	}

        public function save():String {
            bmd.draw(video);
            video.attachCamera(null); //this stops video stream, video will pause on last frame (like a preview)
            var quality:Number = 100;
            var byteArray:ByteArray = new JPGEncoder(quality).encode(bmd);
            var string:String = Base64.encodeByteArray(byteArray);
            return string;
        }
    
    }

}
