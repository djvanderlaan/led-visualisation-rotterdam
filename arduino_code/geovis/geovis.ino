#include "flashled.h"
// flashled needs data on pin 11 and clock on 13.
// There are 25 LEDS for the neighbourhoods


// When LOGGING is set to 1 logging info is written to Serial
#define LOGGING 1

// =================================================================
// PALETTE
//
// 0 = Viridis
// 1 = Plasma
// 2 = Sunset
// 3 = SunsetDark
// 4 = ag_GrnYl
// 5 = Zissou 1
const int palette_size = 8*2*4;
//const int palette_num = 1;
const uint8_t palette[] PROGMEM = { 
//Viridis,
0xFF, 0x19, 0x00, 0x16,
0xFF, 0x36, 0x12, 0x0C,
0xFF, 0x4D, 0x34, 0x00,
0xFF, 0x4E, 0x5E, 0x00,
0xFF, 0x37, 0x87, 0x00,
0xFF, 0x14, 0xAA, 0x4E,
0xFF, 0x09, 0xBA, 0xC9,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x0A, 0x00, 0x09,
0xFF, 0x16, 0x07, 0x05,
0xFF, 0x1F, 0x15, 0x00,
0xFF, 0x1F, 0x25, 0x00,
0xFF, 0x16, 0x36, 0x00,
0xFF, 0x08, 0x44, 0x1F,
0xFF, 0x04, 0x4B, 0x50,
0xFF, 0x00, 0x01, 0x01,
//Plasma,
0xFF, 0x43, 0x04, 0x00,
0xFF, 0x46, 0x00, 0x30,
0xFF, 0x42, 0x03, 0x63,
0xFF, 0x2D, 0x1B, 0x90,
0xFF, 0x0C, 0x47, 0xAC,
0xFF, 0x00, 0x8A, 0xB2,
0xFF, 0x12, 0xE6, 0x9A,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x1B, 0x01, 0x00,
0xFF, 0x1C, 0x00, 0x13,
0xFF, 0x1A, 0x01, 0x28,
0xFF, 0x12, 0x0B, 0x3A,
0xFF, 0x05, 0x1C, 0x45,
0xFF, 0x00, 0x37, 0x47,
0xFF, 0x07, 0x5C, 0x3D,
0xFF, 0x00, 0x01, 0x01,
//Sunset,
0xFF, 0x58, 0x1B, 0x2E,
0xFF, 0x64, 0x1F, 0x5E,
0xFF, 0x61, 0x29, 0x8C,
0xFF, 0x50, 0x3F, 0xB3,
0xFF, 0x3F, 0x63, 0xC1,
0xFF, 0x3C, 0x8F, 0xC3,
0xFF, 0x54, 0xC0, 0xBB,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x23, 0x0B, 0x13,
0xFF, 0x28, 0x0C, 0x26,
0xFF, 0x27, 0x11, 0x38,
0xFF, 0x20, 0x19, 0x48,
0xFF, 0x19, 0x28, 0x4D,
0xFF, 0x18, 0x39, 0x4E,
0xFF, 0x21, 0x4D, 0x4B,
0xFF, 0x00, 0x01, 0x01,
//SunsetDark,
0xFF, 0x26, 0x04, 0x39,
0xFF, 0x32, 0x06, 0x65,
0xFF, 0x33, 0x0E, 0x96,
0xFF, 0x2A, 0x23, 0xBF,
0xFF, 0x2B, 0x4D, 0xCA,
0xFF, 0x3A, 0x7A, 0xCC,
0xFF, 0x59, 0xAC, 0xCC,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x0F, 0x02, 0x17,
0xFF, 0x14, 0x03, 0x28,
0xFF, 0x15, 0x06, 0x3C,
0xFF, 0x11, 0x0E, 0x4C,
0xFF, 0x11, 0x1F, 0x51,
0xFF, 0x17, 0x31, 0x52,
0xFF, 0x24, 0x45, 0x52,
0xFF, 0x00, 0x01, 0x01,
//Fall,
0xFF, 0x0F, 0x22, 0x0F,
0xFF, 0x26, 0x4C, 0x32,
0xFF, 0x4C, 0x86, 0x6D,
0xFF, 0x88, 0xD1, 0xC6,
0xFF, 0x46, 0x8C, 0xA6,
0xFF, 0x18, 0x50, 0x92,
0xFF, 0x06, 0x1E, 0x82,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x06, 0x0E, 0x06,
0xFF, 0x0F, 0x1E, 0x14,
0xFF, 0x1F, 0x36, 0x2C,
0xFF, 0x36, 0x54, 0x4F,
0xFF, 0x1C, 0x38, 0x42,
0xFF, 0x0A, 0x20, 0x3B,
0xFF, 0x03, 0x0C, 0x34,
0xFF, 0x00, 0x01, 0x01,
//Zissou 1,
0xFF, 0x6F, 0x5C, 0x0E,
0xFF, 0x58, 0x79, 0x1D,
0xFF, 0x4E, 0x8A, 0x57,
0xFF, 0x06, 0x98, 0xAE,
0xFF, 0x02, 0x68, 0xAC,
0xFF, 0x00, 0x3A, 0xAC,
0xFF, 0x03, 0x04, 0xBE,
0xFF, 0x01, 0x02, 0x02,
0xFF, 0x2C, 0x25, 0x06,
0xFF, 0x23, 0x30, 0x0C,
0xFF, 0x1F, 0x37, 0x23,
0xFF, 0x03, 0x3D, 0x46,
0xFF, 0x01, 0x29, 0x45,
0xFF, 0x00, 0x17, 0x45,
0xFF, 0x01, 0x01, 0x4C,
0xFF, 0x00, 0x01, 0x01
};

