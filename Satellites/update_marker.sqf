params = ["_target", "_markers"];

_target = _this select 0;
_associated_markers = _target getVariable "_associated_markers";

{
	_x setMarkerColor "ColorGreen";
} forEach _associated_markers;