local Entity = require 'src.entities.entity'
local CELL_SIZE = require('src.globals').CELL_SIZE

---@class slot
---@field x number
---@field y number
---@field i number
---@field j number
---@field item Item | nil
---@field empty boolean

---@class Inventory: Entity
---@field shape number[][]
---@field slots slot[][]
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
      local x = position.x + (CELL_SIZE * (j - 1))
      local y = position.y + (CELL_SIZE * (i - 1))

      if slots[i] == nil then slots[i] = {} end

      table.insert(slots[i], {
        x = x,
        y = y,
        i = i,
        j = j,
        item = nil,
        empty = col == 0,
      })
    end
  end

  --[[ for _, row in ipairs(slots) do
    for _, col in pairs(row) do
      print(col.x, col.y, col.empty)
    end
  end ]]

  o.slots = slots

  return o
end

---@param mx number
---@param my number
function Inventory:containsPoint(mx, my)
  local contains = false
  ---@type slot | nil
  local slot = nil

  for _, row in ipairs(self.slots) do
    for _, _slot in ipairs(row) do
      if
        (mx >= _slot.x)
        and (mx <= _slot.x + CELL_SIZE)
        and (my >= _slot.y)
        and (my <= _slot.y + CELL_SIZE)
      then
        contains = true
        slot = _slot
        break
      end
    end
  end

  return { contains = contains, slot = slot }
end

---@param mx number
---@param my number
---@param item_shape number[][]
function Inventory:checkSlotAvailability(mx, my, item_shape)
  local result = self:containsPoint(mx, my)

  if not result.contains or not result.slot then return end

  if result.slot.item then
    print 'has item already'
    return
  end

  local is_available = true
  for i, row in ipairs(item_shape) do
    for j, col in ipairs(row) do
      if col == 0 then goto continue end

      if
        result.slot.i + i - 1 > #self.slots
        or result.slot.j + j - 1 > #self.slots[1]
      then
        is_available = false
        break
      end

      local current_slot =
        self.slots[result.slot.i + i - 1][result.slot.j + j - 1]

      print(current_slot.x, current_slot.y)

      if current_slot.item or current_slot.empty then
        is_available = false
        break
      end

      ::continue::
    end
  end

  if is_available then
    print 'item can fit'
  else
    print 'item cannot fit'
  end
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
