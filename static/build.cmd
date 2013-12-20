cd js/libs/
type * | uglifyjs -nm -nmf -o ../libs.js
cd ../..
start /B coffee -blcw js/test.coffee
start /B coffee -blcw js/review.coffee
start /B coffee --join js/script.js -blcw js/src/
REM start /B java -jar "C:\Users\a5c\Desktop\ab\Apps\xampp\htdocs\static\JsTestDriver-1.3.4.b.jar" --port 9876 --browser C:\Users\a5c\AppData\Local\Google\Chrome\Application\chrome.exe
start /B C:\cygwin\bin\ruby /usr/bin/sass --style compressed --watch css/src/sitestyle.scss:css/sitestyle.css
