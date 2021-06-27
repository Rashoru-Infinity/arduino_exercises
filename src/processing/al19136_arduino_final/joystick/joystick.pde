import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

void setup() {
  arduino = new Arduino(this, "COM4", 57600);
  arduino.pinMode(0, Arduino.INPUT);
  arduino.pinMode(1, Arduino.INPUT);
  size(1920, 1200);
}

void draw() {
  background(0);
  int xValue = arduino.analogRead(0);
  int yValue = arduino.analogRead(1);
  text("x:" + xValue, 10, 100);
  textSize(64);
  text("y:" + yValue, 10, 200);
  fill(25, 255, 50);
}
