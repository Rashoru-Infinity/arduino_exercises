import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;

float x;
float y;
int velocityX = 1;
int velocityY = 1;

int radius = 10;

void setup() {
  size(400, 300);
  arduino = new Arduino(this, "COM4",57600);
  arduino.pinMode(input0, Arduino.INPUT);
  x = radius;
  y = height / 2;
}

void draw() {
  background(0);
  int speed = arduino.analogRead(input0) * 10 / 1023;
  if (x <= 10 && velocityX < 0)
    velocityX *= -1;
  if (x >= width - 10 && velocityX > 0)
    velocityX *= -1;
  if (y <= 10 && velocityY < 0)
    velocityY *= -1;
  if (y >= height - 10 && velocityY > 0)
    velocityY *= -1;
  x += velocityX * speed;
  y += velocityY * speed;
  fill(255,255,50);
  ellipse(x, y, radius * 2, radius * 2);
}
