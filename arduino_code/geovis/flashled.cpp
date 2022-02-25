#include <SPI.h>
#include "flashled.h"

extern "C" {
  uint8_t turn_off_leds_asm(uint16_t n_leds);
  uint8_t show_data_asm(uint8_t *data, uint8_t *palette, uint16_t n_leds);
}

// turn_off_leds()
// Turns off all LEDs of a LED array with SPI interface. 
// Parameters:
//   n_leds   number of LEDs in the array
void flashled::turn_off_leds(uint16_t n_leds) {
  SPISettings settings(16000000, MSBFIRST, SPI_MODE0);
  SPI.beginTransaction(settings);

  turn_off_leds_asm(n_leds);

  SPI.endTransaction();  
}

// show_data()
// Shows data on a LED array with SPI interface, using the colours from palette.
// Parameters:
// data     data to be shown on the LED array, with 1 byte per LED. Data must reside in flash memory
// palette  colour palette to use. If data[i] = n, use colour at position 4*n to 4*n + 3 in the palette array.
//          The palette must reside in flash memory
// n_leds   The number of LEDs in the LED array
void flashled::show_data(uint8_t *data, uint8_t *palette, uint16_t n_leds) {
  SPISettings settings(16000000, MSBFIRST, SPI_MODE0);
  SPI.beginTransaction(settings);

  show_data_asm(data, palette, n_leds);

  SPI.endTransaction();
}

// begin()
// Initializes the flashled library. To be invoked once, during setup
void flashled::begin() {
    SPI.begin();
}
