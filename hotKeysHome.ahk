XButton1::
Send, {XButton1}
Sleep, 100
return

XButton2::
Send, {XButton2}
Sleep, 100
return

+WheelUp::
Send, {Volume_Up}
Send, {Volume_Up}
return

+WheelDown::
Send, {Volume_Down}
Send, {Volume_Down}
return

CapsLock::WinSet, AlwaysOnTop,, A
return

^+CapsLock::CapsLock
return

;Window:	1265, 300 (default)
;F3::
;MouseGetPos, mouseX, mouseY
;PixelGetColor, paka, mouseX, mouseY
;
;Loop {
;	Sleep, 1
;	PixelGetColor, paka, mouseX, mouseY
;	if (paka == "0x6ADB4B") {
;		Send, {Click}
;		return
;	}
;}

;Send, {Click}
;Sleep, 4000
;Send, {Click}
return

Pause::Reload
return