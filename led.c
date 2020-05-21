/*
 * Cordero B. Woods
 * EENG 461 LAB 2
 *
 */

#include <stdbool.h>
#include <stdint.h>

//PORTF located at 0x40025000 pg.660
#define PORTF_DATA (*((volatile unsigned long *)0x40025038))   //bitwise addressing (ex. PF1  0000 0010 changes to 00 0000 1000=0x08,PF2 0000 0100 changes to 00 0001 0000=0x10,PF3=0x20) offset of DATA 0x038 for PF1,PF2,PF3
#define PORTF_DIR (*((volatile unsigned long *)0x40025400))   //offset of DIR register is 0x400 pg.663 DataSheet
#define PORTF_DEN (*((volatile unsigned long *)0x4002551C))   //offset of DEN register is 0x51C pg.682 DataSheet
#define PORTF_AFSEL (*((volatile unsigned long *)0x40025420))   //offset of AFSEL register is 0x420 pg.671 DataSheet
#define PORTF_LOCK	(*((volatile unsigned long *)0x40025520))   //offset of Lock register is 0x520 pg.684 DataSheet
#define PORTF_ICR	(*((volatile unsigned long *)0x4002541C))   //offset of Interrupt Clear register is 0x41C pg.670 DataSheet
#define PORTF_AMSEL (*((volatile unsigned long *)0x40025528))   //offset of AMSEL register is 0x528 pg.687 DataSheet
#define PORTF_PCTL (*((volatile unsigned long *)0x4002552C))   //offset of PCTL register is 0x52C pg.688 DataSheet
#define PORTF_PUR (*((volatile unsigned long *)0x40025510))   //offset of Pull Up  register is 0x510 pg.677 DataSheet
#define PORTF_CR	(*((volatile unsigned long *)0x40025524))   //offset of Interrupt Clear register is 0x524 pg.685 DataSheet

#define PORTF_IS (*((volatile unsigned long *)0x40025404))   //offset of Interrupt Sense register is 0x404 pg.664 DataSheet
#define PORTF_IBE (*((volatile unsigned long *)0x40025408))   //offset of Interrupt Both Edges register is 0x408 pg.665 DataSheet
#define PORTF_IEV (*((volatile unsigned long *)0x4002540C))   //offset of Interrupt Event register is 0x40C pg.666 DataSheet
#define PORTF_IM (*((volatile unsigned long *)0x40025410))   //offset of Interrupt Mask register is 0x410 pg.667 DataSheet
#define PORTF_RIS (*((volatile unsigned long *)0x40025414))   //offset of GPIO Raw Interrupt Status register is 0x414 pg.668 DataSheet

//Clock Setup
#define RCGCGPIO (*((volatile unsigned long *)0x400FE608))   //offset 0x608, base: 0x400FE000 pg. 340 DataSheet
#define RCC (*((volatile unsigned long *)0x400FE060))   //offset is 0x060 base: 0x400FE000 pg.254 DataSheet
#define RCC2 (*((volatile unsigned long *)0x400FE070))   //offset is 0x070 base: 0x400FE000 pg.260 DataSheet
#define RIS (*((volatile unsigned long *)0x400FE050))   //offset is 0x050 base: 0x400FE000 pg.244 DataSheet
#define NVIC_ISER_0 (*((volatile unsigned long *)0xE000E100))   //pg.142 DataSheet Reg 4
#define NVIC_IP_30 (*((volatile unsigned long *)0xE000E478))   //pg.136 DataSheet

//LED Bits
#define PF1 0x02
#define PF2 0x04
#define PF3 0x08

void rcgcgpio_setup(){
	
	RCGCGPIO |= 0x20; //enable the clock for portf
	
}

void wait_for_pll(){
	
	// Wait for PLLRIS = 1, bit 6 
	while (RIS &(1<<6) != 1) 
		continue; 
	
}

