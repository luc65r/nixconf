import XMonad
import XMonad.Config.Bepo
import XMonad.Util.EZConfig

main = xmonad $ bepoConfig
    { terminal = "alacritty"
    , modMask = mod4Mask
    } `additionalKeys` [ ((mod4Mask, xK_p), spawn "rofi -show run") ]
