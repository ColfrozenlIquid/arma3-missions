sleep 0.5;
_actions = actionIDs screen;
_addAction_ID = _actions select 0;
screen removeAction _addAction_ID;
_pos_cargo = getPos cargo1;

[
	["HANDLER", "Airlift the cargo container", 0]
] spawn BIS_fnc_EXP_camp_playSubtitles;

[player, "al1", ["Airlift the container", "Airlift", "Airlift Marker"], _pos_cargo, "CREATED"] call BIS_fnc_taskCreate;
["al1", "container"] call BIS_fnc_taskSetType
