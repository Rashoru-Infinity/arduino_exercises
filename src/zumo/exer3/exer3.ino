#include <ZumoShield.h>
ZumoMotors motors;

bool fin = true;
Pushbutton button(ZUMO_BUTTON);

void setup()
{
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
    motors.setSpeeds(180, 0);
    delay(2600);
    motors.setSpeeds(0, 0);
    delay(100);
    motors.setSpeeds(-180, 0);
    delay(2600);
    motors.setSpeeds(0, 0);
    delay(100);
    motors.setSpeeds(-180, -180);
    delay(2000);
    motors.setSpeeds(0, 0);
    fin = true;
  }
}
