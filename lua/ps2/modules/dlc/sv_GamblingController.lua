Pointshop2.GamblingController = class( "Pointshop2.GamblingController" )
Pointshop2.GamblingController:include( BaseController )

function Pointshop2.GamblingController:canDoAction( ply, action )
    if action == "startSpin" then
	    return Promise.Resolve( )
    else
        return Promise.Reject( "Invalid action" )
    end
end

function Pointshop2.GamblingController:spinLogic( bet )
	local randomseeds = {
		tostring( os.time( ) + math.random( os.time( ) ) ),
		tostring( os.time( ) + math.random( os.time( ) ) ),
		tostring( os.time( ) + math.random( os.time( ) ) )
	}

	--Spin the wheel serverside
	local endIcons = {}
	for i = 1, 3 do
		math.randomseed( tonumber( randomseeds[i] ) )
		for k = 1, i * 10 do --take 10th, 20th and 30th entry of each wheel to win
			endIcons[i] = Pointshop2.Gambling:GetItemNumberForChance( math.random( 1, Pointshop2.Gambling.CHOICECOUNT ) )
		end
	end

	--Check for wins
	local winNumber = endIcons[1]
	local won = true
	for k, v in pairs( endIcons ) do
		if v != winNumber then
			won = false
		end
	end
	local amountWon = bet * Pointshop2.Gambling.WinMultiplier[winNumber]

	return randomseeds, won and amountWon
end

function Pointshop2.GamblingController:simulateSpinning( )
	local balances = {}
	for i = 1, 1000 do
		local balance = 1000000
		for i = 1, 10000 do
			balance = balance - 100
			balance = balance + ( Pointshop2.GamblingController:spinLogic( 100 ) or 0 )
		end
		print( "Performed 10000 spins, balance:", balance )
		table.insert(balances, balance)
	end
	local average = LibK._.reduce(balances, 0, function(a, b) return a + b end) / #balances
	print( "Average (100 * 10000 spins): ", average )
end

function Pointshop2.GamblingController:startSpin( ply, bet )
	if ply.PS2_Wallet.points < bet then
		return Promise.Reject( "You cannot afford this!" )
	end

    if not table.HasValue( Pointshop2.Gambling.BetAmounts, bet ) then
        return Promise.Reject( "Invalid Bet" )
    end

	ply.lastSpin = ply.lastSpin or 0
	if ply.lastSpin + 1.6 > CurTime() then
		return Promise.Reject( "Hey, slow down a bit!" )
	end
	ply.lastSpin = CurTime( )

	ply:PS2_AddStandardPoints( -bet, "Gambling" )


	local randomseeds, amountWon = self:spinLogic( bet )
	if amountWon then
		timer.Simple( 1.5, function( )
			if not IsValid( ply ) then return end
			if Pointshop2.GetSetting( "Pointshop 2 DLC", "GamblingSettings.GlobalSound" ) then
				ply:EmitSound( "slots_win.wav" )
			end
			ply:PS2_AddStandardPoints( amountWon, "Gambling Earnings" )
		end )
	end

	return Promise.Resolve( randomseeds, amountWon and true, amountWon )
end
