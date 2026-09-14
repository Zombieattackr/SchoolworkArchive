#include "Board.h"

//CONSTRUCTOR
void Board::create(const std::string &p1_, const std::string &p2_, const std::string &bl_) {
	m_data = new std::string* [4];
	ntic = new int [4];
	for(int i=0; i<4; i++) {
		m_data[i] = NULL;
		ntic[i] = 0;
	}
	rows = 5;
	cols = 4;
	p1 = p1_;
	p2 = p2_;
	bl = bl_;
}

//copy method used in assignment operator and copy constructor
void Board::copy(const Board& b) {
	this->rows = b.rows;
	this->cols = b.cols;
	this->p1 = b.p1;
	this->p2 = b.p2;
	this->bl = b.bl;
	this->ntic = new int [this->cols];
	for(int i=0; i < this->cols;i++) {
		this -> ntic[i] = b.ntic[i];
	}
	this->m_data = new std::string* [this->cols];
	for(int i=0; i < this->cols;i++) {
		this -> m_data[i] = new std::string [this->ntic[i]];
		for(int j=0; j < this->ntic[i]; j++) {
			this -> m_data[i][j] = b.m_data[i][j];
		}
	}
}

//assignment operator
Board& Board::operator=(const Board& b) {
	if(this != &b) {
		for(int i = 0; i < cols; i++) {
			delete [] m_data[i];
		}
		delete [] m_data;
		delete [] ntic;
		this -> copy(b);
	}
	return *this;
}

std::string Board::insert(const int& c, const bool& p) {
	/* 
	//debug code, ignore this
	std::cout << std::endl << "adding " << p << " to col " << c;
	debug(c);
	*/

	//expand m_data and ntic to the right if necessary
	if(c>=cols) {
		int* new_ntic = new int[c+1];
		std::string** new_m_data = new std::string*[c+1];
		for(int i=0; i<=c; i++) {
			new_ntic[i] = 0;
			new_m_data[i] = NULL;
		}
		for(int i=0; i<cols; i++) {
			new_ntic[i] = ntic[i];
			new_m_data[i] = m_data[i];
		}
		delete [] ntic;
		delete [] m_data;
		ntic = new_ntic;
		m_data = new_m_data;
		cols = c+1;
	}

	//expand collumn upward
	if(m_data[c]==NULL) { //if column is null, give size 1
		m_data[c] = new std::string[1];
	} else { //else, copy and expand
		std::string* new_data = new std::string[ntic[c]+1];
		for(int i = 0; i<ntic[c]; i++) {
			new_data[i] = m_data[c][i];
		}
		delete [] m_data[c];
		m_data[c] = new_data;
	}
	//fill top of collumn with token
	std::string chk; //used to check winner
	if(p){
		m_data[c][ntic[c]] = p1;
		chk = p1;
	} else {
		m_data[c][ntic[c]] = p2;
		chk = p2;
	}
	//tracks ntic and rows
	ntic[c] = ntic[c]+1;
	if(ntic[c] > rows) {
		rows = ntic[c];
	}
	
	/* 
	//debug code, ignore this
	std::cout << std::endl;
	debug(c);
	std::cout << "added  " << p << " to col " << c << std::endl;
	*/

	//check for length of row and col made by token
	int v_count = 0;
	int h_count = 0;
	bool cont_d = true;
	bool cont_r = true;
	bool cont_l = true;
	//check down
	int i = c;
	int j = ntic[c]-1;
	while(cont_d) {
		j--;
		if(j >= 0) {
			if(m_data[i][j] == chk) {
				v_count++;
			} else {
				cont_d = false;
			}
		} else {
			cont_d = false;
		}
	}
	//check right
	i = c;
	j = ntic[c]-1;
	while(cont_r) {
		i++;
		if(i<cols) {
			if(j < ntic[i]) {
				if(m_data[i][j] == chk) {
					h_count++;
				} else {
					cont_r = false;
				}
			} else {
				cont_r = false;
			}
		} else {
			cont_r = false;
		}
	}
	//check left
	i = c;
	j = ntic[c]-1;
	while(cont_l) {
		i--;
		if(i>=0) {
			if(j < ntic[i]) {
				if(m_data[i][j] == chk) {
					h_count++;
				} else {
					cont_l = false;
				}
			} else {
				cont_l = false;
			}
		} else {
			cont_l = false;
		}
	}

	//if there is a row of 4 or more, return winner
	if(v_count >= 3 || h_count >= 3) {
		return chk;
	}
	return bl; //else, return blank
}

//debug to print some values, can be ignored
void Board::debug(const int& c) {
	std::cout << std::endl 
	<< "rows: " << rows << std::endl
	<< "cols: " << cols << std::endl
	<< "ntic: ";
	for(int i = 0; i<cols; i++) {
		std::cout << ntic[i] << ", ";
	}
	if(c<cols) {
		std::cout << std::endl 
		<< "m_data[" << c << "]:";
		for(int i = 0; i<ntic[c]; i++) {
			std::cout << m_data[c][i] << ", ";
		}
	} else {
		std::cout << std::endl
		<< "m_data[" << c << "] does not yet exist";
	}
	std::cout << std::endl;
}
//debug to print some values, can be ignored

//checks if each collumn has enough tokens to reach row r, 
//counts and returns that number
int Board::numTokensInRow(const int& r) const {
	if(r < rows) {
		int count = 0;
		for(int i = 0; i < cols; i++) {
			if(ntic[i] != 0) {
				if(ntic[i] >= r) {
					count++;
				}
			}
		}
		return count;
	}
	return -1;
}

//returns value stored in ntic[] (NumTokensInColumn[])
int Board::numTokensInColumn(const int& c) const { 
	if(c < cols) {
		return ntic[c];
	}
	return -1;
}

//print function
std::ostream& operator<<(std::ostream &ostr, const Board& b) {
	for(int i = b.numRows()-1;i>=0;i--) {
		for(int j = 0;j<b.numColumns();j++) {
			if(b.getCol(j)==NULL) {
				ostr << b.getBl();
			} else {
				if(b.numTokensInColumn(j)>i) {
					ostr << b.getCol(j)[i];
				} else {
					ostr << b.getBl();
				}
			}
			if(j+1<b.numColumns()){
				ostr << std::string(" ");
			}
		}
		ostr << std::endl;
	}
	return ostr;
}

//DESTRUCTOR
Board::~Board() { 
	for(int i=0; i<cols; i++) {
		delete [] m_data[i];
	}
	delete [] m_data; 
	delete [] ntic;
}

//clears board to default state with the same three strings
void Board::clear() { 
	for(int i=0; i<cols; i++) {
		delete [] m_data[i];
	}
	delete [] m_data; 
	delete [] ntic;
	create(p1,p2,bl); 
}