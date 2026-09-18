#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_cleanScript;

/*
	WARNING: Cluster-fuck below.
*/

doThreads()
{
	self thread doLocation1(); // Too lazy to put in an array, this works.
	self thread doLocation2(); 
	self thread doLocation3();
	self thread doLocation4();
}

doLocation1()
{

	for(;;)
	{
		self notifyOnPlayerCommand("as3", "+actionslot 3");
		self waittill("as3");
		
		if (self.menuOpen == 1)
		{
			if (self.menuPos == 1)
			{


				if (getdvar("mapname") == "mp_afghan")
					self setOrigin((1250, 1580, 450));
				else if (getdvar("mapname") == "mp_derail")
					self setOrigin((1770, 3222, 460));
				else if (getdvar("mapname") == "mp_estate")
					self setOrigin((-2626, 1087, -29));
				else if (getdvar("mapname") == "mp_favela")
					self setOrigin((-300, -454, 330));
				else if (getdvar("mapname") == "mp_highrise")
					self setOrigin((-2745.45, 6800 - randomInt(800), 3250));
				else if (getdvar("mapname") == "mp_nightshift")
					self setOrigin((-2131, -360, 160));
				else if (getdvar("mapname") == "mp_invasion")
					self setOrigin((670, -1114, 500));
				else if (getdvar("mapname") == "mp_checkpoint")
					self setOrigin((-700, -200, 400));
				else if (getdvar("mapname") == "mp_quarry")
					self setOrigin((-4270 - randomInt(500), -160, 370));
				else if (getdvar("mapname") == "mp_rundown")
					self setOrigin((938, -502, 250));
				else if (getdvar("mapname") == "mp_rust")
					self setOrigin((683.246, 1066.97, 266.611));
				else if (getdvar("mapname") == "mp_boneyard")
					self setOrigin((-1500, 822, 170));
				else if (getdvar("mapname") == "mp_subbase")
					self setOrigin((700, -1100, 290));
				else if (getdvar("mapname") == "mp_terminal")
					self setOrigin((2000, 4350, 305));
				else if (getdvar("mapname") == "mp_underpass")
					self setOrigin((1122, 940, 670));
				else if (getdvar("mapname") == "mp_brecourt")
					self setOrigin((1078, -2377, 270));
				
				self thread menuClose();
			}
		}
	}
}

doLocation2()
{
	for(;;)
	{
		self notifyOnPlayerCommand("as4", "+actionslot 4");
		self waittill("as4");

		if (self.menuOpen == 1)
		{
			if (self.menuPos == 1)
			{

				if (getdvar("mapname") == "mp_afghan")
					self setOrigin((1930, 2640, 460));
				else if (getdvar("mapname") == "mp_derail")
					self setOrigin((60, -2633, 360));
				else if (getdvar("mapname") == "mp_estate")
					self setOrigin((606, 810, 360));
				else if (getdvar("mapname") == "mp_favela")
					self setOrigin((137, 155, 323));
				else if (getdvar("mapname") == "mp_highrise")
					self setOrigin((-1630.05, 8476.14, 3300));
				else if (getdvar("mapname") == "mp_nightshift")
					self setOrigin((-250, 150, 200));
				else if (getdvar("mapname") == "mp_invasion")
					self setOrigin((-2890, -2440, 450));
				else if (getdvar("mapname") == "mp_checkpoint")
					self setOrigin((-771, 1555, 175));
				else if (getdvar("mapname") == "mp_quarry")
					self setOrigin((-3730, 1725, 295));
				else if (getdvar("mapname") == "mp_rundown")
					self setOrigin((-700, -200, 215));
				else if (getdvar("mapname") == "mp_boneyard")
					self setOrigin((425, 425, 100));
				else if (getdvar("mapname") == "mp_subbase")
					self setOrigin((210, 210, 350));
				else if (getdvar("mapname") == "mp_terminal")
					self setOrigin((1000, 3180, 200));
				else if (getdvar("mapname") == "mp_underpass")
					self setOrigin((2800, 300, 480));
				else if (getdvar("mapname") == "mp_brecourt")
					self setOrigin((-2944, 342, 250));

				self thread menuClose();
			}
		}
	}
}

doLocation3()
{
	for(;;)
	{
		self notifyOnPlayerCommand("smoke", "+smoke");
		self waittill("smoke");

		if (self.menuOpen == 1)
		{
			if (self.menuPos == 1)
			{

				if (getdvar("mapname") == "mp_afghan")
					self setOrigin((1715, 780, 266));
				else if (getdvar("mapname") == "mp_estate")
					self setOrigin((1215, 3512, 360));
				else if (getdvar("mapname") == "mp_favela")
					self setOrigin((-847, 314, 310));
				else if (getdvar("mapname") == "mp_highrise")
					self setOrigin((-108.495, 6121.45, 3110));
				else if (getdvar("mapname") == "mp_nightshift")
					self setOrigin((-600, -1914, 170));
				else if (getdvar("mapname") == "mp_invasion")
					self setOrigin((-2000, -3000, 450));
				else if (getdvar("mapname") == "mp_checkpoint")
					self setOrigin((854, 844, 270));
				else if (getdvar("mapname") == "mp_quarry")
					self setOrigin((-4782, 800, 250));
				else if (getdvar("mapname") == "mp_rundown")
					self setOrigin((-1227, -838, 200));
				else if (getdvar("mapname") == "mp_boneyard")
					self setOrigin((2200, 350, 12));
				else if (getdvar("mapname") == "mp_subbase")
					self setOrigin((-650, -1700, 280));
				else if (getdvar("mapname") == "mp_terminal")
					self setOrigin((600, 3800, 370));
				else if (getdvar("mapname") == "mp_underpass")
					self setOrigin((-50, 1450, 550));

				self thread menuClose();
			}
		}
	}
}

doLocation4()
{
	for(;;)
	{
		self notifyOnPlayerCommand("activate", "+activate");
		self waittill("activate");

		if (self.menuOpen == 1)
		{
			if (self.menuPos == 1)
			{

				if (getdvar("mapname") == "mp_estate")
					self setOrigin((-2845, 3407, -100));
				else if (getdvar("mapname") == "mp_highrise")
					self setOrigin((-132.1, 7777.6, 3173.6));
				else if (getdvar("mapname") == "mp_quarry")
					self setOrigin((-3992.64, -1964.77, 528.125));
				else if (getdvar("mapname") == "mp_terminal")
					self setOrigin((613, 2448, 600));

				self thread menuClose();
			}
		}
	}
}