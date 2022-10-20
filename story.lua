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
	soundBGM( 4 )

	local UIGroup = display.newGroup()
	local UI = {}

	UI[0] = display.newRect(UIGroup, display.contentWidth/2, display.contentHeight/2, display.contentWidth,display.contentHeight)
	UI[0]:setFillColor(0.5,0.7,0.8)
	UI[1] = display.newImage(UIGroup, "icon/settingback.png")
	UI[1].x, UI[1].y = display.contentWidth*0.5, display.contentHeight*0.5
	UI[2] = display.newRoundedRect(UIGroup, display.contentWidth/2, display.contentHeight/2, display.contentWidth*0.8, display.contentHeight*0.95, 70)
	UI[2]:setFillColor(1)

	local page = display.newGroup()
	local j = 1
	local s = {}
	G.index = 2

	local function story( event )
		if storyData[G.index].child[j].properties["type"] == "image" then
			s[j] = display.newImage(page, storyData[G.index].child[j].value)
			s[j].x, s[j].y = display.contentWidth/2, display.contentHeight/2
			j = j + 1
		elseif storyData[G.index].child[j].properties["type"] == "script" then
			local x = tonumber(storyData[G.index].child[j].properties["x"])
			local y = tonumber(storyData[G.index].child[j].properties["y"])
			local width = tonumber(storyData[G.index].child[j].properties["width"])
			local height = tonumber(storyData[G.index].child[j].properties["height"])

			local tempString = storyData[G.index].child[j].value
			local typingCount = 1
			local typingS = {}
			local function typing_m(event)
				display.remove(typingS)
				typingS = display.newText(page, tempString:sub(1, typingCount), x, y, width, height,
				G.fontLight, 30)
				typingS.anchorX = 0
				typingS:setFillColor(0.2)

				typingCount = typingCount + 1
			end
			timer.performWithDelay(1, typing_m, #tempString)
			j = j + 1
		elseif storyData[G.index].child[j].properties["type"] == "end" then
			composer.gotoScene("start")
		else
			print("?")
		end
	end
	
	UIGroup:addEventListener("tap", story)

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
		composer.removeScene("story")
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