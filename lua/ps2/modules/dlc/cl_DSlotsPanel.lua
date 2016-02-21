surface.CreateFont( "Gambling36", {
 font = "CoffeeTin",
 size = 36,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = true,
 additive = false,
 outline = false
} )

surface.CreateFont( "Gambling16", {
 font = "Arial",
 size = 16,
 weight = 1000,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = true,
 additive = false,
 outline = false
} )

local PANEL = {}
local CUR = "PTS "

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )

	self.rowContainer = vgui.Create( "DPanel", self )
	self.rowContainer:Dock( TOP )
	self.rowContainer:SetTall( 64 * 3 + 30 )
	function self.rowContainer:Paint( w, h )
		surface.SetDrawColor( self:GetSkin( ).ButtonColor )
		surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( self:GetSkin( ).Highlight )
    surface.DrawRect( 0, 64 + 10, w, 64 + 10 )
	end

	function self.rowContainer:PerformLayout( )
		self:SizeToChildren( true, false )
		self:SetWide( self:GetWide( ) + 5 ) -- Had to uncomment to fix butchering
	end

	self.rows = {}
	for i = 1, 3 do
		local idx = i - 1
		local row = vgui.Create( "DSlotStrip", self.rowContainer )
		row:Dock( LEFT )
		row:DockMargin( 5, 5, 5, 5 )
		self.rows[i] = row
	end

	self.wonLabel = vgui.Create( "DLabel", self )
	self.wonLabel:SetText( "YOU WON 1000 POINTS!"  )
	self.wonLabel:SetFont( self:GetSkin( ).SmallTitleFont )
	self.wonLabel:SizeToContents( )
	self.wonLabel:Dock( TOP )
	self.wonLabel:DockMargin( 0, 5, 0, 5 )
	self.wonLabel:SetColor( color_white )
	function self.wonLabel:Think( )
		self:SetColor( HSVToColor(math.sin(CurTime() * 360 / 100) * 360, 1, 1) )
	end
	self.wonLabel:SetContentAlignment( 5 )
	self.wonLabel:SetVisible( false )

	self.betPanel = vgui.Create( "DScrollPanel", self ) --Set to scroll
	self.betPanel:Dock( FILL ) -- Place this at the bottom of the panel
	self.betPanel:DockMargin( 5, 5, 5, 5 )

	self.amountBtns = {}
	for i = 1, 4 do
		local btn = vgui.Create( "DButton", self.betPanel )
		btn:Dock( TOP )
		btn:SetTall( 30 )
		btn:DockMargin( 5, 0, 5, 5 ) -- Lowered the margin for these buttons a bit to work/look better on lower resolutions
		btn:SetText( Pointshop2.Gambling.BetAmounts[i] .. " points" )
		hook.Add( "PS2_OnSettingsUpdate", btn, function( btn )
			btn:SetText( Pointshop2.Gambling.BetAmounts[i] .. " points" )
		end )
		function btn.DoClick( )
			self.Bet = Pointshop2.Gambling.BetAmounts[i]
			self:OnBetChanged( )
		end
		function btn:Think( )
			btn:SetDisabled( LocalPlayer().PS2_Wallet.points < Pointshop2.Gambling.BetAmounts[i] )
		end
	end

	self.betLabel = vgui.Create( "DLabel", self )
	self.betLabel:SetText( "Bet :" )
	self.betLabel:SetFont( self:GetSkin( ).SmallTitleFont )
	self.betLabel:SizeToContents( )
	self.betLabel:Dock( TOP )
	self.betLabel:DockMargin( 0, 5, 0, 5 )
	self.betLabel:SetColor( color_white )

	self.go = vgui.Create( "DButton", self )
	self.go:Dock( TOP )
	self.go:SetText( "Spin" )
	self.go:SetTall( 40 ) -- 75 was a bit much lol
	function self.go:Think( )
		if self:GetParent( ).Spinning or self.Bet == 0 or LocalPlayer().PS2_Wallet.points < self:GetParent().Bet then
			self:SetDisabled( true )
		else
			self:SetDisabled( false )
		end
	end
	function self.go.DoClick( )
		self:StartSpin( )
	end

	local label = vgui.Create( "DLabel", self )
	label:SetText( "Select Bet" )
	label:SetFont( self:GetSkin( ).SmallTitleFont )
	label:SizeToContents( )
	label:Dock( TOP )
	label:DockMargin( 0, 5, 0, 0 )
	label:SetColor( color_white )

	self.Bet = 10
	self:OnBetChanged( )
end

function PANEL:StartSpin( )
	Pointshop2.GamblingView:getInstance( ):startSpin( self.Bet )
	:Done( function( seeds, didWin, winAmount )
		if not IsValid( self ) then return end
		self.wonLabel:SetVisible( false )
		self.Spinning = true
		for i = 1, 3 do
			self.rows[i]:startSpin( seeds[i], i * 10 )
		end
		timer.Create( "PS2_Sound", 0.1, 15, function( )
			LocalPlayer():EmitSound( "garrysmod/balloon_pop_cute.wav", 50, 50 )
		end )
		timer.Simple( 1.8, function( )
			if IsValid( self ) then
				if didWin then
					if not Pointshop2.GetSetting( "Pointshop 2 DLC", "GamblingSettings.GlobalSound" ) then
						LocalPlayer():EmitSound( "slots_win.wav" )
					end

					self.wonLabel:SetVisible( true )
					self.wonLabel:SetText( "YOU WON " .. winAmount .. " POINTS!" )
				end
				self.Spinning = false
			end
		end )
	end )
	:Fail( function( err )
		if not IsValid( self ) then return end

		self.Spinning = false
		Derma_Message( err, "Error" )
	end )
end

function PANEL:OnBetChanged( )
	self.betLabel:SetText( "Bet: " .. self.Bet .. " points" )
end

function PANEL:PerformLayout( )
	self.rowContainer:PerformLayout( )
	self.rowContainer:DockMargin( ( self:GetWide( ) - self.rowContainer:GetWide( ) ) / 2, 0, ( self:GetWide( ) - self.rowContainer:GetWide( ) ) / 2 + 5, 0 )
end

function PANEL:GetBet( )
	return self.Bet
end

function PANEL:Paint( w, h )
end

vgui.Register( "DSlotsPanel", PANEL, "DPanel" )
