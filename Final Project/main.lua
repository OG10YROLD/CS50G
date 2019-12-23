--[[
	GD50 Final project
	Pixel Platformer

	Author: Ali Juma
	ali@mjuma.com

	-- Credits --
	Logo: Me
	Graphics: Me
	Collision Detection Library: https://github.com/kikito/bump.lua
	Title Music: https://youtu.be/QQZwRiPwci0
	Play Music: https://youtu.be/S3S2nw02NJs
	SFX: Bfxr
	Font: https://www.fontspace.com/codeman38/press-start-2p
]]

push = require 'lib/push'
Class = require 'lib/class'
bump = require 'lib/bump'

require 'src/defs'
require 'src/classes/Platform'
require 'src/classes/Enemy'
require 'src/classes/Player'
require 'src/classes/End'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/TitleState'
require 'src/states/PlayState'
require 'src/states/EndState'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 768
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 224

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle('Pixel Platformer')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

	font = love.graphics.newFont('fonts/font.ttf', 8)
	bigFont = love.graphics.newFont('fonts/font.ttf', 24)
	love.graphics.setFont(font)

	gSounds = {
		['title'] = love.audio.newSource('sounds/Title.wav'),
		['play'] = love.audio.newSource('sounds/Play.wav'),
		['enemy'] = love.audio.newSource('sounds/enemy.wav'),
		['jump'] = love.audio.newSource('sounds/jump.wav')
	}
	gSounds['title']:setLooping(true)
	gSounds['play']:setLooping(true)

	gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
		['end'] = function() return EndState() end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key)
	love.keyboard.keysPressed[key] = false
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
	gStateMachine:update(dt)
end

function love.draw()
	push:start()
	gStateMachine:render()
	push:finish()
end

function getLevel()
	love.filesystem.setIdentity('pixelplatformer')
	if not love.filesystem.exists('platformer.lst') then
		love.filesystem.write('platformer.lst', '1')
	end
	return tonumber(love.filesystem.read('platformer.lst'), nil)
end

function setLevel(level)
	love.filesystem.setIdentity('pixelplatformer')
	if not love.filesystem.exists('platformer.lst') then
		love.filesystem.write('platformer.lst', '1')
	end
	love.filesystem.write('platformer.lst', tostring(level))
end