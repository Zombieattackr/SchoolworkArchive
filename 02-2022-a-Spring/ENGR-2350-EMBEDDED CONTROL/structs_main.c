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

// This is one implementation for creating a custom struct variable type named "homework_t"
typedef struct _homework_t {
    float average;      // The struct has a "field" for each value listed
    float stdev;        // in the "Homework Gradebook" table.
    uint8_t min;        // Note that the fields can be all different types
    uint8_t max;
    uint16_t subs;
} homework_t;

// Add function prototypes here, as needed.
// Prototype. Add above main function, below the homework_t definition.
float remove_min_from_avg(homework_t *homework);

// Add global variables here, as needed.
homework_t h1;
homework_t hs[];

int main(void) /* Main Function */
{
    // Add local variables here, as needed.

    // We always call the "SysInit()" first to set up the microcontroller
    // for how we are going to use it.
    SysInit();

    // Place initialization code (or run-once) code here
    h1.average = 94.2;
    h1.stdev = 10.8;
    h1.min = 55;
    h1.max = 100;
    h1.subs = 109;

    hs[0].average = 94.2;
    hs[0].stdev = 10.8;
    hs[0].min = 55;
    hs[0].max = 100;
    hs[0].subs = 109;

    hs[1].average = 76.7;
    hs[1].stdev = 12.6;
    hs[1].min = 40;
    hs[1].max = 100;
    hs[1].subs = 106;

    hs[2].average = 84.5;
    hs[2].stdev = 15.9;
    hs[2].min = 25;
    hs[2].max = 100;
    hs[2].subs = 101;

    hs[3].average = 92.1;
    hs[3].stdev = 12.6;
    hs[3].min = 45;
    hs[3].max = 100;
    hs[3].subs = 99;

    hs[4].average = 66.3;
    hs[4].stdev = 27.3;
    hs[4].min = 10;
    hs[4].max = 100;
    hs[4].subs = 99;

    uint8_t i;
    for(i = 0; i < 5; i++) {
        printf("Homework %u Stats\r\n"
        "    Average: %.2f\r\n"
        "  Std. Dev.: %.2f\r\n"
        "    Minimum: %u\r\n"
        "    Maximum: %u\r\n"
        "Submissions: %u\r\n",
        i+1,
        hs[i].average,hs[i].stdev,hs[i].min,
        hs[i].max,hs[i].subs);
    }

    float newH1avg, newH2avg;
    newH1avg = remove_min_from_avg(&h1);
    newH2avg = remove_min_from_avg(&hs[1]);
    printf("Homework 1 new average: %.2f\r\n",newH1avg);
    printf("Homework 2 new average: %.2f\r\n",newH2avg);

    while(1){
        // Place code that runs continuously in here

    }
}

// Add function declarations here as needed
// Declaration. Add below main function
// This function calculates the average of a homework without the minimum grade.
// The function will return the value of the new average.
float remove_min_from_avg(homework_t *homework){
    float homework_sum = homework->average*homework->subs;
    homework_sum -= homework->min;
    return homework_sum/(homework->subs-1);
}

// Add interrupt functions last so they are easy to find
