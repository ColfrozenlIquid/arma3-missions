//Set up a mission controller to controll the amount and type of missions on the server

//Start up the script and check if there are any running missions on the server
//If there are no missions on the server generate a new mission every 5 minutes
//Split the missions into types as to avoid creating 2 of the same missions

//Tasks that are done return a call to the mission_controller
//This removes the "finished" task from the current tasks array to make space for new tasks
//Otherwise if the task is left unattended for an extended period of time the mission controller makes a call to the active task to "fail" the task
//This allows the task to "garbage collect" properly

//The mission controller should also manage the amount of AI that every mission creates
//This is managed by referencing pre existing max_tas_AI values and comparing them to what the server will currently allow
//If the server is crowded then the mission spawner cant sawn its desired AI count and will be overriden by the mission_controller

//The mission controller will also be able to asses the amount of players on the server at the time of mission creation and mission completion
//to find an average threat of doing the mission
//This allows for dynamically assigning a reward multiplier to the mission base reward

	//Read a list of all possible tasks that can be active on the server
	_all_possible_Tasks = [["TreasureHunt", "hc_0"]];

	//, ["Satellite_Array", "sa_0"], ["Airlift", "al_0"], 

	//Create an array of all currently active tasks on the server
	//If new tasks are created they are added to the end of the array
	//["task_Type", "task_ID", "task_starting_time", "task_alloted_time"]
	current_Tasks = [];
	available_Tasks = [];

	//Task Workflow

	//Init:					available_Tasks = [["Task1", "Task1ID"], ["Task2", "Task2ID"], ["Task3", "Task3ID"]]
	//						current_Tasks = []


	//Create Task:			available_Tasks = [["Task1", "Task1ID"], ["Task3", "Task3ID"]]
	//						current_Tasks =  ["Task2", "Task2ID"]

	//Delete Task 2:		available_Tasks = [["Task1", "Task1ID"], ["Task2", "Task2ID"], ["Task3", "Task3ID"]]
	//						current_Tasks = []

	fn_remove_task = {
		_task_ID = _this select 0;
		//Remove the task from the current_Tasks array
		{
			if(_task_ID in _x) then {
				current_Tasks deleteAt _x;
				[nil, nil, nil, "stage_fail"] execVM "mission_Airlift_Stages.sqf";
			}
		} forEach current_Tasks;
	};

	fn_new_Task_Spawner = {
		//Call a function to start a new mission
		_mission_type = _this select 0;
		[] execVM format ["\%1\mission_%1_init.sqf", _mission_type];
	};

/////////////////
//DEFINES
////////////////

max_Tasks = 5;
max_AI = 100;

//Two arrays of tasks are created that move avaiable and currently assigned tasks between each other to avoid the need of having to compare 3 lists
available_Tasks_Type_List = [];
active_Tasks_Type_List = [];

name_Task_List = [];		//Contains an array of tasks of smae type that can be spawned. This allows for spawning a variety of tasks of the same overarching type

////////////////
//MAIN//
///////////////

_taskName = Nil;
_startTime = Nil;
_endTime = Nil;

current_task = [_taskName, _startTime, _endTime];
current_Tasks pushBack current_task;

	fn_AI_count = {
		_allAI = [];
					{
						if !(isPlayer _x) then
						{
							_allAI pushBack _x;
						};
					} forEach playableUnits;
		_count = count _allAI;
		_count		
	};

	//Main function loop
	while {isServer} do {

		//Check if any tasks are past their alloted time
		{
			_end = _x select 2;
			if(_end > serverTime) then {
				[_x select 0] call fn_remove_task;
				systemChat format ["Task %1 removed.", _x];
			}
			 else {
				systemChat "No task found to be removed";
			 };
		} forEach current_Tasks;

		//Check size of current tasks array
		//If size smaller than the maximum call a new mission spawner function
		//Create available_Tasks array to be used to spawn new mission
		if(count active_Tasks_Type_List < max_Tasks) then {
			//Check if mission type is already active
			if(count(available_Tasks_Type_List) > 0) then {
				_task_type = selectRandom available_Tasks_Type_List;
				_query = format ["%1_Task_List.sqf", _task_type];
				name_Task_List = object getVariable _query;
				_task_List = call compile preprocessFileLineNumbers _query;
				_selected_task = selectRandom _Task_List;
			};
		systemChat format ["Task %1 chosen of type %2.", _selected_task, _task_type];
		};

		//Monitor the amount of AI on the server at the given time
		AI_count = [] call fn_AI_count;
		_available_AI = max_AI - AI_count;

		//Spawn a new mission, receive a randomly chosen task
		_task_Name = format ["mission_%1_init.sqf", _taskName];
		[_available_AI, _selected_task] execVM _task_Name;

	sleep 10;
	
	};