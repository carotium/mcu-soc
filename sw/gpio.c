
#include <stdint.h>
#include "config.h"
#include "sleep.h"

#define GPIO  0x40000000
#define TIMER 0x30000000
#define UART  0x60000000


volatile uint32_t * uart_config = (uint32_t *) (UART+0);
volatile uint32_t * uart_speed = (uint32_t *) (UART+4);
volatile uint32_t * uart_tx = (uint32_t *) (UART+8);
volatile uint32_t * uart_status = (uint32_t *) (UART+12);

void uart_init() {
    // configure UART: enable, no parity, 1 stop bit, 8 data bits
    *uart_config = 0x00000001;
    // set speed
    int limit; 
    limit = 5208; // 50Mhz / 9600;
    *uart_speed = limit;
}

void uart_print_char(char c) {
	// wait until UART is ready to transmit
	while ((*uart_status & 0x00000001) == 0) {
		// UART is not ready, keep waiting
	}
	*uart_tx = (uint32_t) c;
}

void uart_print_string(const char * str) {
    while (*str) {
        uart_print_char(*str++);
    }
}
int main()
{
    volatile uint32_t * led_device = (uint32_t *) (GPIO+0);
    volatile uint32_t   led_value = 0x00000003;
    volatile uint32_t * timer_config = (uint32_t *) TIMER ;
    volatile uint32_t * timer_count_low = (uint32_t *)(TIMER + 4); // second mistake: need to put parentheses around the addition
    volatile uint32_t * timer_count_high = (uint32_t *)(TIMER + 8); 
	volatile uint32_t * timer_limit_low = (uint32_t *)(TIMER + 12);
	volatile uint32_t * timer_limit_high = (uint32_t *)(TIMER + 16);

    volatile uint64_t counter_new, counter_old, limit;

    *timer_limit_low = 0xFFFFFFFF;
	*timer_limit_high = 0xFFFFFFFF;

    //reset counter
	*timer_config = 0x00000003;
	//start counter
	*timer_config = 0x00000001;
	// read counter
	limit = 100000000;
    uart_init();
    
	while(1){
		led_value =  ~led_value;
	    *led_device = led_value;

        counter_new = *timer_count_high;
    	counter_new = *timer_count_low + (counter_new << 32);
    	counter_old = counter_new;

        uart_print_string("LEDs toggled\r\n");
    	while((counter_old + limit) > counter_new) {
    		counter_new = *timer_count_high;
    	    counter_new = *timer_count_low + (counter_new << 32);
    	}
        
    }

    return 0;
}
