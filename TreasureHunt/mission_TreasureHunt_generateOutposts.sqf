params ["_town_location", "_available_AI", "_selected_Task"];

_town_location = _this select 0;
_available_AI = _this select 1;
_selected_Task = _this select 2;

duration = 10;			//Duration in seconds

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
        _iterator = _this select 1;
		_selected_Task = _this select 2;
		_available_AI = _this select 3;

		task_child = "hc_1" + str _iterator;
        object_name = "serverobject_" + str _iterator;
        private _server_position = nil;

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

		_task_objects = format ["%1_objects.sqf", _selected_Task];
		_objects_array = call compile preprocessFileLineNumbers _task_objects;

		_array_obj = [_position, 0 , _objects_array, 0] call BIS_fnc_ObjectsMapper;
		{
            _x enableSimulation false;
            if (typeOf _x == "Land_PortableServer_01_sand_F") then {
                _x setVehicleVarName object_name;
                _x setVariable ["task_ID", task_child, true];
				_x setVariable ["defended", true, true];
                _x setVariable ["used_boolean", false, true];       //Define a varibale to check if the action has spawned AI before
                _varname = _x getVariable "task_ID";
                //hint format ["Variable Name is: %1", _varname];

				_icon = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa";

				//Create the server object that progresses the mission
                if ((_iterator + 1) == random_server) then {		//Randomly choose one of the servers to be the correct server
					
                    _code_start = {
                        [
                            ["SERVER", "Downloading Location Data", 0],
                            ["SERVER", format ["Download will take %1 seconds to complete. Don't interrupt the download.", duration], 5]
				        ] spawn BIS_fnc_EXP_camp_playSubtitles;
                    };

					//Check at 1/4 of the progress if an enemy group should be spawned that Seeks and Destroys the player
                    _code_progress = {
                        _arguments = [];
						if (_this select 4 == 6) then {
                            if !(_this select 0 getVariable "used_boolean") then {
                                if(true) then {														//Randomly decide if an enemy group should be spawned [random 3 >= 2]
									_this select 0 setVariable ["used_boolean", true, true];
									_this select 0  setVariable ["defended", false];
                                    //hint "an enemy group was spawned";
                                    [_this select 0, _this select 0 getVariable "task_ID", _available_AI] execVM "TreasureHunt\mission_TreasureHunt_createUnits.sqf";
									[_this select 0, _this select 1, _this select 2, "stage_defend", _this select 0 getVariable "task_ID"] execVM "TreasureHunt\mission_TreasureHunt_Stages.sqf";
                                    playSound3D ["a3\dubbing_f_epa\a_out\03_warning\a_out_03_warning_alp_0.ogg", player];
                                } else {
									_this select 0 setVariable ["used_boolean", true, true];		//Set to true so players cant abuse feature
								}
                            };
						}; 
					};

                    _code_completed = {
                        [_this select 0, _this select 1, _this select 2, "stage_1", _this select 0 getVariable "task_ID"] execVM "TreasureHunt\mission_TreasureHunt_Stages.sqf"
                    };

                    _code_interrupted = {};

					_conditionShow = "if(_this distance _target < 3 && _target getVariable ""defended"") then {true}";
					//systemChat Format ["conditionshow is %1", _conditionShow];

					//Generate holdAddAction functionality to the server object
                    [_x, "Download Location Data", _icon, _icon, _conditionShow, "_caller distance _target < 3", _code_start, _code_progress, _code_completed, _code_interrupted, [], duration, 1000, true, false] call BIS_fnc_holdActionAdd;
                
				} else {

                    _code_start = {
                        [
                            ["SERVER", "Downloading Location Data", 0],
                            ["SERVER", format ["Download will take %1 seconds to complete. Don't interrupt the download.", duration], 5]
				        ] spawn BIS_fnc_EXP_camp_playSubtitles;
                    };
                    _code_progress = {};
                    _code_completed = {
                        [_this select 0, _this select 1, _this select 2, "stage_wrong_server", _this select 0 getVariable "task_ID"] execVM "TreasureHunt\mission_TreasureHunt_Stages.sqf";
                    };
                    _code_interrupted = {};
                    [_x, "Download Location Data", _icon, _icon, "_this distance _target < 3", "_caller distance _target < 3", _code_start, _code_progress, _code_completed, _code_interrupted, [], duration, 1000, true, false] call BIS_fnc_holdActionAdd;
                };
		        _server_position = getPos _x;
            };
        } forEach _array_obj;

		//Generate Task for every oupost
		_task_description = "Download the location data from the server. One of the servers will reveal the more accurate location of the cache.";
		_task_title = "Download Location Data";
		_task_marker = "Download Location Data";
		[true, [task_child, "hc_1"], [_task_description, _task_title, _task_marker], _server_position, "CREATED", -1, false, "intel", true] call BIS_fnc_taskCreate;

        //Randomly set up fireteams to protect the server
        _check_random = random 3;
        if (_check_random >= 2) then {
            _fire_team = ["B_Soldier_TL_F", "B_Soldier_AR_F", "B_soldier_GL_F", "B_soldier_LAT_F"];
            _AI_group = [_server_position, east, _fire_team] call BIS_fnc_spawnGroup;
            _seek_destroy = _AI_group addWaypoint [_position, 15];
            _seek_destroy setWaypointType "GUARD";
        };
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
		_random_distance = random [300, 400, 500];

		//Divide a circle of possible spawn azimuths into the amount of desired outposts
		//A potential outpost azimuth is then randomly generated in one of the number of slices of the azimuth circle
		_minimum = ((360/(_max_count + 1)) *_iterator);
		_maximum = ((360/(_max_count + 1)) * (_iterator+1));
		_median = (_maximum + _minimum) / 2;
		_random_azimuth = random [_minimum, _median, _maximum];
		_relPos = _position getPos [_random_distance, _random_azimuth];
		_relPos
	};

	//Constants for for loop starting and end point to determine how many outposts are created
	minimum = 0;
	maximum = 2;	//Set amount of outposts to spawn for n+1
    random_server = [1,3] call BIS_fnc_randomInt;	//Choose random server to select for valid location data
    random_server = 1;
    safe_position = nil;

	//Create outposts at safe positions around the town where the Treasure Hunt mission spawned
	for "_i" from minimum to maximum do {
			_relPos = [_town_location, _i, maximum] call fn_find_suitable_Area;
			_safe_position = [_relPos] call fn_check_safe_position;
			//[_safe_position, "suitableArea"] call fn_mark_Location;
			[_safe_position, _i, _selected_Task, _available_AI] call fn_build_outpost;
            safe_position = _safe_position;
	};