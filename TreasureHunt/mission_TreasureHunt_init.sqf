//Set up the treasure hunt mission

/**
	Set up all mission paramters and variables here
	*/
	
	//Set up all incoming Parameters here
	params ["available_AI", "_selected_Task"];
	_available_AI = _this select 0;
	_selected_Task = _this select 1;

	//Selected task is passed along into the constructor to be used there

	task_parent_ID = "hc_1";		//Name of the main task ID, keep this as short as possible

	//Compile an array of pre processed towns to choose from
	//Towns are contained in the format ["Town_Name", Position Array,[Radius A, Radius B]]
	towns = call compile preprocessFileLineNumbers "TreasureHunt\towns.sqf";

	//Function that creates a map area marker
	//Input Parameters ["_label_text", "_marker_position", "_marker_size", "_marker_colour"]
	fn_create_Map_Area_Marker = {
		_label = _this select 0;		//Label Text
		_position = _this select 1;		//Marker Position
		_size = _this select 2;			//Marker area size
		_colour = _this select 3;		//Marker colour
			town_marker = createMarker [_label, _position];
			_this = town_marker;
			_this setMarkerSize _size;
			_this setMarkerShape "ELLIPSE";
			_this setMarkerBrush "Grid";
			_this setMarkerColor _colour;
			_this setMarkerAlpha 0.5;
	};

	//Function that finds a random position within the map marker area
	fn_random_position_marker = {
		_position = _this select 0;
		//hint format ["%1", _position];
		randomnumber = random 100;
		_name = "markertest_" + str randomnumber;
		_marker = createMarker [_name, _position];
		_this = _marker;
		_this setMarkerType "mil_unknown";
		_this setMarkerShape "ICON";
		_this setMarkerText _name;
		_this setMarkerColor "ColorRed";
	};

	//Function that finds a the nearest building to the random position selected inside the map marker area
	fn_nearest_house = {
		_position = _this select 0;
		randomnumber = random 100;
		_name = "nearestbuilding" + str randomnumber;
		_marker = createMarker [_name, _position];
		_this = _marker;
		_this setMarkerType "mil_warning";
		_this setMarkerShape "ICON";
		_this setMarkerText _name;
		_this setMarkerColor "ColorRed";
	};

	fn_find_random_house = {
		//Find random position within one of the randomly selected towns circles
		_random_Town_Location = _this select 0;
		_random_Town_Radius = _this select 1;

		found = false;
		while {found == false} do {
			random_position = [[[_random_Town_Location, _random_Town_Radius]], []] call BIS_fnc_randomPos;
			//hint format ["Random position is %1", random_position];
			nearest_Building = nearestBuilding random_position;
			_position_Building = getPos nearest_Building;
				//Make sure that the chosen position is within the map marker areas limits
				if (_position_Building distance _random_Town_Location < _random_Town_Radius) then {
					//[random_position] call fn_random_position_marker;
					//[_position_Building] call fn_nearest_house;
					found = true;
					break;
				};
		};

		//Find a position inside the building to generate the cache
		_all_positions = nearest_Building buildingPos -1;
		cargo_building_position = position nearest_Building;
		_random_placement = selectRandom _all_positions;
		_crates = createVehicle ["CBRNContainer_01_closed_olive_F", _random_placement];
		_crates addAction ["Extract Data", {[random_Town_Location] execVM "TreasureHunt\mission_TreasureHunt_reward.sqf"}];
		
	};
		

	//Main function to start the mission
	//Variables to set up are:
	/**
		mission_location	
	 */
		mission_setup = {
			_available_AI = _this select 0;
			_selected_Task = _this select 1;
			//Select a random town from the available towns list
			//Create variables that store the chosen towns attributes
			//Mark the chosen Town on the map
			_random_Town = selectRandom towns;
			random_Town_Name = _random_Town select 0;
			random_Town_Location = _random_Town select 1;
			_random_Town_Radius = _random_Town select 2 select 0;
			_colour = "ColorGreen";
			[random_Town_Name, random_Town_Location, _random_Town select 2, _colour] call fn_create_Map_Area_Marker;
			
			//Start up stage 0 of the mission
			[nil, nil, nil, "stage_0", nil, random_Town_Location] execVM "TreasureHunt\mission_TreasureHunt_stages.sqf";

			//Generate the container to be found in the town
			[random_Town_Location, _random_Town_Radius] call fn_find_random_house;

			//Generate a group of outposts around the town
			[random_Town_Location, _available_AI ,_selected_Task] execVM "TreasureHunt\mission_TreasureHunt_generateOutposts.sqf";
		};

[_available_AI, _selected_Task]call mission_setup;