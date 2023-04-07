private ["_markerposition"];
_position = _this select 0;

_obj_array = 
[
	["Land_PortableServer_01_sand_F",[1.1377,0.419922,0.74799],308.296,1,0,[-0.00938144,0.0163783],"","",true,false], 
	["Land_PortableGenerator_01_sand_F",[0.908203,0.134766,-1.90735e-006],308.292,1,0,[0.00049673,-0.000409678],"","",true,false], 
	["SatelliteAntenna_01_Sand_F",[-0.699219,-0.164063,-0.00387955],272.784,1,0,[0.0155837,0.00598289],"","",true,false], 
	["SatelliteAntenna_01_Sand_F",[0.582031,-0.683594,-0.00387955],215.112,1,0,[0.0156541,0.00587841],"","",true,false], 
	["Land_BagFence_Round_F",[-0.0634766,2.00781,-0.00130081],175.103,1,0,[0,-0],"","",true,false], 
	["Land_BagFence_Round_F",[0.222656,-2.24023,-0.00130081],355.921,1,0,[0,0],"","",true,false], 
	["OmniDirectionalAntenna_01_black_F",[-0.116211,0.572266,0.00882912],346.538,1,0,[0.000901572,0.004306],"","",true,false], 
	["Land_BagFence_Long_F",[-2.28125,-0.242188,-0.000999451],88.7062,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Long_F",[2.55273,0.0136719,-0.000999451],88.7062,1,0,[0,0],"","",true,false]
];

_array_obj = [_position, 0 , _obj_array, 0] call BIS_fnc_ObjectsMapper;
{_x enableSimulation false;} forEach _array_obj;
_server_obj = _array_obj select 0;
_server_obj_position = mapGridPosition _server_obj;
//_server_obj addAction["Download Location Data", "next_satellite.sqf" , [_server_obj_position]];
_text = "Download Data";
_icon = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa";
[	_server_obj,
 	_text,
	_icon, 
	_icon, 
	"_this distance _target < 3", 
	"_caller distance _target < 3", 
	{}, {}, {}, {},
	[],
	20] call BIS_fnc_holdActionAdd;

_array_obj