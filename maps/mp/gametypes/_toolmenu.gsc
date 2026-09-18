#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// New, from-scratch in-game overlay menu for TSD's Steam port. TSD's own
// original menu (_text.gsc/_menuCont.gsc/_cleanScript.gsc) is left
// untouched for now - this is a fresh, minimal skeleton so we can confirm
// the basic open/close + HUD text mechanism works on Steam before porting
// any of TSD's actual page content (teleports, weapons, killstreaks, etc.)
// over one at a time.

init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		player thread initToolMenu();
	}
}

initToolMenu()
{
	self.toolMenuOpen = 0;
	self.toolMenuPos = 1;

	self thread createToolMenuText();
	self thread watchToolMenuToggle();
	self thread watchToolMenuLeft();
	self thread watchToolMenuRight();
	self thread watchToolMenuResetOnSpawn();

	// Teleports category (position 1) - ported from TSD's _locations.gsc.
	self thread watchToolMenuTeleport1();
	self thread watchToolMenuTeleport2();
	self thread watchToolMenuTeleport3();
	self thread watchToolMenuTeleport4();
}

closeToolMenu()
{
	self.toolMenuOpen = 0;
	self freezeControls( false );
}

watchToolMenuToggle()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuToggle", "+actionslot 1" );
		self waittill( "toolMenuToggle" );

		if ( !isAlive( self ) )
			continue;

		if ( self.toolMenuOpen == 0 )
		{
			self.toolMenuOpen = 1;
			self.toolMenuPos = 1;
			self freezeControls( true );
		}
		else
		{
			self closeToolMenu();
		}
	}
}

watchToolMenuLeft()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuLeft", "+moveleft" );
		self waittill( "toolMenuLeft" );

		if ( self.toolMenuOpen == 0 )
			continue;

		self.toolMenuPos--;
		if ( self.toolMenuPos < 1 )
			self.toolMenuPos = 9;
	}
}

watchToolMenuRight()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuRight", "+moveright" );
		self waittill( "toolMenuRight" );

		if ( self.toolMenuOpen == 0 )
			continue;

		self.toolMenuPos++;
		if ( self.toolMenuPos > 9 )
			self.toolMenuPos = 1;
	}
}

// Closing while the menu is open (e.g. dying with it open) would otherwise
// leave freezeControls stuck true / the overlay stuck visible on respawn.
watchToolMenuResetOnSpawn()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self.toolMenuOpen = 0;
		self.toolMenuPos = 1;
		self freezeControls( false );
	}
}

// Teleports category content, ported from TSD's _locations.gsc - same
// per-map hardcoded coordinates, same 4 bind keys (actionslot 3/4, smoke,
// activate), gated on our own toolMenuOpen/toolMenuPos state instead of
// TSD's self.menuOpen/self.menuPos.
watchToolMenuTeleport1()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuTp1", "+actionslot 3" );
		self waittill( "toolMenuTp1" );

		if ( self.toolMenuOpen != 1 || self.toolMenuPos != 1 )
			continue;

		mapname = getdvar( "mapname" );

		if ( mapname == "mp_afghan" )
			self setOrigin( ( 1250, 1580, 450 ) );
		else if ( mapname == "mp_derail" )
			self setOrigin( ( 1770, 3222, 460 ) );
		else if ( mapname == "mp_estate" )
			self setOrigin( ( -2626, 1087, -29 ) );
		else if ( mapname == "mp_favela" )
			self setOrigin( ( -300, -454, 330 ) );
		else if ( mapname == "mp_highrise" )
			self setOrigin( ( -2745.45, 6800 - randomInt( 800 ), 3250 ) );
		else if ( mapname == "mp_nightshift" )
			self setOrigin( ( -2131, -360, 160 ) );
		else if ( mapname == "mp_invasion" )
			self setOrigin( ( 670, -1114, 500 ) );
		else if ( mapname == "mp_checkpoint" )
			self setOrigin( ( -700, -200, 400 ) );
		else if ( mapname == "mp_quarry" )
			self setOrigin( ( -4270 - randomInt( 500 ), -160, 370 ) );
		else if ( mapname == "mp_rundown" )
			self setOrigin( ( 938, -502, 250 ) );
		else if ( mapname == "mp_rust" )
			self setOrigin( ( 683.246, 1066.97, 266.611 ) );
		else if ( mapname == "mp_boneyard" )
			self setOrigin( ( -1500, 822, 170 ) );
		else if ( mapname == "mp_subbase" )
			self setOrigin( ( 700, -1100, 290 ) );
		else if ( mapname == "mp_terminal" )
			self setOrigin( ( 2000, 4350, 305 ) );
		else if ( mapname == "mp_underpass" )
			self setOrigin( ( 1122, 940, 670 ) );
		else if ( mapname == "mp_brecourt" )
			self setOrigin( ( 1078, -2377, 270 ) );
		else
			continue;

		self closeToolMenu();
	}
}

