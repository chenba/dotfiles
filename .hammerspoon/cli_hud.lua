-- cli_hud.lua
-- Persistent Hammerspoon HUD styled after VimMode.spoon's state indicator.
-- Load from ~/.hammerspoon/init.lua with:
--
--   cliHUD = require("cli_hud")
--
-- The companion `hud` shell command communicates through:
--   hammerspoon://cli-hud?data=<URL-safe-base64>
-- so it does not require the optional `hs` command or AppleScript support.

local M = {}
local canvas = nil

local function rgba(r, g, b, a)
  return {
    red = r / 255,
    green = g / 255,
    blue = b / 255,
    alpha = a or 1.0,
  }
end

-- Values copied from VimMode.spoon's state_indicator.lua/config.lua.
M.style = {
  fillColor = rgba(4, 135, 250, 0.95),
  strokeColor = { white = 1.0 },
  strokeWidth = 3.0,
  cornerRadius = 2,
  font = "Courier New",
  fontSize = 14,
  textColor = { white = 1.0 },
  minWidth = 125,
  minHeight = 25,
  paddingX = 6,
  paddingY = 2,
  bottomMargin = 12.5,
  maxWidthFraction = 0.90,
  maxHeightFraction = 0.50,
}

local function targetScreen()
  -- Put the HUD on the display the pointer is currently on. Fall back to the
  -- main display if the pointer's display cannot be determined.
  return hs.mouse.getCurrentScreen() or hs.screen.mainScreen()
end

local function styledMessage(message)
  return hs.styledtext.new(message, {
    font = {
      name = M.style.font,
      size = M.style.fontSize,
    },
    color = M.style.textColor,
    paragraphStyle = {
      alignment = "center",
      lineBreak = "truncateTail",
    },
  })
end

local function ensureCanvas()
  if canvas then return canvas end

  canvas = hs.canvas.new({
    x = 0,
    y = 0,
    w = M.style.minWidth,
    h = M.style.minHeight,
  })

  canvas:insertElement({
    type = "rectangle",
    action = "fill",
    roundedRectRadii = {
      xRadius = M.style.cornerRadius,
      yRadius = M.style.cornerRadius,
    },
    fillColor = M.style.fillColor,
    -- VimMode specifies these even though its rectangle action is `fill`.
    strokeColor = M.style.strokeColor,
    strokeWidth = M.style.strokeWidth,
    frame = { x = "0%", y = "0%", w = "100%", h = "100%" },
    withShadow = true,
  }, 1)

  canvas:insertElement({
    type = "text",
    action = "fill",
    frame = {
      x = M.style.paddingX,
      y = M.style.paddingY,
      w = M.style.minWidth - (M.style.paddingX * 2),
      h = M.style.minHeight - (M.style.paddingY * 2),
    },
    text = "",
  }, 2)

  return canvas
end

function M.show(message)
  if type(message) ~= "string" then
    error("cliHUD.show(message): message must be a string", 2)
  end
  if message == "" then return false end

  local screen = targetScreen()
  if not screen then return false end

  local c = ensureCanvas()
  local text = styledMessage(message)
  local textSize = c:minimumTextSize(2, text)
  local screenFrame = screen:frame()

  local desiredWidth = math.ceil(textSize.w + (M.style.paddingX * 2))
  local desiredHeight = math.ceil(textSize.h + (M.style.paddingY * 2))
  local maxWidth = math.max(40, math.floor(screenFrame.w * M.style.maxWidthFraction))
  local maxHeight = math.max(M.style.minHeight, math.floor(screenFrame.h * M.style.maxHeightFraction))

  local width = math.min(math.max(M.style.minWidth, desiredWidth), maxWidth)
  local height = math.min(math.max(M.style.minHeight, desiredHeight), maxHeight)

  local x = math.floor(screenFrame.x + ((screenFrame.w - width) / 2))
  local y = math.floor(
    screenFrame.y + screenFrame.h - height - M.style.bottomMargin
  )

  c:frame({ x = x, y = y, w = width, h = height })
  local textFrameWidth = math.max(1, width - (M.style.paddingX * 2))
  local availableTextHeight = math.max(1, height - (M.style.paddingY * 2))
  local textFrameHeight = math.min(
    math.max(1, math.ceil(textSize.h)),
    availableTextHeight
  )
  local textFrameY = math.floor((height - textFrameHeight) / 2)

  c:elementAttribute(2, "frame", {
    x = M.style.paddingX,
    y = textFrameY,
    w = textFrameWidth,
    h = textFrameHeight,
  })
  c:elementAttribute(2, "text", text)

  -- VimMode sets the level after showing the canvas.
  c:show()
  c:level("overlay")
  return true
end

function M.dismiss()
  if canvas then canvas:hide() end
  return true
end

function M.isVisible()
  return canvas ~= nil and canvas:isShowing()
end

local function decodeURLSafeBase64(value)
  if type(value) ~= "string" or value == "" then return nil end

  local standard = value:gsub("-", "+"):gsub("_", "/")
  local remainder = #standard % 4
  if remainder == 1 then return nil end
  if remainder > 0 then
    standard = standard .. string.rep("=", 4 - remainder)
  end

  return hs.base64.decode(standard)
end

-- This deliberately exposes only show/dismiss rather than arbitrary Lua
-- execution. The shell command can therefore work without hs.ipc and without
-- hs.allowAppleScript(true).
hs.urlevent.bind("cli-hud", function(_, params)
  if params.dismiss ~= nil then
    M.dismiss()
    return
  end

  local message = decodeURLSafeBase64(params.data)
  if not message then
    hs.printf("cli-hud: missing or invalid message payload")
    return
  end

  M.show(message)
end)

return M
