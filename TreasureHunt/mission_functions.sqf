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
		hint format ["%1", _position];
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