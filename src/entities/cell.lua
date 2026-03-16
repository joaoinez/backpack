local Entity = require 'src.entities.entity'

---@class Cell: Entity
local Cell = {}
Cell.__index = Cell
setmetatable(Cell, { __index = Entity })

---@param position position
---@param drawable debug_drawable
function Cell:new(position, drawable)
  local o = Entity:new(position, drawable)
  setmetatable(o, self)

  return o
end

return Cell
