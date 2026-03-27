local CELL_SIZE = require('src.globals').CELL_SIZE

---@param position EntityPosition
---@param row_index number
---@param col_index number
---@return number
---@return number
local function get_cell_position(position, row_index, col_index)
  local x = position.x + (CELL_SIZE * (col_index - 1))
  local y = position.y + (CELL_SIZE * (row_index - 1))

  return x, y
end

return get_cell_position
