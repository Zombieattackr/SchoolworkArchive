HOMEWORK 3: CONNECT FOUR


NAME: Hayden Fuller


COLLABORATORS AND OTHER RESOURCES:
List the names of everyone you talked to about this assignment
(classmates, TAs, ALAC tutors, upperclassmen, students/instructor via
LMS, etc.), and all of the resources (books, online reference
material, etc.) you consulted in completing this assignment.

submitty and Vec.h
cplusplus.com for some of the O notation below.

Remember: Your implementation for this assignment must be done on your
own, as described in the "Academic Integrity for Homework" handout.


ESTIMATE OF # OF HOURS SPENT ON THIS ASSIGNMENT:  24



ORDER NOTATION:
For each of the functions below, write the order notation O().
Write each answer in terms of m = the number of rows and n = the
number of columns.  You should assume that calling new [] or delete []
on an array will take time proportional to the number of elements in
the array.

insert (excluding checking for connected four)
O(max(m,n))
insert (including checking for connected four)
O(max(m,n))
numTokensInColum
O(1)
numTokensInRow
O(n)
numColumns
O(1)
numRows
O(1)
print
O(m*n)
clear
O(m*n)

TESTING & DEBUGGING STRATEGY: 
Discuss your strategy for testing & debugging your program.  
What tools did you use (gdb/lldb/Visual Studio debugger,
Valgrind/Dr. Memory, std::cout & print, etc.)?  How did you test the
"corner cases" of your Matrix class design & implementation?

I made a debug method that prints some values with std::cout that were helpful with debugging. I also used Dr Memory, but it wasn't very helpful/necessary for any issues I had. I added multiple test cases to the main file and ran those with my debug code to make sure everything was working propperly.


MISC. COMMENTS TO GRADER:  
(optional, please be concise!)
Have a nice day!