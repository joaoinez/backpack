local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'

function love.load()
  Sword = Item:new({ x = 20, y = 20 }, { w = 1, h = 1 }, 'Sword', { { 1, 1 } })
  Inventory = Inventory:new(
    { x = 200, y = 200 },
    { w = 1, h = 1 },
    { { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 } }
  )
end

function love.draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)
  Inventory:draw()
  Sword:draw()
end

function love.mousepressed(x, y, button)
  if button == 1 and Sword:containsPoint(x, y) then Sword:startDrag(x, y) end
end

function love.mousemoved(x, y) Sword:updateDrag(x, y) end

function love.mousereleased(x, y, button)
  if button == 1 then Sword:stopDrag() end
end

function love.keypressed(key)
  if key == 'space' and Sword.dragging then
    local mx, my = love.mouse.getPosition()
    Sword:rotateClockwiseAt(mx, my)
  end
end
