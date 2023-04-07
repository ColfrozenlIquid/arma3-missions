params ["_target", "_caller", "_actionId", "_stage"];
_current_stage = _this select 3;
_caller_unit = _this select 1;
_current_target = _this select 0;
_trigger_unit = _this select 4;

//On-screen countdown timer
LM_fnc_timeoutCountdown = {

	params [
		["_time", 30, [0]],
		["_colour", "#FFFFFF", [""]]
	];
	private _timeout = time + _time;
	RscFiringDrillTime_done = false;
	1 cutRsc ["RscFiringDrillTime", "PLAIN"];
	while { time < _timeout } do
	{
		private _remainingTime = _timeout - time;
		private _timeFormat = [_remainingTime, "MM:SS.MS", true] call BIS_fnc_secondsToString;
		private _text = format ["<t align='left' color='%1'><img image='%2' />%3:%4<t size='0.8'>.%5</t>",
			_colour,
			"A3\Modules_F_Beta\data\FiringDrills\timer_ca",
			_timeFormat select 0,
			_timeFormat select 1,
			_timeFormat select 2
		];
		RscFiringDrillTime_current = parseText _text;
		sleep 0.01;
	};
	private _timeFormat = [0, "MM:SS.MS", true] call BIS_fnc_secondsToString;
	RscFiringDrillTime_current = parseText format ["<t align='left' color='%1'><img image='%2' />%3:%4<t size='0.8'>.%5</t>",
		_colour,
		"A3\Modules_F_Beta\data\FiringDrills\timer_ca",
		_timeFormat select 0,
		_timeFormat select 1,
		_timeFormat select 2];
	sleep 4;
	RscFiringDrillTime_done = true;
};

switch(_current_stage) do
{
	case "stage_1" : {

	//Stage 1: Mission Start

			//Set previous task to "COMPLETED"
			["al_0", "SUCCEEDED", true] call BIS_fnc_taskSetState;
			
		//Create mission stages

			//Set up mission task
			task_stage_1_1 = [group player, ["al_1", "al_0"], ["Airlift the cargo", "Airlift Cargo", "Cargo Marker"], position cargo_container, "AUTOASSIGNED",1, true,"", true] call BIS_fnc_taskCreate;
			task_stage_1_2 = [group player, ["al_1_2", "al_0"], ["Deliver the Cargo", "Deliver Cargo", "Delivery Location Marker"], position dropoff_location, "AUTOASSIGNED",1, true,"", true] call BIS_fnc_taskCreate;
			["al_1", "container"] call BIS_fnc_taskSetType;
			["al_1_2", "land"] call BIS_fnc_taskSetType;

		//Trigger stage 0 completion subtitles
			//Subtitles in the format [speaker, text, timing] spawn BIS_fnc_EXP_camp_playSubtitles
			if((getPos _caller_unit) distance (getPos interaction_laptop1) < 10) then {
				[
					["HANDLER", "Airlift the cargo container.", 0],
					["HANDLER", "You have 5 minutes before the cargo position is transmitted to all players.", 5]
				] spawn BIS_fnc_EXP_camp_playSubtitles;
			};

		//Create countdown timer
		[60*5, "#FF5500"] spawn LM_fnc_timeoutCountdown;
	};

	case "stage_1_counter" : {
		//Start counter Mission
		//Create a list of all units that are not part of task 2
			//These units will then be assigned the counter task to stop the cargo delivery
			_all_players = call BIS_fnc_listPlayers;
			_unassigned_units = [];
			{
				_unit_tasks = _x call BIS_fnc_tasksUnit;
				if !("al_1" in _unit_tasks) then {
					_unassigned_units pushBack _x; 
				}
			} forEach _all_players;

			//Set up mission task
			task_stage_1_counter = [_unassigned_units, ["alc_1", "al_0"], ["Intercept the cargo", "Intercept Airlift Cargo", "Intercept Marker"], position cargo_container, "AUTOASSIGNED",1, true,"", true] call BIS_fnc_taskCreate;

			//Create trigger when picking up the cargo
			trigger_airlift_stage1_counter_success = createTrigger["EmptyDetector", position _caller_unit, true];
			trigger_airlift_stage1_counter_success setTriggerStatements["if(getSlingLoad vehicle _unassigned_units == cargo_container)then{true};", "[nil, nil, nil, ""stage_2_counter"", thisList] execVM ""mission_Airlift_Stages.sqf"";", ""];
	};

	case "stage_2_counter" : {
		//Assign delivery task
			task_stage_2_counter = [_trigger_unit, ["alc_2", "al_0"], ["Deliver the cargo", "Deliver Cargo", "Delivery Location Marker"], position dropoff_location, "AUTOASSIGNED",1, true,"", true] call BIS_fnc_taskCreate;
	};

	case "stage_3" : {};

	case "stage_success" : {

	//Stage 4 : Mission completion

			_cargo_location = getPos cargo_container;
			_dropoff_location = getPos dropoff_location;

			//Set previous task to "COMPLETED"
			if ((_cargo_location distance _dropoff_location) < 20) then {
				["al_2", "SUCCEEDED", true] call BIS_fnc_taskSetState;
				["al_3", "SUCCEEDED", true] call BIS_fnc_taskSetState;
				[
					["HANDLER", "Great work delivering the cargo.", 0],
					["HANDLER", "Heres the reward for a job well done.", 3]
				] spawn BIS_fnc_EXP_camp_playSubtitles;
			} else {
				[
					["HANDLER", "There is no cargo in the delivery area.", 0],
					["HANDLER", "Make sure your cargo is within 20 meters of the delivery location.", 3]
				] spawn BIS_fnc_EXP_camp_playSubtitles;
			};
		sleep 15;

		//Delete mission tasks
		["al_0", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 2;
		["al_0", true, false] call BIS_fnc_deleteTask;

		//Delete all objects
		{deleteVehicle _x} forEach spawn_location_assets;
		{deleteVehicle _x} forEach delivery_location_assets;
	};

	case "stage_fail" : {
		//Delete mission tasks
		["al_0", "FAILED", true] call BIS_fnc_taskSetState;
		sleep 10;
		["al_0", true, false] call BIS_fnc_deleteTask;

		//Delete all objects
		{deleteVehicle _x} forEach spawn_location_assets;
		{deleteVehicle _x} forEach delivery_location_assets;
	};

	default {
		hint "default case";
		sleep 2;
		hint "";
	};
};