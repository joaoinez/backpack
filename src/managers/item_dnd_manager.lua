---@class ItemDnDManager
---@field private inventory Inventory
---@field private items Item[]
---@field private dragged_item Item?
---@field private item_anchor_slot ItemSlot?
---@field private inventory_anchor_slot InventorySlot?
---@field private are_slots_available boolean
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
    or inventory_slot.row_index ~= self.inventory_anchor_slot.row_index
    or inventory_slot.col_index ~= self.inventory_anchor_slot.col_index
  then
    self.inventory:setHoveredSlots({}, false)
    self.inventory_anchor_slot = inventory_slot
    self.are_slots_available = false

    self:hover()
  end
end

---@private
function ItemDnDManager:snapItemToPosition()
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
  end

  self.dragged_item:snapBack()

  self.inventory:setHoveredSlots({}, false)

  self.dragged_item = nil
  self.item_anchor_slot = nil
  self.inventory_anchor_slot = nil
  self.are_slots_available = false
end

return ItemDnDManager
