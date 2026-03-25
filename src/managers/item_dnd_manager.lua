---@class ItemDnDManager
---@field private inventory Inventory
---@field private items Item[]
---@field private dragged_item Item?
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

  return o
end

---@param mx number
---@param my number
---@param button number
function ItemDnDManager:startDrag(mx, my, button)
  for _, item in ipairs(self.items) do
    if button == 1 then
      local contains, slot = item:containsPoint(mx, my)
      if contains then
        self.dragged_item = item

        break
      end
    end
  end
end

---@param dx number
---@param dy number
function ItemDnDManager:drag(dx, dy)
  if not self.dragged_item then return end

  self.dragged_item:translate(dx, dy)
end

function ItemDnDManager:endDrag()
  if not self.dragged_item then return end

  self.dragged_item:snapBack()
  self.dragged_item = nil
end

return ItemDnDManager
