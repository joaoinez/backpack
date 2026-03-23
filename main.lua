local SceneManager = require 'src.state.scene_manager'
---@type SceneManager | nil
local scene_manager = nil

function love.load()
  scene_manager = SceneManager:new()
  scene_manager:setScene 'main_menu'

  if
    not scene_manager.current_scene or not scene_manager.current_scene.load
  then
    return
  end

  scene_manager.current_scene:load()
end

function love.draw()
  if
    not scene_manager
    or not scene_manager.current_scene
    or not scene_manager.current_scene.draw
  then
    return
  end

  scene_manager.current_scene:draw()
end

function love.mousepressed(x, y, button)
  if
    not scene_manager
    or not scene_manager.current_scene
    or not scene_manager.current_scene.mousepressed
  then
    return
  end

  scene_manager.current_scene:mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  if
    not scene_manager
    or not scene_manager.current_scene
    or not scene_manager.current_scene.mousemoved
  then
    return
  end

  if scene_manager.current_scene.mousemoved then
    scene_manager.current_scene:mousemoved(x, y, dx, dy)
  end
end

function love.mousereleased()
  if
    not scene_manager
    or not scene_manager.current_scene
    or not scene_manager.current_scene.mousereleased
  then
    return
  end

  if scene_manager.current_scene.mousereleased then
    scene_manager.current_scene:mousereleased()
  end
end

function love.keypressed(key)
  if
    not scene_manager
    or not scene_manager.current_scene
    or not scene_manager.current_scene.keypressed
  then
    return
  end

  if scene_manager.current_scene.keypressed then
    scene_manager.current_scene:keypressed(key)
  end
end
