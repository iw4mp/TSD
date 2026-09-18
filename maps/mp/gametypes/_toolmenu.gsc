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
			self.toolMenuOpen = 0;
			self freezeControls( false );
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

	for ( ;; )
	{
		if ( self.toolMenuOpen == 0 )
		{
			menuTitle setText( "" );
			menuLeftPreview setText( "" );
			menuRightPreview setText( "" );
			menuHelp setText( "" );
			menuClose setText( "" );
		}
		else
		{
			left = self.toolMenuPos - 1;
			if ( left < 1 )
				left = 9;

			right = self.toolMenuPos + 1;
			if ( right > 9 )
				right = 1;

			menuTitle setText( "^6" + toolMenuCategoryName( self.toolMenuPos ) + "^7 (coming soon)" );
			menuLeftPreview setText( "^3" + toolMenuCategoryName( left ) );
			menuRightPreview setText( "^3" + toolMenuCategoryName( right ) );
			menuHelp setText( "^3[{+moveleft}]/[{+moveright}] ^2to switch category" );
			menuClose setText( "^2Press ^3[{+actionslot 1}] ^2to close the menu" );
		}

		wait 0.05;
	}
}
