import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;
float x;
int velocityX = 1;
int flug = 1;

void setup() {
  size(400, 300);
  arduino = new Arduino(this, "COM5", 
    57600);
  arduino.pinMode(input0, 
    Arduino.INPUT);
  x = 0;
}

void draw() {
  background(0);
  int analog0 =
    arduino.analogRead(input0);
  text("inpu0 = " + analog0, 10, 40);
  float diameter = map(analog0, 0, 1024, 
    0, height);
  x += velocityX*flug;
  if (x >= width) {
    flug = -1;
  } else if (x <= 0) {
    flug = 1;
  }
  fill(255, 255, 50);
  ellipse(x, height/2, diameter, diameter);
}
