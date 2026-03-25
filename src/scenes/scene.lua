---@class Scene
---@field protected scene_manager SceneManager
---@field protected name string
local Scene = {}
Scene.__index = Scene

---@param scene_manager SceneManager
---@param name string
function Scene:new(scene_manager, name)
  local o = {}
  setmetatable(o, self)

  o.scene_manager = scene_manager
  o.name = name

  return o
end

return Scene
