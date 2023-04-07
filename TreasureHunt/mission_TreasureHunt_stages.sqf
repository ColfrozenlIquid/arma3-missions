params ["_target", "_caller", "_actionId", "_stage", "_task_ID", "_location"];

_current_target = _this select 0;
_caller_unit = _this select 1;
_action_ID = _this select 2;
_current_stage = _this select 3;
_task_child = _this select 4;
_location = _this select 5;		//This should be the center of the town that spawns the mission

//hint format ["_current_target is: %1, _caller_unit is: %2, _action_ID is: %3, _current_stage is: %4, _task_child is: %5", _current_target, _caller_unit, _action_ID, _current_stage, _task_child];

/***********************************************************/
/**
	TASK LAYOUT

	DEFINES:	
		(-?) Potential Task
		(["task_ID"]) Task Identifier

	STRUCTURE:
	["hc_0"]	Hidden Cache Mission 
		["hc_1"]	Find Hidden Cache Data
				["hc_21"]	Download Hidden Cache Location Data #1
					["hc_21d"]	-? Defend Location Server #1
				["hc_22"]	Download Hidden Cache Location Data #2
					["hc_22d"]	-? Defend Location Server #2
				["hc_23"]	Download Hidden Cache Location Data #3
					["hc_22d"]	-? Defend Location Server #3
		["hc_2"]	Find Hidden Cache

 */
/********************************************************** */

switch (_current_stage) do {

	case "stage_0" :{
		//Set up the parent Task
		_task_description = "There is a hidden cache located somewhere in this town. Complete the mission sub-tasks to more accuratly show the cache position.";
		_task_title = "Hidden Cache Mission";
		_task_marker = "Hidden Cache Marker";
		task_stage_0 = [true, "hc_0", [_task_description, _task_title, _task_marker], objNull, "CREATED", -1, true, "whiteboard", true] call BIS_fnc_taskCreate;

		//Set up the initial child task
		_task_description = "There is a hidden cache located somewhere in this town. Complete the mission sub-tasks to more accuratly show the cache position.";
		_task_title = "Hidden Cache Mission";
		_task_marker = "Hidden Cache Marker";
		task_stage_1 = [true, ["hc_1", "hc_0"], [_task_description, _task_title, _task_marker], random_Town_Location, "CREATED",-1, true, "search", true] call BIS_fnc_taskCreate;
	};

	case "stage_1" : {

		//Complete the task that contained the correct server as "SUCCEEDED" and the rest of the tasks as "FAILED"
		_task_children = task_parent_ID call BIS_fnc_taskChildren;
		[_task_child, "SUCCEEDED", true] call BIS_fnc_taskSetState;
		{
			if !(_x call BIS_fnc_taskCompleted) then {
				[_x, "FAILED", false] call BIS_fnc_taskSetState;
			};
		} forEach _task_children;

		//Delete the large town marker in green
		deleteMarker town_marker;

		//Randomise center position of marker
		_random_heading = random 360;
		_random_position = cargo_building_position getPos [20, _random_heading];

		_accurate_Marker = createMarker ["accurate_marker", _random_position];
			_this = _accurate_Marker;
			_this setMarkerSize [50,50];
			_this setMarkerShape "ELLIPSE";
			_this setMarkerBrush "SolidBorder";
			_this setMarkerColor "ColorBlack";

		//Move the parent task location
		[task_parent_ID, _random_position] call BIS_fnc_taskSetDestination;
			
		[
					["SERVER", "You found the right server.", 0],
					["SERVER", "The location of the cargo has been more accurately revealed on your map.", 5]
				] spawn BIS_fnc_EXP_camp_playSubtitles;
	};

	case "stage_defend" : {
		_task_description = "A fireteam has been dispatched to intercept you from completing the download. Eliminate them to continue the download.";
		_task_title = "Defeat Approaching Fireteam";
		_task_marker = "Defeat Approaching Fireteam";
		task_sub_child = format ["%1d", _task_child];
		[true, [task_sub_child, _task_child], [_task_description, _task_title, _task_marker], position _current_target, "CREATED", -1, true, "defend", true] call BIS_fnc_taskCreate;
	};

	case "stage_defend_success" : {
		task_sub_child = format ["%1d", _task_child];
		[task_sub_child, "SUCCEEDED", true] call BIS_fnc_taskSetState;
	};

	case "stage_wrong_server" : {
		[_task_child, "FAILED", true] call BIS_fnc_taskSetState;
	};

	case "stage_2" : {
		_task_children = "hc_1" call BIS_fnc_taskChildren;
		{
			[_x, "SUCCEEDED", true] call BIS_fnc_taskSetState;
		} forEach _task_children;

		_task_description = "The location of the hidden supplies has been revealed on your map. Go retrieve them.";
		_task_title = "Hidden Cache Location";
		_task_marker = "Hidden Cache Location";
		task_stage_2 = [player, ["hc_2", "hc_0"], [_task_description, _task_title, _task_marker], _location, "CREATED", -1, true, "box", true] call BIS_fnc_taskCreate;
		deleteMarker random_Town_Name;
	};

	case "stage_completed" : {
		["hc_0", "SUCCEEDED", true] call BIS_fnc_taskSetState;
		deleteVehicle crateTrigger;
	};
};