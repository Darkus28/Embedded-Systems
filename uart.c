/*
 * Cordero Woods
 * EENG 461 UART TX
 * Lab 3
 */

#include <stdbool.h>
#include <stdint.h>

#define RCGCUART    (*((volatile unsigned long *)0x400FE618)) //Base Address:0x400FE000 Offset:0x618 pg.344 DataSheet
#define PORTA_AFSEL (*((volatile unsigned long *)0x40004420)) //Base Address Port A (APB):0x40004000 Offset:0x420 pg.671 DataSheet
#define PORTA_PCTL  (*((volatile unsigned long *)0x4000452C)) //Base Address Port A (APB):0x40004000 Offset:0x52C pg.688 DataSheet
#define PORTA_DEN   (*((volatile unsigned long *)0x4000451C)) //Base Address Port A (APB):0x40004000 Offset:0x51C pg.682 DataSheet
#define PORTA_AMSEL (*((volatile unsigned long *)0x40004528)) //Base Address Port A (APB):0x40004000 Offset:0x528 pg.687 DataSheet

#define UART0_CTL  (*((volatile unsigned long *)0x4000C030)) //Base Address UART0:0x4000C000 Offset:0x030 pg.904 DataSheet
#define UART0_IBRD (*((volatile unsigned long *)0x4000C024)) //Base Address UART0:0x4000C000 Offset:0x024 pg.904 DataSheet
#define UART0_FBRD (*((volatile unsigned long *)0x4000C028)) //Base Address UART0:0x4000C000 Offset:0x028 pg.904 DataSheet
#define UART0_LCRH (*((volatile unsigned long *)0x4000C02C)) //Base Address UART0:0x4000C000 Offset:0x02C pg.904 DataSheet
#define UART0_CC   (*((volatile unsigned long *)0x4000CFC8)) //Base Address UART0:0x4000C000 Offset:0xFC8 pg.904 DataSheet
#define UART0_FR   (*((volatile unsigned long *)0x4000C018)) //Base Address UART0:0x4000C000 Offset:0x018 pg.904 DataSheet
#define UART0_DR   (*((volatile unsigned long *)0x4000C000)) //Base Address UART0:0x4000C000 Offset:0x000 pg.904 DataSheet

//Clock Setup for enabling Port Clock
#define RCGCGPIO (*((volatile unsigned long *)0x400FE608))   //offset 0x608, base: 0x400FE000 pg. 340 DataSheet

void clock_setup() {
	// Setup the system clock to run at 50 Mhz from PLL with crystal reference
	((void (*)(uint32_t ui32Config))((uint32_t *)(((uint32_t *)0x01000010)[13]))[23])(0x01C00000|0x00000000|0x00000540|0x00000000);

	// Setup the GPIO Port Clock in RCGCGPIO
	((void (*)(uint32_t ui32Peripheral))((uint32_t *)(((uint32_t *)0x01000010)[13]))[6])(0xf0000805);
}

void configure_uart() {
	// Add the configuration steps necessary to enable U0TX at
	//   115200bps
	//   8 data bits
	//   No parity
	//   1 Stop bit
	// See datasheet Section 14.4, pg 902-903 for Init Procedure
	// See datasheet Section 14.3.2, pg 896 for the Baudrate (115200) calculation
	/*Baudrate Calculation
		BitRateSetting = SystemClock / (ClockDiv * DesiredBitRate)
		SystemClock = 50*10^6;
		DesiredBitRate = 115200
		ClockDiv = 16 (based on UARTCTL Reg HSE bit)
		BitRateSetting = 50e6 / (16*115200)= 27.1267
		BRDI = 27; // Write to UARTIBRD [16:0]
		BRDF = int( 0.1267 * 64) + 0.5 = 8 // Write to UARTFBRD [5:0]

	*/
	// Also in Valvano 8.3.2 UART Device Driver, pg 384 in 4th ed
	
	//1: Enable UART Module 0
	RCGCUART |= 0x0001; //enable UART0
	
	//2: enable clock for appropriate GPIO port ,in our case referencing pg. 1351 (Table 23-5) in the DataSheet, 
	//for UART0 we will enable the clock for Port A.This is already done for us in the clock_setup function provided.
	RCGCGPIO |= 0x0001; //enable the clock for portA
	
	//With the BRD values calculated, the UART configuration is written to the module in the following sequence
	
	//3: Disable the UART by clearing the UARTEN bit in the UARTCTL register.
	UART0_CTL &= ~0x0001;
	
	//4: Write the integer portion of the BRD to the UARTIBRD register. 
	UART0_IBRD = 27;
	
	//5: Write the fractional portion of the BRD to the UARTFBRD register.
	UART0_FBRD = 8;
	
	//6:  Write the desired serial parameters to the UARTLCRH register.
	UART0_LCRH = 0x0070; //8-bits data, No Parity, 1-Stop bit
	
	//7: Configure the UART clock source by writing to the UARTCC register.
	//UART0_CC = 0x0; not necessary using system clock by default
	
	//8: Optionally,configure the µDMA channel(see“MicroDirectMemoryAccess(μDMA)”on page 585) and enable the DMA option(s) in the UARTDMACTL register.
	//Not utilized in this Lab
	
	//9: Enable the UART by setting the UARTEN bit in the UARTCTL register. Enable Tx and Rx as well.
	UART0_CTL = 0x0301;
	
	//10: Configure the PMCN fields in the GPIOPCTL register to assign the UART signals to the appropriate pins.
	//see pg. 688 in the datasheet for value to assign.
	//PORTA_PCTL = (PORTA_PCTL & 0xFFFFFF00)+0x00000011;
	PORTA_PCTL = (PORTA_PCTL&0xFFFFFF00)+0x00000011;
	
	//11:disable analog function for PA0 and PA1
	PORTA_AMSEL &= ~0x03;
	
	//12: Set the GPIO AFSEL bits for the appropriate pins. 
	//PA0(U0RX) and PA1(U0TX) (Note for this lab only PA1 is needed) but I will set both for future labs
	PORTA_AFSEL |= 0x03;
	
	//13: Configure the GPIO current level and/or slew rate as specified for the mode selected (see pg. 673 and 681 in the DataSheet)
	//This step is ignored for this Lab
	
	//14: Enable digital input/output for appropriate pins
	PORTA_DEN |= 0x03;
}

void uartwrite(unsigned char data) {
	// Use UARTFR, datasheet pg 911, TXFF bit to make sure the TX FIFO is not full
	// then UARTDR, datasheet pg 906 to write this new character into the TX FIFO
	
	while((UART0_FR & 0x0020) !=0);
	UART0_DR = data;
}

void wait(unsigned long count){
	unsigned long i = 0;
	for(i=0; i<count; i++);
}

void say_hello() {
	// Modify hello string constant to include your name
	
	char hello[] = "Hello EENG461, from Cordero B. Woods\r\n";
	
	int length = sizeof(hello)/sizeof(hello[0]);
	while (true) {		
		for(int i = 0;i<length;i++){
			uartwrite(hello[i]);
			
		wait(1000000);
		}
		// Send hello string one character at a time, repeating forever
		wait(1000000);
	}
}

int main() {
	clock_setup();

	configure_uart();

	say_hello();

	while (true)
		continue;
}
