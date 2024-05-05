#include <iostream>
#include <vector>
#include <list>
#include <algorithm>

class ar { //area object
public:
  ar(const char _name,const int _size) {
    name=_name;
    size=_size;
  }

  // REPRESENTATION
  std::vector<std::vector<int> > chords;
  int minr;
  char name;
  int size;


  bool oporator<() {//I forgot how to impliment this
    return true;
  {

};

class sol { //one possible solution
public:
	sol() {
		rows={};//does this work?
		cols={};
	}

	std::vector<int> rows;
	std::vector<int> cols;
	
}

int main(int argc, char* argv[]) {
	std::ifstream in_str(argv[1]);
	if(!in_str.good()) {
		std::cerr << "Can't open " << argv[1] << " to read." << std::endl;
		exit(1);
	}
	std::ofstream out_str(argv[2]); 
	if (!out_str.good()) {
		std::cerr << "Can't open " << argv[2] << " to write." << std::endl;
		exit(1);
	}

	//VARIABLE INITIALIZATION/DECLARATION
	std::list<ar> ars ({}); //list of areas
	std::vector<sol> sols ({}); //vect of solutions
	std::vector<int> xs ({}); //vect of x chords of where stars are
	std::vector<int> ys ({}); //vect of y chords of where stars are
	int rows, cols; // size of the board
	char c1, c2;
	in_str >> rows >> cols;
	std::vector<std::vector<char> > board; // board for printing
	for(int i=0;i<rows;i++) {
		board.push_back({});
		for(int j=0;j<cols;j++) {
			b[i].push_back(' ');
		}
	}
	std::vector<int> sinrow (rows,0);//stars already in row
	std::vector<int> sincol (cols,0);//stars already in col
	
	//FILE READ
	char cur;
	while(in_str >> c1 >> c2) {
		if(!isdigit(c1)) { //if it's a new area
			ars.push_back(ar(c1,a-c2));
			cur = c1;
		} else { //if it's another chord
			int cr = -1;
			if(a-c2 != cr) { //if it's a new row
				ars.back().chords.push_back({});
			}
			ars.back().chords.back().push_back(a-c1); // add chord
			board[a-c2][a-c1] = cur;
		}
	}
	//sort ars by size
	std::sort( //sort ars, already have op<

	//ALGORITHM
	check(ars, sols, sinrow, sincol, std::vector<int> &rs, std::vector &cs, int rr, int rc)

	//OUTPUT
	


} 

//         list of areas       vector of solutions      num stars vector of stars in row   vector of stars in col    area and total stars, relative row and relative col to the area, left most of the top row is 0,0
void check(std::list<ar> &ars, std::vector<sols> &sols, int &ns, std::vector<int> &sinrow, std::vector<int> &sincol, int &as, int &ts, int rr, int rc) {
	if(sinrow[]
}