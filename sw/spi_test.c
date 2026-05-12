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
	spi_select(0x1);
	sleep();
	spi_unselect();
	sleep();
	spi_send(0xDE);
    }
        
    return 0;
}
