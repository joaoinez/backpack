local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'

function love.load()
  Sword = Item:new({ x = 20, y = 20 }, 'Sword', {
    { 1, 1 },
  })
  Inventory = Inventory:new({ x = 200, y = 200 }, {
    { 1, 1, 1 },
    { 1, 0, 1 },
    { 1, 1, 1 },
  })
end

function love.draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)

  Inventory:draw()
  Sword:draw()
end

function love.mousepressed(x, y, button)
  if button == 1 then Sword:startDrag(x, y) end
end

function love.mousemoved(x, y, dx, dy) Sword:drag(x, y, dx, dy) end

function love.mousereleased() Sword:endDrag() end
