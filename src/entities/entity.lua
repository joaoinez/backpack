---@class position
---@field x number
---@field y number

---@class debug_drawable
---@field w number
---@field h number

---@class Entity
---@field type string
---@field position position
local Entity = {}
Entity.__index = Entity

---@param type string
---@param position position
function Entity:new(type, position)
  local o = {}
  setmetatable(o, self)

  o.type = type
  o.position = position

  return o
end

return Entity
