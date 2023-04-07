params ["_server_obj_position"];
object_position = _this select 0;
object_position_grid = mapGridPosition object_position;
satellite_name = "SA-" + object_position_grid;
//hint format["%1", object_position_grid];

[
	[satellite_name, "Connecting to satellite array system.", 0],
	[satellite_name, "Extracting location data", 3],
	[satellite_name, "Locations of satellite arrays have been revealed on your map.", 6] 
] spawn BIS_fnc_EXP_camp_playSubtitles;
	sleep 3;
/*
_group_drone1 = createGroup[sideEnemy, true];

_waypoint1 = _group_drone1 addWaypoint[[15135.5,16967.7,0], -1];
_waypoint1 setWaypointCombatMode "RED";
_waypoint1 setWaypointType "SAD";
_group_drone1 setCurrentWaypoint[_group_drone1, 1];
[_group_drone1, 1] setWaypointBehaviour "COMBAT";


_drone_object = _drone select 0;
_trigger1 = createTrigger["EmptyDetector", getPos player, true];
if(!alive zamak1) then{
	hint "truck destroyed";
};
//_trigger1 setTriggerStatements[!alive zamak1, hint "truck destroyed", hint "truck not destroyed"];
*/

//_drone = [[15193.3,16826.6,182.63], 90, "O_UAV_02_dynamicLoadout_F", sideEnemy] call BIS_fnc_spawnVehicle;
drone1 = createVehicle["O_UAV_02_dynamicLoadout_F", [15121.7,16776.4,136.453], [], 0, "FLY"];
createVehicleCrew drone1;
//hint format["%1", _drone];
code1 = "!alive drone;";
code2 = "['t2', 'SUCCEEDED', true] call BIS_fnc_taskSetState;";
code3 = "hint 'drone not destroyed';";
trigger1 = createTrigger["EmptyDetector", position player, true];
trigger1 setTriggerInterval 3;
trigger1 setTriggerStatements[
	code1,
	code2,
	code3
];
["t1", "SUCCEEDED", true] call BIS_fnc_taskSetState;
[player, "t2", ["Destroy the enemy UAV", "Destroy", "Destroymarker"], [drone1, false], "CREATED"] call BIS_fnc_taskCreate;





/*
comment "Exported from Arsenal by Luke Skywalker [AJ]";

comment "[!] UNIT MUST BE LOCAL [!]";
if (!local this) exitWith {};

comment "Remove existing items";
removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

comment "Add weapons";
this addWeapon "arifle_Velko_lxWS";
this addPrimaryWeaponItem "saber_light_lxWS";
this addPrimaryWeaponItem "optic_r1_high_lxWS";
this addPrimaryWeaponItem "35Rnd_556x45_Velko_reload_tracer_red_lxWS";
this addWeapon "launch_MRAWS_green_F";
this addSecondaryWeaponItem "MRAWS_HEAT_F";

comment "Add containers";
this forceAddUniform "U_O_R_Gorka_01_F";
this addVest "V_PlateCarrier2_rgr_noflag_F";
this addBackpack "B_AssaultPack_rgr";

comment "Add items to containers";
this addItemToUniform "FirstAidKit";
for "_i" from 1 to 3 do {this addItemToUniform "35Rnd_556x45_Velko_reload_tracer_red_lxWS";};
for "_i" from 1 to 2 do {this addItemToBackpack "MRAWS_HEAT_F";};
this addHeadgear "H_HelmetAggressor_cover_F";
this addGoggles "G_Aviator";

comment "Add items";
this linkItem "ItemMap";
this linkItem "ItemCompass";
this linkItem "ItemWatch";
this linkItem "ItemRadio";

comment "Set identity";
[this,"WhiteHead_04","male12eng"] call BIS_fnc_setIdentity;
*/