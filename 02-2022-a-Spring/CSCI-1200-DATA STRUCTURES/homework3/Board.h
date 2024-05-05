#ifndef __Board_h_
#define __Board_h_
#include <ostream>

#include <iostream> //ONLY USED IN DEBUG METHOD

class Board {
public:
	//CONSTRUCTOR, COPY CONSTRUCTOR, ASSIGNMENT OPERATOR, DESTRUSTOR
	Board(const std::string &p1_, const std::string &p2_, const std::string &bl_) { this->create(p1_,p2_,bl_); }
	Board(const Board& b) { copy(b); }
	Board& operator=(const Board& b);
	~Board();

	//MEMBER FUNCTIONS AND OTHER OPERATIONS
	std::string* operator[] (int i) { return m_data[i]; } 
	const std::string* operator[] (int i) const { return m_data[i]; }
	std::string insert(const int& c, const bool& p);
	void clear();

	//ACCESSORS
	int numRows() const { return rows; }
	int numColumns() const { return cols; }
	int numTokensInRow(const int& r) const;
	int numTokensInColumn(const int& c) const;
	std::string getP1() const { return p1; }
	std::string getP2() const { return p2; }
	std::string getBl() const { return bl; }
	std::string* getCol(const int& c) const { return m_data[c]; }

private:
	//PRIVATE MEMBER FUNCTIONS
	void create(const std::string &p1_, const std::string &p2_, const std::string &bl_);
	void copy(const Board& b);
	void debug(const int& c);

	//REPRESENTATION
	std::string** m_data;
	int* ntic;
	std::string p1;
	std::string p2;
	std::string bl;
	int rows;
	int cols;
};

//NON MEMBER FUNCTION
std::ostream& operator<<(std::ostream &ostr, const Board& b);

#endif