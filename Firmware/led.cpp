#include "Arduino.h"
#include "led.h"

void LED::init(int _pin)
{
  pin=_pin;
  pinMode(pin, OUTPUT);
}
void LED::pulse()
{
  
  on();
  delay(1000);
  off();
  delay(1000);
}
void LED::on()
{
  analogWrite(pin,0);
}
void LED::off()
{
  analogWrite(pin,255);
}
void LED::setVal(int val)
{
  analogWrite(pin,255-val);
}

