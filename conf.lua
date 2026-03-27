---@class LoveWindowConfig
---@field title string
---@field icon string|nil
---@field width number
---@field height number
---@field borderless boolean
---@field resizable boolean
---@field minwidth number
---@field minheight number
---@field fullscreen boolean
---@field fullscreentype string
---@field vsync number|boolean
---@field msaa number
---@field depth number|nil
---@field stencil number|nil
---@field display number
---@field highdpi boolean
---@field usedpiscale boolean
---@field x number|nil
---@field y number|nil

---@class LoveAudioConfig
---@field mic boolean
---@field mixwithsystem boolean

---@class LoveModulesConfig
---@field audio boolean
---@field data boolean
---@field event boolean
---@field font boolean
---@field graphics boolean
---@field image boolean
---@field joystick boolean
---@field keyboard boolean
---@field math boolean
---@field mouse boolean
---@field physics boolean
---@field sound boolean
---@field system boolean
---@field thread boolean
---@field timer boolean
---@field touch boolean
---@field video boolean
---@field window boolean

---@class LoveConfig
---@field identity string|nil
---@field appendidentity boolean|nil
---@field version string|nil
---@field console boolean|nil
---@field accelerometerjoystick boolean|nil
---@field externalstorage boolean|nil
---@field gammacorrect boolean|nil
---@field audio LoveAudioConfig|nil
---@field window LoveWindowConfig
---@field modules LoveModulesConfig

---@param t LoveConfig
function love.conf(t)
  t.version = '11.5'
  t.window.title = 'Backpack'
  t.window.width = 1600
  t.window.height = 900
end
