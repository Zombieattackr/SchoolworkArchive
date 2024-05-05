#ifndef __Item_h_
#define __Item_h_

#include <string>

class Item {
public:
	Item(std::string _name, int _time) { name = _name; time = _time; }
	const std::string& getName() const { return name; }
	const int getTime() const { return time; }
	void setTime(int _time) { time = _time; }
private:
	std::string name;
	int time;
};

#endif