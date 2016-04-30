#include <SoftwareSerial.h>
#include "led.h"
SoftwareSerial mySerial(3, 2); // RX, TX
int _red = 9;
int _green = 8;
int _blue = 7;
int pressure=0;
int r=0;
int g=0;
int p=0;
int offset=0;
LED red;
LED blue;
LED green;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  mySerial.begin(9600);
  // mySerial.println("Hello, world?");
  pinMode(_red, OUTPUT);
  pinMode(_green, OUTPUT);
  pinMode(_blue, OUTPUT);
  pinMode(0, INPUT);
  char c;
  red.init(_red);
  blue.init(_blue);
  green.init(_green);
  blue.off();
  green.off();
  red.off();
  offset=analogRead(0);
}

void loop() { // run over and over
 // red.pulse();
  
 // green.pulse();
  //red.setVal(200);
//pressure =analogRead(0);
//Serial.println(analogRead(0));

  pressure =analogRead(0);
//  data =pressure;
  p = map(pressure,0,1023,0,255);
  r=p/2;
  g= 350-p;
 /* Serial.print("r: ");
  Serial.println(r);
  Serial.print("g ");
 Serial.println(g);*/
  red.setVal(r);
  green.setVal(g);
//  Serial.print("pressure 1 ");
 // Serial.println(analogRead(0));
 // Serial.print("pressure 2 ");
 char pressureStringData[10];
 memset(pressureStringData, 0, 10);
 sprintf(pressureStringData, "%d", pressure);
  Serial.println(pressureStringData);
  mySerial.print(pressureStringData);
  mySerial.println();
  delay(100);
 
//}
 /* while (Serial.available())
  {
    mySerial.print((char)Serial.read());

    delay(10);
  }
  while (mySerial.available())
  {

    Serial.print((char)mySerial.read());
    //delay(10);
  }
  for (int i = 0; i <= 1000; i ++)
  {
    mySerial.write("A");
    mySerial.write(i);
    mySerial.write("/");
    mySerial.write("A");
    mySerial.println();
    delay(150);
  }*/
}

