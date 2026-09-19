#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;
#include maps\mp\gametypes\_cleanscript;

defaultSnipingSet()
{
	self TakeAllWeapons();
	self giveWeapon( "cheytac_fmj_mp", 8, false );
	self giveWeapon( "beretta_tactical_mp" );
	wait 0.1;
	self switchToWeapon( "cheytac_fmj_mp" );

	self _clearPerks();							// Duh 1337 iSnipe set. Lulz.
	self maps\mp\perks\_perks::givePerk( "throwingknife_mp" ); 		// Throwing Knife
	self maps\mp\perks\_perks::givePerk( "specialty_fastreload" ); 		// Sleight Of Hand
	self maps\mp\perks\_perks::givePerk( "specialty_quickdraw" ); 		// Sleight Of Hand Pro
	self maps\mp\perks\_perks::givePerk( "specialty_lightweight" ); 	// Lightweight
	self maps\mp\perks\_perks::givePerk( "specialty_fastsprintrecovery" ); 	// Lightweight Pro
	self maps\mp\perks\_perks::givePerk( "throwingknife_mp" ); 		// Throwing Knife

	self SetOffhandSecondaryClass( "concussion" );
	self giveWeapon( "concussion_grenade_mp" );

	self thread refillAmmo();

	self thread menuClose();
}

refillAmmo()
{
	weaponList = self GetWeaponsListAll();
	
	if ( self _hasPerk( "specialty_tacticalinsertion" ) && self getAmmoCount( "flare_mp" ) < 1 )
		self _setPerk( "specialty_tacticalinsertion");	
	
	foreach ( weaponName in weaponList )
	{
		if ( isSubStr( weaponName, "grenade" ) )
		{
			if ( self getAmmoCount( weaponName ) >= 1 )
				continue;
		} 
		
		self giveMaxAmmo( weaponName );
	}
}

acceptLoadout()
{

	if (self.pers["secAttach"] == "none")
	{
		self thread menuClose();
	}
	else
	{
		self thread menuClose();
		self.pers["created"] = true;
	
		self.weap1 = "none";
		self.weap2 = "none";
	
		if (self.pers["priAttach"] == "mp")
			self.weap1 = self.pers["pri"] + "_" + self.pers["priAttach"];
		else
			self.weap1 = self.pers["pri"] + "_" + self.pers["priAttach"] + "_mp";
	
		if (self.pers["secAttach"] == "mp")
			self.weap2 = self.pers["sec"] + "_" + self.pers["secAttach"];
		else
			self.weap2 = self.pers["sec"] + "_" + self.pers["secAttach"] + "_mp";
	
		if (self.weap1 == self.weap2)
			self iPrintLnBold( "^1Warning! The two weapons you picked were the same!" );

		weapList = self GetWeaponsListAll();
		weapListPrim = self GetWeaponsListPrimaries();

		self takeWeapon( self getCurrentWeapon() );

		self.omaCustomChange = true;

		while(self getCurrentWeapon() == "none")
		{
			if (weapListPrim.size)
				self switchToWeapon(weapListPrim[RandomInt(weapListPrim.size)]);
			else
				self switchToWeapon(weapList[RandomInt(weapList.size)]);
			wait .05; 
		}

		self takeWeapon( self getCurrentWeapon() );
		self giveWeapon( self.weap1, 5 + randomInt(3), false); // Only sexy camo's.
	
		if (self.pers["secAttach"] == "oma")
		{
			self maps\mp\perks\_perks::givePerk( "specialty_onemanarmy" ); // One Man Army
			self maps\mp\perks\_perks::givePerk( "specialty_omaquickchange" ); // One Man Army Pro
			self giveWeapon( "onemanarmy_mp" );
		}
	
		if (self.pers["secAttach"] == "akimbo")
			self giveWeapon( self.weap2, 5 + randomInt(3), true );
		else if (self.pers["secAttach"] != "akimbo" || self.pers["secAttach"] != "oma")
			self giveWeapon( self.weap2 );

		wait 0.1;
	
		self switchToWeapon( self.weap1 );

		self.secIsPrimary = false;
		self.secType = "none";
	}
}

