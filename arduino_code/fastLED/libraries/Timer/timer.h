namespace Timer {
    inline void init() {
        // Set up timer1 as a clock cycle counter

        TCCR1A = 0;  
        TCCR1B = 0;  
        TCCR1C = 0;
    }

    inline void start() {
        TCNT1 = 0;      // Reset counter
        TCCR1B = 1;     // Start counter    
    }

    inline uint16_t stop() {
        TCCR1B = 0;         // Stop counter
        return TCNT1 - 2;   // Read the counter. Minus 2 because stopping the timer takes 2 cycles
    }
}