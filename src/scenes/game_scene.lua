local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'

---@class GameScene
---@field inventory Inventory
---@field items Item[]
local GameScene = {}
GameScene.__index = GameScene

function GameScene:new()
  local o = {}
  setmetatable(o, self)

  o.inventory = nil
  o.items = {}

  return o
end

function GameScene:load()
  self.inventory = Inventory:new({ x = 200, y = 200 }, {
    { 1, 1, 1 },
    { 1, 0, 1 },
    { 1, 1, 1 },
  })

  table.insert(
    self.items,
    Item:new({ x = 20, y = 20 }, 'Sword', {
      { 1, 1 },
    })
  )
end

function GameScene:draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)

  self.inventory:draw()

  for _, item in ipairs(self.items) do
    item:draw()
  end
end

---@param x number
---@param y number
---@param button number
function GameScene:mousepressed(x, y, button)
  for _, item in ipairs(self.items) do
    if button == 1 then item:startDrag(x, y) end
  end
end

---@param x number
---@param y number
---@param dx number
---@param dy number
function GameScene:mousemoved(x, y, dx, dy)
  for _, item in ipairs(self.items) do
    item:drag(x, y, dx, dy, self.inventory)
  end
end

function GameScene:mousereleased()
  for _, item in ipairs(self.items) do
    item:endDrag()
  end
end

---@param key string
---@param scene_manager SceneManager
function GameScene:keypressed(key, scene_manager)
  if key == 'return' then scene_manager:setScene 'main_menu' end
end

function GameScene:unload()
  self.inventory = nil
  self.items = {}
end

return GameScene
