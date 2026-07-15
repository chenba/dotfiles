require("hs.ipc")

hs.loadSpoon("SpoonInstall")
hs.allowAppleScript(true)

cliHUD = require("cli_hud")

--------------------------------
-- START VIM CONFIG
--------------------------------
-- local VimMode = hs.loadSpoon("VimMode")
-- local vim = VimMode:new()

-- Configure apps you do *not* want Vim mode enabled in
-- For example, you don't want this plugin overriding your control of Terminal
-- vim
-- vim
--   :disableForApp('Code')
--   :disableForApp('zoom.us')
--   :disableForApp('iTerm')
--   :disableForApp('iTerm2')
--   :disableForApp('Terminal')
--   :disableForApp('kitty')

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
-- vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
-- vim:shouldShowAlertInNormalMode(true)

-- You can configure your on-screen alert font
-- vim:setAlertFont("Courier New")

-- Enter normal mode by typing a key sequence
-- vim:enterWithSequence('jk')

-- if you want to bind a single key to entering vim, remove the
-- :enterWithSequence('jk') line above and uncomment the bindHotKeys line
-- below:
--
-- To customize the hot key you want, see the mods and key parameters at:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
--
-- vim:bindHotKeys({ enter = { {'ctrl'}, ';' } })

--------------------------------
-- END VIM CONFIG
--------------------------------


-- set up your windowfilter
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher.ui.showThumbnails = false
-- switcher.ui.showSelectedThumbnail = false

-- bind to hotkeys; WARNING: at least one modifier key is required!
-- hs.hotkey.bind('alt','tab',nil,function()switcher:next()end)
-- hs.hotkey.bind('alt-shift','tab',nil,function()switcher:previous()end)
