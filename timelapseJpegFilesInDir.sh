#!/bin/bash
shopt -s nocaseglob

#Create a collection symlink
echo "Symlink"
SLDIR=/tmp/timelapse
rm -rf "$SLDIR"
mkdir "$SLDIR"
let i=0
for f in *.jpg; do
    ln -s "`readlink -f "$f"`" "$SLDIR"/"$i".jpg
    let i=i+1
done

#Run GST

#gst-launch-1.0 --gst-debug-level=5 multifilesrc location="$SLDIR/%d.jpg" do-timestamp=true caps="image/jpeg,framerate=\(fraction\)12/1" ! \
#    jpegdec ! queue ! videoconvert ! queue ! videorate ! theoraenc drop-frames=false ! oggmux ! \
#    filesink location="/tmp/timelapse.ogg"

gst-launch-0.10 multifilesrc location="/tmp/timelapse/%d.jpg" caps="image/jpeg,framerate=25/1" ! \
    jpegdec ! videorate ! theoraenc drop-frames=false ! oggmux ! \
    filesink location="/tmp/timelapse.ogg"
