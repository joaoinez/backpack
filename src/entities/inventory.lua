local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class Inventory: Entity
---@field shape number[][]
local Inventory = {}
Inventory.__index = Inventory
setmetatable(Inventory, { __index = Entity })

---@param position position
---@param shape number[][]
function Inventory:new(position, shape)
  local o = Entity:new(position)
  setmetatable(o, self)

  o.shape = shape

  return o
end

function Inventory:draw()
  if not self.shape then return end

  for i, row in ipairs(self.shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      local x = self.position.x + (CELL_SIZE * j)
      local y = self.position.y + (CELL_SIZE * i)
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
