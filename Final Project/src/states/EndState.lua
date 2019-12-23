EndState = Class{__includes = BaseState}

function EndState:enter(params)
	self.victory = params.victory
end

function EndState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		setLevel(1)
		love.event.quit()
	end
end

function EndState:render()
	love.graphics.setFont(bigFont)
	if self.victory then
		love.graphics.setColor(255, 255, 0, 255)
		love.graphics.printf('VICTORY!', VIRTUAL_WIDTH / 2 - 96, VIRTUAL_HEIGHT / 4, 192)
	else
		love.graphics.setColor(191, 15, 15, 255)
		love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 108, VIRTUAL_HEIGHT / 4, 216)
	end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font)
	love.graphics.printf('PRESS ENTER TO QUIT', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4, 152)
	love.graphics.printf('AND RESET GAME', VIRTUAL_WIDTH / 2 - 56, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4 + 8, 112)
end