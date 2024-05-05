// Lab 1
// ENGR-2350
// Name: Joseph Hutchinson
// RIN: 662022852

#include "engr2350_msp432.h"

void GPIOInit();
void TestIO();
void ControlSystem();

uint8_t LEDL = 0; // Two variables to store the state of
uint8_t LEDR = 0; // the LEDs

uint8_ SS1; // Switch 1
uint8_t SS2; // Switch 2


uint8_t BMP0;
uint8_t BMP5

int main(void)
{

    SysInit();
    GPIOInit();

    printf("\r\n\n"
           "***********\r\n"
           "Lab 1 Start\r\n"
           "***********\r\n");

    while(1){
        TestIO();
        //ControlSystem();
    }
}

void GPIOInit(){
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN4); // Set P2.4 to output (for BiLED)
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN5); // Set P2.5 to output (for second side of BiLED)
    GPIO_setAsInputPin(GPIO_PORT_P3, GPIO_PIN2); // Set P3.2 as input (for SS1)
    GPIO_setAsInputPin(GPIO_PORT_P2, GPIO_PIN3); // Set P2.3 as input (for SS2)

    GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN6|GPIO_PIN7); // Set 3.6 and 3.7 to outputs for right/left motors (ON/OFF)
    GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN6|GPIO_PIN7); // Set 3.6 and 3.7 to LOW (no power on start)

    GPIO_setAsOutputPin(GPIO_PORT_P8, GPIO_PIN0|GPIO_PIN5); // Set 8.0 and 8.5 to output pins for the FL and FR LEDs on board

    GPIO_setAsInputPin(GPIO_PORT_P4, GPIO_PIN0|GPIO_PIN7); // Set 4.0 and 4.7 to inputs, for the switches BMP0 and BMP5 respectively


    // Add initializations of inputs and outputs
}

void TestIO(){
    // Add printf statement(s) for testing inputs

    // Example code for testing outputs
    while(1){
        uint8_t cmd = getchar();
        if(cmd == 'a'){
            // Turn LEDL On
        }else if(cmd == 'z'){
            // Turn LEDL Off
        }// ...
    }
}

void ControlSystem(){

}
