// ==================================================================
// Important Note: You are encouraged to read through this provided
//   code carefully and follow this structure.  You may modify the
//   file as needed to complete your implementation.
// ==================================================================

#include <cassert>
#include <iostream>
#include <string>
#include <list>

#include "Order.h"
#include "Item.h"

typedef std::list<Order> OrderList;
typedef std::list<Item> KitchenList;

//Needed for CanFillOrder()
typedef std::list <KitchenList::const_iterator> OrderFillList;

//Helper function
//Returns true if order can be fulfilled, and false otherwise. If true, then
//items_to_remove has iterators to kitchen_completed for all items that are used 
//in the order.
bool CanFillOrder(const Order &order, const KitchenList &kitchen_completed,
                  OrderFillList &items_to_remove);

int main() {
  OrderList orders;
  KitchenList food_cooking;
  KitchenList food_completed;

  std::string token;
  while (std::cin >> token) {
    if (token == "add_order") {
      int id, promised_time, n_items = 0;
      std::string next_item;
      std::list <std::string> itrems;

      std::cin >> id >> promised_time >> n_items;
      assert(n_items > 0);

      for (int i = 0; i < n_items; i++) {
        std::cin >> next_item;
        itrems.push_back(next_item);
      }
      
      /* YOU MUST FINISH THIS IMPLEMENTATION */ //insert Order in sorted list orders by shortest time remaining then by ID
      std::cout << "Received new order #" << id << " due in " << promised_time << " minute(s):" << std::endl;
      bool i = true;
      std::list<std::string>::iterator sitr;
      for(sitr = itrems.begin(); sitr != itrems.end(); ++sitr) {
      	std::cout << "  " << *sitr << std::endl;
      }
      if(orders.size() > 0) {
	      std::list<Order>::iterator oitr;
	      for(oitr = orders.begin(); oitr != orders.end(); ++oitr) {
	      	if(oitr->getTime() > promised_time || (oitr->getTime() == promised_time && oitr->getID() > id)) {
	      		orders.insert(oitr, Order(itrems, id, promised_time));
	      		i = false;
	      		break;
	      	}
	      }
	      if(i){
	  		orders.push_back(Order(itrems, id, promised_time));
	      }
	  } else {
	  	orders.push_back(Order(itrems, id, promised_time));
	  }

    } else if (token == "add_item") {
      int cook_time = -1;
      std::string name;
      std::cin >> cook_time >> name;
      assert(cook_time >= 0);

      /* YOU MUST FINISH THIS IMPLEMENTATION */ //insert Item in sorted list food_cooking by shortet remaining cook time then by alphabetical name
      std::cout << "Cooking new " << name << " with " << cook_time << " minute(s) left." << std::endl; 
      if(food_cooking.size() > 0) {
	      std::list<Item>::iterator itr;
	      for(itr = food_cooking.begin(); itr != food_cooking.end(); ++itr) {
	      	if(itr->getTime() > cook_time || (itr->getTime() == cook_time && itr->getName() > name)) {
	      		food_cooking.insert(itr, Item(name, cook_time));
	      		break;
	      	}
	      }
	  } else {
	  	food_cooking.push_back(Item(name, cook_time));
	  }

    
    } else if (token == "print_orders_by_time") {
      /* YOU MUST FINISH THIS IMPLEMENTATION */ //prints orders as it is from add_order
     	std::list<Order>::iterator itr;
    	std::list<std::string>::iterator itr2;
    	std::cout << "Printing " << orders.size() << " order(s) by promised time remaining:" << std::endl;
    	for(itr = orders.begin(); itr != orders.end(); ++itr) {
    		std::cout << "  #" << itr->getID() << " (" << itr->getTime() << " minute(s) left):" << std::endl;
    		std::list<std::string> names;
    		names = itr->getItems();
    		for(itr2 = names.begin(); itr2 != names.end(); ++itr2) {
	    		std::cout << "    " << *itr2 << std::endl;
	    	}
    	}
    	

    } else if (token == "print_orders_by_id") {
      /* YOU MUST FINISH THIS IMPLEMENTATION */ //prints orders by smallest ID first
    	int done = -1;
    	int min = -1;
    	int max = -1;
    	std::list<Order>::iterator min_itr;
			std::list<Order>::iterator itr;
    	std::list<std::string>::iterator itr2;
    	std::list<std::string> names;
    	std::cout << "Printing " << orders.size() << " order(s) by ID:" << std::endl;
    	for(itr = orders.begin(); itr != orders.end(); ++itr) {
    		if(itr->getID() > max) {
    			max = itr->getID();
    		}
    	}
    	max++;
    	for(int i = 0; i < orders.size(); i++) {
    		min = max;
    		for(itr = orders.begin(); itr != orders.end(); ++itr) {
    			if(itr->getID() < min && itr->getID() > done) {
    				min = itr->getID();
    				min_itr = itr;
    			}
    		}
    		std::cout << "  #" << min << " (" << min_itr->getTime() << " minute(s) left):" << std::endl;
    		done = min;
    		names = min_itr->getItems();
    		for(itr2 = names.begin(); itr2 != names.end(); ++itr2) {
	    		std::cout << "    " << *itr2 << std::endl;
	    	}
		}

    } else if (token == "print_kitchen_is_cooking") {
      /* YOU MUST FINISH THIS IMPLEMENTATION */ //print food_cooking as it is from add_item
		std::list<Item>::iterator itr;
    	std::cout << "Printing " << food_cooking.size() << " items being cooked:" << std::endl;
    	for(itr = food_cooking.begin(); itr != food_cooking.end(); ++itr) {
    		std::cout << "  " << itr->getName() << " (" << itr->getTime() << " minute(s) left)" << std::endl;
    	}

    } else if (token == "print_kitchen_has_completed") {
      /* YOU MUST FINISH THIS IMPLEMENTATION */ //print food_completed as it is added
		std::list<Item>::iterator itr;
    	std::cout << "Printing " << food_completed.size() << " completely cooked items:" << std::endl;
    	for(itr = food_completed.begin(); itr != food_completed.end(); ++itr) {
    		std::cout << "  " << itr->getName() << std::endl;
    	}

    } else if (token == "run_for_time") {
	  int run_time = 0;
	  std::cin >> run_time;
	  assert(run_time >= 0);
	  /* YOU MUST FINISH THIS IMPLEMENTATION */
	  std::cout << "===Starting run of " << run_time << " minute(s)===" << std::endl;
	  for(int i = 0; i < run_time; i++) {

/*
	  	std::cout << "orders: " << orders.size() << std::endl
	  			<< "cooked: " << food_completed.size() << std::endl
	  			<< "cooking: " << food_cooking.size() << std::endl
	  			<< "Time Remaining: ";
	  			std::list<Item>::iterator itr;
		    	std::cout << "Printing " << food_cooking.size() << " items being cooked:" << std::endl;
		    	for(itr = food_cooking.begin(); itr != food_cooking.end(); ++itr) {
		    		std::cout << itr->getName() << " (" << itr->getTime() << " minute(s) left)" << std::endl;
		    	}
	  			std::cout << std::endl;
*/

  		//cooking can be completed
		std::list<Item>::iterator iitr;
		std::list<Order>::iterator oitr;
		iitr = food_cooking.begin(); 
  		while(iitr != food_cooking.end()) {
  			if(iitr->getTime() < 1 && food_cooking.size() > 0) {
  				std::cout << "Finished cooking " << iitr->getName() << std::endl;
  				food_completed.push_back(*iitr);
  				food_cooking.erase(iitr);
  				iitr = food_cooking.begin();
  			} else {
				++iitr;
  			}
  		}
  		//order can be filled
  		OrderFillList toRemove;
  		std::list<KitchenList::const_iterator>::iterator litr;
  		oitr = orders.begin();
  		while(oitr != orders.end() && orders.size() > 0) {
  			if(CanFillOrder(*oitr, food_completed, toRemove)) {
  				std::cout << "Filled order #" << oitr->getID() << std::endl;
  				for(litr = toRemove.begin(); litr != toRemove.end(); ++litr) {
  					std::cout << "Removed a " << (*litr)->getName() << " from completed items." << std::endl;
  					food_completed.erase(*litr);
  				}
  				orders.erase(oitr);
  				oitr = orders.begin();
  			} else {
  				++oitr;
  			}
  		}
  		//order expires
  		oitr = orders.begin();
  		while(oitr != orders.end()) {
  			if(oitr->getTime() < 1) {
  				std::cout << "Order # " << oitr->getID() << " expired." << std::endl;
  				orders.erase(oitr);
  				oitr = orders.begin();
  			} else {
  				++oitr;
  			}
  		}

  		
  		//incriment orders
  		for(oitr = orders.begin(); oitr != orders.end(); ++oitr) {
  			oitr->setTime(oitr->getTime()-1);
  		}
  		//incriment food_cooking
  		for(iitr = food_cooking.begin(); iitr != food_cooking.end(); ++iitr) {
  			iitr->setTime(iitr->getTime()-1);
  		}
	  }
	  //cooking can be completed
		std::list<Item>::iterator iitr;
		std::list<Order>::iterator oitr;
		iitr = food_cooking.begin(); 
			while(iitr != food_cooking.end()) {
				if(iitr->getTime() < 1 && food_cooking.size() > 0) {
					std::cout << "Finished cooking " << iitr->getName() << std::endl;
					food_completed.push_back(*iitr);
					food_cooking.erase(iitr);
					iitr = food_cooking.begin();
				} else {
				++iitr;
				}
			}
			//order can be filled
			OrderFillList toRemove;
			std::list<KitchenList::const_iterator>::iterator litr;
			oitr = orders.begin();
			while(oitr != orders.end() && orders.size() > 0) {
				if(CanFillOrder(*oitr, food_completed, toRemove)) {
					std::cout << "Filled order #" << oitr->getID() << std::endl;
					for(litr = toRemove.begin(); litr != toRemove.end(); ++litr) {
						std::cout << "Removed a " << (*litr)->getName() << " from completed items." << std::endl;
						food_completed.erase(*litr);
					}
					orders.erase(oitr);
					oitr = orders.begin();
				} else {
					++oitr;
				}
			}
			//order expires
			oitr = orders.begin();
			while(oitr != orders.end()) {
				if(oitr->getTime() < 1) {
					std::cout << "Order # " << oitr->getID() << " expired." << std::endl;
					orders.erase(oitr);
					oitr = orders.begin();
				} else {
					++oitr;
				}
			}
	  std::cout << "===Run for specified time is complete===" << std::endl;




    } else if (token == "run_until_next") {
      std::cout << "Running until next event." << std::endl;
      /* YOU MUST FINISH THIS IMPLEMENTATION */
	  //check for anything in orders or food_cooking
	  if(orders.size() == 0 && food_cooking.size() == 0) {
	  	std::cout << "No events waiting to process." << std::endl;
	  } else {
	  	int passed = 0;
	  	while(true) {
	  		//checks and break if true
	  		bool b = false; //break if true
	  		//cooking can be completed
  			std::list<Item>::iterator iitr;
  			std::list<Order>::iterator oitr;
	  		for(iitr = food_cooking.begin(); iitr != food_cooking.end(); ++iitr) {
	  			if(iitr->getTime() < 1) {
	  				std::cout << "Finished cooking " << iitr->getName() << std::endl;
	  				food_completed.push_back(*iitr);
	  				food_cooking.erase(iitr);
	  				b=true;
	  				break;
	  			}
	  		}
	  		if(b) {
	  			break;
	  		}
	  		//order can be filled
	  		OrderFillList toRemove;
	  		std::list<KitchenList::const_iterator>::iterator litr;
	  		for(oitr = orders.begin(); oitr != orders.end(); ++oitr) {
	  			if(CanFillOrder(*oitr, food_completed, toRemove)) {
	  				for(litr = toRemove.begin(); litr != toRemove.end(); ++litr) {
	  					food_completed.erase(*litr);
	  				}
	  				std::cout << "Filled order #" << oitr->getID() << std::endl;
	  				orders.erase(oitr);
	  				b=true;
	  				break;
	  			}
	  		}
	  		if(b) {
	  			break;
	  		}
	  		//order expires
	  		for(oitr = orders.begin(); oitr != orders.end(); ++oitr) {
	  			if(oitr->getTime() < 1) {
	  				std::cout << "Order # " << oitr->getID() << " expired." << std::endl;
	  				orders.erase(oitr);
	  				b=true;
	  				break;
	  			}
	  		}
	  		if(b) {
	  			break;
	  		}

	  		
	  		//incriment orders
	  		for(oitr = orders.begin(); oitr != orders.end(); ++oitr) {
	  			oitr->setTime(oitr->getTime()-1);
	  		}
	  		//incriment food_cooking
	  		for(iitr = food_cooking.begin(); iitr != food_cooking.end(); ++iitr) {
	  			iitr->setTime(iitr->getTime()-1);
	  		}
	  		//incriment counter
	  		passed++;
	  	}
	  	std::cout << passed << " minute(s) have passed." << std::endl;
      }




    }
  }

  return 0;
}


