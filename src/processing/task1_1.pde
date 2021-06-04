/* ライブラリのインポート*/
import processing.serial.*;
import cc.arduino.*;
/* 値の設定*/
Arduino arduino;
int input0 = 0;
float x;
int velocityX = 1;
int flug = 1;

void setup() {
size(400, 300);
x = 0;
}

void draw() {
background(0);
x += velocityX*flug;
if(x >= width){
  flug = -1;
}else if(x <= 0){
  flug = 1;
}
fill(255,255,50);
ellipse(x, height/2, 20, 20);
}
