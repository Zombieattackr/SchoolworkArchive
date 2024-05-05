//File: time.h
// Purpose: Header file with declariotion of the Time class, including 
//	member functions and private member variables.


class Time {
public:
	Time();
	Time(int aHour, int aMinute, int aSecond);

	//ACCESSORS
	int getHour() const;
	int getMinute() const;
	int getSecond() const;


	//MODIFIERS
	void setHour(int aHour);
	void setMinute(int aMinute);
	void setSecond(int aSecond);

	//other functions
	void PrintAMPM() const;	//output as hh:mm:ss am/pm
	bool IsEarlierThan(const Time& t1, const Time& t2);

private:	// REPRESENTATION member variables
	int hour;
	int minute;
	int second;
};


bool IsEarlierThan(const Time& t1, const Time& t2);