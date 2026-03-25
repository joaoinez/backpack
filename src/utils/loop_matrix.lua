---@generic T
---@param matrix T[][]
---@param fn fun(row_index: number, col_index: number, row: T[], col: T)
---@return nil
local function loop_matrix(matrix, fn)
  for row_index, row in ipairs(matrix) do
    for col_index, col in ipairs(row) do
      fn(row_index, col_index, row, col)
    end
  end
end

return loop_matrix
