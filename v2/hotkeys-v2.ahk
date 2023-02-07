/*
전역변수 선언
*/
global isStop  := false
global isFirst := true

/*
기본 기능 설정
*/
if (A_UserName = "kdh") {
	workAlarm()
} else if (A_UserName = "rnjse") {
	homeAlarm()
}

/*
기본 기능 선언
*/
!/::MsgBox("##### 프로그램 실행 #####`n!``  - notepad 실행 및 활성화`n##### 기타 #####`n`n^+F12 - 창 최상단 고정")

!`::runNotePad()
!1::runOneNote()
!2::runIntelliJ()

^+F12::WinSetAlwaysOnTop(-1, "A")
!+F12::Suspend

!+WheelUp::setTransparent(10)
!+WheelDown::setTransparent(-10)

ScrollLock::Reload

:*?:na.::rnjsehdgks01@naver.com
:*?:gm.::rnjsehdgks02@gmail.com
:*?:rn.::rnjsehdgks01
:*?:123.::01051124560
:*?:1234.::51124560

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

workAlarm() {
	SetTimer () => workAlarm(), -1000 * 60

	alarmWater()
	alarmBatch()
}

homeAlarm() {
	SetTimer () => homeAlarm(), -1000 * 60

	alarmWater()
}

alarmWater() {
	static waterTime := 0

	if (++waterTime = 60) {
		if (A_UserName = "rnjse") {
			SoundBeep(, 600)
		} else {
			MsgBox("물")
		}

		waterTime := 0
	}
}

alarmBatch() {
	if (A_Hour = 10 && A_Min = 35) {
		Run("cmd.exe /k java -jar -Dspring.profiles.active=prod c:\batch_report-1.1.jar",, "Max")
		openReportDirectory()
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

runNotepad() {
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

/*
#############
## IntelliJ
#############
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox("## IntelliJ ##`nCapsLock - 한 줄 제거`n^w - 탭 끄기`n^+w - 고정 탭 제외 끄기`n^e - 핀으로 고정`n!z - 안 쓰는 import 제거`n!x -`n!q - 파일 검색")

CapsLock::SendInput("^y")
^w::SendInput("^{F4}")
^+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경
^e::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경
!z::SendInput("!^o")
!x::SendInput("/**{Enter 2}{Up}")
!q::SendInput("^+n")

/*
###########
## Chrome
###########
*/
#HotIf WinActive("ahk_exe chrome.exe")
!/::MsgBox("## Chrome ##`n^q - 창 복사")

^q::SendInput("!d!{Enter}")

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

	MouseClick(, 604, 90,, 0)

	Sleep(100)

	if (flag) {
		MouseClick(, 615, 180,, 0)
	} else {
		MouseClick(, 675, 180,, 0)
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
		MouseClick(, 528, 92,, 0)
		Sleep(300)
		MouseClick(, 517, 216,, 0)
		Sleep(300)
		MouseClick(, 477, 92,, 0)
		Sleep(100)
		MouseClick(, 601, 254,, 0)
		Sleep(100)

		global isFirst := false
	} else {
		MouseClick(, 502, 90,, 0)
		MouseMove(nowX, nowY, 0)
		Sleep(50)
		SendInput("^+h")
	}

	BlockInput("MouseMoveOff")
	Sleep(50)
	SendInput("{Esc}")
}

:*?:->.::- > `
:*?:## ::👑
:*?:$$ ::📌
:*?:!! ::🔸
:*?:@@ ::🔹


/*
###########
## Command
###########
*/
#HotIf WinActive("ahk_exe cmd.exe")
!/::MsgBox("^1 - 일배치 jar 실행")

^1::runReport()

runReport() {
	SendInput("java -jar -Dspring.profiles.active=prod c:\batch_report-1.1.jar")

	if (KeyWait("Enter", "D T10")) {
		openReportDirectory()
	}
}

openReportDirectory() {
	try {
		run("C:\Users\kdh\Desktop\온누리 일배치")
		Sleep(1000)
		run("C:\Project\운영\온누리 일배치\auto")
	} catch (Error) {
	}
}

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
!/::MsgBox("!q - SELECT, FROM`n!w - WHERE 1 = 1 ~ AND`n!e - AND`n!r - ORDER BY`n!a - 테이블 정보 조회`n!s - 공통 코드 조회`nCapsLock - 한 줄 지우기")

!q::SendInput("SELECT *`nFROM   ")
!w::SendInput("WHERE  1 = 1`nAND    ")
!e::SendInput("+{Enter}AND    ")
!r::SendInput("ORDER BY REG_DT DESC")
CapsLock::SendInput("+{Home 2}{Backspace 2}{Down}")

