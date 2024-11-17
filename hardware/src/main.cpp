#include "Arduino.h"

void setup()
{
    Serial.begin(115200);
    while (!Serial) { delay(1); } // wait until serial console is open, remove if not tethered to computer
}


void loop() {
    float pot = analogRead(A0);
    float conv = pot/4095*255;
    Serial.println(conv);
    delay(100);
}