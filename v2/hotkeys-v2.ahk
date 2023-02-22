/*
전역변수 선언
*/
global isStop  := false
global isFirst := true

/*
기본 기능 설정
*/
if (A_ComputerName = "DESKTOP-2SVBCIT") {
	workAlarm()
} else if (A_UserName = "DESKTOP-DSINAHN") {
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

;~ F2:: {
	;~ Loop {
		;~ MsgBox(mod(A_Index - 1, Length) + 1)
	;~ }
;~ }

F1:: {
	cookie := "mxuid=0429e91d-fa14-4ff4-86c7-26539b230061; cro_uv_ymd=20230222; FA_CERTIFY_ITEM_TKLINK=SIsQ5ciI9cZO37OJrph1OQ%3D%3D; cro_order_1439909768=1677031514969; FACILITY_NAVIGATION_COOKIE=SCHEDULE; FA_VIEW_ID=mS7v8fJJYHzyYwHTL9n7TQ%3D%3D; SCOUTER=x7b8k9h1ciocev; FA_TKLINK=tt9fTl7vsJreY2qDcEKfbyissnSOR9I5ZhpPr9BcczUYlrA8o2kJpxT6PYgAxO9BCMdWz%2Bby1X0ZV0nitFpfj%2BrJrICUXDiKoLOou46tXMSnjYQxa5BAkuZv4DnkKvsWwT1QwCvS0Y4tTBv0yuenT4z6txCbONeselwMwm2ybTZaH8mBbTh9d%2FWKs6cFU9zi9E%2FhAAamFmhlR7ao4BkUDDhTpacYXmh6dTNIMPFa4%2B6ob6B6dPnKpKoZD6l2kS8Xi4Jkq962ITrwFCTaIQfvdc9khhjxYjj89RaIPrNn%2FlKEW8fEPpVCF7eqmS0PZ6O7uyk2zv7w7v%2FJOE7ONky0x9y7uG1cdH77nktsN7CB%2FUoRO2EdrGOYON%2BMO7ygoGrRQ3%2FDeB7wqsI0pVT1oKQjec8I7m4Lojmzgc6mg7rm5NwWJlRAXCsehVrC3v9OgtWJ69dCtYg2D8y5sZp%2B0TtwBr60uJm%2BHM%2Fb3T4BEd4kASDmRi9dwkIulao8PntnZUxErcwlSbTIddYwTMbos4Jvaqt7cEoR7kVigBHOVLCysNvFUm25Th0cZuQoOQwBhAJZfliq3ajv91WwCnoWfQl%2FYu6E5Krylt4h4I82xZLPgoW63qBczCN6XUNuKLO8K5k9SiDHZa2oB6BglkUvCSP5a1KtzlorGYg19oV3MrvTqNB72FUl2khSd9x1STSOOa%2Bd9sZKJxxDdEyJzYQsVtrAEX1Z5lcVnvzavx%2B6LBdf6qgs%2Fac2axf7%2Bckv91In6v9sg8Q5w2SSvmlqgQnD1Uqbd8F7t6Ow8ootqyP3v%2FWBvwzAN%2B4QcZrwrX54I2rAnRGoFWLLyIOJs%2FVZCluKJjNpXawsn%2BypNmUgUaBdnGXeheVUcOxtENJq6s2PW2gUrFU2fuKv0mcO%2BNTftr3zeDwIXOFZ%2FkSjpmDXtMyxP8qJ9bCZNnmmJF8fbyQ%2BT2hy0bH6ErwNX8JUAS7DkNAQ%2BID4KfNA1BB3%2BiBkD7aqlxiyo2Z7cTTCbjEK1bCEBR1wdRZot5MYufp1a8bHLgkqPkXKvynIdirj3xt20RqWNl7pAwalQxZt4oKOk1UPlrb1d8PCdHY3fvI%2BB3ICPewkNZoED8%2BIuG4vIXd9XvW%2F4YpKZRAYLtY%2F%2Ft8calHXbw6mzK7ObR1uxZwV5znUMBWi5Bic6DZivhFQA%2FXizt8%2F1POZIrSYnSN%2BJWzvFRvkfKf40R%2FIipziucGgWcN76t%2BpN2utGrmNEMUhg6pcvoTFVd%2BhSZZ%2Fm3VZfFQLFmrte8dSnTB059Cls2blRw7Q8nLYVdiT%2Fr3CPOh6tXbiylC1TuxsCVNCfgHuX8XufA78Fstfw4%2BVpMl5PgmAxYBqKUAMTSthNZPI43SlUioIxCHVnhsnrGTxrmTlVJ1c7J2YrDNTIEfbUdPZCe1Tjsrur9iO4QoYI3fagmKjSygVIUb165OWre4dJ3uB4T%2Fp2jxBtbQjhmx06AQrx3vYzYwqIJcR2%2BL3PL92a007pgvCGX2nTZ8o45MBK%2FXnA2JmPU%2FpH5ltBIU6; JSESSIONID=08C1932F8B3F02EEF7A3401DE8CF7852.WAS2; gateKey_ID=5003%3A201%3Akey%3DC381D8B2B262B2127847C27A007D6A9BFE6DCE93AE7CF84304016B6B6293F76C0631B06CD3599B4867BBD33B62EC0B903E6FE7F8C9FA9D25857550C61AE553A423883F3C4BEFCD752FBACD22E1DA0C11978C01C3277CF14C9E3B0FE7C869DF363A4CC99FE943DE453078799C64111020302C312C302C30%26nwait%3D0%26nnext%3D0%26tps%3D0.000000%26ttl%3D10%26ip%3Dwait.ticketlink.co.kr%26port%3D80"

	reqUrl          := "https://facility.ticketlink.co.kr/api/V2/plan/schedules/@/grades"
	indexArray      := ["322237016", "1557972116", "848645101", "1160297891", "1974243180", "130120097", "50461688", "1231453308", "2076089326", "75613394"]
	urlArray        := []
	urlArray.Length := indexArray.Length

	Loop indexArray.Length {
		urlArray[A_Index] := StrReplace(reqUrl, "@", indexArray[A_Index])
	}

	Loop {
		httpObj := ComObject("WinHTTP.WinHTTPRequest.5.1")

		httpObj.Open("GET", urlArray[mod(A_Index - 1, urlArray.Length) + 1])
		httpObj.SetRequestHeader("cookie", cookie)
		httpObj.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36")
		httpObj.SetRequestHeader("Accept", "*/*")
		httpObj.SetRequestHeader("Connection", "keep-alive")

		httpObj.Send()

		httpObj.WaitForResponse
		; httpObj.ResponseText()

		cntArray  := StrSplit(httpObj.ResponseText(), "remainCnt")

		if (cntArray.Length != 5) {
			MsgBox("통신 실패!!!!!!!!!!!!!")
			break
		}

		isSuccess := false

		Loop cntArray.Length - 1 {
			if (SubStr(cntArray[A_Index + 1], 3, 1) != "0") {
				isSuccess := true
			}
		}

		if (isSuccess) {
			Run("https://facility.ticketlink.co.kr/reserve/plan/schedule/" indexArray[mod(A_Index - 1, urlArray.Length) + 1])
			break
		}

		msg("체크 중")

		Sleep(1000)
	}
}

Pause:: {
	SetControlDelay -1

	Loop {
		array := [[259, 302], [57, 335], [125, 332], [225, 334], [58, 361], [193, 363]]

		index := mod(A_INDEX, array.Length) + 1
		MouseClick(, array[index][1], array[index][2],, 0)
		Sleep(700)
		MouseClick(, 388, 281,, 0)
		Sleep(400)

		Loop {
			ImageSearch(&foundX, &foundY, 647, 245, 672, 258, "C:\auto_image\allout.png")

			Sleep(10)

			if (foundX != "") {
				break
			} else {
				ImageSearch(&found2X, &found2Y, 647, 245, 672, 258, "C:\auto_image\clickfail.png")

				if (found2X != "") {
					MouseClick(, 388, 281,, 0)
				}
			}
		}
	}
}



/*
날짜/회차선택
*/
/* F1:: {
	path := ["C:\auto_image\round1.png", "C:\auto_image\round2.png"]

	MouseClick(, 204, 241, 2, 0)

	;~ MouseClick(, 59, 331,, 0)

	;~ global isStop := false

	;~ Loop {
		;~ if (isStop) {
			;~ break
		;~ } ; https://facility.ticketlink.co.kr/reserve/plan/schedule/1882156947 1325537586 838634373 1309764293

		;~ ImageSearch(&foundX, &foundY, 312, 227, 484, 270, path[1]) ; 회차선택 : 312, 227 ~ 485, 270

		;~ if (foundX != "") {
			;~ MouseClick(, 385, 248,, 0)

			;~ Loop {
				;~ if (isStop) {
					;~ break
				;~ }

				;~ ImageSearch(&found2X, &found2Y, 313, 233, 480, 270, path[2]) ; 회차선택 클릭 후 : 313, 233 ~ 480, 270

				;~ if (found2X != "") {
					;~ Loop {
						;~ if (isStop) {
							;~ break
						;~ }

						;~ Sleep(100)
						;~ MouseClick(, 853, 827,, 0) ; 853, 827

						;~ ImageSearch(&found3X, &found3Y, 313, 233, 480, 270, path[2])

						;~ if (found3X == "") {
							;~ Msg("끝")
							;~ break
						;~ }
					;~ }

					;~ break
				;~ }
			;~ }

			;~ break
		;~ }
	;~ }

	;~ Msg("끝")

	;~ ; Real
	;~ ; MouseClick(, 204, 241, 2, 0)
	;~ ; MouseClick(, 57, 454,, 0)
}

;~ F2:: global isStop := true

F3:: {
	seatColor := 0x5E96C5
	originX   := 271
	originY   := 340
	endX      := 446
	endY      := 432 + 100
	pos       := [originX, originY]

	SetControlDelay -1

	Loop {
		if (pos[1] + 13 > endX) { ; x좌표가 우측 끝으로 가면 초기 위치로 초기화
			pos[1] := originX
			pos[2] := pos[2] + 9
		}

		if (pos[2] + 3 > endY) { ; 마지막 줄을 넘어섰을 때 종료
			msg("끝")
			break
		}

		if (PixelSearch(&px, &py, pos[1], pos[2], endX, pos[2] + 2, seatColor)) {
			if (PixelSearch(&p2x, &p2y, px + 10, py, px + 13, py + 2, seatColor)) {
				;~ MsgBox(px ", " py "`n" p2x ", " p2y)

				; 911, 828
				ControlClick("x" px " y" py, "티켓링크 예매 - Chrome")
				ControlClick("x" p2x " y" p2y, "티켓링크 예매 - Chrome")
				;~ MouseClick(, px + 2, py + 2,, 0)
				;~ MouseClick(, p2x + 2, p2y + 2,, 0)

				;~ 아래는 임시. 처음부터 돌릴 건지 아닌지에 따라 넣을 수도 있고 아닐 수도 있음
				pos[1] := px
				pos[2] := py

				;~ Sleep(100)
				;~ ControlClick("x" px + 2 " y" py + 2, "티켓링크 예매 - Chrome",,,, "NA")
				;~ ControlClick("x" p2x + 2 " y" p2y + 2, "티켓링크 예매 - Chrome",,,, "NA")
				;~ MouseClick(, px + 2, py + 2,, 0)
				;~ MouseClick(, p2x + 2, p2y + 2,, 0)
			}
		}

		pos[1] := pos[1] + 10

		;~ ImageSearch(&found3X, &found3Y, 271, 340, 446, 432, "C:\auto_image\seat5.png") ; 3~10열 좌석 : 271, 340 ~ 446, 432

		;~ Loop { ; 선점된 좌석 창 처리
			;~ ImageSearch(&found4X, &found4Y, 281, 100, 347, 124, "C:\auto_image\shit.png") ; 이미 선점된 좌석 처리 : 281, 100 ~ 347, 124

			;~ if (found4X != "") {
				;~ Loop {
					;~ SendInput("{Enter}")
					;~ MouseClick(, 670, 152,, 0) ; 확인 클릭

					;~ Sleep(100)
					;~ ImageSearch(&found5X, &found5Y, 281, 100, 347, 124, "C:\auto_image\shit.png") ; 이미 선점된 좌석 처리 : 281, 100 ~ 347, 124

					;~ if (found5X == "") {
						;~ break
					;~ }
				;~ }

				;~ break
			;~ }
		;~ }
	}
}

F4:: {
	;~ MouseGetPos(&kx, &ky, &kw, &kh)

	;~ seatColor := 0x5E96C5

	;~ if (PixelSearch(&px, &py, kx, ky, kx + 100, ky + 100, seatColor)) {
		;~ if (PixelSearch(&p2x, &p2y, px + 10, py, px + 13, py, seatColor)) { ; 276,
			;~ msg(px ", " py "`n" p2x ", " p2y)
		;~ }
	;~ }

	ControlClick("x911 y828", "티켓링크 예매 - Chrome")


	;~ if (PixelSearch(&px, &py, kx, ky, kx + 100, ky + 100, seatColor)) {
		;~ if (PixelSearch(&p2x, &p2y, kx, ky, kx + 100 + 10, ky + 100, seatColor)) { ; 276,
			;~ msg("찾았다")
		;~ } else {
			;~ msg("2차에서 못찾았다")
		;~ }
	;~ } else {
		;~ msg("1차에서 못찾았다")
	;~ }



	;~ ImageSearch(&found3X, &found3Y, kx, ky, 446, 464, "C:\auto_image\seat3.png") ; 3~10열 좌석 : 271, 340 ~ 446, 432

	;~ if (found3X != "") {
		;~ msg(found3X ", " found3Y)
	;~ }
} */

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
!/::MsgBox("!q - SELECT, FROM`n!w - WHERE 1 = 1 ~ AND`n!e - AND`n!r - ORDER BY`n!a - 테이블 정보 조회`n!s - 공통 코드 조회`n!d - 최근 10개 항목 조회`nCapsLock - 한 줄 지우기")

!q::SendInput("SELECT *`nFROM   ")
!w::SendInput("WHERE  1 = 1`nAND    ")
!e::SendInput("+{Enter}AND    ")
!r::SendInput("ORDER BY REG_DT DESC")
CapsLock::SendInput("{End}+{Home 2}{Backspace 2}{Down}")

!a::runClipboardQuery("SELECT COLUMN_NAME, ATTRIBUTE_NAME, NOT_NULL, DATATYPE, POS FROM COLDEF WHERE TABLE_NAME = '")
!s::runClipboardQuery("SELECT CMMN_CD, CMMN_CD_NM,CMMN_CD_DC_CN, USE_YN FROM COM_CODE WHERE CD_GROUP_ENG_NM = '")
!d::runClipboardQuery("SELECT TOP 10 * FROM ", false, " ORDER BY REG_DT DESC;")

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