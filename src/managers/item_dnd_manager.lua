local G = require 'src.globals'
local list = require 'src.utils.list'

---@class ItemDnDManager
---@field private inventory Inventory
---@field private items Item[]
---@field private dragged_item Item?
---@field private item_anchor_slot ItemSlot?
---@field private inventory_anchor_slot InventorySlot?
---@field private are_slots_available boolean
---@field private num_dragged_item_rotations number
local ItemDnDManager = {}
ItemDnDManager.__index = ItemDnDManager

---@param inventory Inventory
---@param items Item[]
function ItemDnDManager:new(inventory, items)
  local o = {}
  setmetatable(o, self)

  o.inventory = inventory
  o.items = items

  o.dragged_item = nil
  o.item_anchor_slot = nil
  o.inventory_anchor_slot = nil
  o.are_slots_available = false
  o.num_dragged_item_rotations = 0

  return o
end

---@param mx number
---@param my number
---@param button number
function ItemDnDManager:startDrag(mx, my, button)
  for _, item in ipairs(self.items) do
    if button == 1 then
      local is_point_in_item, item_slot = item:containsPoint(mx, my)

      if is_point_in_item then
        self.dragged_item = item
        self.item_anchor_slot = item_slot

        break
      end
    end
  end
end

---@private
function ItemDnDManager:hover()
  if not self.inventory_anchor_slot then return end

  local row_offset = self.inventory_anchor_slot.row_index
    - self.item_anchor_slot.row_index
  local col_offset = self.inventory_anchor_slot.col_index
    - self.item_anchor_slot.col_index

  ---@type HoveredInventorySlot[]
  local hovered_slots = {}
  local available_slots = 0
  for _, item_slot in ipairs(self.dragged_item:getSlots()) do
    local inventory_row_index = item_slot.row_index + row_offset
    local inventory_col_index = item_slot.col_index + col_offset

    local inventory_slot =
      self.inventory:getSlot(inventory_row_index, inventory_col_index)

    if not inventory_slot then goto continue end

    table.insert(
      hovered_slots,
      ---@type HoveredInventorySlot
      {
        x = inventory_slot.x,
        y = inventory_slot.y,
      }
    )

    if not inventory_slot.item then available_slots = available_slots + 1 end

    ::continue::
  end

  local are_slots_available = available_slots == #self.dragged_item:getSlots()

  self.inventory:setHoveredSlots(hovered_slots, are_slots_available)
  self.are_slots_available = are_slots_available
end

---@param mx number
---@param my number
---@param dx number
---@param dy number
function ItemDnDManager:drag(mx, my, dx, dy)
  if not self.dragged_item then return end

  self.dragged_item:translate(dx, dy)

  local is_point_in_inventory, inventory_slot =
    self.inventory:containsPoint(mx, my)

  if not is_point_in_inventory then
    self.inventory:setHoveredSlots({}, false)
    self.inventory_anchor_slot = nil
  elseif
    not self.inventory_anchor_slot
    or (inventory_slot and inventory_slot.row_index ~= self.inventory_anchor_slot.row_index)
    or (
      inventory_slot
      and inventory_slot.col_index ~= self.inventory_anchor_slot.col_index
    )
  then
    self.inventory:setHoveredSlots({}, false)
    self.inventory_anchor_slot = inventory_slot
    self.are_slots_available = false

    self:hover()
  end
end

---@private
function ItemDnDManager:snapItemToPosition()
  if not self.inventory_anchor_slot then return end

  local dx = self.inventory_anchor_slot.x - self.item_anchor_slot.x
  local dy = self.inventory_anchor_slot.y - self.item_anchor_slot.y

  self.dragged_item:translate(dx, dy)

  local dragged_item_position = self.dragged_item:getPosition()

  self.dragged_item:setSnapPosition(
    dragged_item_position.x,
    dragged_item_position.y
  )
end

function ItemDnDManager:endDrag()
  if not self.dragged_item then return end

  if self.are_slots_available then
    self.inventory:addItem(self.dragged_item)

    self:snapItemToPosition()
  elseif self.num_dragged_item_rotations > 0 then
    for _ = 1, 4 - self.num_dragged_item_rotations do
      self.dragged_item:rotate()
    end
  end

  self.dragged_item:snapBack()

  self.inventory:setHoveredSlots({}, false)

  self.dragged_item = nil
  self.item_anchor_slot = nil
  self.inventory_anchor_slot = nil
  self.are_slots_available = false
  self.num_dragged_item_rotations = 0
end

---@private
---@return ItemSlot?
function ItemDnDManager:rotateItemAroundAnchor()
  local cur_anchor_slot_row_index = self.item_anchor_slot.row_index
  local cur_anchor_slot_col_index = self.item_anchor_slot.col_index

  local num_rows_in_dragged_item_shape = #self.dragged_item:getShape()

  local dx = (
    cur_anchor_slot_col_index
    - 1
    - (num_rows_in_dragged_item_shape - cur_anchor_slot_row_index)
  ) * G.CELL_SIZE
  local dy = (cur_anchor_slot_row_index - 1 - (cur_anchor_slot_col_index - 1))
    * G.CELL_SIZE

  self.dragged_item:rotate()
  self.dragged_item:translate(dx, dy)

  local new_anchor_slot_row_index = cur_anchor_slot_col_index
  local new_anchor_slot_col_index = num_rows_in_dragged_item_shape
    - cur_anchor_slot_row_index
    + 1

  local new_anchor_slot = list.find(
    self.dragged_item:getSlots(),
    function(_slot)
      return _slot.row_index == new_anchor_slot_row_index
        and _slot.col_index == new_anchor_slot_col_index
    end
  )

  return new_anchor_slot
end

function ItemDnDManager:rotateDraggedItem()
  if not self.dragged_item then return end

  local new_anchor_slot = self:rotateItemAroundAnchor()

  self.num_dragged_item_rotations = self.num_dragged_item_rotations == 3 and 0
    or self.num_dragged_item_rotations + 1

  if not new_anchor_slot then return end

  self.item_anchor_slot = new_anchor_slot

  self:hover()
end

return ItemDnDManager
