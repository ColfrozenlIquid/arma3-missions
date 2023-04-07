////////////////////////////////////////////////////////////////////////////////////////////////////////
//DEFINES//
////////////////////////////////////////////////////////////////////////////////////////////////////////

iterator = 0;
_initial_road_array = position player nearRoads 20;
_initial_road = _initial_road_array select 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////
//FUNCTIONS//
////////////////////////////////////////////////////////////////////////////////////////////////////////

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

	fn_generate_outpost = {
			_position = _this select 0;
			_heading = _this select 1;
			_roadType = _this select 2;
			_objArray = call compile preprocessFileLineNumbers format ["Outpost\outpost_type_%1.sqf", _roadType];
			[_position, _heading, _objArray, 0] call BIS_fnc_ObjectsMapper;
		};

	fn_choose_color = {
		_difference_heading = _this select 0;
		if (_difference_heading > 4) then {
				_setColor = "colorRed";
			};
			if (_difference_heading < 2) then {
				_setColor = "colorOrange";
			};
			if (_difference_heading < 1) then {
				_setColor = "colorYellow";
			};
			if(_difference_heading < 0.6) then {
				_setColor = "colorGreen";
			};
		_setColor
	};

	fn_draw_polyline = {
		_pos1 = _this select 0;
		_pos2 = _this select 1;
		_setColor = _this select 2;
			_markerName = "polyline" + str iterator;
			_line = createMarker [_markerName, [0,0,0]];
			_this = _line;
				_path = [];
				_path pushBack (_pos1 select 0);
				_path pushBack (_pos1 select 1);
				_path pushBack (_pos2 select 0);
				_path pushBack (_pos2 select 1);
				_markerName setMarkerPolyline _path;
				_markerName setMarkerColor _setColor;
		_lines pushBack _this;
	};

	fn_marker_arrow = {
			_position = _this select 0;
			_name = _this select 1;
			_heading = _this select 2;
			_color = _this select 3;
			_newname = str _name + str iterator;
			_marker = createMarker [_newname, _position];
			_this = _marker;
			_this setMarkerType "mil_arrow";
			_this setMarkerShape "ICON";
			_this setMarkerSize [0.5, 0.5];
			_this setMarkerColor _color;
			_this setMarkerDir _heading;
			_markers pushBack _this;
		};

	fn_create_area_marker = {
		_position = _this select 0;
		_size = _this select 1;
		_marker = createMarker ["lightborder", _position];
			_this = _marker;
			_this setMarkerSize [_size, _size];
			_this setMarkerShape "ELLIPSE";
			_this setMarkerBrush "SolidBorder";
			_this setMarkerAlpha 0.5;
		_this
	};

    fn_forward_check = {
        _current_road = _this select 0;

        //Get all connected roads to nearest road
        _connected_roads_array = roadsConnectedTo _current_road;

        while {(count _connected_roads_array) == 2} do {
                    //Assume forward propagation
                    _forward_connected_road = _connected_roads_array select 1;

					if(getRoadInfo _current_road select 8) then {
						_forward_connected_road = _connected_roads_array select 0;
						systemChat format ["A bridge has been found at %1", getPos _current_road];
					}; 

                    //Get current road paramters
                    _begPos_initial = getRoadInfo _current_road select 6;							//Initial road start point
                    _endPos_initial = getRoadInfo _current_road select 7;							//Initial road end point
                    _heading_initial = _begPos_initial getDir _endPos_initial;						//Initial road heading value

                    //Define forward road parameters
                    _fwd_return_values = [_forward_connected_road, _begPos_initial, _heading_initial] call fn_set_fwd_road_parameters;
                    _fwd_next_road_seg_endPos = _fwd_return_values select 0;
                    _fwd_center_pos_i_n = _fwd_return_values select 1;
                    _fwd_diff_heading_i_n = _fwd_return_values select 2;
                    _fwd_avg_heading_i_n = _fwd_return_values select 3;

                        //Call function to get setColor
                        _setColor = [_fwd_diff_heading_i_n] call fn_choose_color;

                        //Call function to create polyline marker
                        [_begPos_initial, _fwd_next_road_seg_endPos, _setColor] call fn_draw_polyline;

                        //Call function to create arrow marker to display average heading of road segments
                        [_fwd_center_pos_i_n, _fwd_diff_heading_i_n, _fwd_avg_heading_i_n, _setColor] call fn_marker_arrow;
                    //Get next road segment
                    _current_road = _forward_connected_road;
                    _connected_roads_array = roadsConnectedTo _current_road;
                    iterator = iterator + 1;
					sleep 0.01;
                };
        _current_road		//Returns the intersection
    };

    fn_set_fwd_road_parameters = {
        _connected_road = _this select 0;
        _begPos_initial = _this select 1;
        _heading_initial = _this select 2;

        _next_road_seg_begPos = getRoadInfo _connected_road select 6;							//Beginning pos of the next road segment
        _next_road_seg_endPos = getRoadInfo _connected_road select 7;							//End pos of the next road segmnent
        _next_road_seg_heading = _next_road_seg_begPos getDir _next_road_seg_endPos;				//Heading of the next road segment

        _center_pos_i_n = _begPos_initial vectorAdd _next_road_seg_endPos;
        _center_pos_i_n = [(_center_pos_i_n select 0)/2, (_center_pos_i_n select 1)/2, (_center_pos_i_n select 2)/2];		//Get the center position between initial beginning and next end
        _avg_heading_i_n = (_heading_initial + _next_road_seg_heading)/2;													//Get the average heading between the 2 road segments
        _diff_heading_i_n = abs(_heading_initial - _next_road_seg_heading);													//Get the difference in absolute heading of the road segments
        _return_values = [_next_road_seg_endPos, _center_pos_i_n, _diff_heading_i_n, _avg_heading_i_n];
        _return_values
    };

    fn_set_bwd_road_parameters = {
        _connected_road = _this select 0;
        _endPos_initial = _this select 1;
        _heading_initial = _this select 2;

        _next_road_seg_begPos = getRoadInfo _connected_road select 6;							//Beginning pos of the next road segment
        _next_road_seg_endPos = getRoadInfo _connected_road select 7;							//End pos of the next road segmnent
        _next_road_seg_heading = _next_road_seg_begPos getDir _next_road_seg_endPos;				//Heading of the next road segment

        _center_pos_i_n = _endPos_initial vectorAdd _next_road_seg_begPos;
        _center_pos_i_n = [(_center_pos_i_n select 0)/2, (_center_pos_i_n select 1)/2, (_center_pos_i_n select 2)/2];		//Get the center position between initial beginning and next end
        _avg_heading_i_n = (_heading_initial + _next_road_seg_heading)/2;													//Get the average heading between the 2 road segments
        _diff_heading_i_n = abs(_heading_initial - _next_road_seg_heading);													//Get the difference in absolute heading of the road segments
        _return_values = [_next_road_seg_begPos, _center_pos_i_n, _diff_heading_i_n, _avg_heading_i_n];
        _return_values
    };
        

	//For each direction mark the road and heading of the road on map
	//If the loop stumbles upon a connected roads array greater than 2, start a loop for each of the connected roads

	fn_road = {
		_setColor = nil;
		_connected_roads_array = nil;
		_intersection = nil;
		_intersection = [];
		_current_road = _this select 0;
        _intersection_road = [_current_road] call fn_forward_check;
		_current_road = _intersection_road;

		[getPos _current_road] call fn_marker;

		//Check if a road with only 1 connection is found
			if(count(roadsConnectedTo _current_road) == 1) then {
				//systemChat format ["Found road with only one connection at %1", getPos _current_road];
				[getPos _current_road, "Ending road", 0] call fn_marker;
			};

        //Check if an intersection of roads has been found
            if(count(roadsConnectedTo _current_road) > 2) then {
            //systemChat format ["An intersection has been found at: %1 connecting %2 roads, given %3", getPos _current_road, count(roadsConnectedTo _current_road)-1, _current_road];
            //[getPos _current_road, format ["Intersection %1", getPos _current_road], 0] call fn_marker;
        
		//Intersection found
        _connected_roads_array = roadsConnectedTo _current_road;
		//if (searched) then {
        //	[_connected_roads_array select 2] call fn_forward_check;
		//};

		//searched = true;

        _current_road_beg = getRoadInfo _current_road select 6;
        _current_road_end = getRoadInfo _current_road select 7;

        {
            _selected_beg = getRoadInfo _x select 6;
            _selected_end = getRoadInfo _x select 7;
                if ((_current_road_end distance _selected_beg) < (_current_road_end distance _selected_end)) then {     //Check if the current end is the same as the next beginning
                    //systemChat format ["Road %1 is an output road", _x];
					//[getPos _x, "outputroad", 0] call fn_marker;
                    _intersection pushBack [_x, false];     //false if output road
                };
                if ((_current_road_beg distance _selected_end) < (_current_road_beg distance _selected_beg)) then {     //Check if the current beg is the same as the next ending
                    //systemChat format ["Road %1 is an input road", _x];
					//[getPos _x, "inputroad", 0] call fn_marker;
                    _intersection pushBack [_x, true];      //true if input road
                };
        } forEach _connected_roads_array;

		{
            if!(_x select 1) then {       //Check if connected road is an output road
				systemChat format ["Called fn_road check on road: %1", _x select 0];
                [_x select 0] call fn_road;
            };
        } forEach _intersection;
        };
    };

