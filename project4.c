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

/* -----------------------      Global Variables        --------------------- */
//uint32_t ui32PinStatus = 0x00000000;    // Variable to store the pin status of GPIO PortF

//*****************************************************************************
//
// Define pin to LED color mapping.
//
//*****************************************************************************

#define SW_2      GPIO_PIN_0
#define RED_LED   GPIO_PIN_1
#define BLUE_LED  GPIO_PIN_2
#define GREEN_LED GPIO_PIN_3
#define SW_1      GPIO_PIN_4

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

void IntGPIOF(void){

    if (GPIOIntStatus(GPIO_PORTF_BASE,false)&SW_1){
                // Turn on the LED

                    GPIOPinWrite(GPIO_PORTF_BASE, RED_LED|BLUE_LED|GREEN_LED, RED_LED);

                // Delay for a bit
                    SysCtlDelay(2000000);
    }else if(GPIOIntStatus(GPIO_PORTF_BASE,false)&SW_2){
                // Turn on the LED

                    GPIOPinWrite(GPIO_PORTF_BASE, RED_LED|BLUE_LED|GREEN_LED, BLUE_LED);

                // Delay for a bit
                    SysCtlDelay(2000000);
    }else{
                // Turn on the LED

                    GPIOPinWrite(GPIO_PORTF_BASE, RED_LED|BLUE_LED|GREEN_LED, RED_LED|GREEN_LED);

                // Delay for a bit
                    SysCtlDelay(2000000);
    }

    GPIOIntClear(GPIO_PORTF_BASE,GPIO_INT_PIN_0|GPIO_INT_PIN_4);
}

void setupPorts(void){

    // Setup the system clock to run at 50 Mhz from PLL with crystal reference
      SysCtlClockSet(SYSCTL_SYSDIV_4|SYSCTL_USE_PLL|SYSCTL_XTAL_16MHZ|SYSCTL_OSC_MAIN);
    //IntDisable(INT_GPIOF);
       IntMasterDisable();
    //GPIOIntDisable(GPIO_PORTF_BASE,GPIO_INT_PIN_0|GPIO_INT_PIN_4);

       // Enable and wait for the port to be ready for access
      SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
      while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF))
      {
      }
    // Remove the Lock present on Switch SW2 (connected to PF0) and commit the change
        HWREG(GPIO_PORTF_BASE + GPIO_O_LOCK) = GPIO_LOCK_KEY;
        HWREG(GPIO_PORTF_BASE + GPIO_O_CR) |= 0x01;
        HWREG(GPIO_PORTF_BASE + GPIO_O_LOCK) = 0;


      // Configure the GPIO port for the LED operation.
      GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, RED_LED|BLUE_LED|GREEN_LED);

      //Connfigure the GPIO SW1 and SW2
      GPIOPinTypeGPIOInput(GPIO_PORTF_BASE, SW_1|SW_2);

      //Config Pull-Up PF0 and PF4
      GPIOPadConfigSet(GPIO_PORTF_BASE,SW_1|SW_2,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU);

      //Disable interrupt to configure
      //GPIOIntDisable(GPIO_PORTF_BASE,GPIO_INT_PIN_0|GPIO_INT_PIN_4);

      //Configure for falling edge
      GPIOIntTypeSet(GPIO_PORTF_BASE,SW_1|SW_2,GPIO_FALLING_EDGE);

      //Clear Interrupt Flags
      GPIOIntClear(GPIO_PORTF_BASE,GPIO_INT_PIN_0|GPIO_INT_PIN_4);

      //Enable Interrupt
      GPIOIntEnable(GPIO_PORTF_BASE,GPIO_INT_PIN_0|GPIO_INT_PIN_4);
      IntEnable(INT_GPIOF);
      //Master Int Enable
      IntMasterEnable();
}

//*****************************************************************************
//
// Main 'C' Language entry point.  Toggle an LED using TivaWare.
//
//*****************************************************************************
int main(void){

    setupPorts();

    // Loop Forever
    while(1)
    {

    }
}
