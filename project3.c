/* -----------------------          Include Files       --------------------- */
#include <stdint.h>                     // Library of Standard Integer Types
#include <stdbool.h>                    // Library of Standard Boolean Types
#include "driverlib/interrupt.h"

/*
 * Cordero B. Woods
 * EENG 462 LAB 1
 *
 */

//PORTF located at 0x40025000 pg.660
#define PORTF_DATA (*((volatile unsigned long *)0x40025038))   //bitwise addressing (ex. PF1  0000 0010 changes to 00 0000 1000=0x08,PF2 0000 0100 changes to 00 0001 0000=0x10,PF3=0x20) offset of DATA 0x038 for PF1,PF2,PF3
#define PORTF_DIR (*((volatile unsigned long *)0x40025400))   //offset of DIR register is 0x400 pg.663 DataSheet
#define PORTF_DEN (*((volatile unsigned long *)0x4002551C))   //offset of DEN register is 0x51C pg.682 DataSheet
//#define PORTF_AFSEL (*((volatile unsigned long *)0x40025420))   //offset of AFSEL register is 0x420 pg.671 DataSheet
#define PORTF_LOCK  (*((volatile unsigned long *)0x40025520))   //offset of Lock register is 0x520 pg.684 DataSheet
#define PORTF_ICR   (*((volatile unsigned long *)0x4002541C))   //offset of Interrupt Clear register is 0x41C pg.670 DataSheet
//#define PORTF_AMSEL (*((volatile unsigned long *)0x40025528))   //offset of AMSEL register is 0x528 pg.687 DataSheet
//#define PORTF_PCTL (*((volatile unsigned long *)0x4002552C))   //offset of PCTL register is 0x52C pg.688 DataSheet
#define PORTF_PUR (*((volatile unsigned long *)0x40025510))   //offset of Pull Up  register is 0x510 pg.677 DataSheet
#define PORTF_CR    (*((volatile unsigned long *)0x40025524))   //offset of Interrupt Clear register is 0x524 pg.685 DataSheet

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

//SysTick Setup
#define NVIC_ST_CONTROL (*((volatile unsigned long *)0xE000E010))   //offset 0x608, base: 0xE000E000 pg. 134 DataSheet
#define NVIC_ST_RELOAD (*((volatile unsigned long *)0xE000E014))   //offset is 0x060 base: 0xE000E000 pg.134 DataSheet
#define NVIC_ST_CURRENT (*((volatile unsigned long *)0xE000E018))   //offset is 0x070 base: 0xE000E000 pg.134 DataSheet

//Interrupt setup
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



//16MHz using precision internal OSC as clock source, not used for this lab
void system_clk_setup_slow() {

    rcgcgpio_setup();

    // Use Precision Internal OSC
    //By default the OSC source is set to PIOSC (RCC2 bits 4 through 6)
    RCC2 |= 0x80000000; // Set USERCC2
    RCC &= 0xFFBFFFFF; // Clear USESYSDIV
    RCC2 |= 0x800; // Set BYPASS
}
void SysTick_Init(void){

    NVIC_ST_CONTROL = 0; //disable Systick during setup
    NVIC_ST_RELOAD = 0x00FFFFFF; //maximum reload value
    NVIC_ST_CURRENT = 0; //any write to current clears it
    NVIC_ST_CONTROL = 0x00000005; //enable Systick with core clock

}

// Time delay using busy wait.
// The delay parameter is in units of the 50 MHz core clock. (1/f)
void SysTick_Wait(unsigned long delay){
  volatile unsigned long elapsedTime;
  NVIC_ST_CURRENT = 0;
  unsigned long startTime = NVIC_ST_CURRENT;
  do{
    elapsedTime = (startTime-NVIC_ST_CURRENT)&0x00FFFFFF;
  }
  while(elapsedTime <= delay);
}

//alternate implementation
/*void SysTick_Wait(uint32_t delay){
NVIC_ST_RELOAD = delay-1; // number of counts to wait
NVIC_ST_CURRENT = 0; // any value written to CURRENT clears
while((NVIC_ST_CTRL&0x00010000)==0){ // wait for count flag
}*/


// Time delay using busy wait.
// 10000us equals 10ms
void SysTick_Wait10ms(unsigned long delay){
  unsigned long i;
  for(i=0; i<delay; i++){
    SysTick_Wait(500000);  // wait 10ms (assumes 50 MHz clock)
  }
}


void configure(){

    IntMasterDisable();

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

    SysTick_Init();

    IntMasterEnable();

}

//delay n milliseconds (16MHz CPU Clock)
//void wait(int n){
//    int i,j;
//    for(i=0; i<n; i++)
//        for(j=0;j<3180;j++){}
//}

//Interrupt handler port F
void IntGPIOF(void){

    if(PORTF_RIS&0x10){
        PORTF_ICR = 0x10; //acknowledge interrupt

        PORTF_DATA = PF1; //(red led on)
        SysTick_Wait10ms(10); //wait 100 ms
    }
    else if(PORTF_RIS&0x1){
        PORTF_ICR = 0x1; //acknowledge interrupt

        PORTF_DATA = (PF3|PF2); //(red led(PF1), blue led(PF2), green led(PF3))
        SysTick_Wait10ms(10); //wait 100 ms
    }
}

int main() {

    system_clk_setup_50Mhz();

    configure();

    while (true)
        continue;
}
