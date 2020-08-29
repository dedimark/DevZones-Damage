// ------ #include ------ //

#include <sourcemod>
#include <devzones>
#include <multicolors>
#include <sdkhooks>

// ------ Handle ------ //

Handle Handle_Damage_T [MAXPLAYERS + 1];

// ------ ConVar ------ //

ConVar ConVar_Damage_Timer, ConVar_Damage;

// ------ #pragma ------ //

#pragma semicolon 1
#pragma newdecls required

// ------ myinfo ------ //

public Plugin myinfo = 
{
	name = "SM DEV ZONES - x damage per x seconds",
	author = "ByDexter",
	description = "",
	version = "1.0",
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	ConVar_Damage_Timer = CreateConVar("sm_timer_damage", "1.0", "Bölgede bulunan oyunculara kaç saniyede hasar vurulsun");
	ConVar_Damage = CreateConVar("sm_damage", "10", "Bölgede bulunan oyunculara kaç hasar vurulsun");
	AutoExecConfig(true, "DevZones-Damage", "ByDexter");
}

public void OnClientDisconnect(int client)
{
	if (Handle_Damage_T[client] != INVALID_HANDLE)
	{
		delete Handle_Damage_T[client];
		Handle_Damage_T[client] = INVALID_HANDLE;
	}
}

public void Zone_OnClientEntry(int client, const char[] zone)
{
	if(client < 1 || client > MaxClients || !IsClientInGame(client) ||!IsPlayerAlive(client)) 
		return;
		
	if(StrContains(zone, "dmg", false) == 0)
	{
		Handle_Damage_T[client] = CreateTimer(ConVar_Damage_Timer.FloatValue, Timer_Dmg, client, TIMER_REPEAT);
		CPrintToChat(client, "{darkred}[ByDexter] {green}dmg bölgesine {default}girdiniz.");
	}
}

public void Zone_OnClientLeave(int client, const char[] zone)
{
	if(StrContains(zone, "dmg", false) == 0)
	{
		if (Handle_Damage_T[client] != INVALID_HANDLE)
		{
			delete Handle_Damage_T[client];
			Handle_Damage_T[client] = INVALID_HANDLE;
		}
		CPrintToChat(client, "{darkred}[ByDexter] {green}dmg bölgesinden {default}ayrıldınız.");
	}
}

public Action Timer_Dmg(Handle timer, any client)
{
	int HP = GetClientHealth(client);
	SetEntityHealth(client, HP - ConVar_Damage.IntValue);
	CPrintToChat(client, "{darkred}[ByDexter] {green}dmg bölgesinde {default}olduğunuz için {darkblue}%d hasar yediniz", ConVar_Damage.IntValue);
}