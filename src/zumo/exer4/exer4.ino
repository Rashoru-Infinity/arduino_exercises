#include <Wire.h>
#include <ZumoShield.h>

// ライントレースセンサを宣言する
ZumoReflectanceSensorArray reflectanceSensors;
ZumoMotors motors;
int lines = 0;
bool start = false;
Pushbutton button(ZUMO_BUTTON);

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

void loop()
{
  if (start)
    motors.setSpeeds(180, 180);
  if (button.getSingleDebouncedPress())
    start = true;
  // 最後にセンサを読んだ時間を記録
  static uint16_t lastSampleTime = 0;

  // 最後にセンサを読み取った時間より100ms以上，時間がたった時に
  // if文の中に入り，もう一度センサを読み取る
  // millis() プログラムが起動してからの経過時間
  if ((uint16_t)(millis() - lastSampleTime) >= 100)
  {
    // 最後にセンサを読んだ時間を現在時刻にセット
    lastSampleTime = millis();

    // ライントレースセンサを読み取る
    reflectanceSensors.read(sensorValues, QTR_EMITTERS_ON);
    if (sensorValues[4] >= 600 || sensorValues[5] >= 600) {
      lines++;
    }
    if (lines >= 4) {
      start = false;
      motors.setSpeeds(0, 0);
      if (button.getSingleDebouncedPress()) {
        start = true;
        lines = 0;
      }
    }
    // 読み取ったセンサの値をprintする
    printReadingsToSerial();
  }
}
