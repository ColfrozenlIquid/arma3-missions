	fn_marker = {
				_position = _this select 0;
				_name = _this select 1;
				_heading = _this select 2;
				_name = str _name + str random [0, 500, 1000];
				_marker = createMarker [_name, _position];
				_this = _marker;
				_this setMarkerType "mil_unknown";
				_this setMarkerShape "ICON";
				_this setMarkerText _name;
				_this setMarkerColor "ColorRed";
				_this setMarkerDir _heading;
	};

	fn_stripe = {
		_position = _this select 0;
		_heading = _this select 1;
		_distance = _this select 2;
		_color = _this select 3;
		_name = _this select 4;
		_markers = _this select 5;
		_marker = createMarker [_name, _position];
		_this = _marker;
		_this setMarkerSize [5, _distance];
		_this setMarkerDir _heading;
		_this setMarkerShape "RECTANGLE";
		_this setMarkerBrush "Horizontal";
		_this setMarkerColor _color;
		_markers pushBack _this;
	};

	fn_check_safe_position = {
		_position = _this select 0;
		_safe_position = [_position, 0, 15, 5, 0, 0.7, 0, ["road"], [[0,0,0], [0,0,0]]] call BIS_fnc_findSafePos;
		if (_safe_position select 0 != 0) then {
			//hint format ["Relative position at : %1, found safe position at %2", _position, _safe_position];
		} else {
			//hint "Safe Position couldn't be found";
		};
		_safe_position
	};

	fn_find_suitable_Area = {

		_position = _this select 0;
		_iterator = _this select 1;
		_max_count = _this select 2;

		//Find a position a random distance away from the center of the town
		_random_distance = random [200, 250, 300];

		//Divide a circle of possible spawn azimuths into the amount of desired outposts
		//A potential outpost azimuth is then randomly generated in one of the number of slices of the azimuth circle
		_minimum = ((360/(_max_count + 1)) *_iterator);
		_maximum = ((360/(_max_count + 1)) * (_iterator+1));
		_median = (_maximum + _minimum) / 2;
		_random_azimuth = random [_minimum, _median, _maximum];
		_relPos = _position getPos [_random_distance, _random_azimuth];
		_relPos
	};

	fn_build_outpost = {
		_position = _this select 0;
		_iterator = _this select 1;
		_markers = _this select 2;
		object_name = "serverobject_" + str _iterator;
		duration = 10;

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

		{
			_x enableSimulation false;
			if (typeOf _x == "Land_PortableServer_01_sand_F") then {
				_x setVehicleVarName object_name;
				_x setVariable ["assigned_marker1", _markers select _iterator*2, true];
				_x setVariable ["assigned_marker2", _markers select (_iterator*2 + 1), true];
                _x setVariable ["used_boolean", false, true];       //Define a varibale to check if the action has spawned AI before
				_icon = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa";

				_code_start = {
                        [
                            ["SERVER", "Downloading array configuration", 0],
                            ["SERVER", format ["Reconfiguring the satellite array will take %1 seconds. Dont interrupt the process", duration], 5]
				        ] spawn BIS_fnc_EXP_camp_playSubtitles;
                    };
                    _code_progress = {};
                    _code_completed = {
						_marker1 = _this select 0 getVariable "assigned_marker1";
						_marker2 = _this select 0 getVariable "assigned_marker2";
						_marker1 setMarkerColor "ColorGreen";
						_marker2 setMarkerColor "ColorGreen";
                    };
                    _code_interrupted = {};
                    [_x, "Connect Satellite Array", _icon, _icon, "_this distance _target < 3", "_caller distance _target < 3", _code_start, _code_progress, _code_completed, _code_interrupted, [], duration, 1000, true, false] call BIS_fnc_holdActionAdd;
			}
		} forEach _array_obj;
	};

	fn_triangle_markers = {
		// _pos_array = [pos1, pos2, pos3]
		_pos_array = _this select 0;
		_array1 = [];
		_array2 = [];
		_markers = [];
		
		for "_i" from 0 to 2 do {
			_element1 = _pos_array select _i;
			_array1 pushBack _element1;
			for "_j" from 0 to 2 do {
				_element2 = _pos_array select _j;
				if((_element1 distance _element2) > 1) then {
					_distance = _element1 distance _element2;
					_vector_normalised = _element1 vectorFromTo _element2;
					_position1 = _element1 vectorAdd (_vector_normalised vectorMultiply (_distance * 0.24));
					_distance_pos1 = _element1 distance _position1;
					_heading = _element1 getDir _element2;
					_arr = [];
					_arr pushBack _position1;
					_arr pushBack _distance_pos1;
					_arr pushBack _heading;
					_array2 pushBack _arr;
				};
			};
		};
	systemChat format ["Array 1 is: %1", _array1];
	systemChat format ["Array 2 is: %1", _array2];
	{
		[_x, "position", 0] call fn_marker;
	} forEach _array1;
	_markers = [];
	{
		_position1 = _x select 0;
		_distance_pos1 = _x select 1;
		_heading = _x select 2;
		_marker_name = "satellite_" + str(_forEachIndex);
		[_position1, _heading, _distance_pos1, "ColorBlack", _marker_name, _markers] call fn_stripe;
	} forEach _array2;
	systemChat format ["Markers array is %1", _markers];
	_markers
	};

	fn_main = {
		_initial_position  = position player;
		
		//Constants for for loop starting and end point to determine how many outposts are created
		minimum = 0;
		maximum = 2;	//Set amount of outposts to spawn for n+1
		_pos_array = [];

		//Create outposts at safe positions around the town where the Treasure Hunt mission spawned
		for "_i" from minimum to maximum do {
				_relPos = [_initial_position, _i, maximum] call fn_find_suitable_Area;
				_safe_position = [_relPos] call fn_check_safe_position;
				_pos_array pushBack _safe_position;
		};
		_markers = [_pos_array] call fn_triangle_markers;
		{
			[_x, _forEachIndex, _markers] call fn_build_outpost;
		} forEach _pos_array;
	};

[] call fn_main;