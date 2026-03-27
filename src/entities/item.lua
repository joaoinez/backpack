local Entity = require 'src.entities.entity'
local draw_debug_slot = require 'src.utils.draw_debug_slot'
local get_cell_position = require 'src.utils.get_cell_position'
local is_point_in_cell = require 'src.utils.is_point_in_cell'
local list = require 'src.utils.list'
local loop_matrix = require 'src.utils.loop_matrix'

---@class (exact) ItemSlot
---@field x number
---@field y number
---@field row_index number
---@field col_index number

---@class Item: Entity
---@field private name string
---@field private shape number[][]
---@field private slots ItemSlot[]
---@field private snap_position EntityPosition
local Item = {}
Item.__index = Item
setmetatable(Item, { __index = Entity })

---@param position EntityPosition
---@param name string
---@param shape number[][]
function Item:new(position, name, shape)
  local o = Entity:new('item', position)
  setmetatable(o, self)

  o.name = name
  o.shape = shape

  o.slots = {}
  loop_matrix(shape, function(row_index, col_index, _, value)
    if value == 0 then return end

    local x, y = get_cell_position(position, row_index, col_index)

    table.insert(
      o.slots,
      ---@type ItemSlot
      {
        x = x,
        y = y,
        row_index = row_index,
        col_index = col_index,
      }
    )
  end)

  o.snap_position = {
    x = position.x,
    y = position.y,
  }

  return o
end

---@param mx number
---@param my number
function Item:containsPoint(mx, my)
  local slot = list.find(
    self.slots,
    function(_slot) return is_point_in_cell(mx, my, _slot.x, _slot.y) end
  )

  local contains = slot ~= nil

  return contains, slot
end

---@param dx number
---@param dy number
function Item:translate(dx, dy)
  self.position.x = self.position.x + dx
  self.position.y = self.position.y + dy

  for _, slot in ipairs(self.slots) do
    slot.x = slot.x + dx
    slot.y = slot.y + dy
  end
end

function Item:getSlots() return self.slots end

function Item:setSnapPosition(x, y) self.snap_position = { x = x, y = y } end

function Item:snapBack()
  local dx = self.snap_position.x - self.position.x
  local dy = self.snap_position.y - self.position.y

  self:translate(dx, dy)
end

function Item:draw()
  for _, slot in ipairs(self.slots) do
    draw_debug_slot(
      slot.x,
      slot.y,
      { r = 1, g = 1, b = 0, a = 1 },
      { r = 1, g = 1, b = 1, a = 1 }
    )
  end
end

return Item
