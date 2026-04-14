---@param mx number
---@param my number
---@param x number
---@param y number
---@param w number
---@param h number
---@return boolean
local function is_point_in_rect(mx, my, x, y, w, h)
  return (mx >= x) and (mx <= x + w) and (my >= y) and (my <= y + h)
end

return is_point_in_rect