handleMapNames()
{
	self.mapCurPos = 0;

	self.NormMap1 = [];
	self.NormMap1[0] = "mp_afghan";
	self.NormMap1[1] = "mp_derail";
	self.NormMap1[2] = "mp_estate";
	self.NormMap1[3] = "mp_favela";
	self.NormMap1[4] = "mp_highrise";
	self.NormMap1[5] = "mp_invasion";
	self.NormMap1[6] = "mp_checkpoint";
	self.NormMap1[7] = "mp_quarry";

	self.NormMap2 = [];
	self.NormMap2[0] = "mp_rundown";
	self.NormMap2[1] = "mp_rust";
	self.NormMap2[2] = "mp_boneyard";
	self.NormMap2[3] = "mp_nightshift";
	self.NormMap2[4] = "mp_subbase";
	self.NormMap2[5] = "mp_terminal";
	self.NormMap2[6] = "mp_underpass";
	self.NormMap2[7] = "mp_brecourt";

	self.DLCMap = [];
	self.DLCMap[0] = "mp_complex";
	self.DLCMap[1] = "mp_crash";
	self.DLCMap[2] = "mp_overgrown";
	self.DLCMap[3] = "mp_compact";
	self.DLCMap[4] = "mp_storm";
	self.DLCMap[5] = "mp_abandon";
	self.DLCMap[6] = "mp_fuel2";
	self.DLCMap[7] = "mp_strike";
	self.DLCMap[8] = "mp_trailerpark";
	self.DLCMap[9] = "mp_vacant";
}


efficiencyPlusPlus() // LOOOOOOOL
{
	self.sniAttach = [];
	self.sniAttach[0] = "mp";
	self.sniAttach[1] = "silencer";
	self.sniAttach[2] = "acog";
	self.sniAttach[3] = "fmj";
	self.sniAttach[4] = "heartbeat";
	self.sniAttach[5] = "thermal";
	self.sniAttach[6] = "xmags";
	wait 0.1;
	self.mPisAttach = [];
	self.mPisAttach[0] = "mp";
	self.mPisAttach[1] = "reflex";
	self.mPisAttach[2] = "silencer";
	self.mPisAttach[3] = "fmj";
	self.mPisAttach[4] = "akimbo";
	self.mPisAttach[5] = "eotech";
	self.mPisAttach[6] = "xmags";
	wait 0.1;
	self.assAttach = [];
	self.assAttach[0] = "mp";
	self.assAttach[1] = "gl";
	self.assAttach[2] = "reflex";
	self.assAttach[3] = "silencer";
	self.assAttach[4] = "acog";
	self.assAttach[5] = "fmj";
	self.assAttach[6] = "shotgun";
	self.assAttach[7] = "eotech";
	self.assAttach[8] = "heartbeat";
	self.assAttach[9] = "thermal";
	self.assAttach[10] = "xmags";
	wait 0.1;
	self.smgAttach = [];
	self.smgAttach[0] = "mp";
	self.smgAttach[1] = "rof";
	self.smgAttach[2] = "reflex";
	self.smgAttach[3] = "silencer";
	self.smgAttach[4] = "acog";
	self.smgAttach[5] = "fmj";
	self.smgAttach[6] = "akimbo";
	self.smgAttach[7] = "eotech";
	self.smgAttach[8] = "termal";
	self.smgAttach[9] = "xmags";
	wait 0.1;
	self.sgAttach = [];
	self.sgAttach[0] = "mp";
	self.sgAttach[1] = "reflex";
	self.sgAttach[2] = "silencer";
	self.sgAttach[3] = "grip";
	self.sgAttach[4] = "fmj";
	self.sgAttach[5] = "eotech";
	self.sgAttach[6] = "xmags";
	wait 0.1;
	self.lmgAttach = [];
	self.lmgAttach[0] = "mp";
	self.lmgAttach[1] = "grip";
	self.lmgAttach[2] = "reflex";
	self.lmgAttach[3] = "silencer";
	self.lmgAttach[4] = "acog";
	self.lmgAttach[5] = "fmj";
	self.lmgAttach[6] = "eotech";
	self.lmgAttach[7] = "heartbeat";
	self.lmgAttach[8] = "thermal";
	self.lmgAttach[9] = "xmags";
}

