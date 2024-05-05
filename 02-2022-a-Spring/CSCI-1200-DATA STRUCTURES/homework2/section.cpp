#include <iostream>
#include <string>
#include "section.h"

//constructor sets values and adds a day string determined by the nday int
Section::Section(std::string acourseID, std::string adepartment, std::string acode, std::string atitle, int anday, std::string astartt, std::string aendt, std::string aroom) {
	courseID = acourseID;
	department = adepartment;
	code = acode;
	title = atitle;
	nday = anday;
	startt = astartt;
	endt = aendt;
	room = aroom;
	if(nday==1) {
		day = "Monday";
	} else if(nday==2) {
		day = "Tuesday";
	} else if(nday==3) {
		day = "Wednesday";
	} else if(nday==4) {
		day = "Thursday";
	} else if(nday==5) {
		day = "Friday";
	} else {
		std::cerr << "a valid day was entered but an invalid day was passed? This should be impossible." << std::endl;
	}
}

//accessors
std::string Section::getCourseID() const {return courseID;}
std::string Section::getDepartment() const {return department;}
std::string Section::getCode() const {return code;}
std::string Section::getTitle() const {return title;}
int Section::getNDay() const {return nday;}
std::string Section::getStartt() const {return startt;}
std::string Section::getEndt() const {return endt;}
std::string Section::getRoom() const {return room;}
std::string Section::getDay() const {return day;}


//mutators
void Section::setCourseID(std::string a) {courseID = a;}
void Section::setDepartment(std::string b) {department = b;}
void Section::setCode(std::string c) {courseID = c;}
void Section::setTitle(std::string d) {title = d;}
void Section::setNDay(int e) {
	nday = e;
	if(nday==1) {
		std::string day = "Monday";
	} else if(nday==2) {
		std::string day = "Tuesday";
	} else if(nday==3) {
		std::string day = "Wednesday";
	} else if(nday==4) {
		std::string day = "Thursday";
	} else if(nday==5) {
		std::string day = "Friday";
	} else {
		std::cerr << "Invalid day entered, please enter day as 12345 representing MTWRF" << std::endl;
	}
}
void Section::setStartt(std::string f) {courseID = f;}
void Section::setEndt(std::string g) {courseID = g;}
void Section::setRoom(std::string h) {courseID = h;}

//other functions
int timeSort (const Section& sec1, const Section& sec2) {
	if(sec1.getStartt().at(5)<sec2.getStartt().at(5)){ //AMPM
		return 1;
	} else if(sec1.getStartt().at(5)>sec2.getStartt().at(5)) {
		return 2;
	} else {
		if(sec1.getStartt().substr(0,2)<sec2.getStartt().substr(0,2)) {//hour
			if(sec2.getStartt().substr(0,2)==std::string("12")) {
				return 2;
			}
			return 1;
		} else if(sec1.getStartt().substr(0,2)>sec2.getStartt().substr(0,2)) {
			if(sec1.getStartt().substr(0,2)==std::string("12")) {
				return 1;
			}
			return 2;
		} else {
			if(sec1.getStartt().substr(3,4)<sec2.getStartt().substr(3,4)) {//minute
				return 1;
			} else if(sec1.getStartt().substr(3,4)>sec2.getStartt().substr(3,4)) {
				return 2;
			} else {
				return 0; //same time
			}
		}
	}
}

int codeSort (const Section& sec1, const Section& sec2) {
	if(sec1.getCode().substr(0,4)<sec2.getCode() .substr(0,4)) {
		return 1;
	} else if(sec1.getCode().substr(0,4)>sec2.getCode().substr(0,4)) {
		return 2;
	} else {
		if(sec1.getCode().substr(5,6)<sec2.getCode().substr(5,6)) {
			return 1;
		} else if(sec1.getCode().substr(5,6)>sec2.getCode().substr(5,6)) {
			return 2;
		} else {
			return 0;
		}
	}
}

bool roomBased (const Section& sec1, const Section& sec2) {
	if(sec1.getRoom()<sec2.getRoom()) {
		return true;
	} else if(sec1.getRoom()>sec2.getRoom()) {
		return false;
	} else {
		if(sec1.getNDay()<sec2.getNDay()) {
			return true;
		} else if(sec1.getNDay()>sec2.getNDay()) {
			return false;
		} else {
			int i=timeSort(sec1,sec2);
			if(i==1) {
				return true;
			} else if(i==2) {
				return false;
			} else {
				int j=codeSort(sec1,sec2);
				if(j==1) {
					return true;
				} else if(j==2) {
					return false;
				} else {
					return sec1.getDepartment()<sec2.getDepartment();
				}
			}
		}
	}
}

bool deptBased (const Section& sec1, const Section& sec2) {
	int i=codeSort(sec1,sec2);
	if(i==1) {
		return true;
	} else if(i==2) {
		return false;
	} else {
		if(sec1.getNDay()<sec2.getNDay()) {
			return true;
		} else if(sec1.getNDay()>sec2.getNDay()) {
			return false;
		} else {
			int j=timeSort(sec1,sec2);
			if(j==2) {
				return true;
			} else if(j==1) {
				return false;
			} else {
				return false;
			}
		}
	}
}

bool byDept (const Section& sec1, const Section& sec2) {
	if(sec1.getDepartment()>sec2.getDepartment()) {
		return false;
	}
	return true;
}
