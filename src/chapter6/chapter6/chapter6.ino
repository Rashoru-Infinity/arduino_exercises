int ledred=10; //define digital pin10 red
int ledyellow=7; //define digital pin7 yellow
int ledgreen=4; //define digital pin4 green

void setup() {
  // put your setup code here, to run once:
  pinMode(ledred,OUTPUT);//set red pin output
  pinMode(ledyellow,OUTPUT);// set yellow pin output
  pinMode(ledgreen,OUTPUT);// set green pin output
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(ledred,HIGH);//light up red lamp
  delay(1000);//delay 1000 ms = 1 s
  digitalWrite(ledred,LOW);//go out red lamp
  digitalWrite(ledyellow,HIGH);//light up yellow lamp
  delay(200);//delay 200 ms//
  digitalWrite(ledyellow,LOW);//go out
  digitalWrite(ledgreen,HIGH);//light up green lamp
  delay(1000);//delay 1000 ms
  digitalWrite(ledgreen,LOW);//go out
}
