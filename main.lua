-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"

local xml = require("xml").newParser()

local sound = xml:loadFile( "content/sound.xml" )

soundData = {} 

for i=1,#sound.child do
         soundData[i] = sound.child[i]
end

local story = xml:loadFile( "content/story.xml" )

storyData = {} 

for i=1,#story.child do
         storyData[i] = story.child[i]
end

G = {
	money = 10000,

	redBean = 0,
	cream = 0,

	bait = { }, -- G.bait[1]:그냥 떡밥, G.bait[2]:팥 떡밥, G.bait[3]:슈 떡밥

	sound = {},
	bgm = {},
	soundVolume = 1,
	bgmVolume = 0.2,
	fontBold = "content/font/Maplestory Bold.ttf",
	fontLight = "content/font/Maplestory Light.ttf",

	index = 2
}
function resetG(  )
	G.money = 10000
	G.redBean = 5
	G.cream = 5
	for i = 1, 3 do
	G.bait[i] = 0
	end
end

resetG()

audio.setVolume(G.bgmVolume, { channel=1 })
audio.setVolume(G.soundVolume, {channel=2})
audio.setVolume(G.soundVolume, {channel=3})

for i = 1, #soundData[1].child do
	G.bgm[i] = audio.loadStream(soundData[1].child[i].value)
end

for i = 1, #soundData[2].child do
	G.sound[i] = audio.loadStream(soundData[2].child[i].value)
end

BGM_Options = {
	channel = 1,
	loops = -1
}

SOUND_Options = {
	channel = 2
}

function soundPlay( num )
	audio.stop( 2 )
	audio.play(G.sound[num], SOUND_Options)
end

function soundPlay2( num )
	audio.stop( 3 )
	audio.play(G.sound[num], {
	channel = 3
	}
)
end

function soundBGM( num )
	audio.stop( 1 )
	audio.play(G.bgm[num], BGM_Options)

end

-- event listeners for tab buttons:
local function onFirstView( event )
	composer.gotoScene( "start" )
end

onFirstView()	-- invoke first tab button's onPress event manually