watchToolMenuTeleport2()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuTp2", "+actionslot 4" );
		self waittill( "toolMenuTp2" );

		if ( self.toolMenuOpen != 1 || self.toolMenuPos != 1 )
			continue;

		mapname = getdvar( "mapname" );

		if ( mapname == "mp_afghan" )
			self setOrigin( ( 1930, 2640, 460 ) );
		else if ( mapname == "mp_derail" )
			self setOrigin( ( 60, -2633, 360 ) );
		else if ( mapname == "mp_estate" )
			self setOrigin( ( 606, 810, 360 ) );
		else if ( mapname == "mp_favela" )
			self setOrigin( ( 137, 155, 323 ) );
		else if ( mapname == "mp_highrise" )
			self setOrigin( ( -1630.05, 8476.14, 3300 ) );
		else if ( mapname == "mp_nightshift" )
			self setOrigin( ( -250, 150, 200 ) );
		else if ( mapname == "mp_invasion" )
			self setOrigin( ( -2890, -2440, 450 ) );
		else if ( mapname == "mp_checkpoint" )
			self setOrigin( ( -771, 1555, 175 ) );
		else if ( mapname == "mp_quarry" )
			self setOrigin( ( -3730, 1725, 295 ) );
		else if ( mapname == "mp_rundown" )
			self setOrigin( ( -700, -200, 215 ) );
		else if ( mapname == "mp_boneyard" )
			self setOrigin( ( 425, 425, 100 ) );
		else if ( mapname == "mp_subbase" )
			self setOrigin( ( 210, 210, 350 ) );
		else if ( mapname == "mp_terminal" )
			self setOrigin( ( 1000, 3180, 200 ) );
		else if ( mapname == "mp_underpass" )
			self setOrigin( ( 2800, 300, 480 ) );
		else if ( mapname == "mp_brecourt" )
			self setOrigin( ( -2944, 342, 250 ) );
		else
			continue;

		self closeToolMenu();
	}
}

watchToolMenuTeleport3()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuTp3", "+smoke" );
		self waittill( "toolMenuTp3" );

		if ( self.toolMenuOpen != 1 || self.toolMenuPos != 1 )
			continue;

		mapname = getdvar( "mapname" );

		if ( mapname == "mp_afghan" )
			self setOrigin( ( 1715, 780, 266 ) );
		else if ( mapname == "mp_estate" )
			self setOrigin( ( 1215, 3512, 360 ) );
		else if ( mapname == "mp_favela" )
			self setOrigin( ( -847, 314, 310 ) );
		else if ( mapname == "mp_highrise" )
			self setOrigin( ( -108.495, 6121.45, 3110 ) );
		else if ( mapname == "mp_nightshift" )
			self setOrigin( ( -600, -1914, 170 ) );
		else if ( mapname == "mp_invasion" )
			self setOrigin( ( -2000, -3000, 450 ) );
		else if ( mapname == "mp_checkpoint" )
			self setOrigin( ( 854, 844, 270 ) );
		else if ( mapname == "mp_quarry" )
			self setOrigin( ( -4782, 800, 250 ) );
		else if ( mapname == "mp_rundown" )
			self setOrigin( ( -1227, -838, 200 ) );
		else if ( mapname == "mp_boneyard" )
			self setOrigin( ( 2200, 350, 12 ) );
		else if ( mapname == "mp_subbase" )
			self setOrigin( ( -650, -1700, 280 ) );
		else if ( mapname == "mp_terminal" )
			self setOrigin( ( 600, 3800, 370 ) );
		else if ( mapname == "mp_underpass" )
			self setOrigin( ( -50, 1450, 550 ) );
		else
			continue;

		self closeToolMenu();
	}
}

