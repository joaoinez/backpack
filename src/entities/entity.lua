local uuid = require 'src.utils.uuid'

---@param position EntityPosition
---@param dimensions EntityDimensions?
---@param parent_position EntityPosition?
---@param parent_dimensions EntityDimensions?
---@return EntityPosition
local function calc_position(
  position,
  dimensions,
  parent_position,
  parent_dimensions
)
  if
    position.relative
    and parent_position
    and parent_dimensions
    and position.centered
    and dimensions
  then
    ---@type EntityPosition
    return {
      x = ((position.x + parent_position.x) * parent_dimensions.width)
        - (dimensions.width / 2),
      y = ((position.y + parent_position.y) * parent_dimensions.height)
        - (dimensions.height / 2),
      relative = true,
      centered = true,
    }
  end

  if position.relative and parent_position then
    ---@type EntityPosition
    return {
      x = position.x + parent_position,
      y = position.y + parent_position,
      relative = true,
      centered = false,
    }
  end

  if position.centered and dimensions then
    ---@type EntityPosition
    return {
      x = position.x - (dimensions.width / 2),
      y = position.y - (dimensions.height / 2),
      relative = false,
      centered = true,
    }
  end

  ---@type EntityPosition
  return {
    x = position.x,
    y = position.y,
    relative = false,
    centered = false,
  }
end

---@class (exact) EntityPosition
---@field x number
---@field y number
---@field relative boolean?
---@field centered boolean?

---@class (exact) EntityDimensions
---@field width number
---@field height number

---@class Entity
---@field protected id string
---@field protected type string
---@field protected position EntityPosition
local Entity = {}
Entity.__index = Entity

---@param type string
---@param position EntityPosition
---@param dimensions EntityDimensions?
---@param parent_position EntityPosition?
---@param parent_dimensions EntityDimensions?
function Entity:new(
  type,
  position,
  dimensions,
  parent_position,
  parent_dimensions
)
  local o = {}
  setmetatable(o, self)

  o.id = uuid()
  o.type = type
  o.position =
    calc_position(position, dimensions, parent_position, parent_dimensions)

  return o
end

---@return string
function Entity:getId() return self.id end

---@return EntityPosition
function Entity:getPosition() return self.position end

---@param x number?
---@param y number?
function Entity:setPosition(x, y)
  self.position = {
    x = x or self.position.x,
    y = y or self.position.y,
    relative = self.position.relative,
    centered = self.position.centered,
  }
end

return Entity
