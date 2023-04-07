_random = random [5, 6, 7];
mines_array = [];

for "_i" from 0 to _random do {
	_mine = createMine ["APERSMine", [17363,12593.7,0], [], 20];
	mines_array pushBack _mine;
};

systemChat format ["Mines Array is size of: %1", count mines_array];