watchToolMenuTeleport4()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuTp4", "+activate" );
		self waittill( "toolMenuTp4" );

		if ( self.toolMenuOpen != 1 || self.toolMenuPos != 1 )
			continue;

		mapname = getdvar( "mapname" );

		if ( mapname == "mp_estate" )
			self setOrigin( ( -2845, 3407, -100 ) );
		else if ( mapname == "mp_highrise" )
			self setOrigin( ( -132.1, 7777.6, 3173.6 ) );
		else if ( mapname == "mp_quarry" )
			self setOrigin( ( -3992.64, -1964.77, 528.125 ) );
		else if ( mapname == "mp_terminal" )
			self setOrigin( ( 613, 2448, 600 ) );
		else
			continue;

		self closeToolMenu();
	}
}

toolMenuCategoryName( pos )
{
	names = [];
	names[1] = "Teleports";
	names[2] = "Equipment";
	names[3] = "Weapons";
	names[4] = "Killstreaks";
	names[5] = "Character Preferences";
	names[6] = "Match Settings";
	names[7] = "Change Map";
	names[8] = "Bot Settings";
	names[9] = "Kick Players";

	return names[pos];
}

// Per-map Teleports hint text, ported from TSD's _text.gsc (menuPos==1
// block) - lines only shown when a bind actually has a coordinate for the
// current map in watchToolMenuTeleport1..4 above.
toolMenuTeleportHint( line )
{
	mapname = getdvar( "mapname" );

	if ( mapname == "mp_afghan" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Top of the wing";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Top of the rocks";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above Bombsite A";
	}
	else if ( mapname == "mp_derail" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Ledge near Bombsite A";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Above NovaStar";
	}
	else if ( mapname == "mp_estate" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Above TF141 Spawn";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Bed above Bombsite A";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above fishing hut";
		if ( line == 3 ) return "^2[{+activate}] ^5Above power grid";
	}
	else if ( mapname == "mp_favela" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Infront of Campers Shack";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Above Soccer courts";
		if ( line == 2 ) return "^2[{+smoke}] ^5Next to water tank";
	}
	else if ( mapname == "mp_highrise" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Top of Highrise";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Top of Crane";
		if ( line == 2 ) return "^2[{+smoke}] ^5Platform above Bombsite B";
		if ( line == 3 ) return "^2[{+activate}] ^5Climb Spot of Crane";
	}
	else if ( mapname == "mp_nightshift" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Building near Bombsite B";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Next to water tank";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above alley-way";
	}
	else if ( mapname == "mp_invasion" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Next to American Flag";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Above OpFor spawn";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above the Coffee Shop";
	}
	else if ( mapname == "mp_checkpoint" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Platform near Bombsite A";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5The top of the truck";
		if ( line == 2 ) return "^2[{+smoke}] ^5Next to Kashmir Hotel";
	}
	else if ( mapname == "mp_quarry" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Platform near Bombsite A";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Above A080 Tank";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above Transportadora";
		if ( line == 3 ) return "^2[{+activate}] ^5Top of Quarry";
	}
	else if ( mapname == "mp_rundown" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Above Barateiro";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Camping Shack";
		if ( line == 2 ) return "^2[{+smoke}] ^5House above the river";
	}
	else if ( mapname == "mp_rust" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Top of Rust";
	}
	else if ( mapname == "mp_boneyard" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Above TF141 Spawn";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5On top of plane shell";
		if ( line == 2 ) return "^2[{+smoke}] ^5Upstairs in the office";
	}
	else if ( mapname == "mp_subbase" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Communications Room";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Roof near Bombsite A";
		if ( line == 2 ) return "^2[{+smoke}] ^5Above packing area";
	}
	else if ( mapname == "mp_terminal" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Above Bombsite A";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Wing of plane";
		if ( line == 2 ) return "^2[{+smoke}] ^5Top of plane";
		if ( line == 3 ) return "^2[{+activate}] ^5Top of wing";
	}
	else if ( mapname == "mp_underpass" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Circular platform";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Roof near Bombsite B";
		if ( line == 2 ) return "^2[{+smoke}] ^5Roof near Bombsite A";
	}
	else if ( mapname == "mp_brecourt" )
	{
		if ( line == 0 ) return "^2[{+actionslot 3}] ^5Top of roofless house";
		if ( line == 1 ) return "^2[{+actionslot 4}] ^5Top of helicopter";
	}

	return "";
}

