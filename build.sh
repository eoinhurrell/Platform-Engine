#!/bin/bash
zip -r build/platform.love . -x "build/*" ".git/*" ".*"
case "$1" in
  "run" )
   echo "running: build/platform.love"
   xterm -e /Applications/love.app/Contents/MacOS/love "/Users/hurl/Dropbox/Own/Code/platform-engine/build/platform.love"
  ;;
  "build")
   echo "built"
  ;;
  "dist")
   echo "dist"
  ;;
   * )
  ;;

esac

