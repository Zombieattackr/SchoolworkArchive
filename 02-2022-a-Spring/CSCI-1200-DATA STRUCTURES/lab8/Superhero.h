#ifndef __Superhero_h
#define __Superhero_h

#include <string>
#include <ostream>

class Superhero {
public:
	friend class Team;
	friend bool operator== (Superhero const & hero, std::string const & guess);

	Superhero(std::string _name, std::string _rname, std::string _power) {
		name=_name;
		rname=_rname;
		power=_power;
		good=true;
	}

	const std::string getName() const { return name; }

	const std::string getPower() const { return power; }

	const bool isGood() const { return good; }

	bool operator-() { good = !good; return good; }

private:
	const std::string getTrueIdentity() const { return rname; }

	std::string name;
	std::string rname;
	std::string power;
	bool good;
};


std::ostream& operator<< (std::ostream & ostr, Superhero const & h) {
	if(h.isGood()) {
		ostr << "Superhero ";
	} else {
		ostr << "Supervillian ";
	}
	ostr << h.getName() << " has power " << h.getPower() << std::endl;
	return ostr;
}

bool operator== (Superhero const & hero, std::string const & guess) {
	return hero.rname == guess;
}

bool operator!= (Superhero& hero, std::string const & guess) {
	return !(hero==guess);
}

bool operator> (const Superhero& s1, const Superhero& s2) {
	if(s1.getPower()=="Fire" && s2.getPower()=="Wood") {
		return true;
	} else if(s1.getPower()=="Wood" && s2.getPower()=="Water") {
		return true;
	} else if(s1.getPower()=="Water" && s2.getPower()=="Fire") {
		return true;
	} else { //besides these three comparisions, all are equal
		return false;
	}
}

#endif
