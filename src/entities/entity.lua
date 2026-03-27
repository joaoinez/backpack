local uuid = require 'src.utils.uuid'

---@class (exact) EntityPosition
---@field x number
---@field y number

---@class Entity
---@field protected id string
---@field protected type string
---@field protected position EntityPosition
local Entity = {}
Entity.__index = Entity

---@param type string
---@param position EntityPosition
function Entity:new(type, position)
  local o = {}
  setmetatable(o, self)

  o.id = uuid()
  o.type = type
  o.position = position

  return o
end

function Entity:getId() return self.id end

function Entity:getPosition() return self.position end

return Entity
