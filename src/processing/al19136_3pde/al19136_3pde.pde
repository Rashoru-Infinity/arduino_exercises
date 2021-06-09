import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int input0 = 0;

float x;
float y;
float velocityX = 0;
float velocityY = 0;
float deg = 0;
int radius = 10;
float speed = 0;
int time = 0;

void setup() {
  size(1920, 1200);
  arduino = new Arduino(this, "COM4",57600);
  arduino.pinMode(input0, Arduino.INPUT);
  x = 0 + 10;
  y = height - 10;
  velocityX = 0;
  velocityY = 0;
}

void show_status() {
  //heading
  text("deg : ", 10, 20);
  text(deg + 180, 60, 20);
  //speed
  text("speed : ", 10, 40);
  text(speed, 60, 40);
  //location
  text("x:", width - 100, 20);
  text(x, width - 70, 20);
  text("y:", width - 100, 40);
  text(height - y, width - 70, 40);
}

float getVectorSize(float x, float y) {
  return sqrt(x * x + y * y);
}

void draw() {
  background(0);
  if (millis() < 10000) {
    text("Setting", 150, 20);
    text("Remains : ", 250, 20);
    text(10000 - 1 - millis(), 350, 20);
    text("ms", 380, 20);
    deg = float(arduino.analogRead(input0)) / 1023 * 90 - 180;
    show_status();
  }
  if (10000 <= millis() && millis() < 15000) {
    text("OK", 150, 20);
    text("Setting", 150, 40);
    text("Remains : ", 250, 40);
    text(15000 - 1 - millis(), 350, 40);
    text("ms", 380, 40);
    speed = float(arduino.analogRead(input0)) / 1023 * 20;
    velocityX = speed * cos(radians(deg));
    velocityY = speed * sin(radians(deg));
    show_status();
    time = millis();
  }
  if (millis() >= 15000) {
    text("OK", 150, 20);
    text("OK", 150, 40);
    if (x + velocityX > width || x + velocityX < 0) {
      velocityX *= -1;
    }
    if (y + velocityY > height || y + velocityY < 0) {
      velocityY *= -1;
    }
    x += velocityX;
    y += velocityY;
    show_status();
    deg = degrees(atan2(velocityY, velocityX));
    velocityY += 9.8 * (float((millis() - time)) / 1000);
    speed = getVectorSize(velocityX, velocityY);
    time = millis();
  }
  fill(255,255,50);
  ellipse(x, y, radius * 2, radius * 2);
}
