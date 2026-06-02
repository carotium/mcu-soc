#include "config.h"
#include "mem.h"
#include "spi.h"
#include "flash.h"
#include "uart.h"

int main() {
	uart_init();
	spi_init();

	uint8_t status = flash_init();

	if(status != 0)
		return 1;

	uint32_t start_addr = 0x0;
	uint32_t size;
    uint32_t data_size;
	uint32_t *size_p = &size;
	uint32_t hex_data[64];

	flash_read_memory(start_addr, (uint8_t *) size_p, 4);
	printf("Need to load %x bytes!\r\n", size*4);

    data_size = size;

	start_addr += 0x4;

	uint32_t *dest_addr = (uint32_t *) 0x80001000;
	uint32_t *src_addr = hex_data;

	while(size > 64) {
		flash_read_memory(start_addr, (uint8_t *) src_addr, 64);
		memcpy(dest_addr, src_addr, 64);
		dest_addr += 16;
		src_addr += 16;
        start_addr += 64;
		size -= 64;
	}
	
	if(size != 0) {
		flash_read_memory(start_addr, (uint8_t *) src_addr, size);
		memcpy(dest_addr, src_addr, size);
	}

    printf("Check in RAM\r\n");
    uint32_t *data_in_ram = (uint32_t *) 0x80001000;

    for(int i = 0; i < data_size; i++) {
        printf("%x: %x\r\n", (data_in_ram + i) , *(data_in_ram + i));
    }

	return 0;
}
