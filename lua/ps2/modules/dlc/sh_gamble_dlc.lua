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

if SERVER then
	LibK.addContentFolder( "materials/slotmachine" )
	resource.AddFile( "sound/slots_win.wav" )
end