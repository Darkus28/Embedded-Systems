//*****************************************************************************

//*****************************************************************************

/* -----------------------          Include Files       --------------------- */
#include <stdint.h>                     // Library of Standard Integer Types
#include <stdbool.h>                    // Library of Standard Boolean Types
//#include "inc/hw_memmap.h"              // Macros defining the memory map of the Tiva C Series device
//#include "inc/hw_gpio.h"                // Defines macros for GPIO hardware
//#include "inc/hw_types.h"               // Defines common types and macros
#include "driverlib/sysctl.h"           // Defines and macros for System Control API of DriverLib
//#include "driverlib/pin_map.h"          // Mapping of peripherals to pins of all parts
//#include "driverlib/gpio.h"             // Defines and macros for GPIO API of DriverLib
//#include "driverlib/interrupt.h"
#include "driverlib/gpio.c"
//#include "drivers/buttons.h"

#define PF_2      GPIO_PIN_2

//*****************************************************************************
//
// The error routine that is called if the driver library encounters an error.
//
//*****************************************************************************
#ifdef DEBUG
void
__error__(char *pcFilename, uint32_t ui32Line)
{
}
#endif

void setupPorts(void){

    // Setup the system clock to run at 50 Mhz from PLL with crystal reference
      SysCtlClockSet(SYSCTL_SYSDIV_4|SYSCTL_USE_PLL|SYSCTL_XTAL_16MHZ|SYSCTL_OSC_MAIN);

       // Enable and wait for the port to be ready for access
      SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
      while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF))
      {
      }

      // Configure the GPIO port for the LED operation.
      GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,PF_2);

}

void LED_Toggle(void){

    // Turn on the LED

    GPIOPinWrite(GPIO_PORTF_BASE, PF_2, 0);

    // Delay for a bit
    SysCtlDelay(2000000);

    // Turn on the LED

    GPIOPinWrite(GPIO_PORTF_BASE, PF_2, PF_2);

    // Delay for a bit
     SysCtlDelay(2000000);
}

//*****************************************************************************
//
// Main 'C' Language entry point.  Toggle an LED using TivaWare.
//
//*****************************************************************************
int main(void){

    setupPorts();
    LED_Toggle();
    //LED_Toggle();
    //LED_Toggle();

    // Loop Forever
    while(1)
    {
        LED_Toggle();
    }
}
