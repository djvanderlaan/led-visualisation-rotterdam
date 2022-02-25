#include "flashled.h"
// flashled needs data on pin 11 and clock on 13.
// There are 25 LEDS for the neighbourhoods

const uint8_t palette[] PROGMEM = { 
  0xff, 0x00, 0x00, 0xff, 
  0xff, 0x00, 0x40, 0xff, 
  0xff, 0x00, 0x80, 0xff, 
  0xff, 0x00, 0xc0, 0xff, 
  0xff, 0x00, 0xff, 0xff, 
  0xff, 0x00, 0xff, 0xc0, 
  0xff, 0x00, 0xff, 0x80, 
  0xff, 0x00, 0xff, 0x40 
};
const uint8_t data[] PROGMEM = { 
  0, 7, 3, 2, 4, 5, 1, 0, 1, 7,
  0, 7, 3, 2, 4, 5, 1, 0, 1, 4,
  6, 4, 7, 4, 4
  };

void setup() {
  flashled::begin();
}

void loop() {
  flashled::show_data(data, palette, 25);
  delay(1000);
  flashled::turn_off_leds(25);
  delay(1000);
}
