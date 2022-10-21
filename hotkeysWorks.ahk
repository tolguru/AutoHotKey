#Include common.ahk

!/::
MsgBox,
(
##### 프로그램 실행 #####

!``  - notepad 실행 및 활성화

##### 기타 #####

CapsLock - 창 최상단 고정
)
return

!`::
if WinExist("ahk_exe notepad++.exe") {
	WinActivate
} else {
	Run notepad++.exe
}
return

; 현재 Focus된 창 최상단 고정
;CapsLock::WinSet, AlwaysOnTop, , A
;return

!+WheelUp::setTransparent(10)
return

!+WheelDown::setTransparent(-10)
return

^+CapsLock::CapsLock
return

ScrollLock::Reload
return

:*?:na.::rnjsehdgks01@naver.com
:*?:gm.::rnjsehdgks02@gmail.com
:*?:rn.::rnjsehdgks01
:*?:123.::01051124560

setTransparent(gap) {
	; 현재 투명도 변수에 저장
	WinGet, currentValue, Transparent, A

	if (currentValue == null) {
		currentValue := 255
	} else {
		currentValue := currentValue + gap

		if (currentValue > 255) {
			currentValue := 255
		} else if (currentValue < 0) {
			currentValue := 0
		}
	}

	WinSet, Transparent, %currentValue%, A
}

;#############
;## IntelliJ
;#############
#IfWinActive ahk_exe idea64.exe
!/::
MsgBox,
(
CapsLock - 한 줄 제거
^w       - 탭 끄기
^+w      - 고정 탭 제외 끄기
^e       - 핀으로 고정
)
return

CapsLock::Send, ^y
return

^w::Send, ^{F4}
return

; IntelluJ 기본 키설정을 해당 키로 변경
^+w::Send, !i
return

; IntelluJ 기본 키설정을 해당 키로 변경
^e::Send, !u
return

;###########
;## Chrome
;###########
#IfWinActive ahk_exe chrome.exe

!/::
MsgBox,
(
## Chrome ##
^q - 창 복사
)
return

^q::Send, !d!{Enter}



