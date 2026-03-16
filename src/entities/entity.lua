local CELL_SIZE = require('src.globals').CELL_SIZE

---@class position
---@field x number
---@field y number

---@class debug_drawable
---@field w number
---@field h number

---@class Entity
---@field position position
---@field drawable debug_drawable
local Entity = {}
Entity.__index = Entity

---@param position position
---@param drawable debug_drawable
function Entity:new(position, drawable)
  local o = {}
  setmetatable(o, self)

  o.position = position
  o.drawable = drawable

  return o
end

function Entity:draw()
  love.graphics.rectangle(
    'fill',
    self.position.x,
    self.position.y,
    self.drawable.w * CELL_SIZE,
    self.drawable.h * CELL_SIZE
  )
end

return Entity