fnc_get_roads = {

	_markers = [];
	_lines = [];

	_setColor = nil;
	_radius = 15000;
	_all_roads_array = getPos player nearRoads _radius;
	_circle = [position player, _radius] call fn_create_area_marker;
	systemChat format ["All roads array size of: %1", count _all_roads_array];
	{
		_current_road = _x;
		_connected_roads_array = roadsConnectedTo _x;
		
			_fwd_road = _connected_roads_array select 1;
			_bwd_road = _connected_roads_array select 0;

					//Get current road paramters
                    _begPos_initial = getRoadInfo _current_road select 6;							//Initial road start point
                    _endPos_initial = getRoadInfo _current_road select 7;							//Initial road end point
                    _heading_initial = _begPos_initial getDir _endPos_initial;						//Initial road heading value

                    //Define forward road parameters
                    _fwd_return_values = [_fwd_road, _begPos_initial, _heading_initial] call fn_set_fwd_road_parameters;
                    _fwd_next_road_seg_endPos = _fwd_return_values select 0;
                    _fwd_center_pos_i_n = _fwd_return_values select 1;
                    _fwd_diff_heading_i_n = _fwd_return_values select 2;
                    _fwd_avg_heading_i_n = _fwd_return_values select 3;

                    //Call function to get setColor
                    _setColor = [_fwd_diff_heading_i_n] call fn_choose_color;

                    //Call function to create polyline marker
                    [_begPos_initial, _fwd_next_road_seg_endPos, _setColor] call fn_draw_polyline;

                    //Call function to create arrow marker to display average heading of road segments
                    //[_fwd_center_pos_i_n, _fwd_diff_heading_i_n, _fwd_avg_heading_i_n, _setColor] call fn_marker_arrow;

		iterator = iterator + 1;
	} forEach _all_roads_array;
	systemChat format ["Size of lines array is: %1", count _lines];
	
};

//Create array of possible road segments in format [begRoadPos, endRoadPos, type]
//Save the road getPos position to avoid having to retrieve the roads actual variable
//From these a random position between the beginning and end point can be defined where an outpost is generated
//A heading can be determined by using the beg and endPos
//The outpost generated is determined by the type of road

//Add all road segments up into their own arrays which is then placed in a larger array that is then copied to clipboard

////////////////////////////////////////////////////////////////////////////////////////////////////////
//MAIN//
////////////////////////////////////////////////////////////////////////////////////////////////////////
searched = false;
//[_initial_road] call fn_road;
[] call fnc_get_roads;