
#include <stdint.h>
#include "config.h"
#include "sleep.h"

#define GPIO 0x40000000

int main()
{
    volatile uint32_t * led_device = (uint32_t *) (GPIO+0);
    volatile uint32_t led_value = 0x00000003;
	while(1){
		led_value =  ~led_value;
	    *led_device = led_value;
        sleep(SLEEP_CYCLES);	
    }

    return 0;
}
