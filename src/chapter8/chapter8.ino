unsigned long lastTime = -1;

void setup()
{
 pinMode(8,OUTPUT);//set pin8 output
 pinMode(5, INPUT_PULLUP);
 Serial.begin(9600);
 delay(1000);
 Serial.println("ms,value");
}
void loop()
{
 int i;//define i
 while(millis() < 30000 + 1000)
 {
  i=analogRead(5);//read voltage values of pin5
  unsigned long time = millis();
  if (time < 30000 + 1000 && lastTime != time) {
    if (time < 1000 && lastTime == -1) {
      Serial.print(0);
      Serial.print(",");
      Serial.println(i);
      lastTime = 1000;
    } else if (time != lastTime) {
      Serial.print(time - 1000);
      Serial.print(",");
      Serial.println(i);
      lastTime = time;
    }
    digitalWrite(8,HIGH);//light up led lamp
  }
 }
 digitalWrite(8,LOW);//go out led lamp
}
