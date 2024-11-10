#include "Arduino.h"

void setup()
{
    Serial.begin(115200);
    while (!Serial) { delay(1); } // wait until serial console is open, remove if not tethered to computer
    Serial.println("Hello!");
}


void loop() {
    float pot = analogRead(A0)/1024*255;
    Serial.println(pot);
    delay(100);
}