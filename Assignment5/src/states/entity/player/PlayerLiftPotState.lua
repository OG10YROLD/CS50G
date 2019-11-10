--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftPotState = Class{__includes = EntityIdleState}

function PlayerLiftPotState:init(player, dungeon)
    self.entity = player
    self.pot = dungeon.currentRoom.objects[2]

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('lift-pot-' .. self.entity.direction)
    -- we tween the pot's y and x value to ours
    self.tween = Timer.tween(self.entity.currentAnimation.interval * 3, {
        [self.pot] = {y = self.entity.y - 8, x = self.entity.x}
    })
    :finish(function()
        self.entity:changeState('idle-pot')
    end)
end

function PlayerLiftPotState:update(dt)
    self.tween:update(dt)
end