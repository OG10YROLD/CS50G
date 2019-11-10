--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
    self.consumed = false

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.scaleX = def.scaleX
    self.scaleY = def.scaleY

    -- default empty collision callback
    self.onCollide = function() end

    -- timer used to calculate a thrown pot
    self.timer = 0
end

function GameObject:update(dt)
    if self.type == 'pot' and self.state == 'thrown-left' then
        self.timer = self.timer + dt
        self.x = self.x - TILE_SIZE * dt * 4
    elseif self.type == 'pot' and self.state == 'thrown-right' then
        self.timer = self.timer + dt
        self.x = self.x + TILE_SIZE * dt * 4
    elseif self.type == 'pot' and self.state == 'thrown-up' then
        self.timer = self.timer + dt
        self.y = self.y - TILE_SIZE * dt * 4
    elseif self.type == 'pot' and self.state == 'thrown-down' then
        self.timer = self.timer + dt
        self.y = self.y + TILE_SIZE * dt * 4
    elseif self.type == 'pot' and self.state == 'broken' then
        self.timer = self.timer + dt
        if self.timer >= 0.75 then
            self.state = 'completely-broken'
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if not self.consumed then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY), 0, self.scaleX, self.scaleY)
    end
end