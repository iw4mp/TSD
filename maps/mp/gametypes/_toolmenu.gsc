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
	self.toolCurPos = 1;
	self.toolMaxCycle = 1;

	// Weapons wizard state (category 3) - see toolMenuSelectWeapon().
	self.toolWeaponStatus = 1;
	self.toolSecIsPrimary = false;
	self.toolSecTeir = 1;
	self.toolSecType = "none";
	self.toolPri = "none";
	self.toolPriAttach = "none";
	self.toolSec = "none";
	self.toolSecAttach = "none";
	self.toolWeap1 = "none";
	self.toolWeap2 = "none";

	self thread createToolMenuText();
	self thread watchToolMenuToggle();
	self thread watchToolMenuLeft();
	self thread watchToolMenuRight();
	self thread watchToolMenuUp();
	self thread watchToolMenuDown();
	self thread watchToolMenuSelect();
	self thread watchToolMenuMaxCycle();
	self thread watchToolMenuResetOnSpawn();

	// Teleports category (position 1) - ported from TSD's _locations.gsc.
	self thread watchToolMenuTeleport1();
	self thread watchToolMenuTeleport2();
	self thread watchToolMenuTeleport3();
	self thread watchToolMenuTeleport4();
}

// Keeps self.toolCurPos wrapping at the right ceiling for whatever
// category/wizard-step is currently active - ported from TSD's
// _menuCont.gsc's determinMaxCycle(), trimmed to only the categories this
// menu actually implements so far (Equipment, Weapons). Other categories
// pin maxCycle to 1 so up/down does nothing there yet.
watchToolMenuMaxCycle()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		if ( self.toolMenuOpen == 1 )
		{
			if ( self.toolMenuPos == 2 )
			{
				self.toolMaxCycle = 9;
			}
			else if ( self.toolMenuPos == 3 )
			{
				if ( self.toolWeaponStatus == 1 )
				{
					if ( self.toolSecIsPrimary == true )
					{
						if ( self.toolSecTeir == 1 )
							self.toolMaxCycle = 9;
						else if ( self.toolSecTeir == 2 )
							self.toolMaxCycle = 5;
						else if ( self.toolSecTeir == 3 )
							self.toolMaxCycle = 4;
						else if ( self.toolSecTeir == 4 )
							self.toolMaxCycle = 5;
						else if ( self.toolSecTeir == 5 )
							self.toolMaxCycle = 1;
					}
					else
					{
						self.toolMaxCycle = 6;
					}
				}
				else if ( self.toolWeaponStatus == 2 )
					self.toolMaxCycle = 7;
				else if ( self.toolWeaponStatus == 3 )
					self.toolMaxCycle = 6;
				else if ( self.toolWeaponStatus == 4 )
					self.toolMaxCycle = 5;
				else if ( self.toolWeaponStatus == 5 )
					self.toolMaxCycle = 6;
				else if ( self.toolWeaponStatus == 6 )
					self.toolMaxCycle = 4;
				else if ( self.toolWeaponStatus == 7 )
					self.toolMaxCycle = 7;
				else if ( self.toolWeaponStatus == 8 )
					self.toolMaxCycle = 7;
				else if ( self.toolWeaponStatus == 9 )
					self.toolMaxCycle = 3;
				else if ( self.toolWeaponStatus == 10 )
					self.toolMaxCycle = 6;
				else if ( self.toolWeaponStatus == 11 )
					self.toolMaxCycle = 5;
				else if ( self.toolWeaponStatus == 12 )
					self.toolMaxCycle = 7;
				else if ( self.toolWeaponStatus == 13 )
					self.toolMaxCycle = 11;
				else if ( self.toolWeaponStatus == 14 )
					self.toolMaxCycle = 10;
				else if ( self.toolWeaponStatus == 15 )
					self.toolMaxCycle = 10;
			}
			else
			{
				self.toolMaxCycle = 1;
			}
		}

		wait 0.1;
	}
}

watchToolMenuUp()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuUp", "+forward" );
		self waittill( "toolMenuUp" );

		if ( self.toolMenuOpen == 0 )
			continue;

		self.toolCurPos--;
		if ( self.toolCurPos < 1 )
			self.toolCurPos = self.toolMaxCycle;
	}
}

watchToolMenuDown()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuDown", "+back" );
		self waittill( "toolMenuDown" );

		if ( self.toolMenuOpen == 0 )
			continue;

		self.toolCurPos++;
		if ( self.toolCurPos > self.toolMaxCycle )
			self.toolCurPos = 1;
	}
}

