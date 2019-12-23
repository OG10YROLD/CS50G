Platform = Class{}

function Platform:init(params)
	self.x, self.y, self.width, self.height = params.x, params.y, params.width, params.height
	self.name = 'platform'
	params.world:add(self, self.x, self.y, self.width, self.height)
end

function Platform:render()
	love.graphics.setLineWidth(2)
	love.graphics.setColor(15, 31, 159, 255)
	love.graphics.line(self.x, self.y + 4, self.x + 1, self.y + 3, self.x + 2, self.y + 2, self.x + 3, self.y + 1, self.x + 4, self.y, self.x + self.width - 4, self.y, self.x + self.width - 3, self.y + 1, self.x + self.width - 2, self.y + 2, self.x + self.width - 1, self.y + 3, self.x + self.width, self.y + 4, self.x + self.width, self.y + self.height - 4, self.x + self.width - 1, self.y + self.height - 3, self.x + self.width - 2, self.y + self.height - 2, self.x + self.width - 3, self.y + self.height - 1, self.x + self.width - 4, self.y + self.height, self.x + 4, self.y + self.height, self.x + 3, self.y + self.height - 1, self.x + 2, self.y + self.height - 2, self.x + 1, self.y + self.height - 3, self.x, self.y + self.height - 4, self.x, self.y + 4)
	love.graphics.setColor(255, 255, 255, 255)
end