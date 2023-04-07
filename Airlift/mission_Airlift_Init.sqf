	//Create the mission start off location objects
	//Array of object used at the start of the mission when the mission is generated

	_mission_spawn_objects = [
		["B_Slingload_01_Cargo_F",[1.83301,-0.923828,0],360,1,0,[5.997e-006,-5.58239e-006],"cargo_container","",true,false], 
		["B_Truck_01_flatbed_F",[-1.97949,-0.191406,0],0.000124039,1,0,[-0.256674,0.0642917],"","",true,false], 
		["Land_PortableDesk_01_sand_F",[1.83105,2.91016,0],0.000705535,1,0,[-0.00459478,0.000269167],"desk1","",true,false], 
		["Land_Laptop_unfolded_F",[1.83984,3.05078,-0.0019722],0.0204929,1,0,[0.00710905,-0.00220789],"interaction_laptop1","",true,false]
	];
	
	//Create the mission delivery location objects
	//Array of object used at the end of the mission and is generated when the mission begins
	_mission_delivery_objects = [
	["Land_JumpTarget_F",[-3.25684,3.69727,0],0,1,0,[0,0],"dropoff_location","",true,false], 
	["B_T_Truck_01_flatbed_F",[5.07129,-2.28906,-1.80467],223.343,1,0,[-0.265869,0.0828837],"","",true,false], 
	["Land_Laptop_unfolded_F",[-0.662109,-7.13477,-0.00197792],347.086,1,0,[0.0625104,-0.0921632],"interaction_laptop2","",true,false], 
	["Land_PortableDesk_01_sand_F",[-0.639648,-7.27344,-5.91278e-005],347.071,1,0,[0.0545374,-0.0931104],"desk2","",true,false], 
	["Land_HBarrier_5_F",[6.31543,-4.49023,0],133.937,1,0,[0,-0],"","",true,false], 
	["Land_HBarrier_3_F",[-1.12402,-9.00977,-0.00151443],0,1,0,[0.0765974,-0.0766167],"","",true,false], 
	["Land_HBarrier_5_F",[10.3916,-0.273438,0],133.937,1,0,[0,-0],"","",true,false]
];

	//An array of where the mission is spawned initially
	_possible_mission_spawn_locations_array = 
	[[14637.5,16759.5,0]];

	//An array of where the mission delivery point is genertaed when the mission is started
	_possible_mission_delivery_locations_array = 
	[[14609.1,16729,0]];

	//A script to choose which delivery location is best suited for the chosen spawn location
	//Selects a random mission inital spawn location and delivery location 
	_spawn_location = selectRandom _possible_mission_spawn_locations_array;
	_delivery_location = selectRandom _possible_mission_delivery_locations_array;
	_delivery_distance = _spawn_location distance _delivery_location;

	//Calculate the payout from the mission
	//Set an appropriate payout per kilometer here
	_payout_per_kilometer = 1000;
	_payout = round(_delivery_distance/1000);

	//Stage 0: Mission Setup
	_mission_stage_0 = {
		//Set up mission assets
		spawn_location_assets = [_spawn_location, 0, _mission_spawn_objects, 0] call BIS_fnc_ObjectsMapper;
		interaction_laptop1 attachTo [desk1, [0,0,0.6]];
		interaction_laptop1 addAction["Download Delivery Data", {[_this select 0, _this select 1, _this select 2, "stage_1"] execVM "mission_Airlift_Stages.sqf"},nil,1.5,true,false,"","true",3,false,"",""];

		delivery_location_assets = [_delivery_location, 0, _mission_delivery_objects, 0] call BIS_fnc_ObjectsMapper;
		interaction_laptop2 attachTo [desk2, [0,0,0.6]];
		interaction_laptop2 addAction["Deliver Cargo",{[_this select 0, _this select 1, _this select 2, "stage_success"] execVM "mission_Airlift_Stages.sqf"},nil,1.5,true,false,"","true",3,false,"",""];
		
		//Set up mission task
		task_stage_0 = [true, "al_0", ["Start Cargo Delivery Mission", "Delivery Mission", "Delivery Mission Marker"], getPos interaction_laptop1, "CREATED",-1, true,"", true] call BIS_fnc_taskCreate;
		["al_0", "download"] call BIS_fnc_taskSetType;

		//Define trigger for failing the task
		//Spawn an on screen countdown to show the remaining mission time
		trigger_airlift_stage0_fail = createTrigger ["EmptyDetector", position cargo_container, true];
			triggerCondition0 = "if(damage cargo_container > 0.95)then{true};";
			triggerActivation0 = "[nil, nil, nil, ""stage_fail""] execVM ""mission_Airlift_Stages.sqf""";
			triggerDeactivation0 = "";
			trigger_airlift_stage0_fail setTriggerStatements [triggerCondition0, triggerActivation0, triggerDeactivation0];

		//Create a trigger that starts the counter objective mission in mission_Airlift_Stages_Counter.sqf
		_safe_time = 60*5;
		trigger_airlift_counter_start = createTrigger ["EmptyDetector", position cargo_container, true];
			triggerCondition1 = "{true};";
			triggerActivation1 = "[nil, nil, nil, ""stage_1_counter""] execVM ""mission_Airlift_Stages.sqf""";
			triggerDeactivation1 = "";
			trigger_airlift_counter_start setTriggerStatements [triggerCondition1, triggerActivation1, triggerDeactivation1];
			trigger_airlift_counter_start setTriggerTimeout [_safe_time, _safe_time, _safe_time, false];
	};

call _mission_stage_0;