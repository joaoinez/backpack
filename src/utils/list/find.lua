---@generic T
---@param list T[]
---@param fn fun(value: T, index: number, list: T[]): boolean
---@return T?
---@nodiscard
local function find(list, fn)
  for i, value in ipairs(list) do
    if fn(value, i, list) then return value end
  end

  return nil
end

return find
