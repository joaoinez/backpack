---@class position
---@field x number
---@field y number

---@class debug_drawable
---@field w number
---@field h number

---@class Entity
---@field position position
local Entity = {}
Entity.__index = Entity

---@param position position
function Entity:new(position)
  local o = {}
  setmetatable(o, self)

  o.position = position

  return o
end

return Entity
