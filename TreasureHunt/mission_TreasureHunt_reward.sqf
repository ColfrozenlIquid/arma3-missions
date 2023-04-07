params ["_location"];

_location = _this select 0;

fn_random_position_marker = {
		_position = _this select 0;
		//hint format ["%1", _position];
		randomnumber = random 100;
		_name = "BestPos_" + str randomnumber;
		_marker = createMarker [_name, _position];
		_this = _marker;
		_this setMarkerType "mil_unknown";
		_this setMarkerShape "ICON";
		_this setMarkerText _name;
		_this setMarkerColor "ColorRed";
	};

_random_distance = random [1500, 2000, 2500];
_random_heading = random 360;
_new_position = position player getPos [_random_distance, _random_heading];

_constant1 = "Tree";
_constant2 = "forest";

_best_places = selectBestPlaces [_new_position, 500, _constant2, 1, 1];
//systemChat format ["Best places found are %1", _best_places];

{
	//[_x select 0] call fn_random_position_marker;
} forEach _best_places;

_position = _best_places select 0 select 0;

_trees = nearestTerrainObjects[_position, [_constant1], 30, true, true];
_box_position = nil;

if (count _trees != 0) then {
	//systemChat format ["Found %1", _constant1];
	_tree_position = position (_trees select 0);
	_box = "Box_Syndicate_WpsLaunch_F" createVehicle _tree_position;
	_box_position = getPos _box;
	//[_tree_position] call fn_random_position_marker;
	} else {
		//systemChat format ["Couldnt find %1", _constant1];
	};

	crateTrigger = createTrigger ["EmptyDetector", _box_position, true];
	crateTrigger setTriggerArea [5, 5, 0, false, 5];
	crateTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", false]; 
	_condition = "this";
	_activation = "[nil, nil, nil, ""stage_completed"", nil, _box_position] execVM ""TreasureHunt\mission_TreasureHunt_stages.sqf""";
	_deactivation = "";
	crateTrigger setTriggerStatements [_condition, _activation, _deactivation];

//systemChat format ["Box position is: %1", _box_position];
[nil, nil, nil, "stage_2", nil, _box_position] execVM "TreasureHunt\mission_TreasureHunt_stages.sqf";