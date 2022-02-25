namespace flashled {
  void begin();
  void turn_off_leds(uint16_t n_leds);
  void show_data(uint8_t *data, uint8_t *palette, uint16_t n_leds);
}