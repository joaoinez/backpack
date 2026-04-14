---@generic T
---@param matrix T[][]
---@param fn fun(col: T, index: {row: number, col: number}, row: T[])
---@return nil
local function loop(matrix, fn)
  for row_index, row in ipairs(matrix) do
    for col_index, col in ipairs(row) do
      fn(col, { row = row_index, col = col_index }, row)
    end
  end
end

return loop
