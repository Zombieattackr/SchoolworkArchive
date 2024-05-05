HOMEWORK 5: UNROLLED LINKED LISTS


NAME:  Hayden Fuller


COLLABORATORS AND OTHER RESOURCES:
List the names of everyone you talked to about this assignment
(classmates, TAs, ALAC tutors, upperclassmen, students/instructor via
LMS, etc.), and all of the resources (books, online reference
material, etc.) you consulted in completing this assignment.

submitty
cplusplus.com for expected behavior and O notation comparison

Remember: Your implementation for this assignment must be done on your
own, as described in "Academic Integrity for Homework" handout.



ESTIMATE OF # OF HOURS SPENT ON THIS ASSIGNMENT:  30



TESTING & DEBUGGING STRATEGY:
Please be concise!  
print lots of information while it loops, such as the pointer address, the position in the array, etc
also tested the std::string type.



ORDER NOTATION & EVALUATION:
What is the order notation of each of the member functions in your
class? Discuss any differences between the UnrolledLL, dslist, and STL
list classes. Evaluate the memory usage of your initial implementation
in the worst case. Give a specific example sequence of operations
where the data structure is inefficient. What is the average number of
elements per node in this case? 

O notation:
NUM_ELEMENTS_PER_NODE = NEPN
Nodes = number of nodes
size_ = tatal number of values stored

NODE CLASS
default constructor 	O(1)
normal constructor 	O(1)

LIST ITERATOR
constructor	O(1)
operator* 	O(1)
operator++	O(1)
operator++(int)	O(1)
operator--	O(1)
operator--(int)	O(1)
operator==	O(1)
operator!=	O(1)

LIST CLASS DECLARATION
default constructor	O(1)
copy constructor	O(Nodes*NEPN)=O(size_)	: copy_list
destructor		O(Nodes*NEPN)=O(size_)	: destroy_list
size			O(1)
empty			O(1)
clear			O(Nodes*NEPN)=O(size_)	: destroy_list
front			O(1)
front			O(1)
back			O(1)
back			O(1)
begin			O(1)			: iterator constructor
end			O(1)			: iterator constructor

LIST CLASS IMPLEMENTATION
operator=	O(Nodes*NEPN)		: copy_list + destroy_list
push_front	O(NEPN)
pop_front	O(NEPN)
push_back	O(1)
pop_back	O(NEPN)			: delete node, which deletes[] an array size NEPN
operator==	O(size_)
operator!=	O(size_)		: operator==
erase		O(NEPN)
insert		O(NEPN)
copy_list	O(Nodes*NEPN)=O(size_)
destroy_list	O(Nodes*NEPN)=O(size_) 	: while(Nodes)*delete node, which deletes[] an array size NEPN
print		O(size_)

differences:
everything above that is O(Nodes*NEPN) is the same O(size_) as a normal list in the worst case, but they can be more efficient on average.

memory usage: the worst case is that there is only one value stored in each node,
this could be done by filling a list, then deleting all but one element from each noderesulting in NUM_ELEMENTS_PER_NODE times more memory than needed. ex, when NUM_ELEMENTS_PER_NODE = 6:

UnrolledLL<int> a;
for (int i = 10; i < 30; ++i) {
  a.push_back(i);
}
std::cout <<"erase the NON multiples of 6" << std::endl;
UnrolledLL<int>::iterator a_iter = a.begin();
while (a_iter != a.end()) {
  if (*a_iter % 6 != 0) {
    a_iter = a.erase(a_iter);
  } else {
    a_iter++;
  }
}

EXTRA CREDIT:
Improved memory usage implementation.  Discussion as outlined in .pdf.



MISC. COMMENTS TO GRADER:  
Optional, please be concise!


