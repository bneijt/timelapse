
*What*: Simple GTK GUI to create timelapse video from separate images

*Why*: I couldn't find a simple GUI to do it already

*Current state*: Not released yet.


Future
------

 - Clean up temp files
 - Output to more sane place then `/tmp/timelapse.ogg`
 - Scaling images
 - Configure framerate via GUI
 - Tight connection between GUI and `gst-launch` subprocess
 - Multiple back-end support (`gst-launch-0.10`, `gst-launch-1.0`, `ffmpeg`)
 - Make sure all the images do not end up in "Recently used"
 - Hide main gui on subprocess execution
 - Separate temp directory per process (to allow multiple timelapse programs to run at the same time)
