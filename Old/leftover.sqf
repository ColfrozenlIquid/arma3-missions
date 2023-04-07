
	//Find houses within a given area
		//_potential_buildings = position nearObjects 50;
		//_random_building = selectRandom _potential_buildings;

		
		_placement_pos = test_building buildingPos 4;
		_all_positions = test_building buildingPos -1;

		hint format ["All building positions are: %1", _all_positions];
		sleep 3;
		hint "";
		hint format ["There are %1 building positions", count _all_positions];
		sleep 3;
		hint "";
		all_crates = [];
		{
			_crates = createVehicle ["CBRNContainer_01_closed_olive_F", _x];
			all_crates pushBack _crates;
		} forEach _all_positions;

		sleep 10;
		{
			deleteVehicle _x;
		} forEach all_crates;
		

	_city_position = locationPosition player;
	_cities = nearestLocations [getPos player, ["nameCity"], 30000];
	_towns = nearestLocations [getPos player, ["nameVillage"], 30000];
	_capitals = nearestLocations [getPos player, ["nameCityCapital"], 30000];

	_all_towns = nearestLocations [getPos player, ["nameCity", "nameVillage", "nameCityCapital"], 30000];
	_all_towns_array = [];
		{
			_town_array = [];
			_town_array pushBack (text _x);
			_town_array pushBack (locationPosition _x);
			_town_array pushBack (type _x);
			_all_towns_array pushBack _town_array;
		} forEach _all_towns;

	hint format ["all towns array looks like: %1", _all_towns_array];
	copyToClipboard str _all_towns_array;
