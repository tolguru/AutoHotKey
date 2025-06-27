#Include "./library/Class_CNG.ahk"
#Include "./library/StringToBase64.ahk"
#Include "./library/JSON.ahk"

/*
########################################
## 임시 기능 선언
########################################
*/

/*
########################################
## 전역변수 선언
########################################
*/
; Config
configMap := Map()

; Popup Classes
googleTranslatePopup := Popup("https://translate.google.co.kr/?sl=en&tl=ko&text=", "Google 번역")
naverKoDicPopup := Popup("https://ko.dict.naver.com/", "국어사전")
naverEnDicPopup := Popup("https://en.dict.naver.com/", "영어사전")
naverEnDicSearchPopup := Popup.copy(naverEnDicPopup, naverEnDicPopup.url "#/search?query=")
SpotifyPopup := Popup("https://open.spotify.com/", "Spotify")

; Guide
guideMap := Map()

; Default Run Param app Browser
global runAppBrowser := A_AppData "/../Local/Vivaldi/Application/vivaldi.exe"

; 환경 변수 데이터
GMAIL      := EnvGet("aaGmail")
NAVER_MAIL := EnvGet("aaNmail")
PHONE_NUM  := EnvGet("aaPhone")

; PC 목록
companyPC := "PAY-331"
laptop  := "DESKTOP-2SVBCIT"
homePC := "DESKTOP-4AJLHVU"

; PC별 변동값 설정용
laptopList       := [laptop]
desktopList      := [companyPC, homePC]
ratio25List      := [laptop]

/*
++++++++++++++++++++++++++++++++++++++++
++ 기본 기능 설정
++++++++++++++++++++++++++++++++++++++++
*/
SetControlDelay -1

config()

class Popup {
	__New(url, needle) {
		this.url := url
		this.needle := needle
	}

	static copy(popupObject, url := "", needle := "") {
		return Popup(url? url : popupObject.url, needle? needle : popupObject.needle)
	}
}

/*
최초 실행 시 초기 설정 함수
*/
config() {
	; Guide 불러오기
	guideLoad()
}

/*
guideMap 스태틱 변수 return
*/
getGuideMap() {
	return guideMap
}

/* 
guideMap 초기화
*/
guideLoad() {
	ahkFile := FileOpen(".\" A_ScriptName, "r", "UTF-8") 
	groupName := ""
	guideList := ""

	; 줄바꿈 문자로 config 구분 후 ":" 문자로 Key, Value 구분
	Loop Parse, ahkFile.Read(), "`n" {
		if (InStr(A_LoopField, "# @")) {
			if (guideList != "" && groupName != "") {
				getGuideMap().Set(SubStr(groupName, 1, StrLen(groupName) - 1), groupName "`n" guideList)

				guideList := ""
			}

			groupName := StrSplit(A_LoopField, "# @",, 2)[2]
		}

		hotkeyArr := StrSplit(A_LoopField, "::",, 2)

		; ::로 분리됐을 때 && 첫 번째 문자가 ';'(주석)가 아닐 때
		if (hotkeyArr.Length = 2 && SubStr(hotkeyArr[1], 1, 1) != ";") {
			valueArr := StrSplit(hotkeyArr[2], ";#",, 2)

			if (valueArr.Length = 2) {
				guideList := guideList "`n" (StrLen(hotkeyArr[1]) = 0 ? valueArr[2] : hotkeyArr[1] "  -->  " valueArr[2])
			}			
		}
	}

	ahkFile.Close()
}

/*
########################################
## @Common
########################################
*/
#/::MsgBox(getGuideMap().Get("Common"))

#f::activateTitle("Everything") ;# Everything 열기

*XButton2::SendInput("{XButton2}") Sleep(200) ; 마우스 사이드 버튼 중복 입력 방지
*XButton1::SendInput("{XButton1}") Sleep(200) ; 마우스 사이드 버튼 중복 입력 방지

F1::runEXE("perplexity") ;# Perplexity 실행
#`::runEXE("notepad++") ;# 노트패드 실행
#1::runEXE("obsidian") ;# 옵시디언 실행
#2::activateTitle("- Vivaldi") ;# 비발디 열기

#Left::maxSizeMove() ;# 현재 포커싱된 창 왼쪽 모니터의 전체 화면으로 전환
#Right::maxSizeMove(false) ;# 현재 포커싱된 창 오른쪽 모니터의 전체 화면으로 전환
#XButton2::maxSizeMove() ;# 현재 포커싱된 창 왼쪽 모니터의 전체 화면으로 전환
#XButton1::maxSizeMove(false) ;# 현재 포커싱된 창 오른쪽 모니터의 전체 화면으로 전환
#WheelUp::SoundSetVolume("+5") msg(Ceil(SoundGetVolume())) ;# 볼륨 업
#WheelDown::SoundSetVolume("-5") msg(Ceil(SoundGetVolume())) ;# 볼륨 다운
#MButton:: { ;# 사운드 토글
	SoundSetMute(-1)
	
	if (WinExist("Whale")) {
		WinMinimize
	}

	msg(SoundGetMute() ? "Mute On" : "Mute Off")
}

