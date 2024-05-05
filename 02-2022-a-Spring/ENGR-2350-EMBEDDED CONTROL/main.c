/**********************************************************************/
// ENGR-2350 Template Project
// Name: XXXX
// RIN: XXXX
// This is the base project for several activities and labs throughout
// the course.  The outline provided below isn't necessarily *required*
// by a C program; however, this format is required within ENGR-2350
// to ease debugging/grading by the staff.
/**********************************************************************/

// We'll always add this include statement. This basically takes the
// code contained within the "engr_2350_msp432.h" file and adds it here.
#include "engr2350_msp432.h"

// Add function prototypes here, as needed.
void GPIO_Init();
void Timer_Init();

// Add global variables here, as needed.
Timer_A_UpModeConfig timer;
Timer_A_CompareModeConfig timer3;
Timer_A_CompareModeConfig timer4;
uint8_t input;

int main(void) /* Main Function */
{
    // Add local variables here, as needed.

    // We always call the "SysInit()" first to set up the microcontroller
    // for how we are going to use it.
    SysInit();

    // Place initialization code (or run-once) code here
    GPIO_Init();
    Timer_Init();

    while(1){
        // Place code that runs continuously in here
        input = getchar_nw();
        if(input == 'a' || input == 'A'){
            printf("a");
            timer4.compareValue += 50;
            if(timer4.compareValue > 720) {
                timer4.compareValue = 720;
            }
            Timer_A_initCompare(TIMER_A0_BASE, &timer4);
        }
        if(input == 'z' || input == 'Z'){
            printf("z");
            if(timer4.compareValue < 50) {
                timer4.compareValue = 0;
            } else {
                timer4.compareValue -= 50;
            }
            Timer_A_initCompare(TIMER_A0_BASE, &timer4);
        }
        if(input == 's' || input == 'S'){
            printf("s");
            timer3.compareValue += 50;
            if(timer3.compareValue > 720) {
                timer3.compareValue = 720;
            }
            Timer_A_initCompare(TIMER_A0_BASE, &timer3);
        }
        if(input == 'x' || input == 'X'){
            printf("x");
            if(timer3.compareValue < 50) {
                timer3.compareValue = 0;
            } else {
                timer3.compareValue -= 50;
            }
            Timer_A_initCompare(TIMER_A0_BASE, &timer3);
        }
    }
}

// Add function declarations here as needed
void GPIO_Init() {
    GPIO_setAsPeripheralModuleFunctionOutputPin(GPIO_PORT_P2, GPIO_PIN6|GPIO_PIN7,GPIO_PRIMARY_MODULE_FUNCTION); //Timer_A0 CCR3+4
    GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN6|GPIO_PIN7);
    GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN4|GPIO_PIN5);
    GPIO_setOutputHighOnPin(GPIO_PORT_P3, GPIO_PIN6|GPIO_PIN7);
    GPIO_setOutputHighOnPin(GPIO_PORT_P5, GPIO_PIN4|GPIO_PIN5);
}
void Timer_Init() {
    timer.clockSource = TIMER_A_CLOCKSOURCE_SMCLK;
    timer.clockSourceDivider = TIMER_A_CLOCKSOURCE_DIVIDER_1;
    timer.timerPeriod = 800;
    Timer_A_configureUpMode(TIMER_A0_BASE, &timer);
    timer3.compareRegister = TIMER_A_CAPTURECOMPARE_REGISTER_3;
    timer3.compareOutputMode = TIMER_A_OUTPUTMODE_RESET_SET;
    timer3.compareValue = 0;
    timer4.compareRegister = TIMER_A_CAPTURECOMPARE_REGISTER_4;
    timer4.compareOutputMode = TIMER_A_OUTPUTMODE_RESET_SET;
    timer4.compareValue = 0;
    Timer_A_initCompare(TIMER_A0_BASE, &timer4);
    Timer_A_initCompare(TIMER_A0_BASE, &timer3);
    Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);
}
// Add interrupt functions last so they are easy to find
