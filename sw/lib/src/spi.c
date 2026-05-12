#include "spi.h"

// SPI Divisor calculation
#define SPI_DIVISOR(clk_freq_i, spi_freq_i) ((clk_freq_i) / (spi_freq_i * 2) - 1)

void spi_init() {
    // SPI Divisor calculation
    const uint16_t divisor = SPI_DIVISOR(CLK_FREQ, SPI_FREQ);
    
    // Set Division to spi div clk reg
    *reg8(SPI_BASE_ADDR, SPI_DIV_CLK_REG_OFFSET) = divisor;

    // Clear control register
    *reg8(SPI_BASE_ADDR, SPI_CTRL_REG_OFFSET) = 0x0;
}

void spi_select(uint8_t slave) {
    // Set slave select
    *reg8(SPI_BASE_ADDR, SPI_SS_REG_OFFSET) = slave;
}

void spi_unselect() {
    // Set slave select
    *reg8(SPI_BASE_ADDR, SPI_SS_REG_OFFSET) = 0x0;
}

void spi_send(uint8_t data) {
    // Set data to TX data register
    *reg8(SPI_BASE_ADDR, SPI_TX_DATA_REG_OFFSET) = data;

    // Set slave select
    spi_select(0x1);

    // Start SPI transaction
    *reg8(SPI_BASE_ADDR, SPI_CTRL_REG_OFFSET) = SPI_START_WRITING;

    // Wait for SPI done transaction
    while (*reg8(SPI_BASE_ADDR, SPI_CTRL_REG_OFFSET) != 0x20);

    // Clear slave select
    spi_unselect();

    // Acknowledge SPI done transaction
    *reg8(SPI_BASE_ADDR, SPI_CTRL_REG_OFFSET) = 0x0;
}
