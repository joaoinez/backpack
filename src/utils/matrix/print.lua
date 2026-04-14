---@generic T
---@param matrix T[][]
---@return nil
local function mprint(matrix)
  for _, row in ipairs(matrix) do
    io.write '{'
    for col_index, col in ipairs(row) do
      io.write(col)
      if col_index < #matrix[1] then io.write ', ' end
    end
    print '}'
  end
end

return mprint
