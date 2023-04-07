_initial_road_array = position player nearRoads 100;
iterator = 0;
heading = 0;

fn_marker = {
			_position = _this select 0;
			_name = _this select 1;
			_heading = _this select 2;
			_offset = _position getPos [2, heading];
			_name = _name + str iterator;
			_marker = createMarker [_name, _offset];
			_this = _marker;
			_this setMarkerType "mil_unknown";
			_this setMarkerShape "ICON";
			_this setMarkerText _name;
			_this setMarkerColor "ColorRed";
			heading = heading + 90;
		};


{
	_roadID = str _x;
	_begPos = getRoadInfo _x select 6;
	_endPos = getRoadInfo _x select 7;
	_centerPos = _begPos vectorAdd _endpos;
	_centerPos = [(_centerPos select 0)/2, (_centerPos select 1)/2, (_centerPos select 2)/2];
	[_begPos, "begpos", heading] call fn_marker;
	[_endPos, "endpos", heading] call fn_marker;
	[_centerPos, _roadID, heading] call fn_marker;

	iterator = iterator + 1;
} forEach _initial_road_array;