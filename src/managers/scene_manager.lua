local GameScene = require 'src.scenes.game_scene'
local MainMenuScene = require 'src.scenes.main_menu_scene'

---@alias SceneName 'main_menu' | 'game'
---@alias Scenes {main_menu: MainMenuScene, game: GameScene}

---@class SceneManager
---@field private scenes Scenes
---@field private current_scene MainMenuScene | GameScene
local SceneManager = {}
SceneManager.__index = SceneManager

---@param initial_scene SceneName
function SceneManager:new(initial_scene)
  local o = {}
  setmetatable(o, self)

  ---@type Scenes
  o.scenes = {
    main_menu = MainMenuScene:new(o),
    game = GameScene:new(o),
  }

  o.current_scene = o.scenes[initial_scene]

  o.current_scene:load()

  return o
end

---@param scene SceneName
function SceneManager:setScene(scene)
  if self.current_scene then self.current_scene:unload() end

  self.current_scene = self.scenes[scene]

  self.current_scene:load()
end

function SceneManager:draw()
  if not self.current_scene.draw then return end

  self.current_scene:draw()
end

---@param x number
---@param y number
---@param button number
function SceneManager:mousepressed(x, y, button)
  if not self.current_scene.mousepressed then return end

  self.current_scene:mousepressed(x, y, button)
end

---@param x number
---@param y number
---@param dx number
---@param dy number
function SceneManager:mousemoved(x, y, dx, dy)
  if not self.current_scene.mousemoved then return end

  self.current_scene:mousemoved(x, y, dx, dy)
end

function SceneManager:mousereleased()
  if not self.current_scene.mousereleased then return end

  self.current_scene:mousereleased()
end

---@param key string
function SceneManager:keypressed(key)
  if not self.current_scene.keypressed then return end

  self.current_scene:keypressed(key)
end

return SceneManager
