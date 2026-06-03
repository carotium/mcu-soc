
#include <stdint.h>
#include "config.h"
#include "sleep.h"

#define GPIO  0x40000000
#define TIMER 0x30000000

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
	limit = 50000000;

    
	while(1){
		led_value =  ~led_value;
	    *led_device = led_value;

        counter_new = *timer_count_high;
    	counter_new = *timer_count_low + (counter_new << 32);
    	counter_old = counter_new;


    	while((counter_old + limit) > counter_new) {
    		counter_new = *timer_count_high;
    	    counter_new = *timer_count_low + (counter_new << 32);
    	}
    }

    return 0;
}
