--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local keyPos = false
    local keyBlockPos = false
    local keyColor = math.random(4)

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        -- we check if it is the second to last column and the third to last column and if so we have to have already spawned the key and lock
        if math.random(7) == 1 and (x < width - 3 and true or keyPos) and (x < width - 3 and true or keyBlockPos) and x < width - 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            -- if we want to spawn a key or lock, we check if it is spawned
            -- one means a key, two means a lock and three means no key or lock
            local key = math.random(math.floor(width / 1.75))
            if x > width - 3 and (not keyPos or not keyBlockPos) then
                key = keyPos and 2 or 1
            elseif keyPos and not keyBlockPos and key == 1 then 
                key = 2
            elseif keyBlockPos and not keyPos and key == 2 then
                key = 1
            elseif key < 3 and keyPos and keyBlockPos then
                key = 3
            end

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar, and we can't generate one on the last block because there will be a goal there
            if math.random(8) == 1 and x < width then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- spawning the key or lock, and if we do we can't spawn a block
            if key == 1 then
                table.insert(objects,
                    -- key
                    GameObject {
                        texture = 'keys',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyColor,
                        collidable = true,
                        consumable = true,
                        solid = false,

                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.key = true
                        end
                    }
                )
                keyPos = true
            elseif key == 2 then
                table.insert(objects,
                    -- lock
                    GameObject {
                        texture = 'keys',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyColor + 4,
                        collidable = true,
                        hit = false,
                        solid = true,

                        onCollide = function(obj, player)
                            if not obj.hit and player.key then
                                -- goal post
                                table.insert(objects, GameObject {
                                    texture = 'goals',
                                    x = (width - 1) * TILE_SIZE - TILE_SIZE / 2 + 5,
                                    y = 3 * TILE_SIZE,
                                    width = 16,
                                    height = 48,
                                    frame = keyColor + 2,
                                    consumable = true,
                                    hit = false,
                                    solid = false,

                                    onConsume = function(player, object)
                                        if not object.hit then
                                            player.levelOver = true
                                            object.hit = true
                                        end
                                    end
                                })
                                -- goal flag
                                table.insert(objects, GameObject {
                                    texture = 'goals',
                                    x = (width - 1) * TILE_SIZE,
                                    y = 3 * TILE_SIZE,
                                    width = 16,
                                    height = 16,
                                    frame = keyColor + 6,
                                    consumable = true,
                                    hit = false,
                                    solid = false,

                                    onConsume = function(player, object)
                                        if not object.hit then
                                            player.levelOver = true
                                            object.hit = true
                                        end
                                    end
                                })
                                player.key = false
                                obj.hit = true
                                gSounds['powerup-reveal']:play()
                            end
                        end
                    }
                )
                keyBlockPos = true

            -- chance to spawn a block
            -- we can't spawn one on the last column because the flag is there
            elseif math.random(10) == 1 and x < width then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj, player)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end