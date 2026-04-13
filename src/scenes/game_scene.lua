local Inventory = require 'src.entities.inventory'
local Item = require 'src.entities.item'
local ItemDnDManager = require 'src.managers.item_dnd_manager'
local Scene = require 'src.scenes.scene'

---@class GameScene: Scene
---@field private inventory Inventory?
---@field private items Item[]
---@field private item_dnd_manager ItemDnDManager?
local GameScene = {}
GameScene.__index = GameScene
setmetatable(GameScene, { __index = Scene })

---@param scene_manager SceneManager
function GameScene:new(scene_manager)
  local o = Scene:new(scene_manager, 'game')
  setmetatable(o, self)

  o.inventory = nil
  o.items = {}
  o.item_dnd_manager = nil

  return o
end

function GameScene:load()
  local screen_width, screen_height = love.graphics.getDimensions()

  self.inventory = Inventory:new(
    { x = 0.5, y = 0.5, relative = true, centered = true },
    {
      { 1, 1, 1 },
      { 1, 0, 1 },
      { 1, 1, 1 },
      { 1, 0, 0 },
    },
    { x = 0, y = 0 },
    { width = screen_width, height = screen_height }
  )

  self.item_dnd_manager = ItemDnDManager:new(self.inventory, self.items)
end

function GameScene:draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)

  if self.inventory then self.inventory:draw() end

  for _, item in ipairs(self.items) do
    item:draw()
  end
end

---@param x number
---@param y number
---@param button number
function GameScene:mousepressed(x, y, button)
  if not self.item_dnd_manager then return end

  self.item_dnd_manager:startDrag(x, y, button)
end

---@param x number
---@param y number
---@param dx number
---@param dy number
function GameScene:mousemoved(x, y, dx, dy)
  if not self.item_dnd_manager then return end

  self.item_dnd_manager:drag(x, y, dx, dy)
end

function GameScene:mousereleased()
  if not self.item_dnd_manager then return end

  self.item_dnd_manager:endDrag()
end

---@param key string
function GameScene:keypressed(key)
  if key == 'return' then
    table.insert(
      self.items,
      Item:new({ x = 1000, y = 500 }, 'Sword', {
        { 0, 1 },
        { 1, 1 },
      })
    )
  end
end

function GameScene:unload()
  self.inventory = nil
  self.items = {}
  self.item_dnd_manager = nil
end

return GameScene
