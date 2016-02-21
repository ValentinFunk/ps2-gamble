local PANEL = {}

function PANEL:Init( )
	self:DockPadding( 10, 10, 10, 10 )
	self:SetSkin( Pointshop2.Config.DermaSkin )

	self.left = vgui.Create( "DPanel", self )
	self.left:Dock( LEFT )
	self.left:DockMargin( 0, 0, 5, 0 )
	self.left:DockPadding( 10, 5, 10, 5 )
	Derma_Hook( self.left, "Paint", "Paint", "InnerPanel" )

	self.left.label = vgui.Create( "DLabel", self.left )
	self.left.label:SetText( "Slots" )
	self.left.label:SizeToContents( )
	self.left.label:Dock( TOP )
	self.left.label:DockMargin( 0, 0, 0, 5 )

	self.slots = vgui.Create( "DSlotsPanel", self.left )
	self.slots:Dock( FILL )

	self.right = vgui.Create( "DPanel", self )
	self.right:Dock( RIGHT )
	self.right:DockMargin( 5, 0, 0, 0 )
	self.right:DockPadding( 10, 5, 10, 5 )
	Derma_Hook( self.right, "Paint", "Paint", "InnerPanel" )

	self.right.label = vgui.Create( "DLabel", self.right )
	self.right.label:SetText( "Rewards" )
	self.right.label:SizeToContents( )
	self.right.label:Dock( TOP )
	self.right.label:DockMargin( 0, 0, 0, 5 )

	self.rewardsPanel = vgui.Create( "DScrollPanel", self.right ) -- Set to scroll panel
	self.rewardsPanel:DockMargin( 5, 5, 5, 5 )
	self.rewardsPanel:Dock( FILL )
	self.rewardsPanel:DockPadding( 5, 5, 5, 5 )
--	self.rewardsPanel:SetTall( 50 * 8 + 30 ) -- Drawing it in the rect below
	function self.rewardsPanel:Paint( w, h )
		surface.SetDrawColor( self:GetSkin( ).ButtonColor )
		surface.DrawRect( 0, 0, w, 50 * 8 + 30 ) -- Changed the height for the scroll panel
	end
	self:InitRewardsPanel( )
end

function PANEL:InitRewardsPanel( )
	for i = 1, #Pointshop2.Gambling.images do
		local panel = vgui.Create( "DPanel", self.rewardsPanel )
		panel:SetSize( 100, 50 )
		function panel:Paint( w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 60, 60, 60 ) )
		end
		panel:Dock( TOP )
		panel:DockMargin( 10, 10, 10, 0 )

		local pnl = vgui.Create( "DPanel", panel )
		pnl.Paint = function( ) end
		pnl:Dock( LEFT )
		pnl:DockMargin( 5, 5, 5, 5 )
		pnl:SetSize( 32 + 10 )

		local image = vgui.Create( "DImage", pnl )
		image:SetImage( Pointshop2.Gambling.images[i] )
		image:SetSize( 32, 32 )
		function pnl.PerformLayout( )
			image:SetPos( ( pnl:GetWide( ) - image:GetWide( ) ) / 2, ( pnl:GetTall( ) - image:GetTall( ) ) / 2, 0, 0 )
		end
		local oldP = image.Paint
		function image:Paint( w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50 ) )
			oldP( self, w - 2, h - 2 )
		end

		local label = vgui.Create( "DLabel", panel )
		function label.Think( )
			label:SetText( "x3 = " .. self:GetBet( ) * Pointshop2.Gambling.WinMultiplier[i] .. " points" )
		end
		label:SetColor( Color( 255, 255, 255, 255 ) )
		label:DockMargin( 5, 0, 0, 0 )
		label:Dock( FILL )
		label:SetFont( self:GetSkin().fontName )
		label:SetColor( self:GetSkin().Colours.Label.Bright )
		label:SizeToContents( )
	end

	local panel = vgui.Create( "DPanel", self.rewardsPanel )
	panel:SetSize( 100, 60 ) -- Had to change height so that it would look nice in the scroll panel
	function panel:Paint( w, h )
		draw.RoundedBox( 2, 0, 0, w, h-10, Color( 60, 60, 60 ) ) -- Of course -10 pixels because we made it 10 more above
	end
	panel:Dock( TOP )
	panel:DockMargin( 10, 10, 10, 10 ) -- make it look like all other panels

	local pnl = vgui.Create( "DPanel", panel )
	pnl.Paint = function( ) end
	pnl:Dock( LEFT )
	pnl:DockMargin( 5, 5, 5, 5 )
	pnl:SetSize( 32 + 10 )

	local image = vgui.Create( "DImage", pnl )
	image:SetImage( "pointshop2/info20.png" )
	image:SetSize( 32, 32 )
	function pnl.PerformLayout( )
		image:SetPos( ( pnl:GetWide( ) - image:GetWide( ) ) / 2, (( pnl:GetTall( ) - image:GetTall( ) ) - 10) / 2, 0, 0 ) -- Had to change the pos of this to align correctly since we add 10 height
	end
	local oldP = image.Paint
	function image:Paint( w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50 ) )
		oldP( self, w - 2, h - 2 )
	end

	local label = vgui.Create( "DLabel", panel )
	label:SetText( "Align three of the same symbols in \nthe center row to win!" ) -- moved the \n over a word because it was butchering "the" lol
	label:SetColor( Color( 255, 255, 255, 255 ) )
	label:DockMargin( 5, 0, 0, 0 )
	label:SetPos( 32 + 20, 5 ) -- Centered this just right
	label:SetFont( self:GetSkin().fontName )
	label:SetColor( self:GetSkin().Colours.Label.Bright )
	label:SizeToContents( )
end

function PANEL:GetBet( )
	return self.slots:GetBet( )
end

function PANEL:ApplySchemeSettings( )
	self.left.label:SetColor( self:GetSkin( ).Colours.Label.Bright )
	self.left.label:SetFont( self:GetSkin( ).TabFont )
	self.left.label:SizeToContents( )

	self.right.label:SetColor( self:GetSkin( ).Colours.Label.Bright )
	self.right.label:SetFont( self:GetSkin( ).TabFont )
	self.right.label:SizeToContents( )
end

function PANEL:PerformLayout( )
	if not self.left or not self.right then return end
	self.left:SetWide( self:GetWide( ) / 2 - 15 )
	self.right:SetWide( self:GetWide( ) / 2 - 15 )
end

function PANEL:Paint()
end

vgui.Register( "DSlotsTab", PANEL, "DPanel" )
Pointshop2:AddInventoryPanel( "Gambling", "pointshop2/dollar103.png", "DSlotsTab" )
