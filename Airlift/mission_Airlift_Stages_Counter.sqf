//params ["_target", "_caller", "_actionId","_stage"];
//_current_stage = _this select 3;
//_caller_unit = _this select 1;

switch (_current_stage) do 
{
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
			task_stage_1_counter = [_unassigned_units, "alc_1", ["Intercept the cargo", "Intercept Airlift Cargo", "Intercept Marker"], position cargo_container, "AUTOASSIGNED",1, true,"", true] call BIS_fnc_taskCreate;

			//Create trigger when picking up the cargo
			trigger_airlift_stage1_counter_success = createTrigger["EmptyDetector", position _caller_unit, true];
			trigger_airlift_stage1_counter_success setTriggerStatements["if(getSlingLoad vehicle _caller_unit == cargo_container)then{true};", "[nil, _caller_unit, nil, ""stage_2_counter""] execVM ""mission_Airlift_Stages_Counter.sqf"";", ""];

	};
	case "stage_2_counter" :{
		//Create Delivery Location Tsk
	};
};