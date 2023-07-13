/*
++++++++++++++++++++++++++++++++++++++++
++ 임시 기능 선언
++++++++++++++++++++++++++++++++++++++++
*/

/*
++++++++++++++++++++++++++++++++++++++++
++ 전역변수 선언
++++++++++++++++++++++++++++++++++++++++
*/
global isStop  := false
global isFirst := true
global gX      := ""
global gY      := ""

; 에러 코드
ERROR_PATH_NOT_FOUND := 3

; PC 목록
mainPC := "PAY-331"
subPC  := "DESKTOP-2SVBCIT"
homePC := "DESKTOP-4AJLHVU"

; 좌표 변동용 값
laptopList  := [subPC]
desktopList := [mainPC, homePC]
ratio25List := [subPC]

; 좌표 비율
global ratioNow := 1

RATIO_1440 := 1.333
RATIO_X25  := 1.25

; 원노트 좌표
STANDARD_RIBBON_TOOL1_X := 37
STANDARD_RIBBON_TOOL1_Y := 145

STANDARD_RIBBON_TOOL2_X := 58
STANDARD_RIBBON_TOOL2_Y := 145

global RIBBON_TOOL1_XY := "x0 y0"
global RIBBON_TOOL2_XY := "x0 y0"

; 원노트 Clipboard resources
LARGE_STAR_EMOTICON := ClipboardAll(FileRead(".\resources\onenote\large_star_emoticon2", "RAW"))

; 원노트 공통 핫키
ORIGINAL_PASTE_KEY := "!3"

; 물 알람
waterAlarmList := [subPC]

global waterAlarm := false

/*
++++++++++++++++++++++++++++++++++++++++
++ 기본 기능 설정
++++++++++++++++++++++++++++++++++++++++
*/
SetControlDelay -1

config()
alarm()

/*
최초 실행 시 초기 설정 함수
*/
config() {
	; 특정 PC만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	; 화면 비율 설정(좌표 초기화용)
	if (findValue(ratio25List, A_ComputerName)) {
		global ratioNow := RATIO_X25
	}

	; 원노트 좌표 초기화
	global RIBBON_TOOL2_XY      := screenRatioSet(STANDARD_RIBBON_TOOL2_X, STANDARD_RIBBON_TOOL2_Y)
}

/*
화면 비율에 맞춰 좌표 문자열 생성 (format = "x좌표 y좌표")
*/
screenRatioSet(x := 0, y := 0) {
	return "x" Floor(x * ratioNow) " " "y" Floor(y * ratioNow)
}

/*
1분마다 반복되는 재귀함수
타이머 용도로 사용하고 있음
*/
alarm() {
	SetTimer () => alarm(), -1000 * 60

	if (waterAlarm) {
		alarmWater()
	}
}

/*
++++++++++++++++++++++++++++++++++++++++
++ 기본 기능 선언
++++++++++++++++++++++++++++++++++++++++
*/
!/::MsgBox("##### 프로그램 실행 #####`n#`` - notepad 실행 및 활성화`n#1 - 나한테 다이렉트 메세지 보내기`n##### 기타 #####`n`n^+F12 - 1분 타이머 후 사운드`n^\ - caps lock 토글`n^사이드 앞 - 페이지 맨 위로 이동`n^사이드 뒤 - 페이지 맨 뒤로 이동")

#`::runNotepadPP()
#1::Run("slack://channel?team=T047TLC218Q&id=D0476MC9TPE")

; 1분 타이머, Beep 사운드 알람
+F12::ringTimer(60)

!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T")
*ScrollLock::blockAllInput() ; 관리자 권한으로 실행 필요

!+WheelUp::setTransparent(10)
!+WheelDown::setTransparent(-10)
^XButton1::SendInput("^{End}")
^XButton2::SendInput("^{Home}")

^#Right::switchWithMute(true)
^#Left::switchWithMute(false)

Pause::Reload

F1::runParamUrl("https://ko.dict.naver.com/#/search?query=", "국어사전")
F3::runParamUrl("https://en.dict.naver.com/#/search?query=", "영어사전")


