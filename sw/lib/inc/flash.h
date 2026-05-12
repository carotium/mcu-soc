#pragma once

#include "spi.h"
#include "config.h"

#define READ_ID 0x9E

void flash_sendCommand(uint8_t cmd);
