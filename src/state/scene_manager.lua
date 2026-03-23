local GameScene = require 'src.scenes.game_scene'
local MainMenuScene = require 'src.scenes.main_menu_scene'

---@class SceneManager
---@field scenes {['main_menu']: MainMenuScene, ['game']: GameScene}
---@field current_scene MainMenuScene | GameScene | nil
local SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new()
  local o = {}
  setmetatable(o, self)

  ---@type {['main_menu']: MainMenuScene, ['game']: GameScene}
  o.scenes = {
    main_menu = MainMenuScene:new(o),
    game = GameScene:new(o),
  }

  o.current_scene = nil

  return o
end

---@param scene 'main_menu' | 'game'
function SceneManager:setScene(scene)
  if self.current_scene then
    if self.current_scene.unload then self.current_scene:unload() end
  end

  self.current_scene = self.scenes[scene]

  if self.current_scene.load then self.current_scene:load() end
end

return SceneManager
