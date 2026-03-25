local CELL_SIZE = require('src.globals').CELL_SIZE

---@param x number
---@param y number
---@param fill_color Color
---@param line_color Color
local function draw_debug_slot(x, y, fill_color, line_color)
  local radius = math.max(2, CELL_SIZE * 0.08)

  love.graphics.setColor(fill_color.r, fill_color.g, fill_color.b, fill_color.a)
  love.graphics.rectangle('fill', x, y, CELL_SIZE, CELL_SIZE, radius)

  love.graphics.setLineWidth(3)
  love.graphics.setColor(line_color.r, line_color.g, line_color.b, line_color.a)
  love.graphics.rectangle('line', x, y, CELL_SIZE, CELL_SIZE, radius)
end

return draw_debug_slot
