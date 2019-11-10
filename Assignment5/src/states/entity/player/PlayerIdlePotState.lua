--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdlePotState = Class{__includes = EntityIdleState}

function PlayerIdlePotState:init(player, dungeon)
    self.entity = player
    self.pot = dungeon.currentRoom.objects[2]

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('idle-' .. self.entity.direction .. '-pot')
end

function PlayerIdlePotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carry-pot')
    end

    -- if we want to throw the pot
    if love.keyboard.isDown('space') then
        self.pot.state = 'thrown-' .. self.entity.direction
        self.entity:changeState('walk')
        gSounds['pot-throw']:play()
    end

    -- track pot
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.entity.currentAnimation.currentFrame % 2 - 7
end