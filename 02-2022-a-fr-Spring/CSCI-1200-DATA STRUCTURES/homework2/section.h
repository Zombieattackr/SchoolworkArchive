#ifndef __section_h_
#define __section_h_

#include <string>

class Section {
public:
	Section(std::string acourseID, std::string adepartment, std::string acode, std::string atitle, int anday, std::string astartt, std::string aendt, std::string aroom);

	//ACCESSORS
	std::string getCourseID() const;
	std::string getDepartment() const;
	std::string getCode() const;
	std::string getTitle() const;
	int getNDay() const;
	std::string getStartt() const;
	std::string getEndt() const;
	std::string getRoom() const;
	std::string getDay() const;


	//MODIFIERS
	void setCourseID(std::string a);
	void setDepartment(std::string b);
	void setCode(std::string c);
	void setTitle(std::string d);
	void setNDay(int e);
	void setStartt(std::string f);
	void setEndt(std::string g);
	void setRoom(std::string h);

	//other member functions
	

private:	// REPRESENTATION member variables
	std::string courseID;
	std::string department;
	std::string code;
	std::string title;
	int nday;
	std::string startt;
	std::string endt;
	std::string room;
	std::string day;
};

//non member functions
int timeSort (const Section& sec1, const Section& sec2);
int codeSort (const Section& sec1, const Section& sec2);
bool roomBased (const Section& sec1, const Section& sec2);
bool deptBased (const Section& sec1, const Section& sec2);
bool byDept (const Section& sec1, const Section& sec2);

#endif