bool CanFillOrder(const Order &order, const KitchenList &kitchen_completed,
                  OrderFillList &items_to_remove) {
  items_to_remove.clear(); //We will use this to return iterators in kitchen_completed

  //Simple solution is nested for loop, but I can do better with sorting...

  std::list <std::string> itrems = order.getItems();
  itrems.sort();

  std::list<std::string>::const_iterator item_it;
  std::string prev_item = "";
  KitchenList::const_iterator kitchen_it;

  for (item_it = itrems.begin(); item_it != itrems.end(); item_it++) {
    bool found = false;

    /*Start back at beginnging of list if we're looking for something else
     *Thanks to sorting the itrems list copy, we know we're done with
       whatever kind of item prev_item was!*/
    if (prev_item != *item_it) {
      kitchen_it = kitchen_completed.begin();
      prev_item = *item_it;
    }

    /*Resume search wherever we left off last time (or beginning if it's a
    new kind of item*/
    for (; !found && kitchen_it != kitchen_completed.end(); kitchen_it++) {
      if (kitchen_it->getName() == *item_it) {
        items_to_remove.push_back(kitchen_it);
        found = true;
      }
    }

    //If we failed to satisfy an element of the order, no point continuing the search
    if (!found) {
      break;
    }
  }

  //If we couldn't fulfill the order, return an empty list
  if (items_to_remove.size() != itrems.size()) {
    items_to_remove.clear();
    return false;
  }

  return true;
}
