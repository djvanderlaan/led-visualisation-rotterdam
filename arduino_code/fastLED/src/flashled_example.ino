#define PERFMON 0   

#include <flashled.h>
#if PERFMON
#include <timer.h>
#endif

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
const uint8_t data[] PROGMEM = { 0, 7, 3, 2, 4, 5, 1, 0 };

void setup() {
  flashled::begin();
#if PERFMON
  Timer::init();
  Serial.begin(9600);
#endif

}

void loop() {
#if PERFMON
  uint16_t time_elapsed;

  noInterrupts();
  Timer::start();
#endif

  flashled::show_data(data, palette, 8);

#if PERFMON
  time_elapsed = Timer::stop();
  interrupts();
  Serial.print("show_data: ");
  Serial.println(time_elapsed);
#endif

  delay(1000);

#if PERFMON
  noInterrupts();
  Timer::start();
#endif

  flashled::turn_off_leds(8);

#if PERFMON
  time_elapsed = Timer::stop();
  interrupts();
  Serial.print("turn_off_leds: ");
  Serial.println(time_elapsed);
#endif

  delay(1000);
}
