#include <sourcemod>
#include <devzones>

#pragma semicolon 1
#pragma newdecls required

ConVar damage, time_damage;

public Plugin myinfo = 
{
	name = "SM DEV ZONES - x damage per x seconds", 
	author = "ByDexter", 
	description = "", 
	version = "1.1", 
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	LoadTranslations("devzones_damage.phrases");
	time_damage = CreateConVar("sm_damage_time", "3.0", "Oyuncular kaç saniye arayla hasar almalı?\nIn how many seconds should players take damage?", 0, true, 0.1);
	damage = CreateConVar("sm_damage", "10", "Bölgedeki oyunculara ne kadar hasar verilmelidir?\nHow many damage should be dealt to players in the zone?");
	AutoExecConfig(true, "DevZones-Damage", "ByDexter");
}

public void Zone_OnClientEntry(int client, const char[] zone)
{
	if (IsValidClient(client) && StrContains(zone, "dmg", false) != -1)
	{
		CreateTimer(time_damage.FloatValue, DealtDamage, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action DealtDamage(Handle timer, any client)
{
	if (!IsValidClient(client) || !Zone_IsClientInZone(client, "dmg"))
	{
		return Plugin_Stop;
	}
	
	SetEntityHealth(client, GetClientHealth(client) - damage.IntValue);
	PrintToChat(client, "[SM] %T", "damage", damage.IntValue, time_damage.FloatValue);
	return Plugin_Continue;
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 