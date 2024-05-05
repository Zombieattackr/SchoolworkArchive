#ifndef __Order_h_
#define __Order_h_

#include <list>

#include "Item.h"

class Order {
public:
	Order(std::list<std::string>& items_, int ID_, int time_) { items=items_; ID=ID_; time=time_; }
	std::list<std::string> getItems() const { return items; }
	const int getID() const { return ID; }
	const int getTime() const { return time; }
	void setTime(int _time) { time = _time; }
private:
	std::list<std::string> items;
	int ID;
	int time;
};

#endif