#include <string>
#include <ostream>
#include "Board.h"

Board::Board(const std::string& _p1, const std::string& _p2, const std::string _bl) {
	p1 = _p1;
	p2 = _p2;
	bl = _bl;
	rows = 5;
	cols = 4;
	ntic = new int [4];
	m_data = new std::string *[4];
	for(int i = 0; i < 4; i++) {
		m_data[i] = new std::string[0];
		ntic[i] = 0;
	}
}

int Board::numRows() const {
	return rows;
}

int Board::numColumns() const {
	return cols;
}

int Board::numTokensInRow(int r) const {
	if(r < rows) {
		int count = 0;
		for(int i = 0; i < cols; i++) {
			if(numTokensInColumn(i) >= r) {
				count++;
			}
		}
		return count;
	}
	return -1;
}

int Board::numTokensInColumn(int c) const {
	if(c < cols) {
		return ntic[c];
	}
	return -1;
}

void Board::insert(int co, bool p) {
	//if adding a new column
	if(co > cols) {
		std::string** tempc = new std::string*[cols+1];
		int* tntic = new int[cols+1];
		for(int i = 0; i < cols; i++) {
			tempc[i] = m_data[i];
			tntic[i] = ntic[i];
		}
		tntic[cols+1] = 0;
		delete [] m_data;
		delete [] ntic;
		m_data = tempc;
		ntic = tntic;
		cols++;
	}

	//expands m_data[co] and adds p1/p1, checks if new row is created
	std::string* temp = new std::string[numTokensInColumn(co) + 1];
	for(int i = 0; i < numTokensInColumn(co); i++) {
		temp[i] = m_data[co][i];
	}
	if(p) {
		m_data[co][numTokensInColumn(co) + 1] = p1;
	} else {
		m_data[co][numTokensInColumn(co) + 1] = p2;
	}
	delete [] m_data[co];
	m_data[co] = temp;
	ntic[co] = ntic[co]+1;
	if(numTokensInColumn(co) > rows) {
		rows++;
	}

	//checks for any winners

}

void Board::clear(){
	//resets board
	for(int i = 0; i < rows; i++) {
		delete [] m_data[i];
	}
	delete [] m_data;
	delete [] ntic;
	rows = 5;
	cols = 4;
	ntic = new int [4];
	std::string** m_data = new std::string *[4];
	for(int i = 0; i < 4; i++) {
		m_data[i] = new std::string[0];
		ntic[i] = 0;
	}
}

//copy constructor
void Board::copy(const Board& cb) {
	std::string** pm_data = new std::string* [rows];
	int* pntic = new int [rows];
	for(int i = 0; i < rows; i++) {
		pntic[i] = ntic[i];
		pm_data[i] = new std::string[numTokensInColumn(i)];
		for(int j = 0; j < numTokensInColumn(i); j++) {
			pm_data[i][j] = m_data[i][j];
		}
	}
	//return ???pm_data and pntic
}

//assignment operator

Board& Board::operator=(const Board& cb) {
	if(this != &cb) {
		for(int i = 0; i < rows; i++) {
			delete [] m_data[i];
		}
		delete [] m_data;
		delete [] ntic;
		m_data = new std::string *[cb.numColumns()];
		ntic = new int [cb.numColumns()];
		for(int i = 0; i < cb.numColumns(); i++) {
			ntic[i] = cb.numTokensInColumn(i);
			m_data[i] = new std::string[cb.numTokensInColumn(i)];
			for(int j = 0; j < cb.numTokensInColumn(i); j++) {
				m_data[i][j] = cb.tokenAt(i,j); //how do I get a value from an index of cb...
			}
		}

	}
	return *this;
}

/* //this just doesnt work at all
//destructor
Board::~Board(){
	for(int i = 0; i < rows; i++) {
		delete [] m_data[i];
	}
	delete [] m_data;
	delete [] ntic;
}
*/

std::string& Board::tokenAt(const int i, const int j) const{
	return m_data[i][j];
}

std::string Board::blank() const{
	return bl;
}

std::ostream& operator<< (std::ostream& ostr, const Board& b) {
	std::string print;
	for(int i = b.numRows();i > 0; i--) {
		for(int j = 0; j < b.numColumns(); j++) {
			if(i>b.numTokensInColumn(j)) {
				ostr << b.blank() << " ";
			} else {
				ostr << b.tokenAt(i,j) << " ";
			}
		}
		ostr << std::endl;
	}
	return ostr;
}

/*to do
copy constructor wtf
operator<< error
destructor wtf
assignment operator how
check for winners in insert


*/