local PANEL = {}

function PANEL:Init( )
	self.itemQueue = { }
	self.displayItems = { }
	self.scrollOffset = 0

	self.isSpinning = false
	self.lockedElement = 0 --element to lock to
	self.index = index --self.strip number(1-3)
	self.elementsPoped = 0 --number of elements removed from the random list


	--init, seeds are just time, actual seeds are sent when spinning
	self:generateRandomQueue( math.random( 1, 1000000000000000000000 ) )
	for i = 1, 4 do
		table.insert( self.displayItems, self:createNextImage( ) )
	end
end

function PANEL:startSpin( randomSeed, lockedElement )
	self.elementsPoped = -2 --we need to pop 2 more since the lock element should be in the middle
	self:generateRandomQueue( randomSeed )
	self.lockedElement = lockedElement
	self.isSpinning = true
end

function PANEL:generateRandomQueue( randomSeed )
	math.randomseed( randomSeed )
	--Create Queue of 50 elements(should be enough)
	self.itemQueue = { }
	for i = 1, 50 do
		table.insert( self.itemQueue, math.random( 1, Pointshop2.Gambling.CHOICECOUNT ) )
	end
end

function PANEL:createNextImage( )
	local chance = table.remove( self.itemQueue, 1 )
	self.elementsPoped = self.elementsPoped + 1
	local image = vgui.Create( "DImage", self )
	local itemNumber = Pointshop2.Gambling:GetItemNumberForChance( chance )
	image:SetImage( Pointshop2.Gambling.images[itemNumber] )
	image:SetSize( 64, 64 )
	image:SetPos( 0, -image:GetTall( ) )
	local oldP = image.Paint
	function image:Paint( w, h )
		draw.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50 ) )
		oldP( self, w - 2, h - 2 )
	end
	image.itemNumber = itemNumber
	return image
end

function PANEL:Think( )
	if self.isSpinning then
		self.scrollOffset = self.scrollOffset + 1500 * FrameTime( )
		if self.scrollOffset >= 64 then --last item scrolled out, insert new
			local old = table.remove( self.displayItems )
			old:Remove( )

			table.insert( self.displayItems, 1, self:createNextImage( ) )
			self.scrollOffset = 0
			if self.elementsPoped == self.lockedElement then
				self.isSpinning = false
			end
		end
	end

	for k, v in pairs( self.displayItems ) do
		local idx = k - 1
		local yPos = -64 + idx * 64 + self.scrollOffset
		if idx > 1 then
			yPos = yPos + 10 * ( idx - 1 )
		end
		local x, y = v:GetPos( )
		v:SetPos( x, yPos )
	end
end

function PANEL:Paint( w, h )
	--draw.RoundedBox( 6, 0, 0, w, h, Color( 120, 120, 120 ) )
end

vgui.Register( "DSlotStrip", PANEL, "DPanel" )
