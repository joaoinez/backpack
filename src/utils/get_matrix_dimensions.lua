local CELL_SIZE = require('src.globals').CELL_SIZE

---@generic T
---@param matrix T[][]
local function get_matrix_dimensions(matrix)
  local height = #matrix * CELL_SIZE
  local width = #matrix[1] * CELL_SIZE

  return width, height
end

return get_matrix_dimensions
