zip -r build/platform.love . -x "build/*"
if [ $1 == "run" ]
then
   open build/platform.love
fi