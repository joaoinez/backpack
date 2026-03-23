local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'

---@type Inventory
local inventory = nil
---@type Item
local sword = nil

function love.load()
  sword = Item:new({ x = 20, y = 20 }, 'Sword', {
    { 1, 1 },
  })
  inventory = Inventory:new({ x = 200, y = 200 }, {
    { 1, 1, 1 },
    { 1, 0, 1 },
    { 1, 1, 1 },
  })
end

function love.draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)

  inventory:draw()
  sword:draw()
end

function love.mousepressed(x, y, button)
  if button == 1 then sword:startDrag(x, y) end
end

function love.mousemoved(x, y, dx, dy) sword:drag(x, y, dx, dy, inventory) end

function love.mousereleased() sword:endDrag() end
