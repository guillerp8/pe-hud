Config              = {}

-- Variables (HUD)
Config.maxPlayers   = 32 -- Keep same as sv_maxclients within your server.cfg.
Config.hideArmor    = true
Config.hideOxygen   = true

Config.pulseHud     = true -- Pulse Effect when status is below the configured amount.
Config.pulseStart   = 35 -- Minimal value for pulse to start.

Config.waitTime     = 420  -- Set to 100 so the hud is more fluid. However, performance will be affected.

-- Variables (Controls)
Config.voiceChange  = 'z'
Config.openKey      = 'f7'
Config.oxygenMax    = 10 -- Set to 10 / 4 if using vMenu

-- Variables (Framework)
Config.useESX       = false