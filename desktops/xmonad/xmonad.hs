import XMonad

main = xmonad defaultConfig
    { terminal = "alacritty"
    , modMask = mod4Mask
    }
