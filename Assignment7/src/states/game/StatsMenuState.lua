--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StatsMenuState = Class{__includes = BaseState}

function StatsMenuState:init(pokemon, statsIncrease)
	self.menu = Menu {
        x = 200,
        y = 0,
        offsetY = -8,
        width = 184,
        height = 96,
        items = {
            {text = 'HP: ' .. pokemon.HP - statsIncrease[1] .. ' + ' .. statsIncrease[1] .. ' = ' .. pokemon.HP},
            {text = 'Attack: ' .. pokemon.attack - statsIncrease[2] .. ' + ' .. statsIncrease[2] .. ' = ' .. pokemon.attack},
            {text = 'Defense: ' .. pokemon.defense - statsIncrease[3] .. ' + ' .. statsIncrease[3] .. ' = ' .. pokemon.defense},
            {text = 'Speed: ' .. pokemon.speed - statsIncrease[4] .. ' + ' .. statsIncrease[4] .. ' = ' .. pokemon.speed}
        },
        font = gFonts['tiny'],
        cursor = false,
        onSelect = function()
            self:exitMenu()
        end
    }
end

function StatsMenuState:update(dt)
	self.menu:update(dt)
end

function StatsMenuState:render()
	self.menu:render()
end

function StatsMenuState:exitMenu()
	-- fade in
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1, 
    function()

        -- resume field music
        gSounds['victory-music']:stop()
        gSounds['field-music']:play()

        -- pop off ourselves
        gStateStack:pop()

        -- pop off the level up dialogue
		gStateStack:pop()

		-- pop off the battle state
	    gStateStack:pop()

	    gStateStack:push(FadeOutState({
	        r = 255, g = 255, b = 255
	    }, 1, function() end))
    end))
end