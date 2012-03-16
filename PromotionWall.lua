module(..., package.seeall)
local native = require("native")
local system = require("system")
local network = require("network")
local io = require("io")
local app_key= "577951021d0143c09d46696e5282e947"
local deviceID = system.getInfo( "deviceID" )
local model = system.getInfo( "model" )
local demo = "n"
local o = "landscape"
local baseURL = "http://crosspromote.appsperse.com/api?"
local queryListener
local lastTransaction
local webView

local function purchaseNetworkListener( event )
	
end

local function adShown( event )
	local customEvent = {hasAd=true, eventType="adShowing"}
	queryListener(customEvent)
end

local function startAdShowing( event )
	local customEvent = {hasAd=true, eventType="adStartShowing"}
	queryListener(customEvent)
end

local function networkListener( event )
	local customEvent = {hasAd=false, eventType="didReceiveResponse"}
	queryListener(customEvent)
	if ( event.isError ) then
		customEvent = {hasAd=false, eventType="responseError"}
		queryListener(customEvent)
	else
		local customEvent
		if nil ~= string.find( event.response, "Error" ) then
			customEvent = {hasAd=false, eventType="responseError"}
			queryListener(customEvent)
			return
		end
		customEvent = {hasAd=true, eventType="adServed"}
		queryListener(customEvent)
		local path = system.pathForFile( "wall.html", system.DocumentsDirectory )
		fh = io.open( path, "w" )
		fh:write(event.response)
		fh:flush()
		io.close()
		
	end
end

local function getWallRemote()
	o = "landscape"
	if nil ~= string.find(system.orientation, "landscape") then
		o = "landscape"
	end
	if nil ~= string.find(system.orientation, "portrait") then
		o = "portrait"
	end
	print(system.orientation)
	--o = "landscape"
	local customEvent = {hasAd=false, eventType="willRequestAd"}
	queryListener(customEvent)
	print(baseURL.."device_type="..model.."&device_mac="..deviceID.."&app_key="..app_key.."&promotion_type=wall&v=1.0b3&device_app_uuid="..deviceID.."&screen_orientation="..o.."&country=US&language=en&method=htmlpromotion&device_bundle_id=com.appsperse.Corona&demo_mode="..demo.."&device_id="..deviceID)
	network.request( baseURL.."device_type="..model.."&device_mac="..deviceID.."&app_key="..app_key.."&promotion_type=wall&v=1.0b3&device_app_uuid="..deviceID.."&screen_orientation="..o.."&country=US&language=en&method=htmlpromotion&device_bundle_id=com.appsperse.Corona&demo_mode="..demo.."&device_id="..deviceID.."&", "GET", networkListener )
end

local function listener( event )
        local url = event.url
		local customEvent
		if event.errorCode then
				customEvent = {hasAd=false, eventType="adShowingError"}
				queryListener(customEvent)
				webView:removeSelf()
				webView = nil
				return
		end
        if nil ~= string.find( url, "appsperse.com/api" ) then
				customEvent = {hasAd=true, eventType="adTap"}
				queryListener(customEvent)
				system.openURL(url)
				return
        end
		if nil ~= string.find( url, "appsperse.close" ) then
				customEvent = {hasAd=true, eventType="adClose"}
				queryListener(customEvent)
				webView:removeSelf()
				webView = nil
                return
        end
		transition.to( webView, { time=1000, alpha=1, delay=1000 ,onComplete=adShown, onStart=startAdShowing } )
		getWallRemote()
end

local function listener1( event )
        return true
end

function init(appKey, queryAdListner)
	app_key = appKey
	queryListener = queryAdListner
	getWallRemote()
end

function showWall()
	if webView ~= nil then
		return
	end
		
		xa = 0
		ya = 0
		ww = 320
		wh = 480
		--local options = { hasBackground=false, baseUrl=system.DocumentsDirectory, urlRequest=listener1 }
		--native.showWebPopup( 0, 0, 320, 480, 
		--                 "wall.html", 
		--                 options)
		webView = native.newWebView( xa, ya, ww, wh )
		webView.hasBackground = false
		webView.alpha = 0
		webView:request( "wall.html", system.DocumentsDirectory )
		webView:addEventListener( "urlRequest", listener )
end