PlayState = Class{__includes = BaseState}
function PlayState:enter(params)
	gSounds['play']:play()

	self.world = bump.newWorld(16)
	self.player = Player{world = self.world, x = 16, y = 176}
	self.endpoint = End{world = self.world, x = LEVELS[getLevel()].endpoint.x, y = LEVELS[getLevel()].endpoint.y}

	self.platforms = {}
	table.insert(self.platforms, Platform{world = self.world, x = 0, y = 208, width = 256, height = 16})
	table.insert(self.platforms, Platform{world = self.world, x = -17, y = 0, width = 16, height = 224})
	table.insert(self.platforms, Platform{world = self.world, x = 257, y = 0, width = 16, height = 224})
	for k, platform in pairs(LEVELS[getLevel()].platforms) do
		table.insert(self.platforms, Platform{world = self.world, x = platform.x, y = platform.y, width = platform.width, height = platform.height})
	end
	self.enemies = {}
	for k, enemy in pairs(LEVELS[getLevel()].enemies) do
		table.insert(self.enemies, Enemy{world = self.world, player = self.player, x = enemy.x, y = enemy.y})
	end
end

function PlayState:exit()
	gSounds['play']:pause()
end

function PlayState:update(dt)
	self.endpoint:update(dt)
	if self.player then
		self.player:update(dt)
		if self.player.destroyed then
			self.player = nil
			gStateMachine:change('end', {victory = false})
		end
	end
	for k, enemy in pairs(self.enemies) do
		if enemy.destroyed then
			enemy = nil
		end
		if enemy then
			enemy:update(dt)
		end
		if self.player and self.player.destroyed then
			self.player = nil
			gStateMachine:change('end', {victory = false})
		end
	end
end

function PlayState:render()
	self.endpoint:render()
	for k, platform in pairs(self.platforms) do
		platform:render()
	end
	if self.player then
		self.player:render()
	end
	for k, enemy in pairs(self.enemies) do
		enemy:render()
	end
	love.graphics.printf('LEVEL: ' .. getLevel(), 8, 8, 64)
end