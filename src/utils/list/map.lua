---@generic T, R
---@param list T[]
---@param fn fun(value: T, index: number, list: T[]): R
---@return R[]
---@nodiscard
local function map(list, fn)
  local new_table = {}
  for i, value in ipairs(list) do
    table.insert(new_table, fn(value, i, list))
  end

  return new_table
end

return map
