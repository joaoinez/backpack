local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'
local Scene = require 'src.scenes.scene'

---@class GameScene: Scene
---@field private inventory Inventory
---@field private items Item[]
local GameScene = {}
GameScene.__index = GameScene
setmetatable(GameScene, { __index = Scene })

---@param scene_manager SceneManager
function GameScene:new(scene_manager)
  local o = Scene:new(scene_manager, 'game')
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
    { 1, 0, 0 },
  })

  table.insert(
    self.items,
    Item:new({ x = 20, y = 20 }, 'Sword', {
      { 0, 1 },
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
    if button == 1 then
    end
  end
end

---@param x number
---@param y number
---@param dx number
---@param dy number
function GameScene:mousemoved(x, y, dx, dy)
  for _, item in ipairs(self.items) do
  end
end

function GameScene:mousereleased()
  for _, item in ipairs(self.items) do
  end
end

---@param key string
function GameScene:keypressed(key)
  if key == 'return' then self.scene_manager:setScene 'main_menu' end
end

function GameScene:unload()
  self.inventory = nil
  self.items = {}
end

return GameScene