watchToolMenuSelect()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self notifyOnPlayerCommand( "toolMenuSelect", "+gostand" );
		self waittill( "toolMenuSelect" );

		if ( self.toolMenuOpen == 0 )
			continue;

		if ( self.toolMenuPos == 2 )
			self toolMenuSelectEquipment();
		else if ( self.toolMenuPos == 3 )
			self toolMenuSelectWeapon();
	}
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
			self.toolCurPos = 1;
			self.toolWeaponStatus = 1;
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

		self.toolCurPos = 1;
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

		self.toolCurPos = 1;
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
		self.toolCurPos = 1;
		self.toolWeaponStatus = 1;
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

// Equipment category (position 2). Simplified from TSD's original, which
// routed every pick through _class::giveSameLoadout() (a full loadout
// rebuild keyed off this engine's class-table internals) - not verified
// against this Steam build yet, so for now this just gives/equips the item
// directly instead. curPos 9 ("mala"/molotov combo in TSD) isn't a real
// weapon/perk token on its own, so it's simplified to repeat the last item.
toolMenuEquipmentName( pos )
{
	names = [];
	names[1] = "frag_grenade_mp";
	names[2] = "semtex_mp";
	names[3] = "throwingknife_mp";
	names[4] = "specialty_tacticalinsertion";
	names[5] = "specialty_blastshield";
	names[6] = "claymore_mp";
	names[7] = "c4_mp";
	names[8] = "lightstick_mp";
	names[9] = names[8];

	return names[pos];
}

toolMenuSelectEquipment()
{
	item = toolMenuEquipmentName( self.toolCurPos );

	if ( item == "specialty_tacticalinsertion" || item == "specialty_blastshield" )
	{
		self maps\mp\perks\_perks::givePerk( item );
	}
	else
	{
		self giveWeapon( item );
		self switchToWeapon( item );
	}

	self closeToolMenu();
}

// Attachment tables for the Weapons wizard below, ported from TSD's
// _select.gsc (efficiencyPlusPlus()) - 1-indexed here to match
// self.toolCurPos directly instead of TSD's "curPos - 1".
toolMenuSniAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "silencer";
	names[3] = "acog";
	names[4] = "fmj";
	names[5] = "heartbeat";
	names[6] = "thermal";
	names[7] = "xmags";
	return names[pos];
}

toolMenuMPisAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "reflex";
	names[3] = "silencer";
	names[4] = "fmj";
	names[5] = "akimbo";
	names[6] = "eotech";
	names[7] = "xmags";
	return names[pos];
}

toolMenuAssAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "gl";
	names[3] = "reflex";
	names[4] = "silencer";
	names[5] = "acog";
	names[6] = "fmj";
	names[7] = "shotgun";
	names[8] = "eotech";
	names[9] = "heartbeat";
	names[10] = "thermal";
	names[11] = "xmags";
	return names[pos];
}

toolMenuSmgAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "rof";
	names[3] = "reflex";
	names[4] = "silencer";
	names[5] = "acog";
	names[6] = "fmj";
	names[7] = "akimbo";
	names[8] = "eotech";
	names[9] = "termal";
	names[10] = "xmags";
	return names[pos];
}

toolMenuSgAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "reflex";
	names[3] = "silencer";
	names[4] = "grip";
	names[5] = "fmj";
	names[6] = "eotech";
	names[7] = "xmags";
	return names[pos];
}

toolMenuLmgAttach( pos )
{
	names = [];
	names[1] = "mp";
	names[2] = "grip";
	names[3] = "reflex";
	names[4] = "silencer";
	names[5] = "acog";
	names[6] = "fmj";
	names[7] = "eotech";
	names[8] = "heartbeat";
	names[9] = "thermal";
	names[10] = "xmags";
	return names[pos];
}

