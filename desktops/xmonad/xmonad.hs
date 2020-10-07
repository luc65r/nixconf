import XMonad

main = xmonad $ def
    { terminal = "alacritty"
    , modMask = mod4Mask
    }
