--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    -- flag to check if we want to have a cursor or not, used for level up menu
    if def.cursor == nil then self.cursor = true else self.cursor = def.cursor end

    -- if we don't have a cursor, we can have a function that always
    -- calls if we press enter, because we can't select an item
    self.onSelect = not self.cursor and def.onSelect or nil

    self.items = def.items
    self.x = def.x
    self.y = def.y
    -- sometimes the text is not aligned properly, so we manually fix it with this variable
    if def.offsetY == nil then self.offsetY = 0 else self.offsetY = def.offsetY end

    self.height = def.height
    self.width = def.width
    if def.font == nil then self.font = gFonts['small'] else self.font = def.font end

    self.gapHeight = self.height / #self.items

    self.currentSelection = self.cursor and 1 or nil
end

function Selection:update(dt)
    if love.keyboard.wasPressed('up') and self.cursor then
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('down') and self.cursor then
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        if self.cursor then
            self.items[self.currentSelection].onSelect()
        else
            self.onSelect()
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    end
end

function Selection:render()
    local currentY = self.y

    for i = 1, #self.items do
        local paddedY = (currentY + (self.gapHeight / 2) - self.font:getHeight() / 2) + self.offsetY

        -- draw selection marker if we're at the right index
        if i == self.currentSelection then
            love.graphics.draw(gTextures['cursor'], self.x - 8, paddedY)
        end

        love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')

        currentY = currentY + self.gapHeight
    end
end