void system_clk_setup_50Mhz() {
	
	rcgcgpio_setup();
	
	// Use Precision Internal OSC 
	RCC2 |= 0x80000000; // Set USERCC2 we will use RCC2 instead of RCC for clock settings
	RCC &= 0xFFBFFFFF; // Clear USESYSDIV, this disable the division of the system clock
	RCC2 |= 0x800; // Set BYPASS, this bypasses the use of the PLL, so we are running of just the system clock which by default is set to use the PIOSC
	// Configure PLL 
	RCC &= 0xFFFFF83F; //Reset XTAL so that we can configure for our crystal
	RCC |= 0x0540; // configure XTAL for 16 MHz Crystal
	//Powerup PLL (clear RCC2 bit 13) 
	RCC2 &= 0xFFFFDFFF; //clear bit 13 
	RCC2 &= 0xBFFFFFFF; // 200MHz PLL output clear bit 30 
	RCC2 &= 0xE07FFFFF; // clear SYSDIV2 
	RCC2 |= 0x01800000; // set SYSDIV2 for divide 200MHz / 4 = 50MHz
	
	wait_for_pll();
	
	RCC2 &= 0xFFFFF7FF; //& (~(1 << 11)); // Clear BYPASS use PLL for System Clock

}

//66.67MHz the led blinking will speed up
void system_clk_setup_fast() {
	
	rcgcgpio_setup();
	
	// Use Precision Internal OSC 
	RCC2 |= 0x80000000; // Set USERCC2 
	RCC &= 0xFFBFFFFF; // Clear USESYSDIV 
	RCC2 |= 0x800; // Set BYPASS
	// Configure PLL 
	RCC &= 0xFFFFF83F; //Reset XTAL 
	RCC |= 0x0540; // configure XTAL for 16 MHz Crystal
	//Powerup PLL (clear RCC2 bit 13) 
	RCC2 &= 0xFFFFDFFF; //clear bit 13, powerup PLL 
	RCC2 &= 0xBFFFFFFF; // to set 200MHz PLL output clear bit 30 
	RCC2 &= 0xE07FFFFF; // clear SYSDIV2 
	RCC2 |= 0x01000000; // set SYSDIV2 for divide 200MHz / 3 = 66.67MHz clock
	
	wait_for_pll();
	
	RCC2 &= 0xFFFFF7FF; //& (~(1 << 11)); // Clear BYPASS use PLL for System Clock

}

//16MHz using precision internal OSC as clock source, led will blink slower
void system_clk_setup_slow() {
	
	rcgcgpio_setup();
	
	// Use Precision Internal OSC 
	//By default the OSC source is set to PIOSC (RCC2 bits 4 through 6)
	RCC2 |= 0x80000000; // Set USERCC2 
	RCC &= 0xFFBFFFFF; // Clear USESYSDIV 
	RCC2 |= 0x800; // Set BYPASS
	
	//Below code not needed since we are bypassing the use of the PLL
	
	// Configure PLL 
	//RCC &= 0xFFFFF83F; //Reset XTAL 
	//RCC |= 0x0540; // configure XTAL for 16 MHz Crystal
	
	//Powerup PLL (clear RCC2 bit 13) 
	//RCC2 &= 0xFFFFDFFF; //clear bit 13 
	//RCC2 &= 0xBFFFFFFF; // 200MHz PLL output clear bit 30 
	//RCC2 &= 0xE07FFFFF; // clear SYSDIV2 
	//RCC2 |= 0x01000000; // set SYSDIV2 for divide 200MHz / 4 = 50MHz
	
	//wait_for_pll();
	
	//RCC2 &= 0xFFFFF7FF; //& (~(1 << 11)); // Clear BYPASS use PLL for System Clock

}

/*void EnableInterrupts(void){
	
	_asm_ _volatile_(
		"CPSIE I\n"
		"BX LR\n"
	);
}*/

/*void DisableInterrupts(void){
	
	_asm_ _volatile_(
		"CPSID I\n"
		"BX LR\n"
	);
}*/


void CPUcpsie(void)
{
    uint32_t ui32Ret;

    //
    // Read PRIMASK and enable interrupts.
    //
    __asm("    mrs     r0, PRIMASK\n"
          "    cpsie   i\n"
          "    bx      lr\n"
          : "=r" (ui32Ret));

    //
    // The return is handled in the inline assembly, but the compiler will
    // still complain if there is not an explicit return here (despite the fact
    // that this does not result in any code being produced because of the
    // naked attribute).
    //
    
}

