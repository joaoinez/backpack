local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class slot
---@field x number
---@field y number
---@field item Item | nil

---@class Inventory: Entity
---@field shape number[][]
---@field slots any
local Inventory = {}
Inventory.__index = Inventory
setmetatable(Inventory, { __index = Entity })

---@param position position
---@param shape number[][]
function Inventory:new(position, shape)
  local o = Entity:new('inventory', position)
  setmetatable(o, self)

  o.shape = shape

  local slots = {}

  for i, row in ipairs(shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      local x = position.x + (CELL_SIZE * (j - 1))
      local y = position.y + (CELL_SIZE * (i - 1))

      if slots[i] == nil then slots[i] = {} end

      table.insert(slots[i], {
        x = x,
        y = y,
        item = nil,
      })

      ::continue::
    end
  end

  for _, row in ipairs(slots) do
    for _, col in pairs(row) do
      print(col.x, col.y)
    end
  end

  o.slots = slots

  return o
end

---@param mx number
---@param my number
function Inventory:containsPoint(mx, my)
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

function Inventory:draw()
  if not self.shape then return end

  for i, row in ipairs(self.shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      local x = self.position.x + (CELL_SIZE * (j - 1))
      local y = self.position.y + (CELL_SIZE * (i - 1))
      local w, h = CELL_SIZE, CELL_SIZE
      local radius = math.max(2, CELL_SIZE * 0.08)

      love.graphics.setColor(1, 0.6, 0)
      love.graphics.rectangle('fill', x, y, w, h, radius)

      love.graphics.setLineWidth(3)
      love.graphics.setColor(0.6, 0.8, 1)
      love.graphics.rectangle('line', x, y, w, h, radius)

      ::continue::
    end
  end
end

return Inventory
