local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class Item: Entity
---@field name string
---@field shape number[][]
---@field dragging boolean
---@field drag_offset_x number
---@field drag_offset_y number
local Item = {}
Item.__index = Item
setmetatable(Item, { __index = Entity })

---@param position position
---@param drawable debug_drawable
---@param name string
---@param shape number[][]
function Item:new(position, drawable, name, shape)
  local o = Entity:new(position, drawable)
  setmetatable(o, self)

  o.name = name
  o.shape = shape
  o.dragging = false
  o.drag_offset_x = 0
  o.drag_offset_y = 0

  return o
end

function Item:containsPoint(mx, my)
  for row, cols in ipairs(self.shape) do
    for col, value in ipairs(cols) do
      if value == 1 then
        local x = self.position.x + (col - 1) * CELL_SIZE
        local y = self.position.y + (row - 1) * CELL_SIZE
        if
          mx >= x
          and mx < x + CELL_SIZE
          and my >= y
          and my < y + CELL_SIZE
        then
          return true
        end
      end
    end
  end
  return false
end

function Item:startDrag(mx, my)
  self.dragging = true
  self.drag_offset_x = self.position.x - mx
  self.drag_offset_y = self.position.y - my
end

function Item:updateDrag(mx, my)
  if self.dragging then
    self.position.x = mx + self.drag_offset_x
    self.position.y = my + self.drag_offset_y
  end
end

function Item:stopDrag() self.dragging = false end

function Item:draw()
  local radius = 6
  for row, cols in ipairs(self.shape) do
    for col, value in ipairs(cols) do
      if value == 1 then
        local x = self.position.x + (col - 1) * CELL_SIZE
        local y = self.position.y + (row - 1) * CELL_SIZE

        -- Fill
        love.graphics.setColor(1, 0.23, 0.4)
        love.graphics.rectangle(
          'fill',
          x,
          y,
          CELL_SIZE,
          CELL_SIZE,
          radius,
          radius
        )

        -- Border
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle(
          'line',
          x,
          y,
          CELL_SIZE,
          CELL_SIZE,
          radius,
          radius
        )
      end
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return Item
