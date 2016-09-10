Pointshop2.Gambling = {}

Pointshop2.Gambling.WinMultiplier = {
	10, --bar
	20, --lemon
	35, --strawberry
	55, --cherry
	100, --seven
	250 --gold
}

Pointshop2.Gambling.images = {
	"slotmachine/bar.png",
	"slotmachine/lemon.png",
	"slotmachine/strawberry.png",
	"slotmachine/cherry.png",
	"slotmachine/seven.png",
	"slotmachine/gold.png"
}

function Pointshop2.Gambling:GetItemNumberForChance( chance )
	if chance <= 2 then
		return 6
	elseif chance <= 5 then
		return 5
	elseif chance <= 9 then
		return 4
	elseif chance <= 14 then
		return 3
	elseif chance <= 20 then
		return 2
	elseif chance <= 29 then
		return 1
	end
end
Pointshop2.Gambling.CHOICECOUNT = 29 --chance is between 1 and CHOICECOUNT

local amounts = {
	10,
	50,
	100,
	1000
}

Pointshop2.Gambling.BetAmounts = {}
hook.Add( "PS2_OnSettingsUpdate", "CalculateBetAmounts", function( )
	for k, v in pairs( amounts ) do
		Pointshop2.Gambling.BetAmounts[k] = v * Pointshop2.GetSetting( "Pointshop 2 DLC", "GamblingSettings.BetMultiplier" )
	end
end )

if SERVER then
	LibK.addContentFolder( "materials/slotmachine" )
	resource.AddFile( "sound/slots_win.wav" )
end

hook.Add( "PS2_ModulesLoaded", "DLC_GAMBLE", function( )
	local MODULE = Pointshop2.GetModule( "Pointshop 2 DLC" )

	MODULE.Settings.Shared.GamblingSettings = {
		info = {
			label = "Gambling Settings"
		},
		BetMultiplier = {
			tooltip = "Use this to manipulate the bet prices. Multiplier of 1 means standard bets, 0.5 means half the amount, 2 double etc.",
			label = "Bet Multiplier",
			value = 1
		},
		GlobalSound = {
			value = true,
			label = "3D Win Sound",
			tooltip = "Whether or not to play the win sound from the player so that nearby players can hear it"
		},
	}

	table.insert( MODULE.SettingButtons, {
		label = "Gambling Settings",
		icon = "pointshop2/small43.png",
		control = "DPointshop2GamblingConfigurator"
	} )
end )

hook.Add( "PS2_PopulateCredits", "AddGambleCreds", function( panel )
	panel:AddCreditSection( "Pointshop 2 Gamble", [[
Pointshop 2 Gamble by Kamshak.
	]] )
end )
