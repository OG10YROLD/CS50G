--[[
	GD50
	Breakout Remake

	-- Powerup Class --

	Used for Power-ups.
]]

Powerup = Class{}

function Powerup:init(type)
	-- check what type of power-up we are
	self.isKeyPowerup = type == 'key'
	self.isBallPowerup = not self.isKeyPowerup

	self.width = 16
	self.height = 16

	self.x = math.random(20, VIRTUAL_WIDTH - 20 - self.width)
	self.y = 0

	self.caught = false
	self.inPlay = true

	-- particle system belonging to the power-up, emitted if caught
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 1-2 seconds seconds
    self.psystem:setParticleLifetime(1, 2)

    -- give it an acceleration
    self.psystem:setLinearAcceleration(-20, -20, 20, 20)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)

    -- we have seperate positional values for the particle system
    -- because when we are caught, we need to reset the x and y for
    -- the next power-up and spawn the particle system where we were caught.
    self.psystemx = self.x
    self.psystemy = self.y
end

function Powerup:update(dt, paddle)
	self.psystem:update(dt)
	if self.inPlay and not self.caught then
		-- updates position
		self.y = self.y + 15 * dt
		self.psystemy = self.y
		self.psystemx = self.x

		-- checks if caught or gone below the screen
		if not ((self.x > paddle.x + paddle.width or self.x + self.width < paddle.x) or (self.y > paddle.y + paddle.height or self.y + self.height < paddle.y)) then
			self.caught = true
			self.inPlay = false

			-- set the particle system to interpolate between two colors
    		self.psystem:setColors(
        		gPaletteColors[paddle.skin].r,
        		gPaletteColors[paddle.skin].g,
        		gPaletteColors[paddle.skin].b,
        		127,
        		gPaletteColors[paddle.skin].r,
        		gPaletteColors[paddle.skin].g,
        		gPaletteColors[paddle.skin].b,
        		0
    		)
    		self.psystem:emit(64)

    		-- reset x and y for next power-up
    		self.x = math.random(20, VIRTUAL_WIDTH - 20 - self.width)
			self.y = 0
		elseif self.y >= VIRTUAL_HEIGHT then
			self.inPlay = false

			-- reset x and y for next power-up
			self.x = math.random(20, VIRTUAL_WIDTH - 20 - self.width)
			self.y = 0
		end
	end
end

function Powerup:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'], self.isKeyPowerup and gFrames['powerups'][10] or gFrames['powerups'][8], self.x, self.y)
	end
	love.graphics.draw(self.psystem, self.psystemx + 8, self.psystemy + 8)
end