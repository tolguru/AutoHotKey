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

; Config
configMap := Map()

; Config Keys
GOOGLE_TRANSLATE_UUID_KEY := "googleTranslateUUID"
NAVER_KO_DIC_UUID_KEY     := "koreanDictionaryUUID"
NAVER_EN_DIC_UUID_KEY     := "englishDictionaryUUID"

; 에러 코드
ERROR_PATH_NOT_FOUND := 3

; PC 목록
mainPC := "PAY-331"
subPC  := "DESKTOP-2SVBCIT"
homePC := "DESKTOP-4AJLHVU"

; Default Run Param app Browser
global runAppBrowser := "chrome.exe"

; Default Browser 설정 리스트
useWhaleList := [mainPC]

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

; 원노트 공통 핫키
DRAW_FIGURE_KEY    := "!1"
ORIGINAL_PASTE_KEY := "!3"
BULLET_POINT_KEY   := "!08"

; 물 알람
waterAlarmList := []

global waterAlarm := false

; 환경 변수 데이터
GMAIL      := EnvGet("aaGmail")
NAVER_MAIL := EnvGet("aaNmail")
PHONE_NUM  := EnvGet("aaPhone")

; URL
GOOGLE_TRANSLATE_URL := "https://translate.google.co.kr/?sl=en&tl=ko&text="
NAVER_KO_DIC_URL     := "https://ko.dict.naver.com/#/search?query="
NAVER_EN_DIC_URL     := "https://en.dict.naver.com/#/search?query="

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
	; File Config 불러오기
	configLoad()

	; 특정 PC만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	; 화면 비율 설정(좌표 초기화용)
	if (findValue(ratio25List, A_ComputerName)) {
		global ratioNow := RATIO_X25
	}

	; Run Param app Browser 설정
	if (findValue(useWhaleList, A_ComputerName)) {
		global runAppBrowser := "whale.exe"
	}

	; 원노트 좌표 초기화
	global RIBBON_TOOL2_XY := screenRatioSet(STANDARD_RIBBON_TOOL2_X, STANDARD_RIBBON_TOOL2_Y)
}

/*
configMap 스태틱 변수 return
*/
getConfigMap() {
	return configMap
}

/*
config 파일의 데이터를 key, value로 나눈 후 configMap 초기화
*/
configLoad() {
	configFile := FileOpen(".\config.txt", "rw", "UTF-8")

	; 줄바꿈 문자로 config 구분 후 ":" 문자로 Key, Value 구분
	Loop Parse, configFile.Read(), "`n" {
		configData := StrSplit(A_LoopField, ":",, 2)

		; 해당 config에 value가 설정되어 있지 않으면 "NULL" 문자열 지정
		if (A_LoopField != "") {
			getConfigMap().Set(configData[1], configData.Length = 2 ? configData[2] : "NULL")
		}
	}

	configFile.Close()
}

