local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class snap_position
---@field x number
---@field y number

---@class Item: Entity
---@field name string
---@field shape number[][]
---@field dragging boolean
---@field snap_position snap_position
---@field length number
local Item = {}
Item.__index = Item
setmetatable(Item, { __index = Entity })

---@param position position
---@param name string
---@param shape number[][]
function Item:new(position, name, shape)
  local o = Entity:new('item', position)
  setmetatable(o, self)

  o.name = name
  o.shape = shape
  o.dragging = false
  o.snap_position = {
    x = position.x,
    y = position.y,
  }

  local length = 0
  for _, row in ipairs(shape) do
    for _, col in ipairs(row) do
      if col == 0 then goto continue end

      length = length + 1

      ::continue::
    end
  end

  o.length = length

  return o
end

---@param mx number
---@param my number
function Item:containsPoint(mx, my)
  local contains = false
  for i, row in ipairs(self.shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      local x = self.position.x + (CELL_SIZE * (j - 1))
      local y = self.position.y + (CELL_SIZE * (i - 1))

      if
        (mx >= x)
        and (mx <= x + CELL_SIZE)
        and (my >= y)
        and (my <= y + CELL_SIZE)
      then
        contains = true
        break
      end

      ::continue::
    end
  end

  return contains
end

---@param mx number
---@param my number
function Item:startDrag(mx, my)
  if self:containsPoint(mx, my) then self.dragging = true end
end

---@param mx number
---@param my number
---@param dx number
---@param dy number
---@param inventory Inventory
function Item:drag(mx, my, dx, dy, inventory)
  if not self.dragging then return end

  self.position = {
    x = self.position.x + dx,
    y = self.position.y + dy,
  }

  inventory:checkSlotAvailability(mx, my, self.shape, self.length)
end

---@param inventory Inventory
function Item:endDrag(inventory)
  if self.dragging then
    self.dragging = false
    self.position = {
      x = self.snap_position.x,
      y = self.snap_position.y,
    }
    inventory:clearItemHover(self)
  end
end

function Item:draw()
  if not self.shape then return end

  for i, row in ipairs(self.shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      local x = self.position.x + (CELL_SIZE * (j - 1))
      local y = self.position.y + (CELL_SIZE * (i - 1))
      local radius = math.max(2, CELL_SIZE * 0.08)

      love.graphics.setColor(1, 0.8, 0.6)
      love.graphics.rectangle('fill', x, y, CELL_SIZE, CELL_SIZE, radius)

      love.graphics.setLineWidth(3)
      love.graphics.setColor(0.2, 1, 0.7)
      love.graphics.rectangle('line', x, y, CELL_SIZE, CELL_SIZE, radius)

      ::continue::
    end
  end
end

return Item
