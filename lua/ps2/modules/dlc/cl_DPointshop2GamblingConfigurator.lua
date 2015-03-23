local PANEL = {}

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	self:SetTitle( "Pointshop2 Gambling Settings" )
	self:SetSize( 300, 600 )
	
	self:AutoAddSettingsTable( { GamblingSettings = Pointshop2.GetModule( "Pointshop 2 DLC" ).Settings.Shared.GamblingSettings }, self )
end

function PANEL:DoSave( )
	Pointshop2View:getInstance( ):saveSettings( self.mod, "Shared", self.settings )
end

derma.DefineControl( "DPointshop2GamblingConfigurator", "", PANEL, "DSettingsEditor" )