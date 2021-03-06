#include <Wire.h>
#include <ZumoShield.h>

// ライントレースセンサを宣言する
ZumoReflectanceSensorArray reflectanceSensors;
ZumoMotors motors;
bool start = false;
Pushbutton button(ZUMO_BUTTON);

int threshold = 1500;

enum status {
  right,
  left,
  stp,
  nop
};

// センサ値を保存するための配列に使うための変数
// 今回使用するものはセンサを6つ搭載するので6
#define NUM_SENSORS 6
uint16_t sensorValues[NUM_SENSORS];


void setup()
{
  // シリアルを初期化してボーレートを115200に設定する
  Serial.begin(115200);
  // センサを初期化する
  reflectanceSensors.init();
  delay(1000);
  Serial.println("sensor init ok");
}

int updateStatus() {
  if (sensorValues[0] >= threshold && sensorValues[5] >= threshold)
    return 0;
  if ((sensorValues[0] >= threshold || sensorValues[1] >= threshold)
  &&  (sensorValues[4] < threshold || sensorValues[5] < threshold)) {
    return 2;
  }
  if ((sensorValues[0] < threshold || sensorValues[1] < threshold)
  &&  (sensorValues[4] >= threshold || sensorValues[5] >= threshold)) {
    return 1;
  }
  return 3;
}

// センサ値をシリアルに送る
void printReadingsToSerial()
{
  char buffer[80];
  sprintf(buffer, "%4d %4d %4d %4d %4d %4d\n",
    sensorValues[0],
    sensorValues[1],
    sensorValues[2],
    sensorValues[3],
    sensorValues[4],
    sensorValues[5]
  );
  Serial.print(buffer);
}

bool mySerialRead() {
  char buf[5];
  int index = 0;
  int i = 0;
  char msg;
  //Serial.print("mySerialRead");
  if(Serial.available() > 0) {
    msg = Serial.read();
    if (msg == 's') {
      return true;
    }
  /*for(i = 0; i < 5; i++){
    Serial.print("read");
    char c = Serial.read();
    Serial.print("str");
    if (index >= 5) {
      return false;
    }
    buf[index++] = c;
    */
  }
  /*
  if (buf[0] != 's')
    return false;
  if (buf[1] != 't')
    return false;
  if (buf[2] != 'a')
    return false;
  if (buf[3] != 'r')
    return false;
  if (buf[4] != 't')
    return false;
  if (msg != 's')
    return false; 
  return true;
  */
  return false;
}

void loop()
{
  //Serial.print("loop");
  if (!start) {
    //while (true) {
      //if (button.getSingleDebouncedPress() || mySerialRead()) {
      if (mySerialRead()) {
        start = true;
        Serial.print("start");
      }
      //if (start)
        //break;
    //}
  }
  if (start) {
    reflectanceSensors.read(sensorValues, QTR_EMITTERS_ON);
    int s = updateStatus();
    if (s == 1) {
      motors.setSpeeds(400, 0);
      delay(30);
    //Serial.print("r\n");
    }
    if (s == 2) {
      motors.setSpeeds(0, 400);
      delay(30);
    //Serial.print("l\n");
    }
    if (s == 0) {
    //Serial.print("s\n");
    //while (true) {
      start = false;
      motors.setSpeeds(0, 0);
      Serial.print("goal");
      /*
      if (button.getSingleDebouncedPress()) {
        start = true;
      }
      if (start)
        break;
        */
      //}
    }
    if (s == 3) {
    //Serial.print("nop\n");
      motors.setSpeeds(100, 100);
    }
    printReadingsToSerial();
  }
}
