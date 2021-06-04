import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;
float x, y;
int velocityX = 1, velocityY = 1;
int flugX = 1, flugY = 1;

void setup() {
  size(400, 300);
  arduino = new Arduino(this, 
    "COM5", 57600);
  arduino.pinMode(input0, 
    Arduino.INPUT);
  x = 0;
}

void draw() {
  background(0);
  float analog0 =(float)(arduino.analogRead(input0))/102;
  x += velocityX*flugX*analog0;
  y += velocityY*flugY*analog0;
  if (x >= width) {
    flugX = -1;
  } else if (x <= 0) {
    flugX = 1;
  }
  if (y >= height) {
    flugY = -1;
  } else if (y <= 0) {
    flugY = 1;
  }
  fill(255, 255, 50);
  ellipse(x, y, 20, 20);
}
