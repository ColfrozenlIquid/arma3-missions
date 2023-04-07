_nearbyLocations = [];
_search_Query = "RockArea";
_nearbyLocations = nearestLocations [position player, [_search_Query], 10000];
if (count _nearbyLocations != 0) then {
	hint format ["%1 locations found of type %2", count _nearbyLocations, _search_Query];
} else {
	hint format ["0 locations found of search query %1", _search_Query];
};

fn_mark_Location = {
	_position = _this select 0;
	_search_Query = _this select 1;
		randomnumber = random 100;
		_name = _search_Query + str randomnumber;
		_marker = createMarker [_name, _position];
		_this = _marker;
		_this setMarkerType "mil_destroy";
		_this setMarkerShape "ICON";
		_this setMarkerText _name;
		_this setMarkerColor "ColorRed";
};

fn_build_outpost = {
	_position = _this select 0;
	_obj_array = 
		[
			["Land_PortableServer_01_sand_F",[1.1377,0.419922,0.74799],308.296,1,0,[-0.00938144,0.0163783],"","",true,false], 
			["Land_PortableGenerator_01_sand_F",[0.908203,0.134766,-1.90735e-006],308.292,1,0,[0.00049673,-0.000409678],"","",true,false], 
			["SatelliteAntenna_01_Sand_F",[-0.699219,-0.164063,-0.00387955],272.784,1,0,[0.0155837,0.00598289],"","",true,false], 
			["SatelliteAntenna_01_Sand_F",[0.582031,-0.683594,-0.00387955],215.112,1,0,[0.0156541,0.00587841],"","",true,false], 
			["Land_BagFence_Round_F",[-0.0634766,2.00781,-0.00130081],175.103,1,0,[0,-0],"","",true,false], 
			["Land_BagFence_Round_F",[0.222656,-2.24023,-0.00130081],355.921,1,0,[0,0],"","",true,false], 
			["OmniDirectionalAntenna_01_black_F",[-0.116211,0.572266,0.00882912],346.538,1,0,[0.000901572,0.004306],"","",true,false], 
			["Land_BagFence_Long_F",[-2.28125,-0.242188,-0.000999451],88.7062,1,0,[0,0],"","",true,false], 
			["Land_BagFence_Long_F",[2.55273,0.0136719,-0.000999451],88.7062,1,0,[0,0],"","",true,false]
		];
	_array_obj = [_position, 0 , _obj_array, 0] call BIS_fnc_ObjectsMapper;
	{_x enableSimulation false;} forEach _array_obj;

};

fn_check_safe_position = {
	_position = _this select 0;
	_safe_position = [_position, 0, 15, 5, 0, 0.7, 0, [], [[0,0,0], [0,0,0]]] call BIS_fnc_findSafePos;
	if (_safe_position select 0 != 0) then {
		hint format ["Realtive position at : %1, found safe position at %2", _position, _safe_position];
	} else {
		hint "Safe Position couldn't be found";
	};
	_safe_position
};

fn_find_suitable_Area = {

	_position = _this select 0;
	_iterator = _this select 1;
	_max_count = _this select 2;

	//Find a position a random distance away from the center of the town
	_random_distance = random [500, 700, 900];

	//Divide a circle of possible spawn azimuths into the amount of desired outposts
	//A potential outpost azimuth is then randomly generated in one of the number of slices of the azimuth circle
	_minimum = ((360/(_max_count + 1)) *_iterator);
	_maximum = ((360/(_max_count + 1)) * (_iterator+1));
	_median = (_maximum + _minimum) / 2;
	_random_azimuth = random [_minimum, _median, _maximum];
	_relPos = _position getRelPos [_random_distance, _random_azimuth];
	_relPos
};

	//Constants for for loop starting and end point to determine how many outposts are created
	minimum = 0;
	maximum = 2;

	//Create outposts at safe positions around the town where the Treasure Hunt mission spawned
	for "_i" from minimum to maximum do {
			_relPos = [player, _i, maximum] call fn_find_suitable_Area;
			_safe_position = [_relPos] call fn_check_safe_position;
			[_safe_position, "suitableArea"] call fn_mark_Location;
			[_safe_position] call fn_build_outpost;
		};

/*	
{
	//_position = locationPosition _x;
	//[_position] call fn_mark_Location;
	
} forEach _nearbyLocations;
*/