#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstring>

//functions edit the vector of strings given command line argument characters

//replace, if pixel matches A, replace with B
int replace(std::vector<std::string> &lines, std::string thiswith, std::string withthis) {
	for (int i=0; i < lines.size(); i++) {
		for(int j=0; j < lines[i].size(); j++) {
			if (lines[i][j] == thiswith[0]) {
				lines[i].replace(j,1,withthis);
			}
		}
	}
	return 1;
}

//dilation, if any surrounding pixels match A, replace with A
int dilation(std::vector<std::string> &lines, const std::vector<std::string> linesr, std::string withthis) {
	for (int i=0; i < lines.size(); i++) {
		for(int j=0; j < lines[i].size(); j++) {
			if (i==0 && j==0) { //top left corner
				if ((linesr[i+1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0])) { //checks down and right
					lines[i].replace(j,1,withthis);
				}
			} else if (i==0 && j==lines[i].size()-1) { //top right corner
				if ((linesr[i+1][j] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks down and left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1 && j==0) { //bottom left corner
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0])) { //checks up and right
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1 && j==lines[i].size()-1) { //bottom right corner
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks up and left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==0) { //top edge
				if ((linesr[i+1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks down right left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1) { //bottom edge
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks up right left
					lines[i].replace(j,1,withthis);
				}
			} else if (j==0) { //left edge
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i+1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0])) { //checks up down right
					lines[i].replace(j,1,withthis);
				}
			} else if (j==lines[i].size()-1) { //right edge
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i+1][j] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks up down left
					lines[i].replace(j,1,withthis);
				}
			} else { //not on a corner or edge
				if ((linesr[i-1][j] == withthis[0]) || (linesr[i+1][j] == withthis[0]) || (linesr[i][j+1] == withthis[0]) || (linesr[i][j-1] == withthis[0])) { //checks up down right left
					lines[i].replace(j,1,withthis);
				}
			}
		}
	}
	return 1;
}

//erosion, if not all surrounding pixels match A, replace with B
int erosion(std::vector<std::string> &lines, const std::vector<std::string> linesr, std::string thiswith, std::string withthis) {
	for (int i=0; i < lines.size(); i++) {
		for(int j=0; j < lines[i].size(); j++) {
			if (i==0 && j==0) { //top left corner
				if ((linesr[i+1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0])) { //checks down and right
					lines[i].replace(j,1,withthis);
				}
			} else if (i==0 && j==lines[i].size()-1) { //top right corner
				if ((linesr[i+1][j] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks down and left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1 && j==0) { //bottom left corner
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0])) { //checks up and right
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1 && j==lines[i].size()-1) { //bottom right corner
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks up and left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==0) { //top edge
				if ((linesr[i+1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks down right left
					lines[i].replace(j,1,withthis);
				}
			} else if (i==lines.size()-1) { //bottom edge
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks up right left
					lines[i].replace(j,1,withthis);
				}
			} else if (j==0) { //left edge
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i+1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0])) { //checks up down right
					lines[i].replace(j,1,withthis);
				}
			} else if (j==lines[i].size()-1) { //right edge
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i+1][j] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks up down left
					lines[i].replace(j,1,withthis);
				}
			} else { //not on a corner or edge
				if ((linesr[i-1][j] != thiswith[0]) || (linesr[i+1][j] != thiswith[0]) || (linesr[i][j+1] != thiswith[0]) || (linesr[i][j-1] != thiswith[0])) { //checks up down right left
					lines[i].replace(j,1,withthis);
				}
			}
		}
	}
	return 1;
}

//opening, runs erosion then dilation
int opening(std::vector<std::string> &lines, std::string thiswith, std::string withthis) {
	erosion(lines, lines, thiswith, withthis);
	dilation(lines, lines, thiswith);
	return 1;
}

//closing, runs dilation then erosion
int closing(std::vector<std::string> &lines, std::string thiswith, std::string withthis) {
	dilation(lines, lines, thiswith);
	erosion(lines, lines, thiswith, withthis);
	return 1;
}

int main(int argc, char* argv[]) {

	//checks for valid arguments
	if(argc < 5 || ((strcmp(argv[3],"replace")==0 || strcmp(argv[3],"erosion")==0 || strcmp(argv[3],"opening")==0 || strcmp(argv[3],"closing")==0) && argv[5] == NULL)) {
		std::cerr << "missing arguments" << std::endl << "usage: ./image_processing.out input_file output_file operation pixel1 [pixel2]" << std::endl << "operations: " << "replace: replace any px1 with px2" << std::endl << "dilation: replace pixels with px1 if any adjasent pixels are also px1" << std::endl << "erosion: replace pixels with px2 if any adjasent pixels are not px1" << std::endl << "opening: run erosion then dilation" << std::endl << "closing: run dilation then erosion" << std::endl << "remember to escape characters such as '.' using '\\'" << std::endl;
		exit(1);
	}

	//creates file streams and checks that they work
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

	//reads from file stream and puts lines in a vector of strings
	std::string ascii;
	std::vector<std::string> lines;
	while (in_str >> ascii) {
		lines.push_back(ascii);
	}

	//uses the command line argument to determine which funtion to call 
	if(strcmp(argv[3],"replace")==0) {
		replace(lines, argv[4], argv[5]);
	} else if (strcmp(argv[3],"dilation")==0) {
		dilation(lines, lines, argv[4]);
	} else if (strcmp(argv[3],"erosion")==0) {
		erosion(lines, lines, argv[4], argv[5]);
	} else if (strcmp(argv[3],"opening")==0) {
		opening(lines, argv[4], argv[5]);
	} else if (strcmp(argv[3],"closing")==0) {
		closing(lines, argv[4], argv[5]);
	} else {
		std::cerr << "invalid operation, please use replace, dilation, erosion, opening, or closing" << std::endl;
	}
	
	//write array to file and close files
	in_str.close();
	for (int i=0; i < lines.size(); i++) {
		out_str << lines[i] << std::endl;
	}
	out_str.close();
	return(0);
}