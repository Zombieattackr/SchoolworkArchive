#include <vector>
#include <iostream> 

void moveFrom(int row, int col, int& count,std::vector<std::vector<int> >& board);

int main() {
	int x;
	int y;
	int c = 0;
	std::cin >> x >> y;
	std::vector<std::vector<int> > b;
	for(int i=0;i<=y;i++) {
		b.push_back({});
		for(int j=0;j<=x;j++) {
			b[i].push_back(i);
		}
	}
	moveFrom(x,y,c,b);
	std::cout << c << std::endl;
}

///*
void moveFrom(int col, int row, int& count,std::vector<std::vector<int> >& board) {
	if(row == 0 && col == 0) {
		count++;
	} else if(row == 0) {
		moveFrom(col-1,row,count,board);
	} else if(col == 0) {
		moveFrom(col,row-1,count,board);
	} else {
		moveFrom(col-1,row,count,board);
		moveFrom(col,row-1,count,board);
	}
}
//*/

/*
void moveFrom(int row, int col, int& count,std::vector<std::vector<int> >& board) {
	if(row == 0 && col == 0) {
    count++;
  } 
  if(row != 0) {
    if(board[row-1][col] == 0) {
      moveFrom(row-1,col,count,board);
    }
  } 
  if(col != 0) {
    if(board[row][col-1] == 0) {
      moveFrom(row,col-1,count,board);
    }
  }
}
*/