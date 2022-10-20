-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------
local widget = require ("widget")
local composer = require("composer")
local scene = composer.newScene()

	local bgmNum = composer.getVariable(bgmNum)

	--local vText = display.newText("SETTINGS", 600 ,250, "font/crazy_ras", 130)

function scene:create( event )
	local sceneGroup = self.view

	local UI = display.newGroup()

	local background = display.newImage( UI, "icon/settingback.png" )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2


	local settings = {}
	settings["fxvolume"] = 0.5
	settings["bgvolume"] = 0.5

	
	-- Audio setup
	--audio.reserveChannels(1)

	--audio.setVolume( settings["bgvolume"], { channel=1 } )
	--audio.play( backgroundSound, { channel=1, loops=-1, fadein=1000 }  )


	-- Background volume label
	local bgLabel = display.newText("배경 음악",display.contentWidth/2, display.contentHeight*0.4, G.fontBold, 100)
	bgLabel:setFillColor( 0.4 )
	UI:insert(bgLabel)

	local settingUI = {}

	settingUI[1] = display.newText(UI, "배경 음악", display.contentWidth*0.32, display.contentHeight*0.55, G.fontLight, 50)
	settingUI[1].anchorX = 0
	settingUI[1]:setFillColor(0)
	settingUI[2] = display.newRoundedRect(UI, display.contentWidth*0.57, display.contentHeight*0.55, 500, 40, 55)
	settingUI[2]:setFillColor(1)
	settingUI[2].alpha = 0.7

	settingUI[3] = display.newText(UI, "효과음", display.contentWidth*0.32, display.contentHeight*0.65, G.fontLight, 50)
	settingUI[3].anchorX = 0
	settingUI[3]:setFillColor(0)
	settingUI[4] = display.newRoundedRect(UI, display.contentWidth*0.57, display.contentHeight*0.65, 500, 40, 55)
	settingUI[4]:setFillColor(1)
	settingUI[4].alpha = 0.7

	local volumeUI = {}

	volumeUI[1] = display.newRoundedRect(UI, display.contentWidth*0.55, display.contentHeight*0.55, 55, 40, 45)
	volumeUI[1]:setFillColor(1, 0.2, 0.2)
	volumeUI[1].alpha = 0.6
	volumeUI[2] = display.newRoundedRect(UI, display.contentWidth*0.55, display.contentHeight*0.65, 55, 40, 45)
	volumeUI[2]:setFillColor(1, 0.2, 0.2)
	volumeUI[2].alpha = 0.6

	volumeUI[1].name = "bgm"
	volumeUI[2].name = "sound"


	local high = display.contentWidth*0.685
	local low = display.contentWidth*0.455

	volumeUI[1].x = low + (high - low)*G.bgmVolume
	volumeUI[2].x = low + (high - low)*G.soundVolume

	local function setVolume( event )
		local volume
		if ( event.phase == "began" ) then
	        display.getCurrentStage():setFocus( event.target )
	        event.target.xStart = event.target.x
	        soundPlay(1)
	    event.target.isFocus = true
	 
	    elseif ( event.phase == "moved" ) then -- 드래그
	        if ( event.target.isFocus ) then
	        	event.target.x = event.target.xStart + event.xDelta
            	if event.target.x > high  then
    	       		event.target.x = high
            	elseif event.target.x < low then
            		event.target.x = low
            	end
	        end
	        volume = math.floor(event.target.x/((high - low)/100)+0.5)/100 - 1.98

	        if event.target.name == "bgm" then
	        	G.bgmVolume = volume
		        audio.setVolume(G.bgmVolume, { channel=1 })
		    else
		    	G.soundVolume = volume
				audio.setVolume(G.soundVolume, {channel=2})
				audio.setVolume(G.soundVolume, {channel=3})
			end
	    elseif (event.phase == "ended") then
	    	if ( event.target.isFocus ) then
	    		soundPlay(2)
	    		if event.target.name == "bgm" then
	        		print(event.target.name.." 음량이 "..G.bgmVolume.."으로 조정되었습니다.")
			    else
					print(event.target.name.." 음량이 "..G.soundVolume.."으로 조정되었습니다.")
				end
            	display.getCurrentStage():setFocus( nil )
        		event.target.isFocus = false
	        end
	        display.getCurrentStage():setFocus( nil )
	        event.target.isFocus = false
	    end
	end

	volumeUI[1]:addEventListener("touch", setVolume)
	volumeUI[2]:addEventListener("touch", setVolume)
	
	local function backButton( event )    
      	soundPlay(7)
      	composer.hideOverlay("setting")
   	end

   local outButton = widget.newButton( 
   		{	
	   		width = 235*1.5, height = 82*1.5,
	   		left = -1000,
	   		defaultFile = "icon/back.png", 
	   		overFile = "icon/back2.png", 
	   		onRelease = backButton
	   	}
	)	
   outButton.x, outButton.y = display.contentWidth*0.1, display.contentHeight*0.1
   UI:insert(outButton)

   sceneGroup:insert(UI)
end
--then you have to center it: 

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.hideOverlay("setting")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene