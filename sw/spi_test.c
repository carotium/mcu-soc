// Copyright (c) 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Authors:
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>

#include "spi.h"
#include "uart.h"
#include "print.h"
#include "config.h"
#include "flash.h"

void sleep(void) {
    int i;
    for (i=0; i < SLEEP_CYCLES; i++)
        asm volatile("nop" ::: "memory");
}

int main() {
    uart_init();
    spi_init();
    while (1) {
        printf("RVJ1\n\r");
	//sleep();
        uart_write_flush();
	sleep();
	//*reg8(SPI_BASE_ADDR, SPI_DIV_CLK_REG_OFFSET) = 19;
	//*reg8(SPI_BASE_ADDR, SPI_CTRL_REG_OFFSET) = 0x0;
	spi_select(SLAVE);
	sleep();
	spi_unselect();
	sleep();
	spi_select(SLAVE);
	spi_write(0xDE);
	spi_unselect();

	spi_select(SLAVE);
	flash_sendCommand(READ_ID);
	uint8_t flash_id = spi_read(1);
	//spi_unselect();
	printf("Flash ID: %x\r\n", flash_id);
    }
        
    return 0;
}
