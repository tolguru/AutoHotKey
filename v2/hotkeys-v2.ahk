/*
전역변수 선언
*/
global isStop       := false
global isFirst      := true
global gX           := ""
global gY           := ""

; PC 목록
mainPC              := "PAY-331"
subPC               := "DESKTOP-2SVBCIT"

; 좌표 변동용 값
laptopList          := [subPC]
desktopList         := [mainPC]

; Slack 좌표
global slackXY      := "x71 y366"

; Whale 번역 좌표
global wTranslateXY := [1901, 50, 1654, 415]

; 물 알람
waterAlarmList      := [subPC]
global waterAlarm   := false

/*
기본 기능 설정
*/
SetControlDelay -1

initGlobalVariable()
alarm()

initGlobalVariable() {
	; 랩탑만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	; 슬랙 나 클릭 좌표 초기화
	if (findValue(laptopList, A_ComputerName)) {
		global slackXY := "x94 y458"
	}

	; Whale 번역 좌표 초기화
	if (findValue(laptopList, A_ComputerName)) {
		global wTranslateXY := [1897, 59, 1586, 519]
	}
}

alarm() {
	SetTimer () => alarm(), -1000 * 60

	if (waterAlarm) {
		alarmWater()
	}
}

/*
임시 기능 선언
*/

/*
기본 기능 선언
*/
!/::MsgBox("##### 프로그램 실행 #####`n!`` - notepad 실행 및 활성화`n!1 - 나한테 다이렉트 메세지 보내기`n##### 기타 #####`n`n^+F12 - 창 최상단 고정`n^\ - caps lock 토글")

!`::runNotepadPP()
!1::directMessageToMe()

^+F12::WinSetAlwaysOnTop(-1, "A")
!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T")

!+WheelUp::setTransparent(10)
!+WheelDown::setTransparent(-10)

Pause::Reload

:*?:na.::rnjsehdgks01@naver.com
:*?:gm.::rnjsehdgks02@gmail.com
:*?:rn.::rnjsehdgks01
:*?:123.::01051124560
:*?:1234.::51124560

F1::runParamUrl("https://ko.dict.naver.com/#/search?query=", "국어사전")
F3::runParamUrl("https://en.dict.naver.com/#/search?query=", "영어사전")

/*
URL에 param 더해서 실행하는 함수
*/
runParamUrl(url, title := "Run URL") {
	input := InputBox(, title, "w100 h70")
	if input.Result = "OK" {
		Run(url input.value)
	}
}

setTransparent(gap) {
	; 현재 투명도 변수에 저장
	currentValue := WinGetTransparent("A")

	try {
		if (currentValue = "") {
			currentValue := 255
		} else {
			currentValue := currentValue + gap

			if (currentValue > 255) {
				currentValue := 255
			} else if (currentValue < 0) {
				currentValue := 7
			}
		}

		WinSetTransparent(currentValue, "A")
	} catch Error {
	}
}

alarmWater() {
	static waterTime := 0

	if (++waterTime = 60) {
		MsgBox("물")

		waterTime := 0
	}
}

/*
메세지 출력
#param message : 메세지
#param time    : 노출 시간 (default = 2초)
*/
msg(message, time := 2) {
	ToolTip message
	SetTimer () => ToolTip(), -1000 * time
}

/*
배열에서 값 찾기(에러처리 X)
#param arr    : 배열
#param target : 찾을 값
*/
findValue(arr, target) {
	for value in arr {
		if (value = target) {
			return true
		}
	}
	return false
}

runNotepadPP() {
	if WinExist("ahk_exe notepad++.exe") {
		WinActivate
	} else {
		Run("notepad++.exe")
	}
}

runOneNote() {
	if WinExist("ahk_exe ApplicationFrameHost.exe") {
		WinActivate
	} else {
		Run("ApplicationFrameHost.exe")
	}
}

runIntelliJ() {
	if WinExist("ahk_exe idea64.exe") {
		WinActivate
	} else {
		Run("idea64.exe")
	}
}

directMessageToMe() {
	if WinExist("ahk_exe slack.exe") {
		WinActivate

		ControlClick(slackXY, "ahk_exe slack.exe")
	} else {
		Run("C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Slack Technologies Inc\Slack")
	}
}

/*
#############
## IntelliJ
#############
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox("## IntelliJ ##`nCapsLock - 한 줄 제거`n^w - 탭 끄기`n^+w - 고정 탭 제외 끄기`n^e - 핀으로 고정`n!z - 안 쓰는 import 제거`n!x - 메서드 return값으로 변수 생성`n!q - 최근 사용 파일 검색`n!w - 파일 검색`n^. - 문장 주석 달기`n!a - 현재 커서 위치 모듈 Run`n!s - 마지막 모듈 Run`n!d - 마지막 모듈 Debug")

;~ CapsLock::SendInput("^y")
^w::SendInput("^{F4}")
^+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경
^e::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경
^.::SendInput("{Home 2}^{Enter 2}/*{Enter}")
!z::SendInput("!^o")
;~ !x::SendInput("/**{Enter 2}{Up}")
!x::SendInput("^!v")
!w::SendInput("^+n")
!q::SendInput("^e")
!a::SendInput("^+{F10}")
!s::SendInput("+{F10}")
!d::SendInput("+{F9}")

/*
###########
## Chrome
###########
*/
#HotIf WinActive("ahk_exe chrome.exe")
!/::MsgBox("## Chrome ##`n^q - 창 복사`n!s - 시크릿 모드 창 열기")

^q::SendInput("!d!{Enter}")
!s::SendInput("^+n")

/*
###########
## Whale
###########
*/
#HotIf WinActive("ahk_exe whale.exe")
!/::MsgBox("## Whale ##`n^q - 창 복사`n!a - 새 탭 열기`n!s - 시크릿 모드 창 열기")

