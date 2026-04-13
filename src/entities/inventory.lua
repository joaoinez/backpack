local Entity = require 'src.entities.entity'
local draw_debug_slot = require 'src.utils.draw_debug_slot'
local get_cell_position = require 'src.utils.get_cell_position'
local get_matrix_dimensions = require 'src.utils.get_matrix_dimensions'
local is_point_in_cell = require 'src.utils.is_point_in_cell'
local list = require 'src.utils.list'
local loop_matrix = require 'src.utils.loop_matrix'

---@class (exact) InventorySlot
---@field x number
---@field y number
---@field row_index number
---@field col_index number
---@field item Item?

---@class (exact) HoveredInventorySlot
---@field x number
---@field y number

---@class Inventory: Entity
---@field private shape number[][]
---@field private slots InventorySlot[]
---@field private hovered_slots HoveredInventorySlot[]
---@field private are_hovered_available boolean
local Inventory = {}
Inventory.__index = Inventory
setmetatable(Inventory, { __index = Entity })

---@param position EntityPosition
---@param shape number[][]
---@param parent_position EntityPosition?
---@param parent_dimensions EntityDimensions?
function Inventory:new(position, shape, parent_position, parent_dimensions)
  local width, height = get_matrix_dimensions(shape)
  local dimensions = { width = width, height = height }

  local o = Entity:new(
    'inventory',
    position,
    dimensions,
    parent_position,
    parent_dimensions
  )
  setmetatable(o, self)

  o.shape = shape

  o.slots = {}
  loop_matrix(shape, function(row_index, col_index, _, value)
    if value == 0 then return end

    local x, y = get_cell_position(o.position, row_index, col_index)

    table.insert(
      o.slots,
      ---@type InventorySlot
      {
        x = x,
        y = y,
        row_index = row_index,
        col_index = col_index,
        item = nil,
      }
    )
  end)

  o.hovered_slots = {}
  o.hovered_available = false

  return o
end

---@param mx number
---@param my number
function Inventory:containsPoint(mx, my)
  local slot = list.find(
    self.slots,
    function(_slot) return is_point_in_cell(mx, my, _slot.x, _slot.y) end
  )

  local contains = slot ~= nil

  return contains, slot
end

---@param row_index number
---@param col_index number
---@return InventorySlot?
function Inventory:getSlot(row_index, col_index)
  return list.find(
    self.slots,
    function(_slot)
      return _slot.row_index == row_index and _slot.col_index == col_index
    end
  )
end

---@param slots HoveredInventorySlot[]
---@param are_slots_available boolean
function Inventory:setHoveredSlots(slots, are_slots_available)
  self.hovered_slots = slots
  self.are_hovered_available = are_slots_available
end

---@param item Item
function Inventory:addItem(item)
  for _, hovered_slot in ipairs(self.hovered_slots) do
    -- PERF: If `self.slots` were a table indexed by row and column indices,
    -- this lookup would be O(1) instead of O(n)
    local slot = list.find(
      self.slots,
      function(_slot)
        return _slot.x == hovered_slot.x and _slot.y == hovered_slot.y
      end
    )

    if slot then slot.item = item end
  end
end

function Inventory:draw()
  for _, slot in ipairs(self.slots) do
    if slot.item then goto continue end
    draw_debug_slot(
      slot.x,
      slot.y,
      { r = 0, g = 0, b = 1, a = 1 },
      { r = 1, g = 1, b = 1, a = 1 }
    )

    ::continue::
  end

  for _, slot in ipairs(self.hovered_slots) do
    draw_debug_slot(
      slot.x,
      slot.y,
      self.are_hovered_available and { r = 0, g = 1, b = 0, a = 1 }
        or { r = 1, g = 0, b = 0, a = 1 },
      { r = 1, g = 1, b = 1, a = 1 }
    )
  end
end

return Inventory
