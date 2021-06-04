import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;
float x,y;
int velocityX = 1,velocityY = 1;
int flugX = 1,flugY = 1;

void setup() {
  size(400, 300);
  x = 0;
}

void draw() {
  background(0);
  x += velocityX*flugX;
  y += velocityY*flugY;
  if (x >= width) {
    flugX = -1;
  } else if (x <= 0) {
    flugX = 1;
  }
  if(y >= height){
    flugY = -1;
  }else if(y <= 0){
    flugY = 1;
  }
   fill(255, 255, 50);
  ellipse(x, y, 20, 20);
}
