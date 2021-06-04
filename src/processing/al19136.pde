import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;

float x;
float y;
int velocityX = 10;
int velocityY = 0;
int coe = 1;

void setup() {
size(400, 300);
arduino = new Arduino(this, "COM5",57600);
arduino.pinMode(input0, Arduino.INPUT);
x = 0;
y = height / 2;
velocityY = 0;
}

void draw() {
background(0);
velocityY = coe * (int)((float)(arduino.analogRead(input0)) / 1024 * 10);
text(velocityY, 10, 20);
if (velocityY > 10)
  velocityY = 10;
if (velocityY < -10)
  velocityY = -10;
if (x <= 0 && velocityX < 0)
  velocityX *= -1;
if (x >= width)
  velocityX *= -1;
x += velocityX;
if (y <= 0 && velocityY < 0) {
  coe *= -1;
  velocityY *= -1;
}
if (y >= height && velocityY > 0) {
  coe *= -1;
  velocityY *= -1;
}
y += velocityY;
fill(255,255,50);
ellipse(x, y, 20, 20);
}
