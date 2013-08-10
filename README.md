
*What*: Simple GTK GUI to create time-lapse video from separate images

*Why*: I could not find a simple GUI to do it already

*Current state*: Works, but there is no easy way for any user to get it.

Installation
------------

There currently is no easy setup. This is a `cabal` based project, run `cabal-dev install` in repository directory to compile the GUI, but you will have to know what you are doing. After getting the binary, make sure you run the binary next to `main.glade` so it can find the GUI definition.

If you want to experiment with the [gstreamer](http://gstreamer.freedesktop.org/) pipeline to create timelapse movies from separate frames, take a look at [timelapseJpegFilesInDir.sh](blob/master/timelapseJpegFilesInDir.sh).


Roadmap
-------

The following is a list, without order, of the shortcomings I could think of. Let me know if you have patches for any of these or you would like to poke me to implement them.

 - Clean up temp files
 - Output to more sane place then `/tmp/timelapse.ogg`
 - Scaling images
 - Configure framerate via GUI
 - Tight connection between GUI and `gst-launch` subprocess
 - Multiple back-end support (`gst-launch-0.10`, `gst-launch-1.0`, `ffmpeg`)
 - Make sure all the images do not end up in "Recently used"
 - Hide main gui on subprocess execution
 - Separate temp directory per process (to allow multiple timelapse programs to run at the same time)