createToolMenuText()
{
	self endon( "disconnect" );

	menuTitle = self createFontString( "default", 2 );
	menuTitle setPoint( "CENTER", "CENTER", 0, -150 );

	menuLeftPreview = self createFontString( "default", 1.5 );
	menuLeftPreview setPoint( "CENTER", "CENTER", -200, -150 );

	menuRightPreview = self createFontString( "default", 1.5 );
	menuRightPreview setPoint( "CENTER", "CENTER", 200, -150 );

	menuHelp = self createFontString( "default", 1.5 );
	menuHelp setPoint( "CENTER", "CENTER", 0, 140 );

	menuClose = self createFontString( "default", 2 );
	menuClose setPoint( "CENTER", "CENTER", 0, 160 );

	tpLine0 = self createFontString( "default", 1.5 );
	tpLine0 setPoint( "CENTER", "CENTER", 0, -100 );
	tpLine1 = self createFontString( "default", 1.5 );
	tpLine1 setPoint( "CENTER", "CENTER", 0, -80 );
	tpLine2 = self createFontString( "default", 1.5 );
	tpLine2 setPoint( "CENTER", "CENTER", 0, -60 );
	tpLine3 = self createFontString( "default", 1.5 );
	tpLine3 setPoint( "CENTER", "CENTER", 0, -40 );

	for ( ;; )
	{
		if ( self.toolMenuOpen == 0 )
		{
			menuTitle setText( "" );
			menuLeftPreview setText( "" );
			menuRightPreview setText( "" );
			menuHelp setText( "" );
			menuClose setText( "" );
			tpLine0 setText( "" );
			tpLine1 setText( "" );
			tpLine2 setText( "" );
			tpLine3 setText( "" );
		}
		else
		{
			left = self.toolMenuPos - 1;
			if ( left < 1 )
				left = 9;

			right = self.toolMenuPos + 1;
			if ( right > 9 )
				right = 1;

			menuLeftPreview setText( "^3" + toolMenuCategoryName( left ) );
			menuRightPreview setText( "^3" + toolMenuCategoryName( right ) );
			menuHelp setText( "^3[{+moveleft}]/[{+moveright}] ^2to switch category" );
			menuClose setText( "^2Press ^3[{+actionslot 1}] ^2to close the menu" );

			if ( self.toolMenuPos == 1 )
			{
				menuTitle setText( "^6Teleports" );
				tpLine0 setText( toolMenuTeleportHint( 0 ) );
				tpLine1 setText( toolMenuTeleportHint( 1 ) );
				tpLine2 setText( toolMenuTeleportHint( 2 ) );
				tpLine3 setText( toolMenuTeleportHint( 3 ) );
			}
			else
			{
				menuTitle setText( "^6" + toolMenuCategoryName( self.toolMenuPos ) + "^7 (coming soon)" );
				tpLine0 setText( "" );
				tpLine1 setText( "" );
				tpLine2 setText( "" );
				tpLine3 setText( "" );
			}
		}

		wait 0.05;
	}
}
