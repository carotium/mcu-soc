#include "flash.h"

void flash_init() {
    spi_select(SLAVE);

    spi_write(READ_ID);

    uint8_t flash_id[8] = {0};

    spi_read(flash_id, 8);

    for(uint8_t i = 0; i < 8; i++) {
        if(i == 0) printf("Flash ID: ");
        printf("%x ", flash_id[i]);
        if(i == 7) printf("\r\n");
    }

    spi_unselect();
}

void flash_send_address(uint32_t addr) {

    uint8_t addr_byte_0 = (uint8_t) addr;
    uint8_t addr_byte_1 = (uint8_t) addr >> 8;
    uint8_t addr_byte_2 = (uint8_t) addr >> 16;

    spi_write(addr_byte_0);
    spi_write(addr_byte_1);
    spi_write(addr_byte_2);
}

void flash_read_memory(uint32_t start_addr, uint32_t num_of_data) {
    spi_select(SLAVE);

    spi_write(READ);
    flash_send_address(start_addr);

    uint8_t data[num_of_data];

    printf("Start address:\r\n%x: ", start_addr);

    spi_read(data, num_of_data);

    for(uint32_t i = 0; i < num_of_data; i++) {
        if(i != 0 && i % 8 == 0) printf("\r\n%x: ", start_addr + i);
        printf("%x ", *(data + i));
    }

    spi_unselect();

    printf("\r\nEnd of read!\r\n");
}
