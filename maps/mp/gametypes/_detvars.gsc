#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

doThreads() // Trying to cut back on threads...
{
	for(;;)
	{

	// Crosshair Size.
		if ( getDvar( "chs" ) == "0" )
		{
			self setClientDvar( "perk_weapSpreadMultiplier", "1" ); 	// Commando
			self.noScopes = "Commando";
		}
		else if ( getDvar( "chs" ) == "1" )
		{
			self setClientDvar( "perk_weapSpreadMultiplier", "0.65" ); 	// Steady Aim
			self.noScopes = "Steady Aim";
		}
		else if ( getDvar( "chs" ) == "2" )
		{
			self setClientDvar( "perk_weapSpreadMultiplier", "0.001" ); 	// Straight Noscopes
			self.noScopes = "Straight";
		}

	// Slow Motion
		if ( getDvar( "timescale" ) == "1" )
			self.slowmoScale = "Off";
		else if ( getDvar( "timescale" ) == "0.75" )
			self.slowmoScale = "75 Percent";
		else if ( getDvar( "timescale" ) == "0.5" )
			self.slowmoScale = "50 Percent";
		else if ( getDvar( "timescale" ) == "0.25" )
			self.slowmoScale = "25 Percent";

	// Bot Dvars
		if ( getDvar( "testClients_doMove" ) == "0" )
			self.bMove = "false";
		else if ( getDvar( "testClients_doMove" ) == "1" )
			self.bMove = "true";

		if ( getDvar( "testClients_doAttack" ) == "0" )
			self.bShoot = "false";
		else if ( getDvar( "testClients_doAttack" ) == "1" )
			self.bShoot = "true";
		
		if ( getDvar( "testClients_doReload" ) == "0" )
			self.bReload = "false";
		else if ( getDvar( "testClients_doReload" ) == "1" )
			self.bReload = "true";
		
		if ( getDvar( "testClients_doLock" ) == "0" )
			self.bLock = "false";
		else if ( getDvar( "testClients_doLock" ) == "1" )
			self.bLock = "true";
		
		if ( getDvar( "testClients_doRespawn" ) == "0" )
			self.bResp = "false";
		else if ( getDvar( "testClients_doRespawn" ) == "1" )
			self.bResp = "true";

	// Explosive Bullets
		if ( getDvar( "expb" ) == "0" )
			self.kos = "Off";
		else if ( getDvar( "expb" ) == "1" )
			self.kos = "Close";
		else if ( getDvar( "expb" ) == "2" )
			self.kos = "Everywhere";

	// Damage Type
		if ( getDvar( "dmgt" ) == "0" )
			self.damageLevelStatus = "Snipers Only";
		else if ( getDvar( "dmgt" ) == "1" )
			self.damageLevelStatus = "Snipers and Hitmarkers";
		else if ( getDvar( "dmgt" ) == "2" )
			self.damageLevelStatus = "Normal Damage";

		wait 0.2;
	}
}