^XButton2::SendInput("^{Home}") ;# 스크롤 맨 위로
^XButton1::SendInput("^{End}") ;# 스크롤 맨 아래로
+XButton1::runPopupBlockedInput(googleTranslatePopup,, "{Blind}{Shift Up}") ;# 구글 번역 팝업
+XButton2::runPopupBlockedInput(naverEnDicSearchPopup, true, "{Blind}{Shift Up}") ;# 네이버 영어사전 팝업

ScrollLock::return ;# ATEN KM 스위칭 시 키 입력되지 않도록 변경

Pause:: {
	ToolTip("Reload")
	Reload
}

#SuspendExempt
+Pause::Suspend
#SuspendExempt False

#F9::runPopup(naverKoDicPopup) ;# 네이버 국어사전 열기
#F10::runPopup(naverEnDicPopup) ;# 네이버 영어사전 열기
#F11::runPopup(googleTranslatePopup) ;# 구글 번역 열기
^#F11::runPopupBlockedInput(googleTranslatePopup,, "{Blind}{LWin Up}{LCtrl Up}") ;# 구글 번역 팝업
^#F10::runPopupBlockedInput(naverEnDicSearchPopup, true, "{Blind}{LWin Up}{LCtrl Up}") ;# 네이버 영어사전 팝업

VK19 & c::encryptClipboard() ;# 클립보드 암호화
VK19 & x::decryptClipboard() ;# 클립보드 복호화

Hotstring(":*:gm.", GMAIL)
Hotstring(":*:na.", NAVER_MAIL)
Hotstring(":*:123.", PHONE_NUM)

/*
Guide 출력을 위해 GUI를 초기화 후 반환
#param String fileName : 출력할 파일명
*/
createGuideGui(fileName) {
	guiObj := Gui("-MinimizeBox")
	guiObj.BackColor := 0xFFFFFF
	guiObj.SetFont("s11 q5", "Noto Sans KR")
	guiObj.OnEvent("Escape", guiObj.Hide)

	setGuiTextFromFile(guiObj, fileName)

	return guiObj
}

/*
Guide 파일 오픈 후 GUI Object에 텍스트 추가
"---"가 구분자(Column) 역할을 함
#param Object guiObj : GUI Object
#param String fileName : 출력할 파일명
*/
setGuiTextFromFile(guiObj, fileName) {
	guideText := readTextFromFile("./guide/shortcut/" fileName)
	guideContext := splitGuideText(guideText)
	
	addContextToGuideGui(guiObj, guideContext)
}

addContextToGuideGui(guiObj, guideContext) {
	guiObj.Add("Text", "Section")

	Loop guideContext.Length {
		guiObj.Add("Text", "ys", guideContext[A_Index])
	}
}

readTextFromFile(path, decode := "UTF-8") {
	guideFile := FileOpen(path, "r", decode)
	
	text := guideFile.Read()

	guideFile.Close()

	return text
}

splitGuideText(guideText) {
	return StrSplit(guideText, "---")
}

/*
HTTP 요청 후 HTTP Object 반환
#param String method : HTTP Method
#param String url : Request URL
#param String[][] headers : [["key1", "value1"]["key2", "value2"]]
*/
httpSend(method, url, headers := []) {
	httpObj := ComObject("WinHTTP.WinHTTPRequest.5.1")
	httpObj.Open(method, url)
	
	httpSetHeaders(httpObj, headers)

	httpObj.Send()
	httpObj.WaitForResponse

	return httpObj
}

/*
Http Object에 request header 지정
#param Object httpObj : HTTP Object
#param String[][] headers : [["key1", "value1"]["key2", "value2"]]
*/
httpSetHeaders(httpObj, headers := []) {
	Loop headers.Length {
		httpObj.SetRequestHeader(headers[A_Index][A_Index], headers[A_Index][A_Index + 1])
	}
}

/*
왼쪽/오른쪽 화면으로 창 이동 후 전체화면
#param boolean isLeft : 왼쪽 화면으로 이동할지 여부
*/
maxSizeMove(isLeft := true) {
	WinRestore("A")

	MonitorGet(1, &a)
	MonitorGet(2, &b)
	
	max := a
	min := b

	if (a < b) {
		max := b
		min := a
	}

	WinMove(isLeft ? min : max + 100, 100,,, "A")

	WinMaximize("A")
}

