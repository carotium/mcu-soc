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

    printf("Hello from RVJ1!\n\r");
    uart_write_flush();
    sleep();
    
    flash_init();

    printf("Testing uart read\r\n");
    printf("Type number: ");
    uint8_t uart_num = uart_read();
    printf("\r\nTyped number: %x\r\n", uart_num);

    while (1) {
	    
        printf("\r\nReading from memory:\r\n");

        uint32_t start_addr = 0x0;
        uint32_t num_of_data = 0x100;

        flash_read_memory(start_addr, num_of_data);

    }
    return 0;
}
