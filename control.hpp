class dialogTest {

	idd = 1234;

	class controls {

class baseFrame: RscFrame
{
	idc = 1800;
	x = 0.298906 * safezoneW + safezoneX;
	y = 0.236 * safezoneH + safezoneY;
	w = 0.402187 * safezoneW;
	h = 0.528 * safezoneH;
	colorBackground[] = {1,1,1,1};
};
class listBox: RscListbox
{
	idc = 1500;
	x = 0.309219 * safezoneW + safezoneX;
	y = 0.258 * safezoneH + safezoneY;
	w = 0.04125 * safezoneW;
	h = 0.231 * safezoneH;
};
class Button1: RscButton
{
	idc = 1600;
	text = "Test"; //--- ToDo: Localize;
	x = 0.365937 * safezoneW + safezoneX;
	y = 0.258 * safezoneH + safezoneY;
	w = 0.04125 * safezoneW;
	h = 0.055 * safezoneH;
};
class RscControlsGroup_2300: RscControlsGroup
{
	idc = 2300;
	x = 53.79 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
	y = 17.09 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
	w = 4 * GUI_GRID_CENTER_W;
	h = 2.5 * GUI_GRID_CENTER_H;
	class Controls
	{
	};
};
class slider: RscSlider
{
	idc = 1900;
	x = 1.5 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
	y = 12.5 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
	w = 11.5 * GUI_GRID_CENTER_W;
	h = 1 * GUI_GRID_CENTER_H;
};
class button2: RscButton
{
	idc = 1601;
	text = "test2"; //--- ToDo: Localize;
	x = 12 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
	y = 1.5 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
	w = 4 * GUI_GRID_CENTER_W;
	h = 2.5 * GUI_GRID_CENTER_H;
};

	};
};