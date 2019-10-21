--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = {}
    table.insert(self.balls, params.ball)
    self.level = params.level

    self.recoverPoints = 5000

    -- give balls random starting velocity
    for k, ball in pairs(self.balls) do
        ball.dx = math.random(-200, 200)
        ball.dy = math.random(-50, -60)
    end

    -- initialize power-up and spawn timer for it
    self.powerup = Powerup('ball')
    self.powerup.inPlay = false
    self.powerupTimer = 0
    self.powerupInterval = math.random(POWERUP_INTERVAL_SMALLEST, POWERUP_INTERVAL_BIGGEST)
    self.powerupsCaught = {
        ['key'] = false,
        ['ball'] = false
    }

    -- check if there is a block with a key; used for determining if a key powerup can spawn
    self.hasKeyBlock = false
    self.keyBlockUnlocked = false

    for k, brick in pairs(self.bricks) do
        if brick.key then
            self.hasKeyBlock = true
        end
    end
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end
    self.powerup:update(dt, self.paddle)

    -- calculate the power-up logic
    if self.powerup.inPlay == false then
        if not self.powerup.caught then
            self.powerupTimer = self.powerupTimer + dt
        end
        if self.powerupTimer >= self.powerupInterval then
            if (self.hasKeyBlock and self.powerupsCaught['key'] or true) and self.powerupsCaught['ball'] then
                self.powerup.inPlay = false
            elseif self.powerupsCaught['key'] then
                self.powerup.isBallPowerup = true
                self.powerup.isKeyPowerup = false
                self.powerup.inPlay = true
            elseif self.powerupsCaught['ball'] and self.hasKeyBlock then
                self.powerup.isBallPowerup = false
                self.powerup.isKeyPowerup = true
                self.powerup.inPlay = true
            else
                self.powerup.isBallPowerup = math.random(self.hasKeyBlock and 2 or 1) == 1 and true or false
                self.powerup.isKeyPowerup = not self.powerup.isBallPowerup
                self.powerup.inPlay = true
            end
            self.powerupTimer = 0
            self.powerupInterval = math.random(POWERUP_INTERVAL_SMALLEST, POWERUP_INTERVAL_BIGGEST)
        end
        if self.powerup.caught and self.powerup.isKeyPowerup then
            gSounds['powerup']:play()
            self.powerupsCaught['key'] = true
            self.keyBlockUnlocked = true
            self.powerup.inPlay = false
            self.powerup.caught = false
            self.hasKeyBlock = false
        elseif self.powerup.caught and self.powerup.isBallPowerup then
            gSounds['powerup']:play()
            self.powerupsCaught['ball'] = true
            table.insert(self.balls, Ball(math.random(7)))
            self.balls[2].x = self.paddle.x + (self.paddle.width / 2) - 4
            self.balls[2].y = self.paddle.y - 8
            self.balls[2].dx = math.random(-200, 200)
            self.balls[2].dy = math.random(-50, -60)
            self.powerup.inPlay = false
            self.powerup.caught = false
        end
    end

    for k, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end

    -- detect collision across all bricks with the balls
    for l, ball in pairs(self.balls) do
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                if not brick.key or self.keyBlockUnlocked then
                    -- add to score
                    if not brick.key then
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    else
                        self.score = self.score + 1000

                        -- removes key power-up because
                        -- we have used it
                        self.powerupsCaught['key'] = false
                    end

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()

                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- multiply recover points by 2
                        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                        -- increase the paddle's size
                        self.paddle.size = math.min(self.paddle.size + 1, 4)

                        -- play recover sound effect
                        gSounds['recover']:play()
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.balls[1],
                            recoverPoints = self.recoverPoints
                        })
                    end
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                goto continue
            end
        end
        ::continue::
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    for k, ball in pairs(self.balls) do
        if ball.y >= VIRTUAL_HEIGHT and self.powerupsCaught['ball'] == false then
            self.health = self.health - 1
            gSounds['hurt']:play()
            self.paddle.size = math.max(self.paddle.size - 1, 1)

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints
                })
            end
        elseif ball.y >= VIRTUAL_HEIGHT then
            ball.inPlay = false
            gSounds['hurt']:play()
        end
    end
    -- checks if balls are in play
    if self.powerupsCaught['ball'] then
        if not self.balls[2].inPlay then
            table.remove(self.balls, 2)
            self.powerupsCaught['ball'] = false
        end
        if not self.balls[1].inPlay then
            table.remove(self.balls, 1)
            self.powerupsCaught['ball'] = false
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end
    self.powerup:render()
    renderPowerupsCaught(self.powerupsCaught['ball'], self.powerupsCaught['key'])
    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end