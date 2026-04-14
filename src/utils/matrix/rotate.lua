---@generic T
---@param matrix T[][]
---@return T[][]
local function rotate(matrix)
  local rotated_matrix = {}
  for row_index, row in ipairs(matrix) do
    for col_index, _ in ipairs(row) do
      rotated_matrix[col_index] = rotated_matrix[col_index] or {}
      rotated_matrix[col_index][#matrix - row_index + 1] =
        matrix[row_index][col_index]
    end
  end

  return rotated_matrix
end

return rotate
