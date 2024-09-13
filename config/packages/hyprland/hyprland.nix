{ pkgs, ... }:
{
  home.packages = [
    pkgs.hyprland
    pkgs.brightnessctl
    pkgs.hyprcursor
    pkgs.hyprshot
    pkgs.libnotify
    pkgs.playerctl
    pkgs.cliphist
  ];

  wayland.windowManager.hyprland.settings = {
    enable = true;
    systemd.enable = true;
    monitor = [ "eDP-1, 1920x1080@60, 0x0, 1" ];

    "$mod" = "SUPER";
    "$terminal" = "alacritty";

    exec-once = [
      "[workspace 1 silent] $terminal"
      "[workspace 2 silent] firefox"
    ];

    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border-size = 1;
      "col.active_border" = "rgba(9ccfd8ff) rgba(c4a7e7ff) 45deg";
      "col.inactive_border" = "rgba(21202eff)";
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    decoration = {
      rounding = 5;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      drop_shadow = false;
      blur = {
        enabled = false;
      };
    };

    animations = {
      enabled = true;
      animation = [
        "windows, 1, 7, default"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 3, default"
        "layers, 1, 2, fade"
      ];
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      focus_on_activate = 1;
    };

    input = {
      kb_layout = "us";
      kb_options = [
        "caps:escape"
      ];
      follow_mouse = 1;
      sensitivity = 0;
      touchpad.natural_scroll = true;
    };

    gestures.workspace_swipe = false;

    workspace = [
      "special:spotify, on-created-empty:[float] spotify"
    ];
    
    bind = [
      "$mod, Q, exec, $terminal"
      "$mod, C, killactive,"
      "$mod, M, exit,"
      "$mod, V, exec, cliphist list | tofi --width 80% | cliphist decode | wl-copy"
      "$mod, F, togglefloating,"
      "$mod, P, pseudo,"
      "$mod, J, togglesplit,"

      "$mod, S, togglespecialworkspace, spotify"
      "$mod, SHIFT, S, movetoworkspace, special:spotify"
    ]
    # bind = $mainMod, 0, workspace, 1
    # bind = $mainMod SHIFT, 1, movetoworkspace, 1
    ++ (
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1; in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]
      )
      9)
    );

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set +1"
      ", XF86MonBrightnessDown, exec, brightnessctl set 1-"
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    # windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
  };
}