/*
클립보드 데이터를 .\resources에 파일로 저장
*/
clipboardSave() {
	try {
		FileAppend(ClipboardAll(), ".\resources\" A_Now)
	} catch OSError {
		if (A_LastError = ERROR_PATH_NOT_FOUND) {
			; 경로가 없을 시 경로 생성
			DirCreate(".\resources")
			MsgBox("경로 생성 완료.`n함수 재실행 필요")
		} else {
			MsgBox("알 수 없는 OSError 발생, 에러 코드 : " A_LastError)
		}
	} catch as e {
		MsgBox("알 수 없는 Error 발생, 에러 코드 : " A_LastError)
	}
}

/*
타이머 실행 후 사운드 알람, ToolTip 표기
#param Number time : 타이머 시간(초) (default = 1초)
*/
ringTimer(time := 1) {
	msg(time "초 타이머 시작")
	SoundBeep(550, 500)
	SetTimer () => SoundBeep(550, 500), -1000 * time

	displayCounter(time)
}

/*
설정한 시간에 따라 매 초 ToolTip 표기
1부터 N까지 진행
#param Number time : 타이머 시간(초) (default = 3초)
*/
displayCounter(count := 3) {
	CoordMode("ToolTip", "Screen")

	Loop count {
		locatedMsg(A_Index)
		Sleep(1000)
	}
}

/*
URL에 param 더해서 실행하는 함수
#param String url   : URL
#param String title : 입력 창 제목 (default = "Run URL")
*/
runParamUrl(url, title := "Run URL") {
	input := InputBox(, title, "w100 h70")
	if input.Result = "OK" {
		Run(url input.value)
	}
}

/*
현재 포커스된 창 투명도 조절
#param Number gap : 변동시킬 투명도 수치
*/
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

/*
60분마다 "물" 메세지 박스 출력
*/
alarmWater() {
	static waterTime := 0

	if (++waterTime = 60) {
		MsgBox("물")

		waterTime := 0
	}
}

/*
메세지 출력
#param String message : 메세지
#param Number time    : 노출 시간 (default = 2초)
*/
msg(message, time := 2) {
	ToolTip(message)
	SetTimer () => ToolTip(), -1000 * time
}

/*
고정 위치에 메세지 출력
#param String message : 메세지
#param Number x       : x좌표
#param Number y       : y좌표
#param Number time    : 노출 시간 (default = 2초)
*/
locatedMsg(message, x := 100, y := 100, time := 2) {
	ToolTip(message, x, y)
	SetTimer () => ToolTip(), -1000 * time
}

/*
배열에서 값 찾기(예외처리 X)
#param String[] arr  : 배열
#param String target : 찾을 값
*/
findValue(arr, target) {
	for value in arr {
		if (value = target) {
			return true
		}
	}
	return false
}

/*
Notepad++ 실행
*/
runNotepadPP() {
	if WinExist("ahk_exe notepad++.exe") {
		WinActivate
	} else {
		Run("notepad++.exe")
	}
}

/*
OneNote 실행
*/
runOneNote() {
	if WinExist("ahk_exe ApplicationFrameHost.exe") {
		WinActivate
	} else {
		Run("ApplicationFrameHost.exe")
	}
}

/*
IntelliJ 실행
*/
runIntelliJ() {
	if WinExist("ahk_exe idea64.exe") {
		WinActivate
	} else {
		Run("idea64.exe")
	}
}

/*
키보드 마우스 입력 중지
#param Number time : 노출 시간 (default = 0.1초)
*/
blockAllInput(time := 0.1) {
	BlockInput True

	Sleep(1000 * time)

	BlockInput False
}


/*
가장 최근 클립보드 데이터의 포맷 출력
*/
printClipboardFormatList() {
	formatCount := DllCall("CountClipboardFormats")

	formatList := []

	formatList.Push(DllCall("custom-utility.dll\checkImageFormats", "UINT", "0"))

	result := formatList[1]

	Loop  formatCount - 1 {
		formatList.Push(DllCall("custom-utility.dll\checkImageFormats", "UINT", formatList[A_Index]))

		result := result " " formatList[A_Index + 1]
	}

	MsgBox(result)
}

/*
타이머 실행 후 사운드 알람, ToolTip 표기
#param Number time : 타이머 시간(초) (default = 1초)
*/
switchWithMute(muteFlag) {
	SoundSetMute(muteFlag)
	if (muteFlag) {
		SendInput("^#{Right}")
	} else {
		SendInput("^#{Left}")
	}
}

/*
########################################
## IntelliJ
########################################
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox("## IntelliJ ##`n(X)CapsLock - 한 줄 제거`n^w - 탭 끄기`n^+w - 고정 탭 제외 끄기`n^e - 핀으로 고정`n!z - 안 쓰는 import 제거`n!x - 메서드 return값으로 변수 생성`n!c - 메서드화`n!q - 최근 사용 파일 검색`n!w - 파일 검색`n!e - 클래스 구조(Structure) 보기`n^. - 메서드 Document 주석 달기`n!a - 현재 커서 위치 모듈 Run`n!s - 마지막 모듈 Run`n!d - 마지막 모듈 Debug")

;~ CapsLock::SendInput("^y")
^w::SendInput("^{F4}")
^+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경
^e::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경
^.::SendInput("!+h") ; 메서드 Document 주석 달기(IntelliJ JavaDoc plugin 키설정을 해당 키로 변경)
!z::SendInput("!^o")
!x::SendInput("^!v")
!c::SendInput("^!m") ; 메서드화
!q::SendInput("^e")
!w::SendInput("^+n")
!e::SendInput("!7") ; Structure
!a::SendInput("^+{F10}")
!s::SendInput("+{F10}")
!d::SendInput("+{F9}")
`::SendInput("^y")

/*
########################################
## Chrome
########################################
*/
#HotIf WinActive("ahk_exe chrome.exe")
!/::MsgBox("## Chrome ##`n^q - 창 복사`n!s - 시크릿 모드 창 열기")

^q::SendInput("{F6}!{Enter}")
!s::SendInput("^+n")

/*
########################################
## Whale
########################################
*/
#HotIf WinActive("ahk_exe whale.exe")
!/::MsgBox("^q - 창 복사`n!a - 새 탭 열기`n!s - 시크릿 모드 창 열기")

^q::SendInput("^k")
!a::SendInput("^t")
!s::SendInput("^+n")

/*
########################################
## 원노트
########################################
*/
#HotIf WinActive("ahk_exe ONENOTE.EXE")
!/::MsgBox("!q - Highlight`n!w - 폰트 색 설정`n!e - Bold 12pt`n!z - 서식 제거`n!x - 줄머리 넣기`n!c - 가로줄 넣기`n!a - 그리기 직선`n!s - 그리기 화살표`n!d - 1레벨 목차 설정`n!f - 2레벨 목차 설정`n^v - HTTP URL일 경우 링크 이름 편집 / 이미지 그림 붙여넣기`n^+v - 서식 유지해서 붙여넣기`n^+z - 맨 밑에 페이지 추가`n^+x - 현재 페이지 밑에 페이지 추가`n^+c - 페이지 수준 내리기`n^+q - 현재 페이지 목차 생성`n#q - LARGE_STAR_EMOTICON`nF5 - 즐겨찾기`n+Enter - 현재 커서 위치랑 상관 없이 다음 줄로 넘어가기`n!PgUp, !사이드 앞 - 객체 맨 앞으로`n사이드 앞 - 다음 페이지`n사이드 뒤 - 이전 페이지")

!a::selectFigure() ; 그리기 직선(도형 도구 - 빠른 실행 도구 1번째에 지정)
!s::selectFigure("0", "1") ; 그리기 화살표(도형 도구 - 빠른 실행 도구 1번째에 지정)
!w::paintFont("7") ; 글씨색 변경 빨간색(빠른 실행 도구 2번째에 지정, 팔레트 기준 7번째 아래 위치)
^+v::SendInput(ORIGINAL_PASTE_KEY) ; 서식 유지해서 붙여넣기(빠른 실행 도구 3번째에 지정)
#q::printResource(LARGE_STAR_EMOTICON) ; 큰 별 넣기 (서식 유지해서 붙여넣기)
^v::paste() ; HTTP URL일 경우 붙여넣기 시 이름 링크로 삽입 / 이미지는 그림으로 붙여넣기(빠른 실행 도구 4번째에 지정)
!q::SendInput("!5") ; Highlight(빠른 실행 도구 5번째에 지정)
;!w::SendInput("!6") ; Red emphasis(빠른 실행 도구 6번째에 지정)
!e::SendInput("!7") ; Bold 12pt(빠른 실행 도구 7번째에 지정)
F5::SendInput("!8") ; 즐겨찾기(빠른 실행 도구 8번째에 지정)
^+x::SendInput("!09") ; 현재 선택된 페이지 하위에 페이지 추가(빠른 실행 도구 10번째에 지정)
!x::SendInput("!08") ; 줄머리 넣기(빠른 실행 도구 11번째에 지정)
^+q::SendInput("!07") ; 목차 생성(빠른 실행 도구 12번째에 지정)
!d::SendInput("!06") ; 1레벨 목차 설정(빠른 실행 도구 13번째에 지정)
!f::SendInput("!05") ; 2레벨 목차 설정(빠른 실행 도구 14번째에 지정)
!c::SendInput("!04") ; 텍스트 직선 긋기(빠른 실행 도구 15번째에 지정)
!PgUp::SendInput("!03") ; 객체 맨 앞으로(빠른 실행 도구 16번째에 지정)
!XButton2::SendInput("!03") ; 객체 맨 앞으로(빠른 실행 도구 16번째에 지정)

!z::SendInput("^+n") ; 글 서식 제거

^+z::SendInput("^n") ; 맨 밑에 페이지 추가
^+c::SendInput("!^]") ; 페이지 수준 내리기

XButton1::SendInput("!{Left}")
XButton2::SendInput("!{Right}")

+Enter::SendInput("{End}{Enter}") ; 현재 커서 위치랑 상관 없이 다음 줄로 넘어가기

+PgUp::SendInput("^+`>") ; 폰트 크기 키우기
+PgDn::SendInput("^+`<") ; 폰트 크기 줄이기
+WheelUp::SendInput("^+`>") ; 폰트 크기 키우기
+WheelDown::SendInput("^+`<") ; 폰트 크기 줄이기

/*
resource 출력, 빠른 실행 도구의 원본 서식 유지해서 붙여넣기 기능에 의존
입력키를 따로 관리하지 않는 이유는 귀찮아서(개선 여지가 있음)
#param Object resource : Buffer 객체, ClipboardALl(data)로 생성
*/
printResource(resource) {
	try {
		A_Clipboard := resource
		SendInput(ORIGINAL_PASTE_KEY)

	} catch as e {
		msg("실패 : " e)
	}
}

/*
도형 선택 - 도형 도구 빠른 실행 도구 1번째에 지정
#param String figureXY : 리본 내 선택할 도형 x, y좌표 (format = "x좌표 y좌표")
*/
selectFigure(downCount := "0", rightCount := "0") {
	; STEP 01. 도형 도구
	SendInput("!1")

	; STEP 02. 도형 선택
	SendInput("{Down " downCount "}{Right " rightCount "}{Space}")
}

/*
Font Style 지정 후 맨 앞으로 가져오기 - 빠른 실행 도구 16번째에 "맨 앞으로 가져오기" 지정
#param String locate : 실행할 빠른 실행 도구의 스타일 핫키
*/
;~ setFontStyle(locate) {
	;~ SendInput("!" locate)
	;~ Sleep(1000)
	;~ SendInput("!2")
;~ }

/*
Font Color 선택 - 빠른 실행 도구 2번째에 지정
#param String downCount  : 팔레트에서 아래 방향으로 향할 횟수
#param String rightCount : 팔레트에서 오른쪽 방향으로 향할 횟수
#param Boolean backColor : 현재 지정되어 있는 배경색 적용 (default = true)
*/
paintFont(downCount := "0", rightCount := "0", backColor := false) {
	if (isFirst) {
		global isFirst := false

		SendInput("!2")
		SendInput("{Down " downCount "}{Right " rightCount "}{Enter}")
	} else {
		; STEP 01. Font Color 클릭
		ControlClick(RIBBON_TOOL2_XY, "A",,,, "NA")

		; STEP 02. Font Background Color 추가
		if (backColor) {
			SendInput("^+h")
		}
	}
}

/*
붙여넣기 시 클립보드 내용에 따라 분류해서 처리

1. 텍스트가 http로 시작할 경우 지정된 형식의 링크로 삽입
2. 텍스트에 속할 경우 일반 붙여넣기
3. Slack에서 복사한 이미지일 경우(UINT format -> 50121) 그림으로 붙여넣기
*/
paste() {
	if (DllCall("CountClipboardFormats") = 6 && DllCall("IsClipboardFormatAvailable", "UInt", 2)) {
		A_Clipboard := ClipboardAll()
	}

	if (SubStr(A_Clipboard, 1, 4) = "http") {
		SendInput("^k")
		Sleep(150)
		ControlSetText("Link", "RICHEDIT60W3", "ahk_exe ONENOTE.EXE")
		ControlSetText(A_Clipboard, "RICHEDIT60W2", "ahk_exe ONENOTE.EXE")
		ControlFocus("RICHEDIT60W3", "ahk_exe ONENOTE.EXE")
		SendInput("{Enter}")
	} else if(DllCall("IsClipboardFormatAvailable", "UInt", 49437)) {
		SendInput("!4")
		SendInput("{Esc}")
	} else {
		SendInput("^v")
	}
}

/*
########################################
## SSMS
########################################
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
########################################
## DBeaver
########################################
*/
#HotIf WinActive("ahk_exe dbeaver.exe")
!/::MsgBox("!q - SELECT, FROM`n!w - WHERE 1 = 1 ~ AND`n!e - AND`n!r - ORDER BY`n!a - 테이블 정보 조회`n!s - 공통 코드 조회`n!d - 최근 10개 항목 조회`n(X)CapsLock - 한 줄 지우기")

!q::SendInput("SELECT *`nFROM   ")
!w::SendInput("WHERE  1 = 1`nAND    ")
!e::SendInput("+{Enter}AND    ")
!r::SendInput("ORDER BY REG_DT DESC")
;~ CapsLock::SendInput("{End}+{Home 2}{Backspace 2}{Down}")

/*
해당 항목으로 쿼리 실행
#param String query   : 실행시킬 쿼리
#param Boolean quote  : 뭐더라 (default = true)
#param String endWord : 뭐더라 (endWord = ";")
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
########################################
## VSCode
########################################
*/
#HotIf WinActive("ahk_exe Code.exe")
!/::MsgBox("CapsLock - 한 줄 지우기`n!c - console.log()")

;~ CapsLock::SendInput("^+k")
!c::SendInput("console.log(){Left}")
+Enter::SendInput("^{Enter}")
^Enter::SendInput("{End};")

/*
########################################
## SciTE4AutoHotkey
########################################
*/
#HotIf WinActive("ahk_exe SciTE.exe")
!/::MsgBox("!q - 책갈피 설정/제거`n!w - 책갈피로 이동`n^/ - 구역 주석")

!q::SendInput("^{F2}")
!w::SendInput("{F2}")
^/::SendInput("/*`n`n*/{Up}")

/*
########################################
## Slack
########################################
*/
#HotIf WinActive("ahk_exe slack.exe")
!/::MsgBox("!q - 이미지 복사")

!q::copyImage()

/*
이미지 클릭된 상태일 때 이미지 복사
*/
copyImage() {
	WinGetPos(,, &x, &y, "A")
	ControlClick("x" (x / 2) " y" (y / 2), "A",, "Right")
	Sleep(50)
	SendInput("{Down}{Enter}")
}