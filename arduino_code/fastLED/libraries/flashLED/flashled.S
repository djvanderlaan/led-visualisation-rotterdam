#define __SFR_OFFSET 0
#include <avr/io.h>

.global turn_off_leds_asm
.global show_data_asm

.macro WAIT cycles
.rept \cycles
nop
.endr
.endm

; Is this the fastest way of pushing data from an Arduino to a peripheral device over a synchronous serial bus?
; The code uses the Arduino's inbuilt SPI interface to push the data at the highest possible bit rate (1/2 fclk = 8 MHz), and uses the 
; experimentally verified fact that the Arduino takes 18 clock cycles in total to push a byte of data across the SPI interface.
; It appears that there's 2 clock cycles of overhead in addition to the 2 clock cycles it takes to send a single bit.
; The code does not check the SPIF bit to signal "end of transfer" after each byte to save some clock cycles.

; turn_off_leds_asm
;
; Writes the pattern 00 00 00 00 [ff 00 00 00]* ff ff ff ff to the SPI port to turn all LEDs off,
; the first 4 bytes constitute the start packet, the repeating bytes represent the colour of each LED ("off" in all cases),
; and the final 4 bytes contitute the end packet. 
;
; If you invoke write_end_packet with r25:24 = 4, only the end packet will be written.
;
; Code takes exactly 18 clock cycles between pairs of consecutive bytes written to the LED array
; Parameters: 
;   r25:r24: number of LEDs
turn_off_leds_asm:
  out SPDR, r1  ; r1 = 0 guaranteed by the compiler
  WAIT 1
  add r24, r24  ; multiply r27:r26 by 2
  adc r25, r25
  add r24, r24  ; and multiply r27:r26 by 2 once again, to obtain 4 * size = number of bytes needed to turn off r25:r24 number of LEDs
  adc r25, r25
  adiw r24, 7   ; add number of as yet unwritten bytes in start and end packets
write_end_packet:
loop0:
  ldi r18, 0
  mov r20, r24
  andi r20, 3
  brne nochange
  ldi r18, 0xff
nochange:
  cpi r24, 4  ; compare r27:r26 with 4. If r27:r26 < 4, carry flag is set, else it is cleared
  cpc r25, r1
  sbc r18, r1 ; since r18 = 0 if r27:r26 < 4, this will change it to 0xff
  WAIT 2
  out SPDR, r18
  WAIT 3
  sbiw r24, 1
  brne loop0
  WAIT 6
  in r24, SPSR  ; Force SPIF bit reset
  ret

; show_data_asm
;
; Write data to LED array, using specified colour palette.
; Code takes exactly 18 clock cycles between pairs of consecutive bytes
; Parameters:
;   r25:r24 pointer to data
;   r23:r22 pointer to palette
;   r21:r20 number of LEDs
show_data_asm:
  ; First send start packet (32-bits 0x0) to the LED array
  out SPDR, r1  ; Send 0x0 to the LED array. Register r1 is kept at 0 by the compiler
  WAIT 2
  ldi r19, 3    ; Send 3 more 0x0 bytes to the LED array.
loop1:
  WAIT 14
  out SPDR, r1
  dec r19
  brne loop1
  
  ; Send 1 32-bits colour packet to each LED in the array with the RGB colour and brightness of the LED
  movw r26, r20 ; Move number of LEDs to r27:r26, because we can use adiw and sbiw on r27:r26 but not on r21:r20
  movw r30, r24 ; Move data pointer to Z register
led_set_loop:
  lpm r18, Z+   ; Read colour number in r18, increment data pointer
  movw r24, r30 ; Keep incremented data pointer for future use
  lsl r18       ; Multiply colour number by 4
  lsl r18
  movw r30, r22 ; And add this to the palette pointer. Result is a pointer to the correct 32-bit colour in Z register
  add r30, r18
  adc r31, r1

  ldi r20, 3    ; First send the first three bytes of the colour packet
loop2:
  lpm r18, Z+   ; Read one byte from the palette colour
  out SPDR, r18 ; And send it to the LED array
  WAIT 11
  dec r20
  brne loop2

  lpm r18, Z+   ; Read final byte from the palette colour. Loop is unrolled for the final byte of the colour packet
  movw r30, r24 ; Since we now no longer need Z to point to the palette colour, point it to next data item instead
  out SPDR, r18
  sbiw r26, 1
  brne led_set_loop

  ; Finally, send end packet (32-bits 0xffffffff) to the LED array. We re-use part of the code for turning off all LEDs,
  ; as that code sends the same end packet to the LED array.
  ldi r24, 4
  ldi r25, 0
  rjmp write_end_packet
