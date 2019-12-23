TitleState = Class{__includes = BaseState}

function TitleState:enter(params)
	self.logo = love.graphics.newImage('graphics/logo.png')
	gSounds['title']:play()

	self.timer = 0
	self.alpha = 191
	self.goingUp = true
end

function TitleState:exit()
	gSounds['title']:stop()
end

function TitleState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	elseif love.keyboard.wasPressed('r') then
		setLevel(1)
		gStateMachine:change('title')
	end

	self.timer = self.timer + dt

	if self.timer >= 0.0625 then
		self.timer = self.timer - 0.0625
		if self.alpha == 255 then self.goingUp = false elseif self.alpha == 191 then self.goingUp = true end
		self.alpha = self.goingUp and self.alpha + 4 or self.alpha - 4
	end
end

function TitleState:render()
	love.graphics.setColor(255, 255, 255, self.alpha)
	love.graphics.draw(self.logo, VIRTUAL_WIDTH / 2 - 98, VIRTUAL_HEIGHT / 8)
	love.graphics.printf('Level: ' .. getLevel(), VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 2 + 32, 64)
	love.graphics.printf('PRESS ENTER!', VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 2 + 64, 96)
	love.graphics.printf('PRESS R TO RESET GAME', VIRTUAL_WIDTH / 2 - 84, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 2 + 96, 168)
	love.graphics.setColor(255, 255, 255, 255)
end