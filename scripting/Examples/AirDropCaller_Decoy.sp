#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
// #include <hexstocks>
#include <airdrop>

//Compiler options
#pragma semicolon 1
#pragma newdecls required

//Arrays
ArrayList Array_BoxEnt;

//Booleans
bool bPressed[MAXPLAYERS + 1];

#define PLUGIN_AUTHOR "Hexah"
#define PLUGIN_VERSION "1.00"

//Plugin invos
public Plugin myinfo = 
{
	name = "CallAirDrop with Decoy", 
	author = PLUGIN_AUTHOR, 
	description = "", 
	version = PLUGIN_VERSION, 
	url = "csitajb.it"
};

public void OnPluginStart()
{
	//Create Array
	Array_BoxEnt = new ArrayList(64);
	
	//Hook Events
	HookEvent("teamplay_round_start", Event_RoundStart);
	RegAdminCmd("sm_ck", aaaa, 0);
	// HookEvent("decoy_detonate", Event_DecoyStarted);
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	Array_BoxEnt.Clear();
}

public Action aaaa(int client, int args)
{
	float pos[3];
	GetClientAbsOrigin(client, pos);
	int iBoxEnt2 = AirDrop_Call(pos);
	Array_BoxEnt.Push(iBoxEnt2);
	return Plugin_Handled;
}

public void AirDrop_BoxUsed(int client, int iEnt) //Called when pressing +use on the AirDropBox
{
	if (GetArraySize(Array_BoxEnt) == 0) //Check for not void array
		return;
	
	for (int i = 0; i <= GetArraySize(Array_BoxEnt) - 1; i++)
	{
		int iBoxEnt = Array_BoxEnt.Get(i); //Get BoxEnt (Convert EntRef to Index)
		
		if (iBoxEnt == INVALID_ENT_REFERENCE) //Check for valid ent
		{
			Array_BoxEnt.Erase(i); //Remove Invalid EntRef from the array
			return;
		}
		
		if (iBoxEnt == iEnt) //Check if BoxEnt is the 'pressed' Ent
		{
			if (bPressed[client])
				return;
			
			AcceptEntityInput(iEnt, "kill");
			PrintToChat(client, "냠냠");
			
			bPressed[client] = true;
			
			CreateTimer(2.0, Timer_Pressed, GetClientUserId(client)); //Create Timer to avoid spamming
		}
	}
}

public Action Timer_Pressed(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	
	if (!client) //Client disconnected
		return;
	
	bPressed[client] = false;
} 