// Ported from TSD's _select.gsc's refillAmmo()/defaultSnipingSet().
toolRefillAmmo()
{
	weaponList = self GetWeaponsListAll();

	if ( self _hasPerk( "specialty_tacticalinsertion" ) && self getAmmoCount( "flare_mp" ) < 1 )
		self _setPerk( "specialty_tacticalinsertion" );

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

toolDefaultSnipingSet()
{
	self TakeAllWeapons();
	self giveWeapon( "cheytac_fmj_mp", 8, false );
	self giveWeapon( "beretta_tactical_mp" );
	wait 0.1;
	self switchToWeapon( "cheytac_fmj_mp" );

	self _clearPerks();
	self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
	self maps\mp\perks\_perks::givePerk( "specialty_fastreload" );
	self maps\mp\perks\_perks::givePerk( "specialty_quickdraw" );
	self maps\mp\perks\_perks::givePerk( "specialty_lightweight" );
	self maps\mp\perks\_perks::givePerk( "specialty_fastsprintrecovery" );

	self SetOffhandSecondaryClass( "concussion" );
	self giveWeapon( "concussion_grenade_mp" );

	self thread toolRefillAmmo();

	self closeToolMenu();
}

// Ported from TSD's _select.gsc's acceptLoadout() - builds the two weapon
// names from pri/priAttach and sec/secAttach the wizard below picked, then
// gives them. Only lasts for this life (TSD's version also persisted the
// choice via self.pers[...] to reapply on every future spawn - not ported
// yet, this increment is "give me this loadout now" only).
toolAcceptLoadout()
{
	if ( self.toolSecAttach == "none" )
	{
		self closeToolMenu();
		return;
	}

	self closeToolMenu();

	if ( self.toolPriAttach == "mp" )
		self.toolWeap1 = self.toolPri + "_" + self.toolPriAttach;
	else
		self.toolWeap1 = self.toolPri + "_" + self.toolPriAttach + "_mp";

	if ( self.toolSecAttach == "mp" )
		self.toolWeap2 = self.toolSec + "_" + self.toolSecAttach;
	else
		self.toolWeap2 = self.toolSec + "_" + self.toolSecAttach + "_mp";

	if ( self.toolWeap1 == self.toolWeap2 )
		self iPrintLnBold( "^1Warning! The two weapons you picked were the same!" );

	weapList = self GetWeaponsListAll();
	weapListPrim = self GetWeaponsListPrimaries();

	self takeWeapon( self getCurrentWeapon() );

	while ( self getCurrentWeapon() == "none" )
	{
		if ( weapListPrim.size )
			self switchToWeapon( weapListPrim[ RandomInt( weapListPrim.size ) ] );
		else
			self switchToWeapon( weapList[ RandomInt( weapList.size ) ] );
		wait 0.05;
	}

	self takeWeapon( self getCurrentWeapon() );
	self giveWeapon( self.toolWeap1, 5 + randomInt( 3 ), false );

	if ( self.toolSecAttach == "oma" )
	{
		self maps\mp\perks\_perks::givePerk( "specialty_onemanarmy" );
		self maps\mp\perks\_perks::givePerk( "specialty_omaquickchange" );
		self giveWeapon( "onemanarmy_mp" );
	}

	if ( self.toolSecAttach == "akimbo" )
		self giveWeapon( self.toolWeap2, 5 + randomInt( 3 ), true );
	else if ( self.toolSecAttach != "akimbo" || self.toolSecAttach != "oma" )
		self giveWeapon( self.toolWeap2 );

	wait 0.1;

	self switchToWeapon( self.toolWeap1 );

	self.toolSecIsPrimary = false;
	self.toolSecType = "none";
}

// Weapons category (position 3) - the multi-step wizard, ported 1:1 from
// TSD's _select.gsc's handleSelection() (menuPos==3 branch). Each call
// handles one "+gostand" press at the current self.toolWeaponStatus step.
toolMenuSelectWeapon()
{
	if ( self.toolWeaponStatus == 1 )
	{
		if ( self.toolCurPos == 1 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self.toolPri = "cheytac";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "m4";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 2 )
			{
				self.toolSec = "mp5k";
				self.toolWeaponStatus = 14;
			}
			else if ( self.toolSecTeir == 3 )
			{
				self.toolSec = "cheytac";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "sa80";
				self.toolWeaponStatus = 15;
			}
			else if ( self.toolSecTeir == 5 )
			{
				self.toolSec = "riotshield";
				self.toolSecAttach = "mp";
				self thread toolAcceptLoadout();
			}
		}
		else if ( self.toolCurPos == 2 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self.toolPri = "barrett";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "famas";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 2 )
			{
				self.toolSec = "ump45";
				self.toolWeaponStatus = 14;
			}
			else if ( self.toolSecTeir == 3 )
			{
				self.toolSec = "barrett";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "mg4";
				self.toolWeaponStatus = 15;
			}
		}
		else if ( self.toolCurPos == 3 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self.toolPri = "wa2000";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "scar";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 2 )
			{
				self.toolSec = "kriss";
				self.toolWeaponStatus = 14;
			}
			else if ( self.toolSecTeir == 3 )
			{
				self.toolSec = "wa2000";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "rpd";
				self.toolWeaponStatus = 15;
			}
		}
		else if ( self.toolCurPos == 4 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self.toolPri = "m21";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "tavor";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 2 )
			{
				self.toolSec = "p90";
				self.toolWeaponStatus = 14;
			}
			else if ( self.toolSecTeir == 3 )
			{
				self.toolSec = "m21";
				self.toolWeaponStatus = 2;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "mg4";
				self.toolWeaponStatus = 15;
			}
		}
		else if ( self.toolCurPos == 5 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self thread toolDefaultSnipingSet();
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "fal";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 2 )
			{
				self.toolSec = "uzi";
				self.toolWeaponStatus = 14;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "aug";
				self.toolWeaponStatus = 15;
			}
		}
		else if ( self.toolCurPos == 6 )
		{
			if ( self.toolSecIsPrimary == false )
			{
				self thread toolAcceptLoadout();
			}
			else if ( self.toolSecTeir == 1 )
			{
				self.toolSec = "m16";
				self.toolWeaponStatus = 13;
			}
			else if ( self.toolSecTeir == 4 )
			{
				self.toolSec = "m240";
				self.toolWeaponStatus = 15;
			}
		}
		else if ( self.toolCurPos == 7 && self.toolSecIsPrimary == true && self.toolSecTeir == 1 )
		{
			self.toolSec = "masada";
			self.toolWeaponStatus = 13;
		}
		else if ( self.toolCurPos == 8 && self.toolSecIsPrimary == true && self.toolSecTeir == 1 )
		{
			self.toolSec = "fn2000";
			self.toolWeaponStatus = 13;
		}
		else if ( self.toolCurPos == 9 && self.toolSecIsPrimary == true && self.toolSecTeir == 1 )
		{
			self.toolSec = "ak47";
			self.toolWeaponStatus = 13;
		}

		self.toolCurPos = 1;
	}
	else if ( self.toolWeaponStatus == 2 )
	{
		if ( self.toolSecIsPrimary == false )
		{
			self.toolPriAttach = toolMenuSniAttach( self.toolCurPos );
			self.toolWeaponStatus = 3;
		}
		else
		{
			self.toolSecAttach = toolMenuSniAttach( self.toolCurPos );
			self thread toolAcceptLoadout();
		}
	}
	else if ( self.toolWeaponStatus == 3 )
	{
		if ( self.toolCurPos == 1 )
			self.toolWeaponStatus = 11;
		else if ( self.toolCurPos == 2 )
			self.toolWeaponStatus = 4;
		else if ( self.toolCurPos == 3 )
			self.toolWeaponStatus = 7;
		else if ( self.toolCurPos == 4 )
			self.toolWeaponStatus = 10;
		else if ( self.toolCurPos == 5 )
		{
			self.toolSecAttach = "oma";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 6 )
		{
			self.toolSecIsPrimary = true;
			self.toolWeaponStatus = 1;
		}
	}
	else if ( self.toolWeaponStatus == 4 )
	{
		if ( self.toolCurPos == 1 )
		{
			self.toolSec = "usp";
			self.toolWeaponStatus = 5;
		}
		else if ( self.toolCurPos == 2 )
		{
			self.toolSec = "coltanaconda";
			self.toolWeaponStatus = 6;
		}
		else if ( self.toolCurPos == 3 )
		{
			self.toolSec = "beretta";
			self.toolWeaponStatus = 5;
		}
		else if ( self.toolCurPos == 4 )
		{
			self.toolSec = "deserteagle";
			self.toolWeaponStatus = 6;
		}
		else if ( self.toolCurPos == 5 )
		{
			self.toolWeaponStatus = 3;
		}
		self.toolCurPos = 1;
	}
	else if ( self.toolWeaponStatus == 5 )
	{
		if ( self.toolCurPos == 1 )
			self.toolSecAttach = "mp";
		else if ( self.toolCurPos == 2 )
			self.toolSecAttach = "fmj";
		else if ( self.toolCurPos == 3 )
			self.toolSecAttach = "silencer";
		else if ( self.toolCurPos == 4 )
			self.toolSecAttach = "akimbo";
		else if ( self.toolCurPos == 5 )
			self.toolSecAttach = "tactical";
		else if ( self.toolCurPos == 6 )
			self.toolSecAttach = "xmags";

		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 6 )
	{
		if ( self.toolCurPos == 1 )
			self.toolSecAttach = "mp";
		else if ( self.toolCurPos == 2 )
			self.toolSecAttach = "fmj";
		else if ( self.toolCurPos == 3 )
			self.toolSecAttach = "akimbo";
		else if ( self.toolCurPos == 4 )
			self.toolSecAttach = "tactical";

		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 7 )
	{
		if ( self.toolCurPos == 1 )
		{
			self.toolSec = "spas12";
			self.toolWeaponStatus = 8;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 2 )
		{
			self.toolSec = "aa12";
			self.toolWeaponStatus = 8;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 3 )
		{
			self.toolSec = "striker";
			self.toolWeaponStatus = 8;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 4 )
		{
			self.toolSec = "ranger";
			self.toolWeaponStatus = 9;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 5 )
		{
			self.toolSec = "m1014";
			self.toolWeaponStatus = 8;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 6 )
		{
			self.toolSec = "model1887";
			self.toolWeaponStatus = 9;
			self.toolSecType = "sg";
		}
		else if ( self.toolCurPos == 7 )
		{
			self.toolWeaponStatus = 3;
		}
	}
	else if ( self.toolWeaponStatus == 8 )
	{
		self.toolSecAttach = toolMenuSgAttach( self.toolCurPos );
		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 9 )
	{
		if ( self.toolCurPos == 1 )
			self.toolSecAttach = "mp";
		else if ( self.toolCurPos == 2 )
			self.toolSecAttach = "fmj";
		else if ( self.toolCurPos == 3 )
			self.toolSecAttach = "akimbo";

		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 10 )
	{
		if ( self.toolCurPos == 1 )
		{
			self.toolSec = "at4";
			self.toolSecAttach = "mp";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 2 )
		{
			self.toolSec = "m79";
			self.toolSecAttach = "mp";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 3 )
		{
			self.toolSec = "stinger";
			self.toolSecAttach = "mp";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 4 )
		{
			self.toolSec = "javelin";
			self.toolSecAttach = "mp";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 5 )
		{
			self.toolSec = "rpg";
			self.toolSecAttach = "mp";
			self thread toolAcceptLoadout();
		}
		else if ( self.toolCurPos == 6 )
		{
			self.toolWeaponStatus = 3;
		}
	}
	else if ( self.toolWeaponStatus == 11 )
	{
		if ( self.toolCurPos == 1 )
		{
			self.toolSec = "pp2000";
			self.toolWeaponStatus = 12;
		}
		else if ( self.toolCurPos == 2 )
		{
			self.toolSec = "glock";
			self.toolWeaponStatus = 12;
		}
		else if ( self.toolCurPos == 3 )
		{
			self.toolSec = "beretta393";
			self.toolWeaponStatus = 12;
		}
		else if ( self.toolCurPos == 4 )
		{
			self.toolSec = "tmp";
			self.toolWeaponStatus = 12;
		}
		else if ( self.toolCurPos == 5 )
		{
			self.toolWeaponStatus = 3;
		}
	}
	else if ( self.toolWeaponStatus == 12 )
	{
		self.toolSecAttach = toolMenuMPisAttach( self.toolCurPos );
		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 13 )
	{
		self.toolSecAttach = toolMenuAssAttach( self.toolCurPos );
		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 14 )
	{
		self.toolSecAttach = toolMenuSmgAttach( self.toolCurPos );
		self thread toolAcceptLoadout();
	}
	else if ( self.toolWeaponStatus == 15 )
	{
		self.toolSecAttach = toolMenuLmgAttach( self.toolCurPos );
		self thread toolAcceptLoadout();
	}

	if ( self.toolSecIsPrimary != false || self.toolCurPos != 7 )
		self.toolCurPos = 1;
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
			else if ( self.toolMenuPos == 2 )
			{
				menuTitle setText( "^6Equipment" );
				tpLine0 setText( "^3[{+forward}]/[{+back}] ^2to cycle, ^3[{+gostand}] ^2to give" );

				i = 1;
				list = "";
				while ( i <= 9 )
				{
					if ( i == self.toolCurPos )
						list += "^2> " + toolMenuEquipmentName( i ) + "\n";
					else
						list += "^7  " + toolMenuEquipmentName( i ) + "\n";
					i++;
				}
				tpLine1 setText( list );
				tpLine2 setText( "" );
				tpLine3 setText( "" );
			}
			else if ( self.toolMenuPos == 3 )
			{
				menuTitle setText( "^6Weapons" );
				tpLine0 setText( "^3[{+forward}]/[{+back}] ^2to cycle, ^3[{+gostand}] ^2to confirm" );
				tpLine1 setText( "^7Step " + self.toolWeaponStatus + " - Option " + self.toolCurPos + "/" + self.toolMaxCycle );
				tpLine2 setText( "^7Primary so far: ^3" + self.toolPri + " " + self.toolPriAttach );
				tpLine3 setText( "^7Secondary so far: ^3" + self.toolSec + " " + self.toolSecAttach );
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
