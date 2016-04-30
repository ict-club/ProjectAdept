#include "Arduino.h"
class LED
{
  private:
  int pin;
  public:
  void init(int _pin);
  void pulse();
  void on();
  void off();
  void setVal(int val);
};
