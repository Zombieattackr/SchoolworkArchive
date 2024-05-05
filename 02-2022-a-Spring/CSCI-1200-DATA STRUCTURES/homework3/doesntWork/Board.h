#ifndef __Board_h_
#define __Board_h_
#include <string>

class Board {
public:
	Board(const std::string& _p1, const std::string& _p2, const std::string _bl);
	int numRows() const;
	int numColumns() const;
	int numTokensInRow(int r) const;
	int numTokensInColumn(int c) const;
	void insert(int co, bool p);
	void clear();
	void copy(const Board& cb);
	std::string& tokenAt(const int i, const int j) const;
	std::string blank() const;
	Board& operator=(const Board& cb);

private:
	std::string p1;
	std::string p2;
	std::string bl;
	int rows;
	int cols;
	int* ntic;
	std::string** m_data;
};
std::ostream& operator<< (std::ostream& ostr, const Board& b);

//~Board();

#endif