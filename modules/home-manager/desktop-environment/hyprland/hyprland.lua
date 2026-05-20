local mod = "SUPER"
local terminal = "@alacritty@"

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1,
})

hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRSHOT_DIR", "$HOME/Pictures/Screenshots")

hl.on("hyprland.start", function()
  hl.exec_cmd("[workspace 1 silent] " .. terminal)
  hl.exec_cmd("[workspace 2 silent] @firefox@")
  hl.exec_cmd("@hyprctl@ set cursor $HYPRCURSOR_THEME $HYPRCURSOR_SIZE")
  hl.exec_cmd("@systemctl@ --user start hyprpolkitagent")
end)

hl.config({
  general = {
    gaps_in = 5,
    -- (top, right, bottom, left)
    gaps_out = {
      top = 0,
      right = 15,
      bottom = 15,
      left = 15,
    },
    col = {
      active_border = {
        colors = { "rgba(c4a7e7ff)", "rgba(9ccfd8ff)" },
        angle = 45
      },
      inactive_border = "rgba(21202eff)",
    },
    border_size = 1,
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
    no_focus_fallback = true,
  },
  dwindle = {
    preserve_split = true,
  },
  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = false,
    },
    blur = {
      enabled = false,
    },
  },
  animations = {
    enabled = true,
  },
  misc = {
    force_default_wallpaper = 0,
    vrr = 1,
    disable_hyprland_logo = true,
    focus_on_activate = 1,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
  },
  debug = {
    vfr = true,
  },
  input = {
    kb_layout = "us,ara",
    kb_options = "caps:escape,grp:win_space_toggle",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      disable_while_typing = false,
    },
    repeat_rate = 25,
    repeat_delay = 200,
  },
  cursor = {
    inactive_timeout = 10,
  },
})

hl.curve("out-expo", { type = "bezier", points = { { 0.12, 0.77 }, { 0, 1 } } })
hl.curve("out-expo", { type = "bezier", points = { { 0.12, 0.77 }, { 0, 1 }, } })
hl.curve("ease-in-out-sine", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 }, } })
hl.curve("ease-in-out-circ", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 }, } })
hl.curve("ease-out-circ", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 }, } })
hl.curve("ease-out-quint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 }, } })
hl.curve("ease-in-out-back", { type = "bezier", points = { { 0.68, -0.6 }, { 0.32, 1.6 }, } })
hl.curve("ease-back", { type = "bezier", points = { { 0.75, -0.25 }, { 0.35, 1.25 }, } })

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 3,
  bezier = "ease-back",
  style = "popin",
})

hl.animation({
  leaf = "border",
  enabled = true,
  speed = 10,
  bezier = "default",
})

hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 0.25,
  bezier = "default",
})

hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 1,
  bezier = "default",
})

hl.gesture({
  fingers = 3,
  direction = "down",
  action = "fullscreen",
})

hl.workspace_rule({
  workspace = "special:music",
  on_created_empty = "[float; size 80% 80%] spotify"
})

hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + R", hl.dsp.exec_cmd("@tofi-drun@ --drun-launch=true"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("@cliphist@ list | @tofi@ --width 80% | @cliphist@ decode | @wl-copy@"))
hl.bind(mod .. " + F", hl.dsp.window.float())
hl.bind(mod .. " + F12", hl.dsp.window.fullscreen())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + U", hl.dsp.layout("toggle_split"))
hl.bind("Print", hl.dsp.exec_cmd("@hyprshot@ --freeze -m region"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("@hyprpicker@ -na"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("@bash@ @write_to_layout_pipe.sh@"))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:spotify" }))

for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
  -- "$mod ALT, code:1${toString i}, exec, sh ${./swapworkspace.sh} ${toString ws}"
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("@wpctl@ set-volume @DEFAULT_AUDIO_SINK@ 1%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("@wpctl@ set-volume @DEFAULT_AUDIO_SINK@ 1%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("@wpctl@ set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("@playerctl@ play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("@playerctl@ next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("@playerctl@ previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("@brightnessctl@ -q set +2%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("@brightnessctl@ -q set 2%-"))

hl.window_rule({
  name = "overlay-open-books",
  match = {
    title = "open-books",
  },
  size = "80% 80%",
})

hl.window_rule({
  name = "ueberzugpp",
  match = {
    class = "^(ueberzugpp_.*)$",
  },
  no_anim = true,
  border_size = 0,
  no_focus = true,
  no_follow_mouse = true,
  no_blur = true,
})

hl.window_rule({
  name = "ripdrag",
  match = {
    title = "ripdrag",
  },
  float = true,
  pin = true,
  no_anim = true,
  border_size = 0,
  no_blur = true,
})