/*
핫키 여러 번 입력 시 각기 다른 메서드 실행
#param Number time    : 처리될 타이머 시간
#param Function func* : function 다중 param
*/
setMultiHotkey(time := 400, func*) {
	static pressCount := 0

	if (pressCount > 0) {
		pressCount++
		return
	}

	pressCount := 1
	SetTimer(run, -time)

	run() {
		runMultiHotkey(getPressCount, clearPressCount, func)
	}

	getPressCount() {
		return pressCount
	}

	clearPressCount() {
		pressCount := 0
	}
}

/*
멀티 핫키 실행
#param Function getPressCount : return static 변수값
#param Function clearPressCount : static 변수값 0으로 초기화
#param Function[] funcArr : function 배열
*/
runMultiHotkey(getPressCount, clearPressCount, funcArr) {
	count := getPressCount()

	if (count > funcArr.Length) {
		msg("키 입력 개수 초과")
		clearPressCount()
		return
	}

	; 에러가 발생해도 메세지박스 출력 후 무조건 clear되게 처리
	try {
		funcArr[count]()
	} catch Error as e {
		MsgBox("멀티 핫키 처리 중 에러 발생")
	}
	
	clearPressCount()
}

/*
클립보드 암호화
*/
encryptClipboard() {
	A_Clipboard := ""
	clipboardStr := ""

	SendInput("^c")
	if (ClipWait(3)) {
		clipboardStr := Encrypt.String("AES", "CBC", A_Clipboard, "EhfrnEhfrnEhfrn1", "123")

		A_Clipboard := ""
		A_Clipboard := clipboardStr
		if (!ClipWait(3)) {
			msg("암호화 실패")
			return
		}
	} else {
		msg("복사 실패")
		return
	}
	 
	msg("암호화됨")
}

/*
클립보드 복호화
*/
decryptClipboard() {
	clipboardStr := A_Clipboard
	
	A_Clipboard := ""
	A_Clipboard := Decrypt.String("AES", "CBC", clipboardStr, "EhfrnEhfrnEhfrn1", "123")

	if (ClipWait(3)) {
		msg("복호화됨")
	} else {
		msg("실패")
	}
}

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
runPopup 함수 실행 중 Input Block, 추가 입력(호출 핫키를 Release해서 입력간 오류 방지용)
*/
runPopupBlockedInput(popupObject, enterFlag := false, input := "") {
	BlockInput True
	SendInput(input)
	runPopup(popupObject, true, enterFlag)
	BlockInput False
}

/*
브라우저 팝업 형태로 url 실행
실행 후 입력 기능 있음
Config에서 UUID 조회 후 Active 가능
#param Popup popupObject : Popup 객체(url, needle)
#param boolean dataFlag : 클립보드 데이터 사용 여부 (default = false)
#param boolean enterFlag : 엔터 입력 여부 (default = false)
*/
runPopup(popupObject, dataFlag := false, enterFlag := false, duplicatable := false) {
	if (dataFlag) {
		A_Clipboard := ""

		SendInput("^c")
	}

	; data를 넘기는 작업이 아니면 패스
	if (!dataFlag || ClipWait(1)) {
		findParam := popupObject.needle

		if (!duplicatable && WinExist(findParam)) {
			WinActivate
			if (WinWaitActive(findParam,, 2)) {
				if (dataFlag) {
					enterFlag ? SendInput("^a^v{Enter}") : SendInput("^a^v")
				}

				return
			}
		}

		runParamUrl(popupObject.url, dataFlag ? A_Clipboard : "")
		return
	}

	msg("실패")
}

