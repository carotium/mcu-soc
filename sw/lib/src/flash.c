#include "flash.h"

void flash_sendCommand(uint8_t cmd) {
    //spi_select(SLAVE);
    spi_write(cmd);
}
