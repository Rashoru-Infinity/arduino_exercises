int photocellPin = 2; //define photocellsh=2, read the value of voltage.
int ledPin = 12; //define ledPin12 is the output port of led’s level.
int val = 0; //define original of val.
unsigned long time = 0;

void setup() {
 pinMode(ledPin, OUTPUT); //set ledPin output
 Serial.begin(9600);
}
void loop() {
 val = analogRead(photocellPin); //get the value from sensor
 if (millis() < 30000 && millis() != time) {
  Serial.print(millis());
  Serial.print(",");
  Serial.println(val);
  time = millis();
 }
 if(val<=512){
//512=2.5V, if want the sensor be more sensitive, increase the number, or lese low the number.
 digitalWrite(ledPin, HIGH); //when the value of val is less than 512(2.5V), light up led lamp
 }
 else{
 digitalWrite(ledPin, LOW);
 }
}
