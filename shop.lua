-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

function scene:create( event )
   local sceneGroup = self.view
	soundBGM(5)

  local UI = display.newGroup()

	local image = display.newImageRect( UI, "icon/backgroundmarket.png", 1920, 1080 )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	
	local moneyback = display.newCircle(UI, display.contentWidth*0.85, display.contentHeight/8, 95)
	moneyback.path.radius = 120
	transition.to( moneyback.path, { time=2000, radius=100 } )
	moneyback:setFillColor(1,1,1,0.75)
   
  local showMoney = display.newText(UI, G.money, display.contentWidth*0.85, display.contentHeight/8, G.fontLight)
  showMoney:setFillColor(0.5, 0.5, 1)
  showMoney.size = 80

  sceneGroup:insert(UI)

  local ddukbabNumLayer = {}
  local ddukbabNum = {}
  local dduk = {}

  local layer = display.newRoundedRect(UI, display.contentWidth*0.06, display.contentHeight*0.6, 200, 500, 55)
  layer:setFillColor(0)
  layer.alpha = 0.5

  dduk[1] = display.newImage(UI, "icon/ddukbab.png",100, 500)
  dduk[2] = display.newImage(UI, "icon/ddukbab_redbean.png", 110, 650)
  dduk[3] = display.newImage(UI, "icon/ddukbab_cream.png",120 ,800)
  ddukbabNumLayer[1] = display.newRoundedRect(UI, dduk[1].x + 50, dduk[1].y + 50, 60, 60, 50)
  ddukbabNumLayer[2] = display.newRoundedRect(UI, dduk[2].x + 50, dduk[2].y + 50, 60, 60, 50)
  ddukbabNumLayer[3] = display.newRoundedRect(UI, dduk[3].x + 50, dduk[3].y + 50, 60, 60, 50)
   
  for i = 1, 3 do
    ddukbabNumLayer[i]:setFillColor( 0.45,0.35,0.25 )
    ddukbabNum[i] = display.newText(UI, G.bait[i], ddukbabNumLayer[i].x, ddukbabNumLayer[i].y, G.fontBold, 40)
    --ddukbabNum[i].text = G.bait[i] + 1
  end
  
   --나가기

   -- Function to handle button events
   --팥구입
   local function rBuy(  )    
  		 soundPlay( 11 )		 
         print( "팥떡밥구매" )
 		 G.money = G.money - 500
		 if (G.money + 500 > 0 and G.money + 500 < 500) then
 		 	G.money = G.money + 500
 		 	showMoney.text = G.money       
		 	soundPlay( 7 )
			native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
        	G.bait[2] = G.bait[2] - 1
		 elseif (G.money < 0) then
		 G.money = G.money - 500
	    	G.money = 0
	        showMoney.text = G.money           
 			soundPlay( 7 )
		 	native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
        	G.bait[2] = G.bait[2] - 1
		 end
         showMoney.text = G.money
         G.bait[2] = G.bait[2] + 1
         print(G.bait[2])
     ddukbabNum[2].text = G.bait[2]
   end
    
   local redB = widget.newButton(
       {
           width = 400,
           height = 300,
           defaultFile = "icon/ddukbab_redbean.png",
           overFile = "icon/openred.png",
           onRelease = rBuy
       }
   )
   redB.x, redB.y = display.contentWidth*0.59, display.contentHeight/2.3
   sceneGroup:insert(redB)

	--슈구입
   local function cBuy(  )    
  		 soundPlay( 11 )		 
         print( "슈떡밥구매" )
 		 G.money = G.money - 500
		 if (G.money + 500 > 0 and G.money + 500 < 500) then
 		 	G.money = G.money + 500
 		 	showMoney.text = G.money       
		 	soundPlay( 7 )
			native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
 	        G.bait[3] = G.bait[3] - 1
		 elseif (G.money < 0) then
		 G.money = G.money - 500
	    	G.money = 0
	        showMoney.text = G.money           
 			soundPlay( 7 )
		 	native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
    	    G.bait[3] = G.bait[3] - 1
		 end
         showMoney.text = G.money
         G.bait[3] = G.bait[3] + 1
         print(G.bait[3])
         ddukbabNum[3].text = G.bait[3]
   end

   local creaM = widget.newButton(
       {
           width = 400,
           height = 300,
           defaultFile = "icon/ddukbab_cream.png",
           overFile = "icon/opencream.png",
           onRelease = cBuy
       }
   )
   creaM.x, creaM.y = display.contentWidth*0.73, display.contentHeight/1.62
   sceneGroup:insert(creaM)

   --기본구입
   local function nBuy(  )    
 		 soundPlay( 11 )
         print( "기본떡밥구매" )
		 G.money = G.money - 300
 		 if(G.money + 300 > 0 and G.money + 300 < 300) then
 		 	G.money = G.money + 300
 		 	showMoney.text = G.money       
		 	soundPlay( 7 )
			native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
        	G.bait[1] = G.bait[1] - 1

 		 elseif (G.money < 0) then
	    	G.money = 0
	        showMoney.text = G.money
		 	soundPlay( 7 )
			native.showAlert( "‼이런‼", "💰돈이 부족해요💰", {"돈벌러가기💨"}, out )
        	G.bait[1] = G.bait[1] - 1
		 end
         showMoney.text = G.money  
         G.bait[1] = G.bait[1] + 1
         print(G.bait[1])
         ddukbabNum[1].text = G.bait[1]

    end         
   local normal = widget.newButton(
       {
           width = 400,
           height = 300,
           defaultFile = "icon/ddukbab.png",
           overFile = "icon/opendduck.png",
           onRelease = nBuy
       }
   )
   normal.x, normal.y = display.contentWidth*0.87, display.contentHeight/1.24
   sceneGroup:insert(normal)
   --나가기

   local function out( )
	  	soundPlay( 1 )
     	composer.gotoScene("mainGame")
   end

   local outButton = widget.newButton( 
   		{	
	   		width = 325, 
	   		height = 113, 
	   		defaultFile = "icon/back.png", 
	   		overFile = "icon/back2.png", 
	   		onRelease = out
	   	}
	)
   outButton.x, outButton.y = display.contentWidth*0.15, display.contentHeight/8
   sceneGroup:insert(outButton)

end

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
      composer.removeScene("shop")
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