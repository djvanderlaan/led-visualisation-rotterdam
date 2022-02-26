#include "flashled.h"
// flashled needs data on pin 11 and clock on 13.
// There are 25 LEDS for the neighbourhoods


// When LOGGING is set to 1 logging info is written to Serial
#define LOGGING 1

// =================================================================
// PALETTE
//
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


// =================================================================
// DATASETS
//
const int data_size = 25;
const int ndatasets = 3;
const uint8_t data[] PROGMEM = { 
  // dataset 0 = reference dataset with uniform colour and therefore 
  // not an actual dataset
  7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
  7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
  7, 7, 7, 7, 7,
  // dataset 1
  0, 7, 3, 2, 4, 5, 1, 0, 1, 7,
  0, 7, 3, 2, 4, 5, 1, 0, 1, 4,
  6, 4, 7, 4, 4,
  // dataset 2
  0, 7, 3, 2, 4, 5, 1, 0, 1, 7,
  0, 7, 3, 2, 4, 5, 1, 0, 1, 4,
  6, 4, 7, 4, 4,
  // dataset 3
  0, 7, 3, 2, 4, 5, 1, 0, 1, 7,
  0, 7, 3, 2, 4, 5, 1, 0, 1, 4,
  6, 4, 7, 4, 4
  };

// =================================================================
// READING THE PUNCHCARD VALUES
// 
const int punchcard1 = A0;
const int punchcard2 = A1;
const int punchcard4 = A2;
const int punchcard_threshold = 300;

int read_punchcard() {
  const int punchcard1_value = analogRead(punchcard1);
  const int punchcard2_value = analogRead(punchcard2);
  const int punchcard4_value = analogRead(punchcard4);
  const int value = (punchcard1_value > punchcard_threshold)*1 +
    (punchcard2_value > punchcard_threshold)*2 +
    (punchcard4_value > punchcard_threshold)*4;
#if LOGGING
  Serial.print("read_punchcard(): Punchcard values: ");
  Serial.print(punchcard1_value);
  Serial.print(",");
  Serial.print(punchcard2_value);
  Serial.print(",");
  Serial.print(punchcard4_value);
  Serial.print("-> value = ");
  Serial.println(value);
#endif
  return value;
}


// =================================================================
// DISPLAYING DATA
// 
void display_data(int dataset) { 
  if (dataset < 0 || dataset > ndatasets) {
#if LOGGING
    Serial.print("display_data(): dataset = ");
    Serial.print(dataset);
    Serial.print(" this is lower than 0 or higher than ndatasets = ");
    Serial.print(ndatasets);
    Serial.println("; turning off LED's");
#endif 
    flashled::turn_off_leds(data_size);
  } else {
#if LOGGING
    Serial.print("display_data(): showing dataset ");
    Serial.println(dataset);
#endif
    flashled::show_data(data+(dataset)*data_size, palette, 25);
  }
}


// =================================================================
// SETUP
//
void setup() {
  flashled::begin();
#if LOGGING
  Serial.begin(9600);
#endif
}


// =================================================================
// LOOP
//
void loop() {
  const int punchcard_value = read_punchcard();
  display_data(punchcard_value);
  delay(500);
}
