--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

-- initialize our medal images
local MEDAL_BRONZE_IMAGE = love.graphics.newImage('bronze.png')
local MEDAL_SILVER_IMAGE = love.graphics.newImage('silver.png')
local MEDAL_GOLD_IMAGE = love.graphics.newImage('gold.png')

MEDAL_WIDTH = 51
MEDAL_HEIGHT = 85

SPACE_BETWEEN_MEDALS = 20

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= 2 then
        love.graphics.draw(MEDAL_BRONZE_IMAGE, VIRTUAL_WIDTH / 2 - (MEDAL_WIDTH * 1.5) - SPACE_BETWEEN_MEDALS, 120, 0, 0.25, 0.25)
    end
    if self.score >= 4 then
        love.graphics.draw(MEDAL_SILVER_IMAGE, VIRTUAL_WIDTH / 2 - (MEDAL_WIDTH * 0.5), 120, 0, 0.25, 0.25)
    end
    if self.score >= 6 then
        love.graphics.draw(MEDAL_GOLD_IMAGE, VIRTUAL_WIDTH / 2 + (MEDAL_WIDTH * 0.5) + SPACE_BETWEEN_MEDALS, 120, 0, 0.25, 0.25)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 210, VIRTUAL_WIDTH, 'center')
end