/*
임시 기능 선언
*/

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

; 원노트 좌표
global RIBBON_TOOL1_XY := "x0 y0"
global RIBBON_TOOL2_XY := "x0 y0"

global FONT_COLOR_BLACK_XY := "x0 y0"
global FONT_COLOR_CUSTOM_XY := "x0 y0"

global FIGURE_LINE_XY := "x0 y0"
global FIGURE_ARROW_XY := "x0 y0"

; 물 알람
waterAlarmList      := []
global waterAlarm   := false

/*
기본 기능 설정
*/
SetControlDelay -1

initGlobalVariable()
alarm()

initGlobalVariable() {
	; 특정 PC만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	if (findValue(laptopList, A_ComputerName)) {
		; 슬랙 나 클릭 좌표 초기화
		global slackXY := "x94 y458"

		; Whale 번역 좌표 초기화
		global wTranslateXY := [1897, 59, 1586, 519]

		; 원노트 좌표 초기화
		global FONT_COLOR_BLACK_XY := "x9 y116"
		global FONT_COLOR_CUSTOM_XY := "x12 y255"
		global RIBBON_TOOL1_XY := "x49 y119"
		global RIBBON_TOOL2_XY := "x78 y119"
		global FIGURE_LINE_XY := "x12 y49"
		global FIGURE_ARROW_XY := "x36 y47"
	}
}

alarm() {
	SetTimer () => alarm(), -1000 * 60

	if (waterAlarm) {
		alarmWater()
	}
}

/*
기본 기능 선언
*/
!/::MsgBox("##### 프로그램 실행 #####`n!`` - notepad 실행 및 활성화`n!1 - 나한테 다이렉트 메세지 보내기`n##### 기타 #####`n`n^+F12 - 1분 타이머 후 사운드`n^\ - caps lock 토글")

!`::runNotepadPP()
!1::directMessageToMe()

; 1분 타이머, Beep 사운드 알람
F12::ringTimer(60)

!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T")
;~ *ScrollLock::blockAllInput(0.1)

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
타이머 실행 후 사운드 알람, Tool tip 표기됨
#param count : 타이머 시간(초) (default = 1초)
*/
ringTimer(count := 1) {
	msg(count "초 타이머 시작")
	SoundBeep(550, 500)
	SetTimer () => SoundBeep(550, 500), -1000 * count
}

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
배열에서 값 찾기(예외처리 X)
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
키보드 마우스 입력 중지
#param time    : 노출 시간 (default = 0.1초)
*/
blockAllInput(time := 0.1) {
	BlockInput True

	Sleep(1000 * time)

	BlockInput False
}

/*
#############
## IntelliJ
#############
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox("## IntelliJ ##`nCapsLock - 한 줄 제거`n^w - 탭 끄기`n^+w - 고정 탭 제외 끄기`n^e - 핀으로 고정`n!z - 안 쓰는 import 제거`n!x - 메서드 return값으로 변수 생성`n!c - 북마크`n!q - 최근 사용 파일 검색`n!w - 파일 검색`n!e - 클래스 구조(Structure) 보기`n^. - 메서드 Document 주석 달기`n!a - 현재 커서 위치 모듈 Run`n!s - 마지막 모듈 Run`n!d - 마지막 모듈 Debug")

;~ CapsLock::SendInput("^y")
^w::SendInput("^{F4}")
^+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경
^e::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경
^.::SendInput("!+h") ; 메서드 Document 주석 달기(IntelliJ JavaDoc plugin 키설정을 해당 키로 변경)
!z::SendInput("!^o")
;~ !x::SendInput("/**{Enter 2}{Up}")
!x::SendInput("^!v")
!c::SendInput("{F11}") ; Bookmark
!q::SendInput("^e")
!w::SendInput("^+n")
!e::SendInput("!7") ; Structure
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

^q::SendInput("{F6}!{Enter}")
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

/*
###########
## 원노트
###########
*/
#HotIf WinActive("ahk_exe ONENOTE.EXE")
!/::MsgBox("!q - 글자색 + 배경색`n!d - 글자색`n!w - 서식 제거`n!e - 그리기 직선`n!r - 그리기 화살표`n^v - HTTP URL일 경우 링크 이름 편집`n^+v - 서식 유지해서 붙여넣기`n사이드 앞 - 다음 페이지`n사이드 뒤 - 이전 페이지`n!a - 맨 밑에 페이지 추가`n!s - 커서 밑에 페이지 추가")

!q::paintFont() ; 글자색 + 배경색
!d::paintFont(FONT_COLOR_CUSTOM_XY, false) ; 글자색
!w::SendInput("^+n") ; 글 서식 제거
!e::selectFigure(FIGURE_LINE_XY) ; 그리기 직선
!r::selectFigure(FIGURE_ARROW_XY) ; 그리기 화살표
^v::pasteURL() ; HTTP URL일 경우 붙여넣기 시 이름 링크로 삽입
^+v::SendInput("!3") ; 서식 유지해서 붙여넣기(빠른 실행 도구 3번째에 지정)
XButton1::SendInput("!{Left}")
XButton2::SendInput("!{Right}")
!a::SendInput("^n") ; 맨 밑에 페이지 추가
!s::SendInput("!5") ; 현재 선택된 페이지 하위에 페이지 추가(빠른 실행 도구 5번째에 지정)

+PgUp::SendInput("^+`>") ; 폰트 크기 키우기
+PgDn::SendInput("^+`<") ; 폰트 크기 줄이기
+WheelUp::SendInput("^+`>") ; 폰트 크기 키우기
+WheelDown::SendInput("^+`<") ; 폰트 크기 줄이기

