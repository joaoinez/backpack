---@generic T, R
---@param list T[]
---@param fn fun(acc: R, value: T, index: number): R
---@param initial R
---@return R
---@nodiscard
local function reduce(list, fn, initial)
  local acc = initial
  for i, value in ipairs(list) do
    acc = fn(acc, value, i)
  end

  return acc
end

return reduce