!a::runClipboardQuery("SELECT COLUMN_NAME, ATTRIBUTE_NAME, NOT_NULL, DATATYPE, POS FROM COLDEF WHERE TABLE_NAME = '")
!s::runClipboardQuery("SELECT CMMN_CD, CMMN_CD_NM,CMMN_CD_DC_CN, USE_YN FROM COM_CODE WHERE CD_GROUP_ENG_NM = '")

/*
해당 항목으로 쿼리 실행
*/
runClipboardQuery(query) {
	beforeData := A_Clipboard

	SendInput("^c")
	Sleep(10)
	SendInput("+{Enter}")
	Sleep(1)
	A_Clipboard := query A_Clipboard "';"

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

CapsLock::SendInput("^+k")
!c::SendInput("console.log(){Left}")

;F1::emoticon(false)
;F3::emoticon(true)
;~ F1::emoticonAllLines(false)
;~ F3::emoticonAllLines(true)
;~ F4::global isStop := true

;~ emoticonAllLines(variation) {
	;~ path   := ["C:\you2.png", "C:\me.png"]
	;~ heartX := [53, -23]
	;~ heartY := 23

	;~ emoticonArray    := [26]
	;~ emoticonIdxLimit := 1

	;~ if (variation) {
		;~ emoticonArray    := [26, 66, 100, 136, 177, 216]
		;~ emoticonIdxLimit := 6
	;~ }

	;~ CoordMode("Pixel", "Window")

	;~ WinGetPos(&kx, &ky, &kw, &kh, "ahk_class #32770")

	;~ global isStop := false

	;~ Loop {
		;~ randomY           := Random(ky, ky + kh - 150)
		;~ randomPick        := Random(1, 2)
		;~ randomEmoticonIdx := Random(1, emoticonIdxLimit)

		;~ ImageSearch(&foundX, &foundY, kx, randomY, kx + kw, ky + kh - 150, path[randomPick])

		;~ if (foundX != "") {
			;~ MouseClick(, foundX + heartX[randomPick], foundY + heartY,, 0)
			;~ Sleep(50)
			;~ MouseClick(, emoticonArray[randomEmoticonIdx], 26,, 0)
			;~ Sleep(50)
			;~ MouseClick(, 10, 10,, 0)
		;~ }

		;~ if (isStop) {
			;~ break
		;~ }
	;~ }
;~ }

;~ /*
;~ 이모티콘 헛짓거리
;~ */
;~ emoticon(variation) {
	;~ MouseGetPos(&xpos, &ypos)

	;~ emoticonArray := [26]
	;~ emoticonCount := 1

	;~ if (variation) {
		;~ emoticonArray := [26, 66, 100, 136, 177, 216]
		;~ emoticonCount := 6
	;~ }

	;~ global isStop := false

	;~ Loop {
		;~ MouseClick(, xpos, ypos,, 0)
		;~ Sleep(100)
		;~ MouseClick(, emoticonArray[mod(A_Index + 1, emoticonCount) + 1], 26,, 0)
		;~ Sleep(100)
		;~ MouseClick(, 10, 10,, 0)

		;~ if (isStop) {
			;~ break
		;~ }
	;~ }

	;~ MouseClick(, xpos, ypos,, 0)
;~ }


; 이미지 다운로드
;~ F1:: {
	;~ Loop 396 {
		;~ Download("https://ebook.nebooks.co.kr/nw/h/BD04000012/assets/page-images/page-395042-0" Format("{:03}", A_Index + 1) ".jpg", "C:\down\grammarzone-" Format("{:03}", A_Index + 1) ".jpg")
		;~ Sleep(400)
	;~ }
;~ }