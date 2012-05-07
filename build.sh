#!/bin/bash
zip -r build/platform.love . -x "build/*" ".git/*" ".*"
case "$1" in
  "run" )
   echo "running: build/platform.love"
   open build/platform.love
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

