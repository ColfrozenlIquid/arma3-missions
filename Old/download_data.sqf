/*
	Mission Satellite Array
*/
/*
//Function to call mission creation from list of available missionStart
//Generate the first mission location including entities and interactible mission object_position
//Mark the mission on the map for all players to see

//Stage 1.)		A compound is created that conatains various antennas and satellite dishes used to connect to satellites
				These satellites control a formation of combat drones that loiter around the island
//Stage 2.)		Upon clearing the compund of enemies the players discover a laptop and servers which they can interact with and download data from
				This download process could take some time and cant be interrupted.
//Stage 3.)		When the player manages to successfully download the coordinates their map is updated to display an array of locations where communication dishes
				are set up to enable communication with the drones
				These outposts are generated from a random list of possible locations. These locations contain a server and are guarded
//Stage 4.) 	Players must attempt to connect to all 3 satellite dish arrays to get the maximum mission rewards.
				Their currently connected satellite dish arrays are tracked for user friendliness
//Stage 5.)		Connecting to any of the satellite arrays will reveal the position of the drones on the players map
				Shooting down the drones will result in completing the mission
//Stage 6.)		A helicopter airdrop will 
*/

sleep 0.5;
_actions = actionIDs laptop;
_addAction_ID = _actions select 0;
laptop removeAction _addAction_ID;

[
	["UNKNOWN", "Connecting to satellite array system.", 0],
	["UNKNOWN", "Extracting location data", 3],
	["UNKNOWN", "Locations of satellite arrays have been revealed on your map.", 6] 
] spawn BIS_fnc_EXP_camp_playSubtitles;
	sleep 3;

//Create mission map marker
_mapMarker_Satellite_Area = createMarker["satellite_array_area", [15144.2,18263.3]];
	_mapMarker_Satellite_Area setMarkerShapeLocal "ELLIPSE";
	_mapMarker_Satellite_Area setMarkerColorLocal "ColorRed";
	_mapMarker_Satellite_Area setMarkerSizeLocal[50, 50];
	_mapMarker_Satellite_Area setMarkerBrushLocal "BDiagonal";

_mapMarker_Satellite_Cross = createMarker["satellite_array_cross", [15144.2,18263.3]];
	_mapMarker_Satellite_Cross setMarkerShapeLocal "ICON";
	_mapMarker_Satellite_Cross setMarkerColorLocal "ColorRed";
	_mapMarker_Satellite_Cross setMarkerSizeLocal[1, 1];
	_mapMarker_Satellite_Cross setMarkerTypeLocal "mil_destroy_noShadow";
	_mapMarker_Satellite_Cross setMarkerText "Satellite Array";

//Select possible location for satellite diag_resetShapes
//Build a function that selects a set of locations to spawn the satellite dishes at
//_array_markers_satellite = [[array_set1],[array_set2],[array_set3],[array_set4]];



//Generate objects from mission
_markerposition = getPos bluemarker_1;
_outpost = [_markerposition] execVM "satellite_dish_array.sqf";

[player, "t1", ["Move to the given marker", "Move", "Movemarker"], [14753.6,16729.6,0], "CREATED"] call BIS_fnc_taskCreate;
["t1", "download"] call BIS_fnc_taskSetType