/*
URL에 text 더해서 실행하는 함수
#param String url     : URL
#param String text    : 입력할 param text
*/
runParamUrl(url, text) {
	beforeProcessID := WinGetID("A")
	Run(runAppBrowser " --app=" url urlEncode(text))

	if (WinWaitNotActive("ahk_id " beforeProcessID,, 5)) {
		WinRestore("A")
	} else {
		msg("실행시간 타임아웃")
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
runEXE(exeFileName, runHook?) {
	if WinExist("ahk_exe " exeFileName ".exe") {
		WinActivate
	} else {
		Run(exeFileName ".exe")
	}
}

/*
매치되는 타이틀의 프로그램 활성화
#param String title : 실행시킬 프로그램의 타이틀명
*/
activateTitle(title) {
	if WinExist(title) {
		WinActivate
	} else {
		msg("찾을 수 없음")
	}
}

/*
exe파일 실행 후 대기
#param String   exeFileName : 실행시킬 파일명
#param Function runHook     : 실행 후 동작
*/
runWaitEXE(exeFileName, runHook?) {
	runEXE(exeFileName)

	if (WinWaitActive("ahk_exe " exeFileName ".exe",, 3)) {
		if IsSet(runHook) {
			runHook
		}
	} else {
		msg("실패")
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
########################################
## @Obsidian
########################################
*/
obsidianGuideGui := createGuideGui("obsidian.txt")

#HotIf WinActive("ahk_exe Obsidian.exe")
#/::obsidianGuideGui.Show()

; 체크박스
:*:/-::- [ ] `
:*:/?::- [?] `
:*:/>::- [>] `

/*
########################################
## @IntelliJ
########################################
*/
jetbrainsGuideGui := createGuideGui("jetbrains.txt")

#HotIf WinActive("ahk_exe idea64.exe") or WinActive("ahk_exe rider64.exe") or WinActive("ahk_exe datagrip64.exe") or WinActive("ahk_exe pycharm64.exe")
#/::jetbrainsGuideGui.Show()

/*
########################################
## @Vivaldi
########################################
*/
#HotIf WinActive("ahk_exe vivaldi.exe")
#/::MsgBox(getGuideMap().Get("Vivaldi"))

!`::SendInput("!0") ;# Window Workspaces로 변경

/* 
기본 단축키들 도움말 출력용
::;#
::;#
::;# ---- 키 지정 라인 ----
::;#
F2:: ;# 탭 더미 이름 변경
Alt + Q:: ;# 탭 쌓기
Alt + W:: ;# 탭 더미 해제
*/

/*
########################################
## @Azure Data Studio
########################################
*/
#HotIf WinActive("ahk_exe azuredatastudio.exe")
#/::MsgBox(getGuideMap().Get("Azure Data Studio"))

; !`::SendInput("^+k") ;# 라인 지우기
; !`::SendInput("``") ;# 백틱 입력
; ^+c::SendInput("^+h") ;# Header 복사
; +Enter::SendInput("^{Enter}") ;# 다음 줄 추가
; ^Enter::SendInput("{Home}{Enter}{Up}") ;# 윗 줄 추가 후 이동
; ^+/::SendInput("!+a") ;# 블록 주석 토글

/*
########################################
## @Trello
########################################
*/
#HotIf WinActive("ahk_exe trello.exe")
#/::MsgBox(getGuideMap().Get("Trello"))

^+1::SendInput("^!1") ;# 폰트 헤더 1
^+2::SendInput("^!2") ;# 폰트 헤더 2
^+3::SendInput("^!3") ;# 폰트 헤더 3

/*
########################################
## @Perplexity
########################################
*/
perplexityGuideGui := createGuideGui("perplexity.txt")
searchImagePath1 := "\resources\perplexity_search_image_desktop1.png"
searchImagePath2 := "\resources\perplexity_search_image_desktop2.png"
laptopImagePath1 := "\resources\perplexity_search_image_laptop1.png"
laptopImagePath2 := "\resources\perplexity_search_image_laptop2.png"

setImagePath()

setImagePath() {
	if (findValue(ratio25List, A_ComputerName)) {
		global searchImagePath1 := laptopImagePath1
		global searchImagePath2 := laptopImagePath2
	}
}

#HotIf WinActive("ahk_exe Perplexity.exe")
#/::perplexityGuideGui.Show()
Enter::clickEnter()
!d:: {
	SendInput("Ctrl Down")
	ControlClick("X37 Y34")	
	SendInput("Ctrl Up")
}

:*:/yy::
{
	SendText("after:" FormatTime(A_Now, "yyyy") "-01-01")
}

:*:/mm::
{
	SendText("after:" FormatTime(A_Now, "yyyy-MM") "-01")
}

:*:/dd::
{
	SendText("after:" FormatTime(DateAdd(A_Now, -1, "Days"), "yyyy-MM-dd"))
}

:*:/ft::
{
	SendText("filetype:")
}

/*
Perplexity 윈도우 애플리케이션 사용 시 Enter 입력이 처리되지 않는 경우가 많아 보조 용도로 구현
*/
clickEnter() {
	perplexityWindowId := WinGetID()

	WinGetPos(,, &w, &h, perplexityWindowId)

	if (ImageSearch(&enterX, &enterY, 0, 0, w, h, A_ScriptDir searchImagePath1) ||
		ImageSearch(&enterX, &enterY, 0, 0, w, h, A_ScriptDir searchImagePath2)) {
		ControlClick("X" enterX " Y" enterY)
	} else {
		msg("Perplexity의 입력 위치를 찾지 못했음")
	}
}

/*
########################################
## @ETC
########################################
*/
#HotIf WinActive("Google")

:*:/af::
{
	SendText("after:2025-01-01")
}

; # @