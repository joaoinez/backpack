local Scene = require 'src.scenes.scene'

---@class MainMenuScene: Scene
local MainMenuScene = {}
MainMenuScene.__index = MainMenuScene
setmetatable(MainMenuScene, { __index = Scene })

---@param scene_manager SceneManager
function MainMenuScene:new(scene_manager)
  local o = Scene:new(scene_manager, 'main_menu')
  setmetatable(o, self)

  return o
end

function MainMenuScene:draw()
  love.graphics.setBackgroundColor(0.12, 0.16, 0.20)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Main Menu', 20, 20)
end

function MainMenuScene:keypressed(key)
  if key == 'return' then self.scene_manager:setScene 'game' end
end

return MainMenuScene