handleSelection()
{
	self thread efficiencyPlusPlus();

	for(;;)
	{
		self thread handleMapNames();
		self notifyOnPlayerCommand( "gostand", "+gostand" );
		self waittill( "gostand" );
		
		if (self.menuOpen == 1)
		{
			// menuPos == 1 uses notifyOnPlayerCommand.

			if (self.menuPos == 2)
			{
				equ = [];
				equ[0] = "frag_grenade_mp";
				equ[1] = "semtex_mp";
				equ[2] = "throwingknife_mp";
				equ[3] = "specialty_tacticalinsertion";
				equ[4] = "specialty_blastshield";
				equ[5] = "claymore_mp";
				equ[6] = "c4_mp";
				equ[7] = "lightstick_mp";

				if (self.curPos == 9)
					self maps\mp\gametypes\_class::giveSameLoadout( self.pers["class"], "mala" );
				else
					self maps\mp\gametypes\_class::giveSameLoadout( self.pers["class"], equ[self.curPos - 1] );

				self thread menuClose();

			}
			else if (self.menuPos == 3)
			{
				if (self.weaponStatus == 1)
				{
					if (self.curPos == 1)
					{
						if (self.secIsPrimary == false)
						{
							self.pers["pri"] = "cheytac";
							self.weaponStatus = 2;
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "m4";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "mp5k";
								self.weaponStatus = 14;
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "cheytac";
								self.weaponStatus = 2;
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "sa80";
								self.weaponStatus = 15;
							}
							else if (self.secTeir == 5)
							{
								self.pers["sec"] = "riotshield";
								self.pers["secAttach"] = "mp";
								self thread acceptLoadout();	
							}
						}
					}
					else if (self.curPos == 2)
					{
						if (self.secIsPrimary == false)
						{
							self.pers["pri"] = "barrett";
							self.weaponStatus = 2;
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "famas";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "ump45";
								self.weaponStatus = 14;
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "barrett";
								self.weaponStatus = 2;
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "mg4";
								self.weaponStatus = 15;
							}
						}
					}
					else if (self.curPos == 3)
					{
						if (self.secIsPrimary == false)
						{
							self.pers["pri"] = "wa2000";
							self.weaponStatus = 2;
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "scar";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "kriss";
								self.weaponStatus = 14;
							} 
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "wa2000";
								self.weaponStatus = 2;
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "rpd";
								self.weaponStatus = 15;
							}
						}
					} 
					else if (self.curPos == 4)
					{
						if (self.secIsPrimary == false)
						{
							self.pers["pri"] = "m21";
							self.weaponStatus = 2;
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "tavor";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "p90";
								self.weaponStatus = 14;
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "m21";
								self.weaponStatus = 2;
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "mg4";
								self.weaponStatus = 15;
							}
						}
					}
					else if (self.curPos == 5)
					{
						if (self.secIsPrimary == false)
						{
							self thread defaultSnipingSet();
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "fal";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "uzi";
								self.weaponStatus = 14;
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "aug";
								self.weaponStatus = 15;
							}
						}
					}
					else if (self.curPos == 6)
					{
						if (self.secIsPrimary == false)
						{
							self thread acceptLoadout(); // Give last loaded shit... O.o ?
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "m16";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "m240";
								self.weaponStatus = 15;
							}
						}
					}
					else if (self.curPos == 7)
					{
						if (self.secIsPrimary == false)
						{
							if (self.pers["created"] == true)
							{
								if (self.pers["giveOnSpawn"] == "false")
									self.pers["giveOnSpawn"] = "true";
								else
									self.pers["giveOnSpawn"] = "false";
							}
							else
							{
								self thread menuClose();
							}
						}
						else
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "masada";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "";
							}
						}

					}
					else if (self.curPos == 8)
					{
						if (self.secIsPrimary == true)
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "fn2000";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "";
							}
						}
					}
					else if (self.curPos == 9)
					{
						if (self.secIsPrimary == true)
						{
							if (self.secTeir == 1)
							{
								self.pers["sec"] = "ak47";
								self.weaponStatus = 13;
							}
							else if (self.secTeir == 2)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 3)
							{
								self.pers["sec"] = "";
							}
							else if (self.secTeir == 4)
							{
								self.pers["sec"] = "";
							}
						}
					}

					self.curPos = 1;
				}
				else if (self.weaponStatus == 2)
				{
					if (self.secIsPrimary == false)
					{
						self.pers["priAttach"] = self.sniAttach[self.curPos - 1];
						self.weaponStatus = 3;
					}
					else
					{
						self.pers["secAttach"] = self.sniAttach[self.curPos - 1];
						self thread acceptLoadout();
					}
				}
				else if (self.weaponStatus == 3)
				{
					if (self.curPos == 1) 		// Machine Pistols
						self.weaponStatus = 11;
					else if (self.curPos == 2)  	// Handguns
						self.weaponStatus = 4;
					else if (self.curPos == 3)  	// Shotgun
						self.weaponStatus = 7;
					else if (self.curPos == 4)  	// Launchers
						self.weaponStatus = 10;
					else if (self.curPos == 5)   	// One man army
					{
						self.pers["secAttach"] = "oma";
						self thread acceptLoadout();
					}
					else if (self.curPos == 6)	// Second Primary
					{
						self.secIsPrimary = true;
						self.weaponStatus = 1;
					}
				}
				else if (self.weaponStatus == 4)
				{
					if (self.curPos == 1)
					{
						self.pers["sec"] = "usp";
						self.weaponStatus = 5;
					}
					else if (self.curPos == 2)
					{
						self.pers["sec"] = "coltanaconda";
						self.weaponStatus = 6;
					}
					else if (self.curPos == 3)
					{
						self.pers["sec"] = "beretta";
						self.weaponStatus = 5;
					}
					else if (self.curPos == 4)
					{
						self.pers["sec"] = "deserteagle";
						self.weaponStatus = 6;
					}
					else if (self.curPos == 5)
					{
						self.weaponStatus = 3;
					}
					self.curPos = 1;

				}
				else if (self.weaponStatus == 5)
				{
					if (self.curPos == 1)
						self.pers["secAttach"] = "mp";
					else if (self.curPos == 2)
						self.pers["secAttach"] = "fmj";
					else if (self.curPos == 3)
						self.pers["secAttach"] = "silencer";
					else if (self.curPos == 4)
						self.pers["secAttach"] = "akimbo";
					else if (self.curPos == 5)
						self.pers["secAttach"] = "tactical";
					else if (self.curPos == 6)
						self.pers["secAttach"] = "xmags";

					self thread acceptLoadout();

				}
				else if (self.weaponStatus == 6)
				{
					if (self.curPos == 1)
						self.pers["secAttach"] = "mp";
					else if (self.curPos == 2)
						self.pers["secAttach"] = "fmj";
					else if (self.curPos == 3)
						self.pers["secAttach"] = "akimbo";
					else if (self.curPos == 4)
						self.pers["secAttach"] = "tactical";
					
					self thread acceptLoadout();

				}
				else if (self.weaponStatus == 7)
				{
					if (self.curPos == 1)
					{
						self.pers["sec"] = "spas12";
						self.weaponStatus = 8;
						self.secType = "sg";
					}
					else if (self.curPos == 2)
					{
						self.pers["sec"] = "aa12";
						self.weaponStatus = 8;
						self.secType = "sg";
					}
					else if (self.curPos == 3)
					{
						self.pers["sec"] = "striker";
						self.weaponStatus = 8;
						self.secType = "sg";
					}
					else if (self.curPos == 4)
					{
						self.pers["sec"] = "ranger";
						self.weaponStatus = 9;
						self.secType = "sg";
					}
					else if (self.curPos == 5)
					{
						self.pers["sec"] = "m1014";
						self.weaponStatus = 8;
						self.secType = "sg";
					}
					else if (self.curPos == 6)
					{
						self.pers["sec"] = "model1887";
						self.weaponStatus = 9;
						self.secType = "sg";
					}
					else if (self.curPos == 7)
					{
						self.weaponStatus = 3;
					}

				}
				else if (self.weaponStatus == 8)
				{
					self.pers["secAttach"] = self.sgAttach[self.curPos - 1];
					self thread acceptLoadout();
				}
				else if (self.weaponStatus == 9)
				{
					if (self.curPos == 1)
						self.pers["secAttach"] = "mp";
					else if (self.curPos == 2)
						self.pers["secAttach"] = "fmj";
					else if (self.curPos == 3)
						self.pers["secAttach"] = "akimbo";
					
					self thread acceptLoadout();
				}
				else if (self.weaponStatus == 10) // Launchers
				{
					if (self.curPos == 1)
					{
						self.pers["sec"] = "at4";
						self.pers["secAttach"] = "mp";
						self thread acceptLoadout();
					}
					else if (self.curPos == 2)
					{
						self.pers["sec"] = "m79";
						self.pers["secAttach"] = "mp";
						self thread acceptLoadout();
					}
					else if (self.curPos == 3)
					{
						self.pers["sec"] = "stinger";
						self.pers["secAttach"] = "mp";
						self thread acceptLoadout();
					}
					else if (self.curPos == 4)
					{
						self.pers["sec"] = "javelin";
						self.pers["secAttach"] = "mp";
						self thread acceptLoadout();
					}
					else if (self.curPos == 5)
					{
						self.pers["sec"] = "rpg";
						self.pers["secAttach"] = "mp";
						self thread acceptLoadout();
					}
					else if (self.curPos == 6)
					{
						self.weaponStatus = 3;
					}

				}
				else if (self.weaponStatus == 11) // Machine Pistols
				{

					if (self.curPos == 1)
					{
						self.pers["sec"] = "pp2000";
						self.weaponStatus = 12;
					}
					else if (self.curPos == 2)
					{
						self.pers["sec"] = "glock";
						self.weaponStatus = 12;
					}
					else if (self.curPos == 3)
					{
						self.pers["sec"] = "beretta393";
						self.weaponStatus = 12;
					}
					else if (self.curPos == 4)
					{
						self.pers["sec"] = "tmp";
						self.weaponStatus = 12;
					}
					else if (self.curPos == 5)
					{
						self.weaponStatus = 3;
					}
				}
				else if (self.weaponStatus == 12)	// Machine Pistol Attachments
				{
					self.pers["secAttach"] = self.mPisAttach[self.curPos - 1];
					self thread acceptLoadout();
				}
				else if (self.weaponStatus == 13)	// Assault Rifle Attachments
				{
					self.pers["secAttach"] = self.assAttach[self.curPos - 1];
					self thread acceptLoadout();
				}
				else if (self.weaponStatus == 14)	// Sub Machine Gun Attachments
				{
					self.pers["secAttach"] = self.smgAttach[self.curPos - 1];
					self thread acceptLoadout();
				}
				else if (self.weaponStatus == 15)	// Light Machine Gun Attachments
				{
					self.pers["secAttach"] = self.lmgAttach[self.curPos - 1];
					self thread acceptLoadout();
				}

				if (self.secIsPrimary == false && self.curPos == 7)
				{
					// idontevenfuckingknow.jpg
				}
				else
				{
					self.curPos = 1;
				}

			}
			else if (self.menuPos == 4) // Killsteaks
			{
				if (self.curPos == 1)
					self maps\mp\killstreaks\_killstreaks::giveKillstreak( "uav", false );
				else if (self.curPos == 2)
					self maps\mp\killstreaks\_killstreaks::giveKillstreak( "airdrop", false );
				else if (self.curPos == 3)
					self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", false );
				else if (self.curPos == 4)
					self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile", false );

				self thread menuClose();

			}
			else if (self.menuPos == 5) // SO MANY FUCKING IF STATEMENTS...
			{

				if (self.curPos == 1)
				{
					self setWeaponAmmoStock( self getCurrentWeapon(), 0 );
					self setWeaponAmmoStock( self getCurrentWeapon(), 0, "right" );
					self setWeaponAmmoStock( self getCurrentWeapon(), 0, "left" );
					self iPrintLn( "The ammo in your stock was reset to 0." );
				}
				else if (self.curPos == 2)
				{
					self setWeaponAmmoClip( self getCurrentWeapon(), 0 );
					self setWeaponAmmoClip( self getCurrentWeapon(), 0, "right" );
					self setWeaponAmmoClip( self getCurrentWeapon(), 0, "left" );
					self iPrintLn( "The ammo in your clip was reset to 0." );

				}
				else if (self.curPos == 3)
				{
					self thread refillAmmo();
					self iPrintLn( "Everything in your class was refilled." );
				}
				else if (self.curPos == 4)
				{
					if (self.pers["rAmmo"] == "true")
						self.pers["rAmmo"] = "false";
					else if (self.pers["rAmmo"] == "false")
						self.pers["rAmmo"] = "true";
				}
				else if (self.curPos == 5)
				{
					if (self.pers["rSpec"] == "true")
						self.pers["rSpec"] = "false";
					else if (self.pers["rSpec"] == "false")
						self.pers["rSpec"] = "true";
				}
				else if (self.curPos == 6)
				{
					if (self.pers["rEquip"] == "true")
						self.pers["rEquip"] = "false";
					else if (self.pers["rEquip"] == "false")
						self.pers["rEquip"] = "true";
				}
				else if (self.curPos == 7)
				{
					if (self.pers["omaTrickshot"] == "true")
						self.pers["omaTrickshot"] = "false";
					else if (self.pers["omaTrickshot"] == "false")
						self.pers["omaTrickshot"] = "true";
				}
				else if (self.curPos == 8)
				{
					if (self.pers["useCustom"] == "false")
						self.pers["useCustom"] = "true";
					else if (self.pers["useCustom"] == "true")
						self.pers["useCustom"] = "false";
				}
				else if (self.curPos == 9)
				{

					if (self.fb == "false")
					{
						self.fb = "true";
						self setClientDvar( "r_fullbright", "1" );
					}
					else if (self.fb == "true")
					{
						self.fb = "false";
						self setClientDvar( "r_fullbright", "0" );
					}
				}
			}
			else if (self.menuPos == 6) // Match Settings
			{
				if (self.curPos == 1)
				{
					if ( getDvar( "dmgt" ) == "0" )
						setDvar( "dmgt", "1" );
					else if ( getdvar( "dmgt" ) == "1" )
						setDvar( "dmgt", "2" );
					else if ( getdvar( "dmgt" ) == "2" )
						setDvar( "dmgt", "0" );
				}
				else if (self.curPos == 2)
				{
					if ( getdvar( "expb" ) == "0" )
						setDvar( "expb", "1" );
					else if ( getdvar( "expb" ) == "1" ) 
						setDvar( "expb", "2" );
					else if ( getdvar( "expb" ) == "2" ) 
						setDvar( "expb", "0" );
				}
				else if (self.curPos == 3)
				{
					if ( getdvar( "timescale" ) == "1" )
						setDvar( "timescale", "0.75" );
					else if ( getdvar( "timescale" ) == "0.75" )
						setDvar( "timescale", "0.5" );
					else if ( getdvar( "timescale" ) == "0.5" )
						setDvar( "timescale", "0.25" );
					else if ( getdvar( "timescale" ) == "0.25" )
						setDvar( "timescale", "1" );
				}
				else if (self.curPos == 4)
				{
					if ( getDvar( "hostMig" ) == "0" )
						setDvar( "hostMig", "1" );
					else if ( getDvar( "hostMig" ) == "1" )
						setDvar( "hostMig", "0" );
				}

			}
			else if (self.menuPos == 7) // Change Map
			{
				// Disabled - confirmed via gsc-tool (compiling against a
				// real stock GSC dump) that bare map(...) calls here are the
				// ONLY compile error anywhere in this whole file ("couldn't
				// determine function call type") - not a native/script
				// function this build recognizes at all, likely an iw4x-only
				// addition. Not part of what was actually asked for
				// (Equipment/Weapons/Match Settings) - left disabled rather
				// than guessing at a replacement.
				/*
				if (self.mapPack == 0) // And not one single fuck was given if you changed the map by accident...
				{
					if (self.page == 1)
						map( self.NormMap1[self.curPos - 1] );
					else if (self.page == 2)
						map( self.NormMap2[self.curPos - 1] );
				}
				else if (self.mapPack == 1)
				{
					map( self.DLCMap[self.curPos - 1] );
				}
				*/
			}
			else if (self.menuPos == 8)
			{
				if (self.curPos == 2)
				{
					if ( getdvar( "testClients_doMove" ) == "0" )
						setDvar( "testClients_doMove", "1" );
					else if ( getdvar( "testClients_doMove" ) == "1" )
						setDvar( "testClients_doMove", "0" );
				}
				else if (self.curPos == 3)
				{
					if ( getdvar( "testClients_doAttack" ) == "0" )
						setDvar( "testClients_doAttack", "1" );
					else if ( getdvar( "testClients_doAttack" ) == "1" )
						setDvar( "testClients_doAttack", "0" );
				}
				else if (self.curPos == 4)
				{
					if ( getdvar( "testClients_doReload" ) == "0" )
						setDvar( "testClients_doReload", "1" );
					else if ( getdvar( "testClients_doReload" ) == "1" )
						setDvar( "testClients_doReload", "0" );
				}
				else if (self.curPos == 5)
				{
					if ( getDvar( "testClients_doLock" ) == "0" )
						setDvar( "testClients_doLock", "1" );
					else if ( getdvar( "testClients_doLock" ) == "1" )
						setDvar( "testClients_doLock", "0" );
				}
				else if (self.curPos == 6)
				{
					if ( getDvar( "testClients_doRespawn" ) == "0" )
						setDvar( "testClients_doRespawn", "1" );
					else if ( getdvar( "testClients_doRespawn" ) == "1" )
						setDvar( "testClients_doRespawn", "0" );
				}

			}
			else if (self.menuPos == 9)
			{
				foreach(player in level.players)
				{
					if (self.kickPage == 1)
					{
						if (player.name == level.players[self.curPos - 1].name)
							kick(player getEntityNumber(),"EXE_PLAYERKICKED");
				 	}
				 	else if (self.kickPage == 2)
				 	{
						if (player.name == level.players[self.curPos - 1 + 9].name)
							kick(player getEntityNumber(),"EXE_PLAYERKICKED");
					}
				}
				self.curPos = 1;
			}
		}
	}
}