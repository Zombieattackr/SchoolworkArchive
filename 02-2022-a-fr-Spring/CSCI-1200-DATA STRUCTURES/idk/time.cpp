//File: time.cpp
// Purpose: Implementation file for the Time class.

#include <iostream>
#include "time.h"

Time::Time() { //default constructor
	hour = 0;
	minute = 0;
	second = 0;
}

Time::Time(int aHour, int aMinute, int aSecond) { //construct from hour minute and second
	hour = aHour;
	minute = aMinute;
	second = aSecond;
}

//Accessors and Modifiers
int Time::getHour() const {
	return hour;
}

int Time::getMinute() const {
	return minute;
}

int Time::getSecond() const {
	return second;
}

void Time::setHour(int h) {
	hour = h;
}

void Time::setMinute(int m) {
	minute = m;
}

void Time::setSecond(int s) {
	second = s;
}

//other functions
void Time::PrintAMPM() const { //output as hh:mm:ss am/pm
	if (hour > 12) {
		std::cout << hour-12 << ":";
	} else if (hour == 0) {
		std::cout << 12 << ":";
	} else {
		std::cout << hour << ":";
	}
	if (minute >= 10) {
		std::cout << minute << ":";
	} else {
		std::cout << "0" << minute << ":";
	}
	if (second >= 10) {
		std::cout << second;
	} else {
		std::cout << "0" << second;
	}
	if (hour >= 12) {
		std::cout << " pm" << std::endl;
	} else {
		std::cout << " am" << std::endl;
	}
}

bool IsEarlierThan(const Time& t1, const Time& t2) { //returns true if t1 is earlier in the day than t2
	if (t1.getHour() < t2.getHour()) {
		return true;
	} else if (t1.getHour() > t2.getHour()) {
		return false;
	} else {
		if (t1.getMinute() < t2.getMinute()) {
			return true;
		} else if (t1.getMinute() > t2.getMinute()) {
			return false;
		} else {
			if (t1.getSecond() < t2.getSecond()) {
				return true;
			} else if (t1.getSecond() > t2.getSecond()) {
				return false;
			} else {
				return false;
			}
		}
	}
}