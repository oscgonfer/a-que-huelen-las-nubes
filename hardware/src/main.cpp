#include "Arduino.h"

void setup()
{
    Serial.begin(115200);
    while (!Serial) { delay(1); } // wait until serial console is open, remove if not tethered to computer
    Serial.println("Hello!");
}


void loop() {
    int randNumber = random(300);
    Serial.println(randNumber);
    delay(100);
}