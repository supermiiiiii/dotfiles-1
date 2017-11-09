-------------------------------------------------------------------------------
-------------------------------- Imports --------------------------------------
import System.IO
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.WindowGo
import XMonad.Actions.SpawnOn
import XMonad.Hooks.SetWMName
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Layout.IndependentScreens
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWS
import Data.Maybe (isNothing)

import qualified XMonad.StackSet as W
import qualified Data.Map as M

---------------------------------- Functions ----------------------------------
isEmpty :: String -> X Bool
isEmpty t = gets $ elem t . map W.tag
           . filter (isNothing . W.stack)
           . W.workspaces . windowset

changeWSifTEmpty t = whenX (isEmpty t) $ moveTo Next HiddenNonEmptyWS
changeWSifCurrEmpty = gets (W.currentTag . windowset) >>= changeWSifTEmpty

------------------------------- Key Bindings ----------------------------------
alt = mod1Mask
ctrl = controlMask
shift = shiftMask
super = mod4Mask

myAdditionalKeys = 
   [ ((alt, xK_r), spawn "xmonad --recompile && xmonad --restart")

   -- Close Focused Window
   , ((alt, xK_w), spawn "xkill -id `xprop -root _NET_ACTIVE_WINDOW | cut -d\\# -f2` && xdotool key ctrl+alt+shift+n")

   -- If current window empty, move to NonEmpty window
   , ((ctrl .|. alt .|. shift, xK_n), changeWSifCurrEmpty)

   -- Prev Hidden NonEmpty Workspace
   , ((alt, xK_bracketleft), moveTo Prev HiddenNonEmptyWS)

   -- Next Hidden NonEmpty Workspace
   , ((alt, xK_bracketright), moveTo Next HiddenNonEmptyWS)

   -- Program Launcher
   , ((alt, xK_space), spawn "dmenu_extended_run")

   -- Toggle External Monitor
   , ((alt, xK_m), spawn "toggle_monitor")

   -- Screenshot Commands
   , ((alt, xK_Print),
   spawn "scrot -s /tmp/shot.png && xclip -selection 'clipboard' -t image/png /tmp/shot.png")

   , ((super, xK_Print), spawn "receipt_sshot")

   -- Shutdown and Restart
   , ((ctrl .|. super .|. alt, xK_s),
   spawn "confirm -d 'ham stop && dbox_sync && shutdown now'")

   , ((ctrl .|. super .|. alt, xK_r),
   spawn "confirm -d 'ham stop && systemctl reboot -i'")

   -- Hamster Start and Stop
   , ((super, xK_KP_Delete), spawn "ham start")
   , ((super, xK_KP_Insert), spawn "ham stop")

   -- Tmux Commands
   , ((alt, xK_e), spawn "clear_screen")
   , ((alt, xK_q), spawn "quit_screen")

   -- clipmenu
   , ((alt .|. shift, xK_c), spawn "clipmenu")

   -- screenlock
   , ((super, xK_l), spawn "screenlock")

   -- Focus Local
   , ((alt, xK_f), windows $ W.focusUp)

   -- Next Screen
   , ((alt, xK_backslash), onNextNeighbour W.view)

   -- Swap Screens
   , ((alt, xK_s), sequence_ [swapNextScreen, spawn "xdotool key ctrl+shift+alt+n"])
   ]

   -- Hamster Numpad Bindings
   ++ [((super, key), spawn $ "ham start " ++ (show i))
       | (i, key) <- zip [1 .. 5] [xK_KP_End, xK_KP_Down, xK_KP_Page_Down, xK_KP_Left, xK_KP_Begin]
      ]

   -- Open Applications
   ++ [((alt, key), raiseNextMaybe (spawn cmd) (className =? cls))
       | (key, cmd, cls) <- zip3
	   [xK_x, xK_c, xK_z, xK_a, xK_KP_End, xK_KP_Down]
	   ["wmctrl -s 0  && termite -e 'tm-init Terminal'","wmctrl -s 1 && google-chrome-stable","wmctrl -s 3 && zathura","wmctrl -s 5 && anki","hamster","slack"]
	   ["Termite","Google-chrome","Zathura","Anki","Hamster","Slack"]
      ]

   -- Shift, Focus
   ++ [((ctrl, k), sequence_ [windows $ W.shift i, windows $ W.view i])
       | (i, k) <- zip myWorkspaces $ [xK_1 .. xK_9] ++ [xK_0]
      ]

   -- Shift, No Focus
   ++ [((super, k), windows $ W.shift i)
       | (i, k) <- zip myWorkspaces $ [xK_1 .. xK_9] ++ [xK_0]
      ]

   -- View Workspace
   ++ [((alt, k), windows $ W.view i)
       | (i, k) <- zip (myWorkspaces) $ [xK_1 .. xK_9] ++ [xK_0]
      ]

-------------------------------- Misc Configs ---------------------------------
myTerminal = "termite -e 'tm-init Terminal'"
myModMask = mod1Mask

myFocusFollowsMouse = False
myClickJustFocuses = False

-- Colors --
yellow = "#F8FB27"
red = "#FF1300"
------------

myBorderWidth = 5
myFocusedBorderColor = red

xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) $ ["1:TERM","2:WEB","3:WEB","4:PDF","5:PDF","6:ANKI","7","8","9","0"]
  where                                                                       
         clickable l = [ "<action=xdotool key alt+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..10] l,                                        
                            let n = i ]

myLayout = tiled ||| Mirror tiled ||| Full
  where
    tiled = smartSpacing 5 $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

-- Window Rules
myManageHook = composeAll
	[ className=? "Pinentry"		--> doFloat]

-------------------------------- Main -----------------------------------------
main = do
	xmproc <- spawnPipe "xmobar /home/bryan/.xmobarrc"
	spawn "init-bg"
	xmonad $ ewmh desktopConfig
		{
		  terminal				= myTerminal
		  , modMask				= myModMask
		  , borderWidth			= myBorderWidth
		  , focusedBorderColor	= myFocusedBorderColor
		  , focusFollowsMouse 	= myFocusFollowsMouse
		  , clickJustFocuses  	= myClickJustFocuses
		  , workspaces			= myWorkspaces
		  , manageHook 			= myManageHook
		  , layoutHook			= avoidStruts $ myLayout
		  , startupHook			= ewmhDesktopsStartup >> setWMName "LG3D"
		  , logHook 			= dynamicLogWithPP xmobarPP
			{ ppOutput 			= hPutStrLn xmproc
			, ppOrder           = \(ws:l:t:_)   -> [ws]
			, ppCurrent 		= xmobarColor "yellow" "" . wrap "[" "]"
			, ppHidden			= xmobarColor "white" ""
			, ppHiddenNoWindows = xmobarColor "darkgrey" ""
			, ppWsSep			= "    "
			, ppTitle   		= xmobarColor "green"  "" . shorten 40
			, ppVisible 		= xmobarColor "yellow" ""
			, ppUrgent  		= xmobarColor "red" "yellow"
			} >> ewmhDesktopsLogHook <+> dynamicLogXinerama
	  } `additionalKeys` myAdditionalKeys

