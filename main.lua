local SceneManager = require 'src.managers.scene_manager'
---@type SceneManager?
local scene_manager = nil

function love.load() scene_manager = SceneManager:new 'main_menu' end

function love.draw()
  if not scene_manager then return end

  scene_manager:draw()
end

function love.mousepressed(x, y, button)
  if not scene_manager then return end

  scene_manager:mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  if not scene_manager then return end

  scene_manager:mousemoved(x, y, dx, dy)
end

function love.mousereleased()
  if not scene_manager then return end

  scene_manager:mousereleased()
end

function love.keypressed(key)
  if not scene_manager then return end

  scene_manager:keypressed(key)
end
