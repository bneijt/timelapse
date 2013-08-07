
*What*: Simple GTK GUI to create timelapse video from separate images

*Why*: I couldn't find a simple GUI to do it already

*Current state*: Not released yet.

Roadmap
-------
 - Add scroll bars to list view
 - Clean up temp files
 - Hide main gui on subprocess execution



Future
------

 - Scaling images
 - Configure framerate via GUI
 - Tight connection between GUI and `gst-launch` subprocess
 - Multiple back-end support (`gst-launch-0.10`, `gst-launch-1.0`, `ffmpeg`)
 - Make sure all the images do not end up in "Recently used"