; 도형 선택 - 빠른 실행 도구 2번째에 지정
selectFigure(figureXY) {

	; STEP 01. 도형 클릭
	ControlClick(RIBBON_TOOL2_XY, "ahk_exe ONENOTE.EXE",,,, "NA")
	Sleep(100)

	; STEP 02. 도형 선택
	ControlClick(figureXY, "ahk_exe ONENOTE.EXE",,,, "NA")

	; STEP 03. 즉시 도구가 사용되지 않는 버그 해결용으로 단순 클릭 입력
	SendInput("{Click}")

	; STEP 04. Alt 키 자동 입력으로 도형 위치를 자유롭게 배치, 10초 제한
	Sleep(300)
	SendInput("{Alt down}")
	if (KeyWait("LButton", "D T10")) {
	}

	Sleep(500)
	SendInput("{Alt up}")
}

; Font Color 선택 - 빠른 실행 도구 1번째에 지정
paintFont(colorXY := FONT_COLOR_BLACK_XY, backColor := true) {

	; STEP 01. Font Color 클릭
	ControlClick(RIBBON_TOOL1_XY, "ahk_exe ONENOTE.EXE",,,, "NA")
	Sleep(100)

	; STEP 02. Font Color 선택
	ControlClick(colorXY, "ahk_exe ONENOTE.EXE",,,, "NA")

	; STEP 03. Font Background Color 추가
	if (backColor) {
		Sleep(60)
		SendInput("^+h")
	}

	; STEP 04. 마우스에 가위표 생기는 버그 해결용
	Sleep(20)
	SendInput("{Esc}")
}

pasteURL() {
	if (SubStr(A_Clipboard, 1, 4) = "http") {
		SendInput("^k")
		Sleep(150)
		ControlSetText("Link", "RICHEDIT60W3", "ahk_exe ONENOTE.EXE")
		ControlSetText(A_Clipboard, "RICHEDIT60W2", "ahk_exe ONENOTE.EXE")
		ControlFocus("RICHEDIT60W3", "ahk_exe ONENOTE.EXE")
		SendInput("{Enter}")
	} else {
		SendInput("^v")
	}
}

:*?:>> ::- > `

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

/*
###########
## SciTE4AutoHotkey
###########
*/
#HotIf WinActive("ahk_exe SciTE.exe")
!/::MsgBox("!q - 책갈피 설정/제거`n!w - 책갈피로 이동")

!q::SendInput("^{F2}")
!w::SendInput("{F2}")