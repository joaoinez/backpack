local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class Inventory: Entity
---@field shape number[][]
local Inventory = {}
Inventory.__index = Inventory
setmetatable(Inventory, { __index = Entity })

---@param position position
---@param drawable debug_drawable
---@param shape number[][]
function Inventory:new(position, drawable, shape)
  local o = Entity:new(position, drawable)
  setmetatable(o, self)

  o.shape = shape

  return o
end

function Inventory:draw()
  local radius = 6
  for row, cols in ipairs(self.shape) do
    for col, value in ipairs(cols) do
      if value == 1 then
        local x = self.position.x + (col - 1) * CELL_SIZE
        local y = self.position.y + (row - 1) * CELL_SIZE

        -- Fill
        love.graphics.setColor(0.1, 0.63, 0.1)
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

return Inventory
