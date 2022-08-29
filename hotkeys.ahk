#Include common.ahk

;F3::ControlClick, x277 y90, A
;return

!/::
MsgBox,
(
----- 프로그램 실행 -----

!``  - editplus 실행 및 활성화
!1 - bitvise 터미널 실행


----- 기타 -----

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

!1::
if WinExist("ahk_exe BvSsh.exe") {
	WinActivate
	SetControlDelay, -1
	ControlClick, x61 y302, ahk_exe BvSsh.exe,,,, NA
	WinMinimize, ahk_exe BvSsh.exe
} else {
	showMsg("BvSsh 활성화 요망", 1)
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

	currentValue := currentValue + gap

	if (currentValue > 255) {
		currentValue := 255
	} else if (currentValue < 0) {
		currentValue := 0
	}

	WinSet, Transparent, %currentValue%, A
}

;---------------------------------------------------------------------------------------------------------
; 원노트
;---------------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe ApplicationFrameHost.exe
!/::
MsgBox,
(
!q - 글 배경색
!w - 서식 제거
!e - 그리기 펜
!d - 펜 해제
)
return

; 원노트 - 글 배경색
!q::Send, ^+h
return

; 원노트 - 글 서식 제거
!w::Send, ^+n
return

; 원노트 - 그리기 메뉴 첫 번째 펜 선택
!e::
BlockInput, MouseMove

Send, !{d}

Sleep, 100

MouseGetPos, nowX, nowY

MouseClick, Left, 277, 90,, 0

MouseMove, %nowX%, %nowY%, 0

BlockInput, MouseMoveOff

return

;---------------------------------------------------------------------------------------------------------
; IntelliJ
;---------------------------------------------------------------------------------------------------------
#IfWinActive ahk_exe idea64.exe
!/::
MsgBox,
(
CapsLock - 한 줄 제거
^w       - 탭 끄기
^e       - 핀으로 고정
)
return

CapsLock::Send, ^y
return

^w::Send, ^{F4}
return

^e::Send, !u
return