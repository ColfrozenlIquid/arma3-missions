_position = position player;

_constant1 = "FOREST";
_constant2 = "forest";

_trees = nearestTerrainObjects[_position, [_constant1], 50, true, true];

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


if (count _trees != 0) then {
	systemChat format ["Found %1", _constant1];
	_tree_position = position (_trees select 0);
	//_move_position = _tree_position getPos [0.5, 0];
	"Box_Syndicate_WpsLaunch_F" createVehicle _tree_position;
	} else {
		systemChat format ["Couldnt find %1", _constant1];
	};

_best_places = selectBestPlaces [_position, 1000, _constant2, 1, 5];
systemChat format ["Best places found are %1", _best_places];

{
	[_x select 0] call fn_random_position_marker;
} forEach _best_places;
