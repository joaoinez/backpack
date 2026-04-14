---@return string
local function uuid()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local _uuid, _ = string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and love.math.random(0, 0xf)
      or love.math.random(8, 0xb)
    return string.format('%x', v)
  end)

  return _uuid
end

return uuid
