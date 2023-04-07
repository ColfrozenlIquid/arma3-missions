["al2", "FAILED", true] call BIS_fnc_taskSetState;

[
	["HANDLER", "You destroyed the cargo.", 0],
	["HANDLER", "Dont expect any reward.", 3]
] spawn BIS_fnc_EXP_camp_playSubtitles;