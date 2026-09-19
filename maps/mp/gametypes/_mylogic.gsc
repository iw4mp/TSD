#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_weapons;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_callbacksetup;

doThreads()
{
	self thread botLockOn();
	self thread dropMyWeapon();
	self thread newBulletReg();
	self thread toggleFinalStand();
	// self thread EditorInput(); // EditorInput() is undefined anywhere in
	// this codebase (not stock, not TSD-defined) - calling it would fail
	// this whole file to compile. Commented out rather than guessed at.

	self thread debuggingThread();
}

debuggingThread()
{
	for(;;)
	{
//		self iPrintLnBold( primaryName );
		wait 1;
	}
}

toggleFinalStand()
{
	for(;;)
	{
		self notifyOnPlayerCommand( "fs", "+fs" );
		self waittill( "fs" );
		

		if (self.finalStandOnCooldown == false)
		{
			self thread startFinalStandCooldown();
			self.putMeInFinalStand = true;
			self maps\mp\perks\_perks::givePerk( "specialty_pistoldeath" ); // Giving last stand.
			self thread [[level.callbackPlayerDamage]]( self, self, 100, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "torso_upper", 0 );
		}
	}
}

startFinalStandCooldown()
{
	self.finalStandOnCooldown = true;
	wait 5;
	self.finalStandOnCooldown = false;
}

dropMyWeapon()
{
	for(;;)
	{
		self notifyOnPlayerCommand( "drop", "+drop" );
		self waittill( "drop" );

		self.item delete();
		self.item = self dropItem( self getCurrentWeapon() ); // So simple... O.o
	}
}

clearPlayerWeapons()
{
	self.item delete();
	self iPrintLnBold( "Deleted dropped weapons." );
}

newBulletReg()
{
	self endon( "disconnect" ); 

	for(;;)
	{
		
		self waittill( "weapon_fired" );
		self.fired = true;

		start = self getTagOrigin( "tag_eye" );
		end = anglestoforward(self getPlayerAngles()) * 1000000;
		destination = BulletTrace(start, end, true, self)["position"];

		aimAt = undefined;
	
		foreach( player in level.players)
		{ 
			aimAt = player;

			if( (player == self) || (level.teamBased && self.pers["team"] == player.pers["team"]) || ( !isAlive(player) ) ) 
				continue;
		
			if( !bulletTracePassed( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), false, self ) ) // Not using through walls. :3
				continue;

 			if( isDefined( aimAt ) )
			{

				if ( getDvar( "dmgt" ) == "0" || getDvar( "dmgt" ) == "1" )
				{
					sWeapon = self getCurrentWeapon();
	
					if ( isSubStr(sWeapon, "cheytac_") || isSubStr(sWeapon, "barrett_") || isSubStr(sWeapon, "wa2000_") || isSubStr(sWeapon, "m21_"))
					{
						if ( getDvar( "expb" ) == "1" )
						{
							if (Distance( destination, player.origin ) <= 175)
								aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "torso_upper", 0 );
	
						}
						else if ( getDvar( "expb" ) == "2" )
						{
								aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "torso_upper", 0 );
						}
					}
				}
			}
		}
	}
}

botLockOn()
{
	self endon( "disconnect" ); 

	for(;;)
	{

		if ( getDvar( "testClients_doLock" ) == "1" )
		{
			aimAt = undefined; 
	
			foreach(player in level.players)
			{
				if( (player == self) || (level.teamBased && self.pers["team"] == player.pers["team"]) || ( !isAlive(player) ) ) 
					continue;
			
				if( !bulletTracePassed( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), false, self ) ) // Comment this and the next line to use it through walls
					continue;
		
				if( isDefined(aimAt) )
				{
		
					if( closer( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) ) 
						aimAt = player; 
				}
				else
					aimAt = player; 
			}

			if (self.pers["isBot"] == true)
				self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );

		}
		wait 0.001;
	}
}