void
CPUcpsid(void)
{
    //
    // Read PRIMASK and disable interrupts.
    //
    __asm("    mrs     r0, PRIMASK\n"
          "    cpsid   i\n"
          "    bx      lr\n");

    //
    // The following keeps the compiler happy, because it wants to see a
    // return value from this function.  It will generate code to return
    // a zero.  However, the real return is the "bx lr" above, so the
    // return(0) is never executed and the function returns with the value
    // you expect in R0.
    //
    //return(0);
}

void configure(){
	
	/*NVIC_R4 &= ~0x40000000;
	
	PORTF_LOCK |= 0x4C4F434B;   //unlock GPIO Port F (specifically PF0 and PD7 when used need to be unlocked) key given <-
	PORTF_CR |= 0x1F;           // allow changes to PF4-0
	PORTF_AMSEL &= 0x00; //Leave as 0x0 not using analog
	PORTF_PCTL &= ~0x000FFFFF;   //PCTL GPIO on PF4-0
	PORTF_DIR &= ~0x11;
	PORTF_DIR |=0x0000000E; //Set to 1 for PF1,PF2,PF3 to set as output, PF0 and PF4 input
	PORTF_AFSEL &= ~0x1F; //Leave as 0x0 not using alternate functions
	PORTF_PUR |= 0x11; //enable pull up on pf0 and pf4
	PORTF_DEN |=0x1F; //Set to 1 for PF0-PF4 to enable digital signals
	//PORTF_DATA =0; //set to low (off) to start
	
	PORTF_IM &= ~0x11; //Disable interrupt to configure
	PORTF_IS &= ~0x11;   // PF4,PF0 is edge-sensitive (default setting)
	PORTF_IBE &= ~0x11;  // PF4,PF0 is not both edges (default setting)
	PORTF_IEV &= ~0x11;   // PF4,PF0 falling edge event
	PORTF_RIS &= ~0x11;  // clear raw interrupt status PF0/4
	PORTF_CR = 0x1F;
	PORTF_IM |= 0x11;    // enable interrupt on PF4,PF0
	
	NVIC_R4 = 0x4000000;
	
	EnableInterrupts();*/
	
	CPUcpsid();
	
	PORTF_LOCK = 0x4C4F434B;   //unlock GPIO Port F (specifically PF0 and PD7 when used need to be unlocked) key given <-
	PORTF_CR = 0x01;           // make PF0 configurable
	PORTF_LOCK = 0; //lock commit register
	
	PORTF_DIR &= ~0x11; //make PF4 and PF0 inputs
	PORTF_DIR |=0x0E; //Set to 1 for PF1,PF2,PF3 to set as output, PF0 and PF4 input
	PORTF_DEN |=0x1F; //Set to 1 for PF0-PF4 to enable digital signals
	PORTF_PUR |= 0x11; //enable pull up on pf0 and pf4
	
	PORTF_IS &= ~0x11;   // PF4,PF0 is edge-sensitive (default setting)
	PORTF_IBE &= ~0x11;  // PF4,PF0 is not both edges (default setting)
	PORTF_IEV &= ~0x11;   // PF4,PF0 falling edge event
	PORTF_ICR |= 0x11; //clear any prior interrupt
	PORTF_IM |= 0x11; //unmask interrupt
	
	NVIC_IP_30 = 3 << 5; //set priority to 3
	NVIC_ISER_0 |=0x40000000; //enable IRQ30
	
	CPUcpsie();

}

void wait(unsigned long count){
	unsigned long i = 0;
	for(i=0; i<count; i++);
}

void blink(void){
	
	/*if(PORTF_RIS&0x10)*/PORTF_ICR = 0x10;
	
	/*if(PORTF_RIS&0x1)*/PORTF_ICR = 0x1;
	
	PORTF_DATA = PF1; //(red led on, blue led off, green led off)
	wait(1000000); //delay to see transition better
	PORTF_DATA = PF2; //(red led off, blue led on, green led off)
	wait(1000000); //delay to see transition better
	PORTF_DATA = PF3; //(red led off, blue led off, green led on)
	wait(1000000); //delay to see transition better
}

int main() {
	
	system_clk_setup_slow();

	configure();

	blink();
	
	//Repeat blinking sequence 100 times
	//for (int x=0;x<99;x++){
		//blink();
	//}
	while (true)
		continue;
}
