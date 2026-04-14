local G = require 'src.globals'
local is_point_in_rect = require 'src.utils.is_point_in_rect'

---@param mx number
---@param my number
---@param cx number
---@param cy number
---@return boolean
local function is_point_in_cell(mx, my, cx, cy)
  return is_point_in_rect(mx, my, cx, cy, G.CELL_SIZE, G.CELL_SIZE)
end

return is_point_in_cell
