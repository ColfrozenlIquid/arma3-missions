params ["_target", "_task_ID"];

_target_object = _this select 0;
_task_child = _this select 1;
_available_AI = _this select 2;

_position = position _target_object;
_random_position = nil;

created_group = [];

	fn_get_random_spawn = {
		_position = _this select 0;
		_random_heading = random 360;
		_random_position = _position getPos [40, _random_heading];
		_random_position
	};

	fn_create_Group = {
		_task_child = _this select 1;
		_target_object = _this select 2;
		_fire_team = ["C_man_1", "C_man_1"/*, "B_soldier_GL_F", "B_soldier_LAT_F"*/];
		_AI_group = [_this select 0, east, _fire_team] call BIS_fnc_spawnGroup;

		{created_group pushBack _x} forEach units _AI_group;
		systemChat format ["%1", created_group];

		{
			_x setVariable ["_task_child_ID", _task_child, true];
			_x setVariable ["_server_object", _target_object, true];
			systemChat format ["The Units assigned target variable is: %1", _x getVariable "_server_object"];
		} forEach units _AI_group;

		{
			_x addEventHandler ["Killed", {
				params ["_unit", "_killer"];
				_index = created_group find _unit;
				created_group deleteAt _index;
                if(count created_group == 0) then {
                    [nil, nil, nil, "stage_defend_success", _unit getVariable "_task_child_ID"] execVM "TreasureHunt\mission_TreasureHunt_stages.sqf";
					_server = _unit getVariable "_server_object";
					_server setVariable ["defended", true, true];
                };
			}];
		} forEach units _AI_group;
		
		_AI_group deleteGroupWhenEmpty true;
		_AI_group
	};

	fn_create_Waypoint = {
		_group = _this select 0;
		_position = _this select 1;
		_seek_destroy = _group addWaypoint [_position, 15];
		_seek_destroy setWaypointType "SAD";
	};

_random_pos = [_position] call fn_get_random_spawn;
_AI_group = [_random_pos, _task_child, _target_object] call fn_create_Group;
//[_random_pos] call fn_random_position_marker;
[_AI_group, _random_pos] call fn_create_Waypoint;