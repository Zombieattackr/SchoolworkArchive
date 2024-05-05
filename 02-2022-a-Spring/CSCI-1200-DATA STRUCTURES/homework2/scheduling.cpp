#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstring>
#include <algorithm>
#include "section.h"

int main(int argc, char* argv[]) {

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

	//crates vector of objects from data in file
	std::string courseID, department, code, title, days, startt, endt, room;
	std::vector<Section> sections;
	while(in_str >> courseID >> department >> code >> title >> days >> startt >> endt >> room) {
		for(unsigned int i=0; i < days.size(); i++) {
			if(days[i]=="M"[0]) {
				Section secTemp(courseID, department, code, title, 1, startt, endt, room);
				sections.push_back(secTemp);
			} else if(days[i]=="T"[0]) {
				Section secTemp(courseID, department, code, title, 2, startt, endt, room);
				sections.push_back(secTemp);
			} else if(days[i]=="W"[0]) {
				Section secTemp(courseID, department, code, title, 3, startt, endt, room);
				sections.push_back(secTemp);
			} else if(days[i]=="R"[0]) {
				Section secTemp(courseID, department, code, title, 4, startt, endt, room);
				sections.push_back(secTemp);
			} else if(days[i]=="F"[0]) {
				Section secTemp(courseID, department, code, title, 5, startt, endt, room);
				sections.push_back(secTemp);
			} else {
				std::cerr << "Invalid day entered, ignored, use MTWRF" << std::endl;
			}
		}
	}

	//filtered based on either room or department
	unsigned int maxt = 11; //max title size
	unsigned int maxd = 0; //max day size
	long unsigned int n = 0;
	long unsigned int m = 0;
	long unsigned int entries = 0;
	long unsigned int i = 0;
	if(strcmp(argv[3],"room")==0) { //room operation
		sort(sections.begin(),sections.end(),roomBased);
		if(argc>=5) { //5 args, filter to one room
			while(i < sections.size()) {
				if(sections[i].getRoom()==std::string(argv[4])) { //if correct room, check max and itterate. if incorrect, erase.
					if(sections[i].getTitle().size() > maxt) {
						maxt = sections[i].getTitle().size();
					}
					if(sections[i].getDay().size() > maxd) {
						maxd = sections[i].getDay().size();
					}
					i++;
				} else {
					sections.erase(sections.begin()+i);
				}
			}
			if(sections.size() != 0) { //print header, sections, and footer
				out_str << "Room " << sections[0].getRoom() << std::endl 
				<< "Dept  Coursenum  Class Title  " << std::string(maxt-11, ' ') 
				<< "Day  " << std::string(maxd-3, ' ') << "Start Time  End Time" << std::endl 
				<< "----  ---------  " << std::string(maxt,'-') << "  " << std::string(maxd,'-') 
				<< "  ----------  --------" << std::endl;
				for(long unsigned int j=0; j<sections.size();j++) { //print loop
					out_str << sections[j].getDepartment() << "  " 
					<< sections[j].getCode() << "    " 
					<< sections[j].getTitle() << std::string(2+maxt-sections[j].getTitle().size(), ' ') 
					<< sections[j].getDay() << std::string(2+maxd-sections[j].getDay().size(), ' ') 
					<< sections[j].getStartt() << "     " 
					<< sections[j].getEndt() << ' ' << std::endl;
				}
				out_str << sections.size() << " entries" << std::endl << std::endl;
			} else {
				out_str << "No data available." << std::endl;
			}
		} else {
			if(sections.size()==0) {
				out_str << "No data available." << std::endl;
			}
			std::string current = "";
			while(i<sections.size()) {//itterates forward through the whole thing
				if(sections[i].getRoom()==current) { //if it matches the same room, continue forward
					i++;
				} else { // when i is a new one, process of finding max's and printing. n=index of first object of new room, 
					current = sections[i].getRoom();
					maxt = 11;
					maxd = 0;
					n = i;
					m = i;
					entries = 0;
					while(i<sections.size()) { //checks for max's and i++ until !=, at start: i=n=m=first index
												//at end: i=end of vector, n=first index, m=last index
						if(sections[i].getRoom() == current) {
							if(sections[i].getTitle().size() > maxt) {
								maxt = sections[i].getTitle().size();
							}
							if(sections[i].getDay().size() > maxd) {
								maxd = sections[i].getDay().size();
							}
							m = i;
							entries++;
						}
						i++;
					}
					//header print
					out_str << "Room " << sections[n].getRoom() << std::endl 
                    << "Dept  Coursenum  Class Title" << std::string(maxt-9, ' ') 
                    << "Day  " << std::string(maxd-3, ' ') << "Start Time  End Time" << std::endl 
                    << "----  ---------  " << std::string(maxt,'-') << "  " << std::string(maxd,'-') 
                    << "  ----------  --------" << std::endl;
                    i=n; //resets i to first index of section
                    while(i<=m) { //loop i until end of section
                    	out_str << sections[i].getDepartment() << "  " 
                        << sections[i].getCode() << "    " 
                        << sections[i].getTitle() << std::string(2+maxt-sections[i].getTitle().size(), ' ') 
                        << sections[i].getDay() << std::string(2+maxd-sections[i].getDay().size(), ' ') 
                        << sections[i].getStartt() << "     " 
                        << sections[i].getEndt() << ' ' << std::endl;
                        i++;
                    }
                    out_str << entries << " entries" << std::endl << std::endl;
                    //once section is printed, i=first index of next section, n and m will be reset to i in next loop
				}
			}
		}
	} else if(strcmp(argv[3],"dept")==0) {
		sort(sections.begin(),sections.end(),deptBased);
		long unsigned int i = 0;
		if(argc<5) {
			std::cerr << "missing department argument, please enter a department to search" << std::endl;
		} else {
			while(i < sections.size()) {
				if(sections[i].getDepartment()==std::string(argv[4])) {
					if(sections[i].getTitle().size() > maxt) {
						maxt = sections[i].getTitle().size();
					}
					if(sections[i].getDay().size() > maxd) {
						maxd = sections[i].getDay().size();
					}
					i++;
				} else {
					sections.erase(sections.begin()+i);
				}
			}
			if(sections.size() != 0) {
				out_str << "Dept " << sections[0].getDepartment() << std::endl 
				<< "Coursenum  Class Title  " << std::string(maxt-11, ' ') 
				<< "Day  " << std::string(maxd-3, ' ') << "Start Time  End Time" << std::endl 
				<< "---------  " << std::string(maxt,'-') << "  " << std::string(maxd,'-') 
				<< "  ----------  --------" << std::endl;
				for(long unsigned int j=0; j<sections.size();j++) {
					out_str <<sections[j].getCode() << "    " 
					<< sections[j].getTitle() << std::string(2+maxt-sections[j].getTitle().size(), ' ') 
					<< sections[j].getDay() << std::string(2+maxd-sections[j].getDay().size(), ' ') 
					<< sections[j].getStartt() << "     " 
					<< sections[j].getEndt() << ' ' << std::endl;
				}
				out_str << sections.size() << " entries" << std::endl << std::endl;
			} else {
				out_str << "No data available." << std::endl;
			}
		}
	} else if(strcmp(argv[3],"custom")==0) {
		long unsigned int stotal = 0;
		long unsigned int etotal = 0;
		long unsigned int tcount = 0;
		std::string ampm = "AM";
		std::string ampm2 = "AM";
		std::string z1 = "";
		std::string z2 = "";
		std::string z3 = "";
		std::string z4 = "";
		sort(sections.begin(),sections.end(),byDept);
		if(sections.size()==0) {
			out_str << "No data available." << std::endl;
		} else {
			out_str << "Dept  Total classes  Average class start time  Average class end time" << std::endl 
			<< "----  -------------  ------------------------  ----------------------" << std::endl;
		}
		std::string current = "";
		while(i<sections.size()) {//itterates forward through the whole thing
			if(sections[i].getDepartment()==current) { //if it matches the same dept, continue forward
				i++;
			} else { // when i is a new one, process of finding times and printing the average. n=index of first object of new room, 
				current = sections[i].getDepartment();
				n = i;
				while(i<sections.size()) { 
					if(sections[i].getDepartment() == current) {
						stotal += 60*stoi(sections[i].getStartt().substr(0,2))+stoi(sections[i].getStartt().substr(3,4));
						if(sections[i].getStartt().substr(5,5)==std::string("PM")) {
							stotal +=720;
						}
						etotal += 60*stoi(sections[i].getEndt().substr(0,2))+stoi(sections[i].getEndt().substr(3,4));
						if(sections[i].getEndt().substr(5,5)==std::string("PM")) {
							etotal +=720;
						}
						tcount++;
					}
					i++;
				}
				stotal /= tcount;
				etotal /= tcount;
				if(stotal>=720) { //if after noon, set to PM
					ampm = "PM";
				}
				if(stotal>=780) { //if after 1pm, subtract 12h
					stotal -=720;
				} else if(stotal<60) { //if before 1am, add 12 hours
					stotal +=720;
				}
				if(stotal/60<10) { //add leading zero if hours less than 10
					z1 = "0";
				}
				if(stotal%60<10) { //add leading zero if minutes less than 10
					z2 = "0";
				}

				if(etotal>=720) { //if after noon, set to PM
					ampm2 = "PM";
				}
				if(etotal>=780) { //if after 1pm, subtract 12h
					etotal -=720;
				} else if(etotal<60) { //if before 1am, add 12 hours
					etotal +=720;
				}
				if(etotal/60<10) { //add leading zero if hours less than 10
					z3 = "0";
				}
				if(etotal%60<10) { //add leading zero if minutes less than 10
					z4 = "0";
				}

				out_str << sections[n].getDepartment() << "  " << tcount << std::string(15-std::to_string(tcount).size(),' ') 
				<< z1 << stotal/60 << ":" << z2 << stotal%60 << ampm << "                   " 
				<< z3 << etotal/60 << ":" << z4 << etotal%60 << ampm2 << std::endl;
				stotal = 0;
				ampm = "AM";
				ampm2 = "AM";
				z1 = "";
				z2 = "";
				z3 = "";
				z4 = "";
                i=n;
                tcount = 0;
                stotal = 0;
                etotal = 0;
			}
		}
	} else {
		std::cerr << "invalid argument, use room, dept, or custom" << std::endl;
	}

	in_str.close();
	out_str.close();
	return(0);
}