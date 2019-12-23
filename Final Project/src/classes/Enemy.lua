Enemy = Class{}

function Enemy:init(params)
	self.player = params.player
	self.destroyed = false

	self.world = params.world
	self.name = 'enemy'
	self.x, self.y = params.x, params.y
	self.dx, self.dy = 0, 0
	self.world:add(self, self.x, self.y, 16, 16)

	self.animation = love.graphics.newImage('graphics/Enemy.png')
	self.animationTimer = 0
	self.animationIs2 = false
end

function Enemy:update(dt)
	self.dx, self.dy = 0, 50
	if self.player.x + 8 < self.x + 8 and self.player.state ~= 'fall' then
		self.dx = -20
	elseif self.player.x + 8 > self.x + 8 and self.player.state ~= 'fall' then
		self.dx = 20
	elseif self.player.x + 8 < self.x + 8 and self.player.state == 'fall' then
		self.dx = 30
	elseif self.player.x + 8 > self.x + 8 and self.player.state == 'fall' then
		self.dx = -30
	end
	self.x, self.y, cols, len = self.world:move(self, self.x + self.dx * dt, self.y + self.dy * dt, function(item, other)
		if other.name == 'end' then
			return 'cross'
		end
		return 'slide'
	end)
	if len > 0 then
		for k, col in pairs(cols) do
			if col.other.name == 'player' then
				col.other.destroyed = true
				self.world:remove(col.other)
			end
		end
	end

	self.animationTimer = self.animationTimer + dt
	if self.animationTimer >= 0.2 then
		self.animationTimer = self.animationTimer - 0.2
		self.animationIs2 = not self.animationIs2
	end
end

function Enemy:render()
	if not self.destroyed then
		love.graphics.draw(self.animation, math.floor(self.animationIs2 and self.x or self.x + 16), math.floor(self.y - 1), 0, self.animationIs2 and 1 or -1, 1)
	end
end