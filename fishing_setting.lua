-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local function fishingStart(  )
  soundPlay( 7 )
  composer.gotoScene("fishing")
  FishStart = 1
end

local UI = display.newGroup()

function scene:create( event )
  local sceneGroup = self.view
  
  local window = display.newRoundedRect(UI, display.contentWidth/2, display.contentHeight/2, display.contentWidth/2, display.contentHeight/2, 55)
  window:setFillColor(0.4,0.3,0.2)
  window:setStrokeColor( 0.5,0.4,0.3 )
  window.strokeWidth = 15

  local windowName = display.newText(UI, "무슨 떡밥을 쓸까?", display.contentWidth/2, display.contentHeight/2 - 200, G.fontBold, 60)
  windowName:setFillColor(1,0.95,0.9)

  local showRedBeanNum = display.newText(UI, G.redBean, display.contentWidth*0.85+100, display.contentHeight*0.25 - 60,
  G.fontBold, 60)
  local showCreamNum = display.newText(UI, G.cream, display.contentWidth*0.85+100, display.contentHeight*0.25 + 60,
  G.fontBold, 60)

  sceneGroup:insert(UI)

end

function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   
   if phase == "will" then
      -- Called when the scene is still off screen and is about to move on screen
   elseif phase == "did" then
      local buttonUI = {}
      for i = 1, 3 do
         buttonUI[i] = display.newGroup()
      end
      local button = {}
      local ddukbab = {}
      local ddukbabOPEN = {}
      local ddukbabName = {}
      local ddukbabNumLayer = {}
      local ddukbabNum = {}

      setX, setY = display.contentWidth*0.5 - 500, display.contentHeight*0.46

      for i = 1, 3 do
        button[i] = display.newRoundedRect( buttonUI[i], setX + 250*i, setY, 200, 200, 50)
        button[i]:setFillColor(0.6,0.5,0.4)
        button[i]:setStrokeColor( 0.5,0.4,0.3 )
        button[i].strokeWidth = 10
        ddukbabName[i] = display.newText(UI, "", button[i].x, setY + 150, G.fontLight, 45)
        ddukbabName[i]:setFillColor(1,0.95,0.9)
        ddukbabNumLayer[i] = display.newRoundedRect( buttonUI[i], button[i].x+70, setY+80, 60, 60, 50)
        ddukbabNumLayer[i]:setFillColor( 0.45,0.35,0.25 )
      end
      
      ddukbabName[1].text = "그냥 떡밥"
      ddukbab[1] = display.newImage( buttonUI[1], "icon/ddukbab.png")
      ddukbabOPEN[1] = display.newImage( buttonUI[1], "icon/opendduck.png")


      ddukbabName[2].text = "팥 떡밥"
      ddukbab[2] = display.newImage( buttonUI[2], "icon/ddukbab_redbean.png")
      ddukbabOPEN[2] = display.newImage( buttonUI[2], "icon/openred.png")

      ddukbabName[3].text = "슈 떡밥"
      ddukbab[3] = display.newImage( buttonUI[3], "icon/ddukbab_cream.png")
      ddukbabOPEN[3] = display.newImage( buttonUI[3], "icon/opencream.png")

      sceneGroup:insert(UI)

      for i = 1, 3 do
        ddukbabNum[i] = display.newText(buttonUI[i], G.bait[i], ddukbabNumLayer[i].x, ddukbabNumLayer[i].y, G.fontBold, 40)
        ddukbab[i].x, ddukbab[i].y = button[i].x, setY
        ddukbabOPEN[i].x, ddukbabOPEN[i].y = ddukbab[i].x, ddukbab[i].y
        buttonUI[i].name = i
        ddukbabOPEN[i].alpha = 0
        sceneGroup:insert(buttonUI[i])
      end

      local function press( num )
         if is_bait[num] == 0 then
            if G.bait[num] ~= 0 then
              soundPlay( 7 )
              is_bait[num] = 1
              button[num]:setFillColor(0.5,0.4,0.3)
              button[num]:setStrokeColor( 0.6,0.5,0.4 )
              ddukbab[num].alpha = 0
              ddukbabOPEN[num].alpha = 1
              G.bait[num] = G.bait[num] - 1
              ddukbabNum[num].text = G.bait[num]
            else
              soundPlay( 11 )
            end
          else
            soundPlay( 7 )
            is_bait[num] = 0
            button[num]:setFillColor(0.6,0.5,0.4)
            button[num]:setStrokeColor( 0.5,0.4,0.3 )
            ddukbab[num].alpha = 1
            ddukbabOPEN[num].alpha = 0
            G.bait[num] = G.bait[num] + 1
            ddukbabNum[num].text = G.bait[num]
         end
      end

      local function tapButton( event )
          press( event.target.name )
      end

      for i = 1, 3 do
          buttonUI[i]:addEventListener("tap", tapButton)
      end

      local startTap = widget.newButton(
          {
              shape = "roundedRect",
              width = 300,
              height = 80,
              cornerRadius = 2,
              fillColor = { default={0.7,0.6,0.5}, over={0.6,0.5,0.4} },
              strokeColor = { default={0.8,0.7,0.6}, over={1,0.95,0.9} },
              strokeWidth = 10,
              onRelease = fishingStart
          }
      )
      startTap.x, startTap.y = display.contentWidth*0.5, display.contentHeight*0.68
      local startText = display.newText("낚시 시작", startTap.x, startTap.y, G.fontBold, 60)
      sceneGroup:insert(startTap)
      sceneGroup:insert(startText)
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
      composer.hideOverlay("fishing_setting")
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