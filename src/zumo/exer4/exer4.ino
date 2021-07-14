#include <ZumoShield.h>
#include <wire.h>
#define NUM_SENSORS 6
uint16_t sensorValues[NUM_SENSORS];
ZumoMotors motors;
ZomoReflecttanceSensorArray reflectanceSensors;


bool fin = true;
Pushbutton button(ZUMO_BUTTON);

void setup()
{
  Serial(115200);
  reflectanceSensors.init();
}

void loop()
{
  if (button.getSingleDebouncedPress())
    fin = false;
  if (!fin) {
    motors.setSpeeds(180, 180);
    delay(1000);
    motors.setSpeeds(0, 0);
    delay(100);
    motors.setSpeeds(180, -180);
    delay(2600);
    motors.setSpeeds(0, 0);
    delay(100);
    motors.setSpeeds(-180, 180);
    delay(2600);
    motors.setSpeeds(0, 0);
    delay(100);
    motors.setSpeeds(-180, -180);
    delay(2000);
    motors.setSpeeds(0, 0);
    fin = true;
  }
}