// =================================================================
// DATASETS
//
const int data_size = 30+7;
const int ndatasets = 6;
const uint8_t data[] PROGMEM = { 
  // dataset 0 = reference dataset with uniform colour and therefore 
  // not an actual dataset
  // 0, 1, 2, 3, 4, 5, 6, 7, 7, 7,
  // 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
  // 7, 7, 7, 7, 7,     1,1,1,1,1,1,1,1,1,1,1,1,
  // == dataset 0
  // var: HuishOnderOfRondSociaalMinimum_79
  // breaks: 1.5, 5, 7.5, 10, 12.5, 15, 17.5, 20
  5, 6, 3, 6, 15, 4, 3, 15, 15, 3, 2, 3, 4, 4, 7, 8, 8, 7, 2, 7, 1, 7, 1, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 1: bedrijven per km2 2020
  // var: BedrijfsvestigingenTotaal_91
  // breaks: 0, 1, 2, 4, 6, 10, 20, 25
  4, 5, 6, 5, 11, 5, 1, 15, 12, 1, 3, 3, 4, 3, 1, 10, 10, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 2
  // var: Omgevingsadressendichtheid_117
  // breaks: 0, 1000, 2000, 3000, 4000, 5000, 6000, 7000
  3, 4, 6, 5, 9, 6, 1, 8, 8, 1, 2, 2, 5, 2, 0, 11, 8, 0, 2, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 3
  // var: SES
  // breaks: -0.55, -0.45, -0.35, -0.25, -0.15, -0.1, 0, 0.1
  0, 0, 4, 1, 15, 3, 4, 15, 15, 4, 6, 4, 2, 2, 7, 15, 14, 7, 3, 7, 5, 7, 6, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 4
  // var: SES_MAD
  // breaks: 0.7, 0.8, 0.95, 0.98, 1, 1.05, 1.1, 1.15
  3, 5, 4, 5, 15, 4, 4, 15, 15, 4, 2, 2, 5, 3, 7, 15, 8, 7, 1, 7, 0, 7, 1, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 5
  // var: SES_change
  // breaks: -0.09, -0.065, -0.04, -0.015, 0.015, 0.04, 0.065, 0.09
  3, 5, 5, 6, 15, 5, 6, 15, 15, 6, 3, 2, 4, 2, 7, 15, 11, 7, 2, 7, 1, 7, 3, 7, 7, 7, 7, 7, 7, 7, 0, 1, 2, 3, 4, 5, 6,
  // == dataset 6
  // var: jongeren
  // breaks: 0, 22, 24, 26, 28, 30, 32, 34
  5, 5, 2, 5, 10, 3, 4, 15, 15, 4, 4, 3, 6, 4, 0, 12, 10, 7, 3, 7, 3, 7, 2, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 0,
  // == dataset 7
  // This is all lights active -> the same as no card; we will use
  // this to switch off the lights
};

// Palettes used by each of the datasets
const int palettes[] = {1, 1, 1, 1, 1, 5, 1};


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
    const int palette_num = palettes[dataset];
    //const int palette_num = 4;
#if LOGGING
    Serial.print("display_data(): using palette ");
    Serial.println(palette_num);
#endif
    flashled::show_data(data+(dataset)*data_size, palette + palette_num*palette_size, data_size);
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
