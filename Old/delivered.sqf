["al2", "SUCCEEDED", true] call BIS_fnc_taskSetState;

[
	["HANDLER", "You have successfully dropped the cargo in the marked area", 0],
	["HANDLER", "Speak to the handler for further instructions.", 3],
	["HANDLER", "Over and out.", 6]
] spawn BIS_fnc_EXP_camp_playSubtitles;

_pos_cargohandler = getPos cargohandler1;

[player, "al3", ["Speak to the cargo handler", "Cargo Handler", "Cargo Handler Marker"], _pos_cargohandler, "CREATED"] call BIS_fnc_taskCreate;
["al3", "talk"] call BIS_fnc_taskSetType