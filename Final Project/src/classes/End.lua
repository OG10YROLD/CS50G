End = Class{}

function End:init(params)
	self.world = params.world
	self.x, self.y = params.x, params.y
	self.name = 'end'
	self.world:add(self, self.x, self.y, 1, 32)

	self.particleImage = love.graphics.newImage('graphics/particle.png')
	self.psystem = love.graphics.newParticleSystem(self.particleImage)
	self.psystem:setParticleLifetime(1, 2.5)
	self.psystem:setEmissionRate(15)
	self.psystem:setLinearAcceleration(-8, -8, -4, 8)
	self.psystem:setColors(255, 255, 0, 255, 255, 255, 0, 255)
end

function End:update(dt)
	self.psystem:update(dt)
end

function End:render()
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y, 1, 32)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.psystem, self.x, self.y + 16)
end