private _countdown = [20, true] call BIS_fnc_countdown;
private _timeleft = [0] call BIS_fnc_countdown;

hint format ["%1", _timeleft];
sleep 5;

private _timeleft = [0] call BIS_fnc_countdown;
hint format ["%1", _timeleft];