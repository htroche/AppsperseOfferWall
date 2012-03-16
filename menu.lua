-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

local function queryAdListener( event )
	if( event.hasAd ) then
		print ("Ad filled")
	end
	if nil ~= string.find( event.eventType, "didReceiveResponse" ) then
		print ("The system received a network response from the ad network")
		--native.setActivityIndicator( false );
	end
	if nil ~= string.find( event.eventType, "responseError" ) then
		print ("There was a network problem")
		--native.setActivityIndicator( false );
	end
	if nil ~= string.find( event.eventType, "willRequestAd" ) then
		print ("About to send a network request for an ad")
		--native.setActivityIndicator( true );
	end
	if nil ~= string.find( event.eventType, "adShowing" ) then
		print ("The ad is showing")
	end
	if nil ~= string.find( event.eventType, "adStartShowing" ) then
		print ("The ad is going to show")
	end
	if nil ~= string.find( event.eventType, "adShowingError" ) then
		print ("There was an error showing the ad")
	end
	if nil ~= string.find( event.eventType, "adTap" ) then
		print ("The user tapped the ad")
	end
	if nil ~= string.find( event.eventType, "adClose" ) then
		print ("The user closed the ad")
	end
end


appsperseAd = require("PromotionWall")
appsperseAd.init("b971c35a66da405999a42ddf4142260c", queryAdListener)

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	appsperseAd.showWall()
	-- go to level1.lua scene
	--storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:

function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene