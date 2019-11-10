--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerCarryPotState = Class{__includes = EntityWalkState}

function PlayerCarryPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.pot = self.dungeon.currentRoom.objects[2]

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerCarryPotState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left-pot')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right-pot')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up-pot')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down-pot')
    else
        self.entity:changeState('idle-pot')
    end

    -- if we want to throw the pot
    if love.keyboard.isDown('space') then
        self.pot.state = 'thrown-' .. self.entity.direction
        self.entity:changeState('walk')
        gSounds['pot-throw']:play()
    end


    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- track pot
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.entity.currentAnimation.currentFrame % 2 - 7
end