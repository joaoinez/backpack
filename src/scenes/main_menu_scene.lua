---@class MainMenuScene
local MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

function MainMenuScene:new()
  local o = {}
  setmetatable(o, self)

  return o
end

function MainMenuScene:draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)
  love.graphics.print('Main Menu', 20, 20)
end

function MainMenuScene:keypressed(key, scene_manager)
  if key == 'return' then scene_manager:setScene 'game' end
end

return MainMenuScene
