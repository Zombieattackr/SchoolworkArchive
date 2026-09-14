HOMEWORK 4: Pizza Event SimulaTOr (PESto)


NAME: Hayden Fuller


COLLABORATORS AND OTHER RESOURCES:
List the names of everyone you talked to about this assignment
(classmates, TAs, ALAC tutors, upperclassmen, students/instructor via
LMS, etc.), and all of the resources (books, online reference
material, etc.) you consulted in completing this assignment.

submitty, lab6, Alex, cplusplus.com

Remember: Your implementation for this assignment must be done on your
own, as described in "Academic Integrity for Homework" handout.


ESTIMATE OF # OF HOURS SPENT ON THIS ASSIGNMENT:  24


ORDER NOTATION:
For each function, using the variables:

  c = number of items still being cooked
  d = number of items completely cooked, but not yet added to an order
  m = number of different item names available
  o = number of orders that have not been filled and are not expired
  p = min number of items per order
  q = max number of items per order

Include a short description of your order notation analysis.

add_order:
O(max(q, o)), there's a for loop of items input to the order and 
		a for loop of orders, so the O() of the whole thing is the max of the two.
add_item:
O(c), there is only one for loop that itterates through food_cooking, which is c in length
print_orders_by_time:
O(o*2q), there is a for loop of orders, and inside that an assignment operator and a loop
		through a list of items, giving 2q.
print_orders_by_id:
O(o*max(o,q*q) in a loop of orders.size, there is a loop through orders, an assignment 
		operator, and a loop through the items, resulting in o and qq, which we 
		take the max of and multiply by the o loop they're in
print_kitchen_is_cooking:
O(c), loops through food_cooking with length c
print_kitchen_has_completed:
O(d), loops through food_completed with length d
run_until_next:
O(timeUntilEvent*max(c,o*max(q*log(q),q*d)*q)), in a while loop that will end after 
		timeUntilEvent runs, there is a loop through food cooking with length c, 
		as well as a loop through orders, which calls CanFillOrder with 
		O(max(q*log(q),q*d), and then loops through toRemove with length q.
run_for_time:
O(runTime*max(c,o*max(q*log(q),q*d)*q)), all the same functions as above but the number of 
		loops timeUntilEvent is specified as runTime.


MISC. COMMENTS TO GRADER:  
Optional, please be concise!






