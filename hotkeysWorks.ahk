#Include common.ahk

!/::
MsgBox,
(
##### 프로그램 실행 #####

!``  - editplus 실행 및 활성화

##### 기타 #####

F1       - 클립보드 문자열 byte 크기 체크(EUC-KR, 한글 = 2byte)
CapsLock - 창 최상단 고정
)
return

!`::
if WinExist("ahk_exe editplus.exe") {
	WinActivate
} else {
	Run editplus.exe
}
return

; 현재 Focus된 창 최상단 고정
CapsLock::WinSet, AlwaysOnTop, , A
return

!+WheelUp::setTransparent(10)
return

!+WheelDown::setTransparent(-10)
return

^+CapsLock::CapsLock
return

; 클립보드 문자열 byte 크기 체크(EUC-KR, 한글 = 2 byte)
;showMsg(StrLen(RegExReplace(Clipboard, "[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]", "  ")), 1)
;줄바꿈할 때 2 byte로 인식 ㅠㅠ
F1::showMsg(StrLen(RegExReplace(Clipboard, "[^a-zA-Z0-9\{\}\[\]\/?.,;:|\)*~``!^\-_+<>@\#$%&\\\=\(\'\"" \r\n\b\t\0]", "  ")), 1)
return

ScrollLock::Reload
return

:*?:na.::rnjsehdgks01@naver.com
:*?:gm.::rnjsehdgks02@gmail.com
:*?:rn.::rnjsehdgks01

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
