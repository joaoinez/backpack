local G = require 'src.globals'

---@generic T
---@param matrix T[][]
---@return number
---@return number
local function get_matrix_dimensions(matrix)
  local height = #matrix * G.CELL_SIZE
  local width = #matrix[1] * G.CELL_SIZE

  return width, height
end

return get_matrix_dimensions
