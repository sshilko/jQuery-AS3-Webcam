/**
* jQuery AS3 Webcam
*
* Copyright (c) 2012, Sergey Shilko (sergey.shilko@gmail.com)
* 
* Date: 08/01/2012
*
* @author Sergey Shilko
* @version 1.0
**/

$(document).ready( function() {
    var webcam = {
	width: 320,
	height: 240,
        cameraId: 'AS3webcamObject',
        callTarget: 'webcam',
        bgcolor: '#000000',
        isSwfReady: false,
        isCameraEnabled: false,
	swffile: "sAS3Cam.swf",
        cameraEnabled:   function () { },
        cameraDisabled:  function () { },
        noCameraFound:   function () { },
        isClientReady:   function () { return true; },
        cameraReady:     function () { },
        cameraConnected: function () {
            this.isSwfReady = true;
	    var cam = document.getElementById(this.cameraId);
            
            this.save          = function()  { try { return cam.save();          } catch(e) { this.swfApiFail(e); } }
            this.setCamera     = function(i) { try { return cam.setCamera(i);    } catch(e) { this.swfApiFail(e); } }
            this.getCameraList = function()  { try { return cam.getCameraList(); } catch(e) { this.swfApiFail(e); } }

            this.cameraReady();
        },
        init: function(container, options) {
            if (typeof options === "object") {
                for (var ndx in webcam) {
                    if (options[ndx] !== undefined) {
                        webcam[ndx] = options[ndx];
                    }
                }
            }
            var source = '<object id="'+this.cameraId+'" type="application/x-shockwave-flash" data="'+webcam.swffile+'" width="'+webcam.width+'" height="'+webcam.height+'"><param name="movie" value="'+webcam.swffile+'" /><param name="FlashVars" value="callTarget='+this.callTarget+'" /><param name="allowScriptAccess" value="always" /><param name="bgcolor" value="'+webcam.bgcolor+'" /></object>';
            $(container).html(source);
            return this;
        },
        swfApiFail: function (e) { },
	debug:	    function ()  { },
    };
    window.webcam = webcam;
    $.fn.webcam = function(options) { return webcam.init(this, options); };
});
