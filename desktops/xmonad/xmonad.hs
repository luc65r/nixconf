import XMonad
import XMonad.Util.EZConfig

main = xmonad $ def
    { terminal = "alacritty"
    , modMask = mod4Mask
    } `additionalKeys` [ ((mod4Mask, xK_p), spawn "rofi -show run") ]
