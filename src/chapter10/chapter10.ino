int photocellPin = 2; //define photocellsh=2, read the value of voltage.
int ledPin = 12; //define ledPin12 is the output port of led’s level.
int val = 0; //define original of val.
int column = 0;
unsigned long lastTime = -1;

void setup() {
 pinMode(ledPin, OUTPUT); //set ledPin output
 Serial.begin(9600);
 delay(1000);
 Serial.println("ms,value");
}
void loop() {
 val = analogRead(photocellPin); //get the value from sensor
 unsigned long time = millis();
 if (time < 30000 + 1000) {
   if (time < 1000 && lastTime == -1) {
     Serial.print(0);
     Serial.print(",");
     Serial.println(val);
     lastTime = 1000;
   }else if (time != lastTime) {
    Serial.print(time - 1000);
    Serial.print(",");
    Serial.println(val);
    lastTime = time;
   }
 }
 if(val<=512){
//512=2.5V, if want the sensor be more sensitive, increase the number, or lese low the number.
 digitalWrite(ledPin, HIGH); //when the value of val is less than 512(2.5V), light up led lamp
 }
 else{
 digitalWrite(ledPin, LOW);
 }
}
