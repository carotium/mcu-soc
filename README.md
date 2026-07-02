# Microcontroller System-on-a-Chip
An open source microcontroller style system-on-chip.

# Organization
Every step from rtl to implementation is in a seperate folder. Workflow is as follows:
- yosys
- openroad
- klayout

# Guide
## Installation
Clone the repository:  
```sh
git clone https://github.com/carotium/mcu-soc.git
cd mcu-soc
```
Install and run docker container:
```sh
make docker-build
make docker-run-it
```
## Yosys
```sh
cd yosys && make clean
cd yosys && make yosys
```
## Openroad
Run openroad to finish:
```sh
cd openroad && make all
```
or step by step:
```sh
cd openroad && make floorplan
cd openroad && make placement
cd openroad && make cts
cd openroad && make routing
cd openroad && make finishing
```
## Klayout
Generate gds file:
```sh
cd klayout && make gds
```
