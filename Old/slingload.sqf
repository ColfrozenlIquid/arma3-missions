["al1", "SUCCEEDED", true] call BIS_fnc_taskSetState;

[
	["HANDLER", "You have successfully airlifted the container.", 0],
	["HANDLER", "Now move the container to the location we marked on your map.", 3],
	["HANDLER", "Over and out.", 6]
] spawn BIS_fnc_EXP_camp_playSubtitles;
_pos_Dropoff = [14791.4,16483.3,0];


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

[60*10 , "#FF5500"] spawn LM_fnc_timeoutCountdown;

[player, "al2", ["Drop the container off at the marked location", "Dropoff", "Dropoff Marker"], _pos_Dropoff, "CREATED"] call BIS_fnc_taskCreate;
["al2", "land"] call BIS_fnc_taskSetType;

