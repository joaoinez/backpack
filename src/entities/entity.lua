---@class (exact) EntityPosition
---@field x number
---@field y number

---@class Entity
---@field protected type string
---@field protected position EntityPosition
local Entity = {}
Entity.__index = Entity

---@param type string
---@param position EntityPosition
function Entity:new(type, position)
  local o = {}
  setmetatable(o, self)

  o.type = type
  o.position = position

  return o
end

return Entity
