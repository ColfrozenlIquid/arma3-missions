
//Get the ID of the current road segment
			//The next road should have the same ID incremented by 1
/*
			_current_road_ID = _current_road;
			_ID_string = str _current_road_ID;
			_ID_string =  [_ID_string, 0, -2] call BIS_fnc_trimString;
			//_ID_integer = parseNumber _ID_string;
			_ID_integer = _ID_string call BIS_fnc_parseNumber;
			_current_road_ID = _ID_integer;

			_next_road_ID = _current_road_ID + 1;
			_correct_road_index = nil;

			//Search the array of connected roads for the correct follow up road segment
			{
				_road_ID_string = str _x;
				_road_ID_string =  [_road_ID_string, 0, -2] call BIS_fnc_trimString;
				_road_ID_integer = _road_ID_string call BIS_fnc_parseNumber;
				_road_ID = _road_ID_integer;
				if (_road_ID == _next_road_ID) then {
					_correct_road_index = _forEachIndex;
					break;
				};
			} forEach _connected_roads_array;

			_next_road_segment = _connected_roads_array select _correct_road_index;

			//Check if next road segment follows the current roads ID
			//That means check if the ID of the next segment is the current ID plus 1
	/*
			_next_road_ID = _next_road;
			_ID_string = str _next_road_ID;
			_ID_string =  [_ID_string, 0, -2] call BIS_fnc_trimString;
			_ID_integer = parseNumber _ID_string;
			_next_road_ID = _ID_integer;
			_next_ID = _current_road_ID + 1;

			if !(_next_ID == _next_road_ID) then {
				systemChat "An error occured";
				systemChat format ["Current Road ID is: %1", _current_road_ID];
				systemChat format ["Next Road ID is: %1", _next_road_ID];
				systemChat format ["Required next Road ID is: %1", _next_ID];
				sleep 7;
			};


            ///////


            //while (new road not found) do {function find next road}
		for "_i" from 1 to 1000 do {
			//Initialise next road segment
			_next_road_segment = nil;

			//Check bridge parameter
			_is_bridge = false;
			found = false;

			//Initialise first road paramters
				_begPos_initial = getRoadInfo _current_road select 6;							//Initial road start point
				_endPos_initial = getRoadInfo _current_road select 7;							//Initial road end point
				_heading_initial = _begPos_initial getDir _endPos_initial;						//Initial road heading value

			//Check if the current road is a bridge
				if((getRoadInfo _current_road) select 8) then {
					_is_bridge = true;
				};

			//Define connected road segments
			_connected_roads_array = [];
			_connected_roads_array = roadsConnectedTo [_current_road, true];

			//Define current road type

			_current_road_type = (getRoadInfo _current_road) select 0;
				
				if ( true /*(count _connected_roads_array) > 2) then {
					_iter = 0;
					_available = [];
					{
						_type = getRoadInfo _x select 0;
						if (_current_road_type == _type) then {
							_available pushBack _x;
						};
					} forEach _connected_roads_array;
				
					_size = (count _available)-1;
					_selection = (_available select _size);
					_type_selection = getRoadInfo _selection select 0;

					if (_current_road isEqualTo _selection) then {
						systemChat format ["Selected road is equal to current road"];
					};

					if (_current_road_type isEqualTo _type_selection) then {
						_next_road_segment = _available select _size;
						//systemChat format ["Selected road type is equal to current road type"];
					} else {
						//systemChat format ["Selected road type is not equal to current road type"];
						break;
					};
				};

                
		

			//Get next road segment parameters
				_next_road_seg_begPos = getRoadInfo _next_road_segment select 6;							//Beginning pos of the next road segment
				_next_road_seg_endPos = getRoadInfo _next_road_segment select 7;							//End pos of the next road segmnent
				_next_road_seg_heading = _next_road_seg_begPos getDir _next_road_seg_endPos;				//Heading of the next road segment

				_center_pos_i_n = _begPos_initial vectorAdd _next_road_seg_endPos;
				_center_pos_i_n = [(_center_pos_i_n select 0)/2, (_center_pos_i_n select 1)/2, (_center_pos_i_n select 2)/2];		//Get the center position between initial beginning and next end
				_avg_heading_i_n = (_heading_initial + _next_road_seg_heading)/2;													//Get the average heading between the 2 road segments
				_diff_heading_i_n = abs(_heading_initial - _next_road_seg_heading);													//Get the difference in absolute heading of the road segments

			//Call function to get setColor
			_setColor = "ColorRed";
			_setColor = [_diff_heading_i_n] call fn_choose_color;

			//Call function to create polyline marker
			[_begPos_initial, _next_road_seg_endPos, _setColor] call fn_draw_polyline;

			//Call function to create arrow marker to display average heading of road segments
			[_center_pos_i_n, _diff_heading_i_n, _avg_heading_i_n, _setColor] call fn_marker_arrow;

			//Set current road to next road segment
			_current_road = _next_road_segment;

			//Increment iterator
			iterator = iterator + 1;


            /*
        //If connected roads array is of size 2 elements, start 2 loops in both directions
        if (_connected_roads_array_size == 2) then {

            _connected1 = _connected_roads_array select 0;      //Assume backward propagating
            _connected2 = _connected_roads_array select 1;      //Assume forward propagating

            //Define forward road parameters
            _fwd_return_values = [_connected2, _begPos_initial, _heading_initial] call fn_set_fwd_road_parameters;
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

            //Define backward road parameters
            _bwd_return_values = [_connected1, _endPos_initial, _heading_initial] call fn_set_bwd_road_parameters;
            _bwd_next_road_seg_begPos = _bwd_return_values select 0;
            _bwd_center_pos_i_n = _bwd_return_values select 1;
            _bwd_diff_heading_i_n = _bwd_return_values select 2;
            _bwd_avg_heading_i_n = _bwd_return_values select 3;

                //Call function to get setColor
                _setColor = [_bwd_diff_heading_i_n] call fn_choose_color;

                //Call function to create polyline marker
                [_endPos_initial, _bwd_next_road_seg_begPos, _setColor] call fn_draw_polyline;

                //Call function to create arrow marker to display average heading of road segments
                [_bwd_center_pos_i_n, _bwd_diff_heading_i_n, _bwd_avg_heading_i_n, _setColor] call fn_marker_arrow;
		};



		
		_roads = roadsConnectedTo _current_road;
            {
                _roadname = format ["road%1", _forEachIndex];
                _roadbeg = format ["roadbeg%1", _forEachIndex];
                _roadend = format ["roadend%1", _forEachIndex];
                [getPos _x, _roadname, 0] call fn_marker;
                [getRoadInfo _x select 6, _roadbeg, 0] call fn_marker;
                [getRoadInfo _x select 7, _roadend, 0] call fn_marker;
            } forEach _roads;