/*
현재 configMap 객체에 있는 데이터를 파일로 저장
*/
configSave() {
	configFile := FileOpen(".\config.txt", "w", "UTF-8")

	For key, data in getConfigMap() {
		configFile.WriteLine(key ":" data)
	}

	configFile.Close()
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
!/::MsgBox("##### 프로그램 실행 #####`n#`` - 노션 실행`n#Tab - notepad 실행 및 활성화`n#1 - 나한테 다이렉트 메세지 보내기`n##### 기타 #####`n`n^+F12 - 1분 타이머 후 사운드`n^\ - caps lock 토글`n^사이드 앞 - 페이지 맨 위로 이동`n^사이드 뒤 - 페이지 맨 뒤로 이동")

#`::runEXE("obsidian")
#1::Run("slack://channel?team=T047TLC218Q&id=D0476MC9TPE")
#Tab::runEXE("notepad++")

; 1분 타이머, Beep 사운드 알람
+F12::ringTimer(60)

!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T")
*ScrollLock::blockAllInput() ; 관리자 권한으로 실행 필요

!+WheelUp::setTransparent(10)
!+WheelDown::setTransparent(-10)
^XButton2::SendInput("^{Home}") ; 스크롤 맨 위로
^XButton1::SendInput("^{End}") ; 스크롤 맨 아래로
+XButton1::runPopupBlockedInput(GOOGLE_TRANSLATE_URL, GOOGLE_TRANSLATE_UUID_KEY,,, "{Blind}{Shift Up}") ; 구글 번역 팝업
+XButton2::runPopupBlockedInput(NAVER_EN_DIC_URL, NAVER_EN_DIC_UUID_KEY,, true, "{Blind}{Shift Up}") ; 네이버 영어사전 팝업

^#Right::switchWithMute(true)
^#Left::switchWithMute(false)

Pause::Reload

F1::runPopup(NAVER_KO_DIC_URL, NAVER_KO_DIC_UUID_KEY, true, true)
F3::runPopup(NAVER_EN_DIC_URL, NAVER_EN_DIC_UUID_KEY, true, true)
F4::runPopup(GOOGLE_TRANSLATE_URL, GOOGLE_TRANSLATE_UUID_KEY, true)

Hotstring(":*:gm.", GMAIL)
Hotstring(":*:na.", NAVER_MAIL)
Hotstring(":*:123.", PHONE_NUM)

/*
URL Encode(ref : https://www.autohotkey.com/boards/viewtopic.php?t=112741)
#param String originData : text to be changed
#param String re         : regex
*/
urlEncode(originData, re := "[0-9A-Za-z]") {
	response := ""
    buf := Buffer(StrPut(originData, "UTF-8"), 0)

    StrPut(originData, buf, "UTF-8")

    While code := NumGet(buf, A_Index - 1, "UChar") {
		char := Chr(code)
        if RegExMatch(char, re) {
            response := response char
        }
        else {
            response := response Format("%{:02X}", code)
        }
    }
    return response
}

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
runPopup 함수 실행 중 Input Block, 추가 입력(호출 핫키를 Release해서 입력간 오류 방지용)
*/
runPopupBlockedInput(url, uuidKey, inputFlag := false, enterFlag := false, input := "") {
	BlockInput True
	SendInput(input)
	runPopup(url, uuidKey, inputFlag, enterFlag)
	BlockInput False
}

/*
URL에 클립보드 데이터 넣어서 실행
Config에서 UUID 조회 후 Active 가능
저장된 UUID가 현재 실행 중인 엉뚱한 프로세스와 겹치면 좀 대책없긴 함(개선 필요)
#param String url        : URL
#param String uuidKey    : config에 저장/조회할 UUID의 key name
#param boolean inputFlag : 입력받을지 여부 (default = false)
#param boolean enterFlag : 엔터 입력 여부 (default = false)
*/
runPopup(url, uuidKey, inputFlag := false, enterFlag := false) {
	if (inputFlag) {
		inputText := showInputBox("URL 실행")

		if (inputText = "") {
			return
		}
	}

	A_Clipboard := ""

	if (inputFlag) {
		A_Clipboard := inputText
	} else {
		SendInput("^c")
	}

	if (ClipWait(1)) {
		try {
			findParam := "ahk_id " getConfigMap().Get(uuidKey)

			if (WinExist(findParam)) {
				WinActivate
				WinWaitActive(findParam,, 2)

				enterFlag ? SendInput("^a^v{Enter}") : SendInput("^a^v")
				return
			}
		} catch Error {
			; 나중에 파일 로깅하는 것도 고려해볼만 할 듯
		}

		runParamUrl(url, A_Clipboard, uuidKey)
		return
	}

	msg("실패")
}

/*
input된 값을 리턴
#param String title : 입력 창 제목 (default = "title")
*/
showInputBox(title := "title") {
	input := InputBox(, title, "w100 h70")
	if input.Result = "OK" {
		return input.value
	} else {
		return ""
	}
}

/*
URL에 param 더해서 실행하는 함수
UUID Key가 있다면 Config에 실행된 Process의 ID 저장
#param String url     : URL
#param String text    : 입력할 param text
#param String uuidKey : config에 저장할 이름
*/
runParamUrl(url, text, uuidKey := "") {
	beforeProcessID := WinGetID("A")
	Run(runAppBrowser " --app=" url urlEncode(text) " --window-size=1100,700")

	if (uuidKey != "") {
		; 오류를 줄이고자 실행 시 입력 방지
		BlockInput True

		if (WinWaitNotActive("ahk_id " beforeProcessID,, 3)) {
			getConfigMap().Set(uuidKey, WinGetID("A"))
			configSave()
		} else {
			msg("실행시간 타임아웃")
		}

		BlockInput False
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
exe파일 실행 또는 활성화
#param String exeFileName : 실행시킬 파일명

#File List
notepad++.exe
onenote.exe
idea64.exe
whale.exe
*/
runEXE(exeFileName) {
	if WinExist("ahk_exe " exeFileName ".exe") {
		WinActivate
	} else {
		Run(exeFileName ".exe")
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
## @Obsidian
########################################
*/
#HotIf WinActive("ahk_exe Obsidian.exe")

; 다음 줄로 이동
+Enter::SendInput("{End}`n")

; 줄바꿈(<br>)
^Enter::SendText("<br>`n")

; 콜아웃
::/ca1::> [{!}TIP] TIP
::/ca2::> [{!}QUESTION] QUESTION
::/ca3::> [{!}EXAMPLE] EXAMPLE
::/ca4::> [{!}WARNING] WARNING

/*
########################################
## @Notion
########################################
*/
#HotIf WinActive("ahk_exe Notion.exe")

; 글씨색 빨간색 적용 후 초기화
!1::SendComplex("/red`n", "^z")

; 텍스트 BOLD
!q::SendInput("^b")
; 텍스트 이탤릭
!w::SendInput("^i")
; 텍스트 최근 사용 색상 적용
!e::SendInput("^+h")

; 배경색 선택
!a::SendText("/bac")
; 글씨색 선택
!s::SendText("/colo")
; 배경색 보라색
!d::SendText("/purpleb`n")

; 글씨색, 배경색 초기화
!z::SendText("/def`n")

; 콜아웃
^q::SendText("/ca`n")

; 지우기
`::SendInput("{Delete}")

; 블록 링크 복사
^+c::SendInput("!+l")

/*
SendText, SendInput을 연속 입력
*/
SendComplex(text, input := "", carriageFlag := false) {
	carriageFlag ? SendTextBlockLineBreak(text) : SendText(text)
	SendInput(input)
}

/*
SendText 시 항목 내 줄바꿈 적용
*/
SendTextBlockLineBreak(text) {
	SendInput("{Shift Down}")
	SendText(text)
	SendInput("{Shift Up}")
}

/*
########################################
## @IntelliJ
########################################
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox("## IntelliJ ##`n(X)CapsLock - 한 줄 제거`n^w - 탭 끄기`n^+w - 고정 탭 제외 끄기`n^e - 핀으로 고정`n!z - 안 쓰는 import 제거`n!x - 메서드 return값으로 변수 생성`n!c - 메서드화`n!q - 최근 사용 파일 검색`n!w - 파일 검색`n!e - 클래스 구조(Structure) 보기`n^. - 메서드 Document 주석 달기`n!a - 마지막 모듈 Run`n!s - 마지막 모듈 Debug`n`` - 라인 DELETE`n!`` - 백틱 입력`n^Enter - 윗 라인 추가 후 이동")

;~ CapsLock::SendInput("^y")
^w::SendInput("^{F4}")
^+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경
^e::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경
^.::SendInput("!+h") ; 메서드 Document 주석 달기(IntelliJ JavaDoc plugin 키설정을 해당 키로 변경)
!z::SendInput("!^o") ; 안 쓰는 Imports 제거
!x::SendInput("^!v") ; return값으로 변수 자동 생성
!c::SendInput("^!m") ; 메서드화
!q::SendInput("^e") ; 최근 파일 검색
!w::SendInput("^+n") ; 파일 검색
!e::SendInput("!7") ; Structure
!a::SendInput("+{F10}") ; 마지막 모듈 run
!s::SendInput("+{F9}") ; 마지막 모듈 debug
`::SendInput("^y") ; 라인 DELETE
!`::SendInput("``") ; 백틱 입력
^Enter::SendInput("{Home}^{Enter}") ; 윗 라인 추가 후 이동

/*
########################################
## @Chrome
########################################
*/
#HotIf WinActive("ahk_exe chrome.exe")
!/::MsgBox("## Chrome ##`n^q - 창 복사`n!s - 시크릿 모드 창 열기")

^q::SendInput("{F6}!{Enter}")
!s::SendInput("^+n")

/*
########################################
## @Whale
########################################
*/
#HotIf WinActive("ahk_exe whale.exe")
!/::MsgBox("!q - 창 복사`n!w - 사이트 번역`n!a - 새 탭 열기`n!s - 시크릿 모드 창 열기`n#q - Chat GPT 프롬프트(영어 교정)`n#q - Chat GPT 프롬프트(문법 분석)`n#w - Chat GPT 프롬프트(문장 비교)`n#e - Chat GPT 프롬프트(문장 요소 분석)")

global tabFlag := true

!q::SendInput("^k")
!w::translate()
!e::ControlClick("x381 y151", "A",,,, "NA") ; 번역 토글 임시 기능
!a::SendInput("^t")
!s::SendInput("^+n")
#q::setPrompt("문장 : `"`"+{Enter 2}문장이 부자연스럽다면, 자연스러운 문장으로 수정한 후 문장이 부자연스러운 이유에 대한 자세한 설명을 해줘.+{Enter}추가적으로, 더 자연스럽게 사용될 수 있는 문장들이 있으면 추천해줘.")
#w::setPrompt("문장 1 : `"`"+{Enter}문장 2 : `"`"+{Enter 2}어느 문장이 더 자연스러워?")
#e::setPrompt("문장 : `"`"+{Enter 2}문장의 구성 요소에 대해 분석해줘.")

/*
구글 번역 확장 프로그램을 통한 웹 페이지 번역
*/
translate() {
	title := WinGetTitle("A")

	SendInput("{F10}{Left 4}{Enter}")

	if (WinWaitNotActive(title,, 1)) {
		Sleep(50)
		SendInput("{Tab 2}{Enter}")
	} else {
		msg("실패")
	}
}

/*
Chat AI Prompt 영어 분석용 함수, 클립보드 사용 후 기존 데이터로 클립보드 원복
!!! 클립보드 덮어씌우기가 제대로 안 되는 경우가 잦음 !!!
#param String prompt : prompt 문자열
*/
gptPrompt(prompt := "") {
	tmpBuffer := A_Clipboard

	A_Clipboard := ""
	A_Clipboard := prompt
	if (ClipWait(2)) {
		SendInput("^{v}{Up 10}{End}{Left}")
	}

	A_Clipboard := tmpBuffer
}

/*
Chat AI Prompt 영어 분석용 함수, SendInput버전
#param String prompt : prompt 문자열
*/
setPrompt(prompt := "") {
	SendInput(prompt "{Up 10}{End}{Left}")
}

/*
GPT <-> 영어사전 토글 함수
*/
toggleTab() {
	tabFlag? SendInput("^2") : SendInput("^1")
	global tabFlag := !tabFlag
}

/*
########################################
## @원노트
########################################
*/
#HotIf WinActive("ahk_exe ONENOTE.EXE")
!/::MsgBox("!q - Highlight`n!w - 폰트 색 설정`n!e - 특정 색 폰트`n!r - 특정 색 폰트`n!d - Bold 14pt`n!z - 서식 제거`n!x - 말머리 넣기`n!c - 가로줄 넣기`n!a - 그리기 직선`n!s - 그리기 화살표`n!`` - 번호 매기기 초기화`n!F1 - 1레벨 목차 설정`n!F2 - 2레벨 목차 설정`n^v - HTTP URL일 경우 링크 이름 편집 / 이미지 그림 붙여넣기`n^+v - 서식 유지해서 붙여넣기`n^+z - 맨 밑에 페이지 추가`n^+x - 현재 페이지 밑에 페이지 추가`n^+c - 페이지 수준 내리기`n^+q - 현재 페이지 목차 생성`n#q - LARGE_STAR_EMOTICON`nF5 - 즐겨찾기`n+Enter - 현재 커서 위치랑 상관 없이 다음 줄로 넘어가기`n!PgUp, !사이드 앞 - 객체 맨 앞으로`n사이드 앞 - 다음 페이지`n사이드 뒤 - 이전 페이지")

!a::toolKeyboardSelect(DRAW_FIGURE_KEY) ; 그리기 직선(도형 도구 - 빠른 실행 도구 1번째에 지정)
!s::toolKeyboardSelect(DRAW_FIGURE_KEY, "0", "1") ; 그리기 화살표(도형 도구 - 빠른 실행 도구 1번째에 지정)
!w::paintFont("7") ; 글씨색 변경 빨간색(빠른 실행 도구 2번째에 지정, 팔레트 기준 7번째 아래 위치)
^+v::SendInput(ORIGINAL_PASTE_KEY) ; 서식 유지해서 붙여넣기(빠른 실행 도구 3번째에 지정)
^v::paste() ; HTTP URL일 경우 붙여넣기 시 이름 링크로 삽입 / 이미지는 그림으로 붙여넣기(빠른 실행 도구 4번째에 지정)
!q::SendInput("!5") ; Highlight(빠른 실행 도구 5번째에 지정)
!d::SendInput("!6") ; Bold 14pt(빠른 실행 도구 6번째에 지정)
!e::SendInput("!7") ; Specific color font - 초록(빠른 실행 도구 7번째에 지정)
!r::SendInput("!8") ; Specific color font - 파랑(빠른 실행 도구 8번째에 지정)
#q::setTextWithSize("⭐", 36) ; 큰 별 넣기 (폰트 크기 - 빠른 실행 도구 9번째에 지정)
^+x::SendInput("!09") ; 현재 선택된 페이지 하위에 페이지 추가(빠른 실행 도구 10번째에 지정)
!x::SendInput(BULLET_POINT_KEY) ; 글머리 넣기(빠른 실행 도구 11번째에 지정)
^+q::SendInput("!07") ; 목차 생성(빠른 실행 도구 12번째에 지정)
!F1::SendInput("!06") ; 1레벨 목차 설정(빠른 실행 도구 13번째에 지정)
!F2::SendInput("!05") ; 2레벨 목차 설정(빠른 실행 도구 14번째에 지정)
!c::SendInput("!04") ; 텍스트 직선 긋기(빠른 실행 도구 15번째에 지정)
!PgUp::SendInput("!03") ; 객체 맨 앞으로(빠른 실행 도구 16번째에 지정)
!XButton2::SendInput("!03") ; 객체 맨 앞으로(빠른 실행 도구 16번째에 지정)
F5::SendInput("!02") ; 즐겨찾기(빠른 실행 도구 17번째에 지정)
^+PgUp::setParagraph(5) ; 단락 간격 넓히기 - 상단(빠른 실행 도구 18번째에 지정)
^+PgDn::setParagraph(-5) ; 단락 간격 줄이기 - 상단(빠른 실행 도구 18번째에 지정)
!+PgUp::setParagraph(5, false) ; 단락 간격 넓히기 - 하단(빠른 실행 도구 18번째에 지정)
!+PgDn::setParagraph(-5, false) ; 단락 간격 줄이기 - 하단(빠른 실행 도구 18번째에 지정)
!1::SendInput("!0a") ; 단락 간격 10(빠른 실행 도구 19번째에 지정)
!2::SendInput("!0b") ; 단락 간격 20(빠른 실행 도구 20번째에 지정)

!`::SendInput("^/^/{F10 2}") ; 번호 매기기 초기화, F10으로 포커스 아웃인
!z::SendInput("^+n") ; 글 서식 제거

^+z::SendInput("^n") ; 맨 밑에 페이지 추가
^+c::SendInput("!^]") ; 페이지 수준 내리기

XButton1::SendInput("!{Left}")
XButton2::SendInput("!{Right}")

+Enter::SendInput("{End}{Enter}") ; 현재 커서 위치랑 상관 없이 다음 줄로 넘어가기
^Enter::SendInput("{Home}{Enter}^{Up}") ; 현재 커서 위치랑 상관 없이 윗 줄 추가한 후 넘어가기

+PgUp::SendInput("^+`>") ; 폰트 크기 키우기
+PgDn::SendInput("^+`<") ; 폰트 크기 줄이기
+WheelUp::SendInput("^+`>") ; 폰트 크기 키우기
+WheelDown::SendInput("^+`<") ; 폰트 크기 줄이기

; 글머리 기호
:*:>> :: {
	toolKeyboardSelect(BULLET_POINT_KEY, "3", "2")
}

:*:]] :: {
	toolKeyboardSelect(BULLET_POINT_KEY, "2", "1")
}


/*
단락 간격 조정
#param Number size : 조정할 수치
*/
setParagraph(size := 10, upsideFlag := true) {
	SendInput("!01")
	Sleep(80)
	control := upsideFlag ? "RICHEDIT60W3" : "RICHEDIT60W2"
	try {
		currentSize := ControlGetText(control, "A")
		ControlSetText(currentSize + size, control, "A")
		SendInput("{Enter}")
	} catch {
		SendInput("{Esc}")
	}
	;~ if (WinWaitActive("단락 간격",, 3)) {
	;~ } else {
		;~ msg("실패")
	;~ }
}

/*
도구 선택 이후 방향키로 세부 항목 선택
#param String key        : 도구 선택 입력키
#param String downCount  : 세부 항목에서 아래 방향으로 향할 횟수
#param String rightCount : 세부 항목에서 오른쪽 방향으로 향할 횟수
*/
toolKeyboardSelect(key, downCount := "0", rightCount := "0") {
	; STEP 01. 도구 선택
	SendInput(key)

	; STEP 02. 세부 항목 선택
	SendInput("{Down " downCount "}{Right " rightCount "}{Space}")
}

/*
지정된 사이즈로 지정된 텍스트 삽입
기존 사이즈 복사해와서 텍스트 삽입 후 원래 사이즈 다시 입력해주는 로직 추가하는 것도 필요하다면 고려하고 있음
#param String text : 삽입할 텍스트
#param Number size : 텍스트 사이즈
*/
setTextWithSize(text := "", size := 0) {
	if (size > 0) {
		SendInput("!9" size "{Enter}" text)
	} else {
		MsgBox("사이즈는 0보다 커야 합니다.")
	}
}

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
3. Slack에서 복사한 이미지일 경우 그림으로 붙여넣기
*/
paste() {
	if (DllCall("CountClipboardFormats") = 6 && DllCall("IsClipboardFormatAvailable", "UInt", 2)) {
		A_Clipboard := ClipboardAll()
		SendInput("!4")
		SendInput("{Esc}")
	} else if (SubStr(A_Clipboard, 1, 4) = "http") {
		SendInput("^k")
		if (WinWaitActive("링크",,3)) {
			ControlSetText("Link", "RICHEDIT60W3", "A")
			ControlSetText(A_Clipboard, "RICHEDIT60W2", "A")
			ControlFocus("RICHEDIT60W3", "A")
			SendInput("{Enter}")
		}
	} else {
		SendInput("^v")
	}
}

/*
########################################
## @SSMS
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
## @DBeaver
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
## @VSCode
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
## @SciTE4AutoHotkey
########################################
*/
#HotIf WinActive("ahk_exe SciTE.exe")
!/::MsgBox("!q - 책갈피 설정/제거`n!w - 책갈피로 이동`n!e - 프로그램별 책갈피 설정`n!r - 모든 책갈피 제거 후 현재 위치 책갈피 설정`n^/ - 구역 주석")

F1::SendInput("!h{Enter}")
!q::SendInput("^{F2}")
!w::SendInput("{F2}")
!e::SendInput("^f@!m{Esc}")
!r::SendInput("!sc^{F2}")
^/::SendInput("/*`n`n*/{Up}")

/*
########################################
## @Slack
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