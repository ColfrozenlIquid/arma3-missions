["al3", "SUCCEEDED", true] call BIS_fnc_taskSetState;

_condition_cargo = damage cargo1;

if(_condition_cargo < 0.5) then{
	[
	["HANDLER", "Great work delivering the cargo.", 0],
	["HANDLER", "Heres the reward for a job well done.", 3]
] spawn BIS_fnc_EXP_camp_playSubtitles;
} else{
	[
	["HANDLER", "Next time try not damaging the cargo.", 0],
	["HANDLER", "Heres the reward for the damaged goods.", 3]
] spawn BIS_fnc_EXP_camp_playSubtitles;
};

//Acts_TerminalOpen