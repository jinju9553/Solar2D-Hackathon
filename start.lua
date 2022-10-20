-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	soundBGM( 1 )

	local UIGroup = display.newGroup()

	local UI = { }

	UI[1] = display.newImage(UIGroup,"icon/first.png")
	UI[1].x, UI[1].y = display.contentWidth/2, display.contentHeight/2

	UI[2] = display.newImageRect(UIGroup,"icon/start.png", 550, 200)
	UI[2].x, UI[2].y = display.contentWidth*0.85, display.contentHeight*0.65

	UI[3] = display.newImageRect(UIGroup,"icon/howto.png", 550, 200)
	UI[3].x, UI[3].y = display.contentWidth*0.85, display.contentHeight*0.85
	
	local function tapStart( event )
		soundPlay( 7 )
		composer.gotoScene( "mainGame" )
	end

	local function tapHowto( event )
		soundPlay( 7 )
		composer.gotoScene( "howto" )
	end

	UI[4] = display.newImageRect(UIGroup,"icon/gosetting.png", 300*1.5, 120*1.5)
	UI[4].x, UI[4].y =  display.contentWidth*0.15, display.contentHeight*0.85

	local options = {	isModal = true	}

	local function goSetting( event )
		soundPlay( 7 )
		composer.showOverlay("setting", options)
	end

	UI[4]:addEventListener("tap", goSetting)

	UI[2]:addEventListener("tap", tapStart)
	UI[3]:addEventListener("tap", tapHowto)

	sceneGroup:insert(UIGroup)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		
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
		composer.removeScene("start", true)
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