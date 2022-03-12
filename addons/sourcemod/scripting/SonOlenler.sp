#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

int olen[65];
int olen2[65];

public Plugin myinfo = 
{
	name = "Son Ölenler", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	HookEvent("player_death", OnClientDead);
	RegConsoleCmd("sm_sonolen", Command_SonOlen, "");
	RegConsoleCmd("sm_so", Command_SonOlen, "");
}

public Action Command_SonOlen(int client, int args)
{
	Menu menu = new Menu(Menu_callback);
	if (args == 999)
	{
		menu.SetTitle("Son Ölenler - Anti-Teröristler\n ");
		char name[128];
		int two;
		menu.AddItem("0", "Sayfayı Yenile\n ");
		for (int i = 0; i < 65; i++)
		{
			two = GetClientOfUserId(olen2[i]);
			if (IsValidClient(two))
			{
				GetClientName(two, name, 128);
				menu.AddItem("X", name, ITEMDRAW_DISABLED);
			}
		}
	}
	else if (args == 1001)
	{
		menu.SetTitle("Son Ölenler - Teröristler\n ");
		char name[128];
		int two;
		menu.AddItem("1", "Sayfayı Yenile\n ");
		for (int i = 0; i < 65; i++)
		{
			two = GetClientOfUserId(olen[i]);
			if (IsValidClient(two))
			{
				GetClientName(two, name, 128);
				menu.AddItem("X", name, ITEMDRAW_DISABLED);
			}
		}
	}
	else
	{
		menu.SetTitle("Son Ölenler - Takım Seç\n ");
		menu.AddItem("0", "Anti-Terörist");
		menu.AddItem("1", "Terörist");
	}
	menu.Display(client, 15);
}

public int Menu_callback(Menu menu, MenuAction action, int client, int position)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_Select)
	{
		char info[8];
		menu.GetItem(position, info, 8);
		if (StringToInt(info) == 0)
		{
			Command_SonOlen(client, 999);
		}
		else if (StringToInt(info) == 1)
		{
			Command_SonOlen(client, 1001);
		}
	}
}

public Action OnClientDead(Event event, const char[] name, bool dB)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		if (GetClientTeam(client) == 2)
		{
			for (int i = 65; i > 1; i--)
			{
				olen[i - 1] = olen[i - 2];
			}
			olen[0] = GetClientUserId(client);
		}
		else if (GetClientTeam(client) == 3)
		{
			for (int i = 65; i > 1; i--)
			{
				olen2[i - 1] = olen2[i - 2];
			}
			olen2[0] = GetClientUserId(client);
		}
	}
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 