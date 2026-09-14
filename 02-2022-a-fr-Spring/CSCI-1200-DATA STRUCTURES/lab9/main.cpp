#include <map>
#include <iostream>
#include <vector>

int main() {
	int x;
	std::map<int, int> counters;
	while(std::cin >> x) {
		//++counters[x];
		if(counters.find(x) == counters.end()) {
			counters.insert(std::make_pair(x,1));
		} else {
			counters.find(x)->second++;
		}
	}

	std::map<int, int>::const_iterator it;
	std::vector<std::map<int, int>::const_iterator> vec;
	int max = 0;
	for(it = counters.begin(); it != counters.end(); ++it) {
		if(it->second > max) {
			max = it->second;
			vec.clear();
			vec.push_back(it);
		} else if(it->second == max) {
			vec.push_back(it);
		}
	}

	for(int i=0; i<vec.size();i++) {
		std::cout << vec[i]->first << std::endl;
	}
}
