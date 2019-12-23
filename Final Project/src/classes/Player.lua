Player = Class{}

function Player:init(params)
	self.idleImage = love.graphics.newImage('graphics/IdlePlayer.png')
	self.walkImage1 = love.graphics.newImage('graphics/WalkPlayer1.png')
	self.walkImage2 = love.graphics.newImage('graphics/WalkPlayer2.png')
	self.jumpImage = love.graphics.newImage('graphics/JumpPlayer.png')

	self.world = params.world
	self.name = 'player'
	self.destroyed = false
	self.x, self.y = params.x, params.y
	self.lastY, self.yBeforeThat = self.y, self.y
	self.dx, self.dy = 0, 0
	self.world:add(self, self.x, self.y, 16, 32)

	self.state = 'idle'
	self.rotation = 'right'
	self.timer = 0
	self.walkAnimationIs2 = false
end

function Player:update(dt)
	self.dx = 0
	if self.state == 'fall' then
		if self.dx == 0 and self.y == self.lastY and self.lastY == self.yBeforeThat and self.timer > 0 then
			self.timer = 0
			self.state = 'idle'
		elseif self.y == self.lastY and self.lastY == self.yBeforeThat then
			self.timer = 0
			self.state = 'walk'
		elseif love.keyboard.wasPressed('a') then
			self.rotation = 'left'
			self.dx = -25
		elseif love.keyboard.wasPressed('d') then
			self.rotation = 'right'
			self.dx = 25
		end
		if self.timer <= 2 then
			self.timer = self.timer + dt
		end
		self.dy = self.dy + self.timer * 96
	elseif self.state == 'walk' then
		self.timer = self.timer + dt
		if self.timer >= 0.175 then
			self.timer = self.timer - 0.175
			self.walkAnimationIs2 = not self.walkAnimationIs2
		end
		if love.keyboard.wasPressed('w') then
			self.timer = 0
			self.walkAnimationIs2 = false
			self.state = 'jump'
			gSounds['jump']:play()
		elseif love.keyboard.wasPressed('a') then
			self.rotation = 'left'
			self.dx = -75
		elseif love.keyboard.wasPressed('d') then
			self.rotation = 'right'
			self.dx = 75
		end
		if self.y > self.lastY and self.lastY > self.yBeforeThat then
			self.timer = 0
			self.walkAnimationIs2 = false
			self.state = 'fall'
		elseif self.dx == 0 then
			self.timer = 0
			self.walkAnimationIs2 = false
			self.state = 'idle'
		end
	elseif self.state == 'idle' then
		if love.keyboard.wasPressed('w') then
			self.state = 'jump'
			gSounds['jump']:play()
		elseif love.keyboard.wasPressed('a') then
			self.rotation = 'left'
			self.state = 'walk'
			self.dx = -75
		elseif love.keyboard.wasPressed('d') then
			self.rotation = 'right'
			self.state = 'walk'
			self.dx = 75
		end
		if self.y > self.lastY and self.lastY > self.yBeforeThat then
			self.state = 'fall'
		end
	elseif self.state == 'jump' then
		if self.timer <= 2 then
			self.timer = self.timer + dt
		else
			self.timer = 0
			self.state = 'fall'
		end
		if self.dx == 0 and self.y == self.lastY and self.lastY == self.yBeforeThat then
			self.timer = 0
			self.state = 'idle'
		elseif self.y == self.lastY and self.lastY == self.yBeforeThat then
			self.timer = 0
			self.state = 'walk'
		elseif love.keyboard.wasPressed('a') then
			self.rotation = 'left'
			self.dx = -25
		elseif love.keyboard.wasPressed('d') then
			self.rotation = 'right'
			self.dx = 25
		end
		self.dy = self.dy - (2 - self.timer) * 80
	end

	self.yBeforeThat = self.lastY
	self.lastY = self.y
	self.x, self.y, cols, len = self.world:move(self, self.x + self.dx * dt, self.y + self.dy * dt, function(item, other)
		if other.name == 'end' then
			return 'cross'
		end
		return 'slide'
	end)
	self.dy = 50
	if len > 0 then
		for k, col in pairs(cols) do
			if col.other.name == 'enemy' then
				if col.normal.y == -1 then
					col.other.destroyed = true
					self.world:remove(col.other)
					gSounds['enemy']:play()
					self.dy = -20
					self.state = 'jump'
				else
					self.destroyed = true
					self.world:remove(col.item)
				end
			elseif col.other.name == 'platform' and col.normal.y == 1 then
				self.state = 'fall'
			elseif col.other.name == 'end' and col.normal.x == -1 then
				if getLevel() < 5 then
					setLevel(getLevel() + 1)
					gStateMachine:change('play')
				else
					gStateMachine:change('end', {victory = true})
				end
			end
		end
	end
end

function Player:render()
	if self.state == 'idle' then
		love.graphics.draw(self.idleImage, math.floor(self.rotation == 'right' and self.x or self.x + 16), math.floor(self.y - 1), 0, self.rotation == 'right' and 1 or -1, 1)
	elseif self.state == 'walk' then
		love.graphics.draw(self.walkAnimationIs2 and self.walkImage2 or self.walkImage1, math.floor(self.rotation == 'right' and self.x or self.x + 16), math.floor(self.y - 1), 0, self.rotation == 'right' and 1 or -1, 1)
	elseif self.state == 'jump' or self.state == 'fall' then
		love.graphics.draw(self.jumpImage, math.floor(self.rotation == 'right' and self.x or self.x + 16), math.floor(self.y - 1), 0, self.rotation == 'right' and 1 or -1, 1)
	end
end