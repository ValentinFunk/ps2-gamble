Pointshop2.GamblingView = class( "Pointshop2.GamblingView" )
Pointshop2.GamblingView.static.controller = "Pointshop2.GamblingController" 
Pointshop2.GamblingView:include( BaseView )

function Pointshop2.GamblingView:startSpin( bet )
	return self:controllerTransaction( "startSpin", bet )
end