^q::SendInput("^k")
!a::SendInput("^t")
!s::SendInput("^+n")
!z::wTranslate()

wTranslate() {
	BlockInput("MouseMove")
	MouseGetPos(&nowX, &nowY)

	MouseClick(, wTranslateXY[1], wTranslateXY[2],, 0) ; 메뉴 버튼 클릭
	Sleep(100)
	MouseClick(, wTranslateXY[3], wTranslateXY[4],, 0) ; 번역 버튼 클릭
	SendInput("{Enter}") ; 번역 확인 팝업 처리
	SendInput("{Esc}") ; 번역 후 팝업 제거

	MouseMove(nowX, nowY, 0)
	BlockInput("MouseMoveOff")
}
	;~ ControlClick("x1901 y50 ", "ahk_exe whale.exe")
	;~ Sleep(200)
	;~ ControlClick(wTranslateXY, "ahk_exe whale.exe")
	;~ Sleep(200)
	;~ ControlClick(wSubmitXY, "ahk_exe whale.exe")

/*
###########
## 원노트
###########
*/
#HotIf WinActive("ahk_exe ApplicationFrameHost.exe")
!/::MsgBox("!q - 글 배경색`n!w - 서식 제거`n!e - 그리기 직선`n!r - 그리기 화살표`n!d - 펜 해제")

!q::paintFont() ; 글 배경색
!w::SendInput("^+n") ; 글 서식 제거
!e::selectFigure(true) ; 그리기 직선
!r::selectFigure(false) ; 그리기 화살표
+Insert::SendInput("^b") ;
+PgUp::SendInput("^+`>") ; 폰트 크기 키우기
+PgDn::SendInput("^+`<") ; 폰트 크기 줄이기

selectFigure(flag) {
	BlockInput("MouseMove")

	SendInput("!d")

	Sleep(100)

	MouseGetPos(&nowX, &nowY)

	MouseClick(, 765, 116,, 0) ; 100% : 604, 90 /

	Sleep(100)

	if (flag) {
		MouseClick(, 769, 238,, 0) ; 100% : 615, 180
	} else {
		MouseClick(, 845, 233,, 0) ; 100% : 675, 180
	}

	MouseMove(nowX, nowY, 0)

	BlockInput("MouseMoveOff")
}

paintFont() {
	BlockInput("MouseMove")

	SendInput("!h")
	Sleep(100)

	MouseGetPos(&nowX, &nowY)

	if (isFirst) {
		Sleep(300)
		MouseClick(, 665, 114,, 0) ; 100% : 528, 92
		Sleep(300)
		MouseClick(, 650, 269,, 0) ; 100% : 517, 216
		Sleep(300)
		MouseClick(, 598, 114,, 0) ; 100% : 477, 92
		Sleep(300)
		MouseClick(, 754, 316,, 0) ; 100% : 601, 254
		Sleep(300)

		global isFirst := false
	} else {
		Sleep(50)
		MouseClick(, 633, 113,, 0) ; 100% : 502, 90
		MouseMove(nowX, nowY, 0)
		Sleep(100)
		SendInput("^+h")
	}

	BlockInput("MouseMoveOff")
	Sleep(50)
	SendInput("{Esc}")
}

:*?:>> ::- > `
:*?:## ::👑
:*?:$$ ::📌
:*?:!! ::🔸
:*?:@@ ::🔹

/*
###########
## SSMS
###########
*/
#HotIf WinActive("ahk_exe Ssms.exe")
!/::MsgBox("^/ - 주석`n^+/ - 주석 해제")

^/:: {
	SendInput("^k")
	SendInput("^c")
}
^+/:: {
	SendInput("^k")
	SendInput("^u")
}

/*
###########
## DBeaver
###########
*/
#HotIf WinActive("ahk_exe dbeaver.exe")
!/::MsgBox("!q - SELECT, FROM`n!w - WHERE 1 = 1 ~ AND`n!e - AND`n!r - ORDER BY`n!a - 테이블 정보 조회`n!s - 공통 코드 조회`n!d - 최근 10개 항목 조회`nCapsLock - 한 줄 지우기")

!q::SendInput("SELECT *`nFROM   ")
!w::SendInput("WHERE  1 = 1`nAND    ")
!e::SendInput("+{Enter}AND    ")
!r::SendInput("ORDER BY REG_DT DESC")
;~ CapsLock::SendInput("{End}+{Home 2}{Backspace 2}{Down}")

/*
해당 항목으로 쿼리 실행
*/
runClipboardQuery(query, quote := true, endWord := ";") {
	beforeData := A_Clipboard

	if (quote) {
		endWord := "'" endWord
	}

	SendInput("^c")
	Sleep(10)
	SendInput("+{Enter}")
	Sleep(1)

	A_Clipboard := query A_Clipboard endWord

	SendInput("^v+{Home}^\^d")

	Sleep(100)
	A_Clipboard := beforeData
}

/*
###########
## VSCode
###########
*/
#HotIf WinActive("ahk_exe Code.exe")
!/::MsgBox("CapsLock - 한 줄 지우기`n!c - console.log()")

;~ CapsLock::SendInput("^+k")
!c::SendInput("console.log(){Left}")
+Enter::SendInput("^{Enter}")
^Enter::SendInput("{End};")