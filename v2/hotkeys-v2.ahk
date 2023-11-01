#Include "./library/Class_CNG.ahk"
#include "./library/UIA.ahk"

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
SPOTIFY_UUID_KEY          := "spotifyUUID"

; Command
commandMap := Map()

; 에러 코드
ERROR_PATH_NOT_FOUND := 3

; PC 목록
mainPC := "PAY-331"
subPC  := "DESKTOP-2SVBCIT"
homePC := "DESKTOP-4AJLHVU"

; Default Run Param app Browser
global runAppBrowser := "chrome.exe"

; Default Browser 설정 리스트
; useWhaleList := [mainPC]

; PC별 변동값 설정용
laptopList       := [subPC]
desktopList      := [mainPC, homePC]
ratio25List      := [subPC]
spotifyPopupList := [mainPC]

; 좌표 비율
global ratioNow := 1

RATIO_1440 := 1.333
RATIO_X25  := 1.25

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
SPOTIFY_URL          := "https://open.spotify.com"

; UIA
global spotifyLikeIndex := 5

/*
++++++++++++++++++++++++++++++++++++++++
++ 기본 기능 설정
++++++++++++++++++++++++++++++++++++++++
*/
SetControlDelay -1
UIA.AutoSetFocus := False ; UIA 기능 실행 시 포커스되는 것을 방지

config()
alarm()

/*
최초 실행 시 초기 설정 함수
*/
config() {
	; File Config 불러오기
	configLoad()

	; Command Guide 불러오기
	commandGuideLoad()

	; 특정 PC만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	; 화면 비율 설정(좌표 초기화용)
	if (findValue(ratio25List, A_ComputerName)) {
		global ratioNow := RATIO_X25
	}

	; 스포티파이 팝업으로 실행 시 config 초기화
	if (findValue(spotifyPopupList, A_ComputerName)) {
		Spotify.setUUIDTitle(getConfigMap().Get(SPOTIFY_UUID_KEY))
		Spotify.isBrowser := true
	}
}

/*
configMap 스태틱 변수 return
*/
getConfigMap() {
	return configMap
}

/*
commandMap 스태틱 변수 return
*/
getCommandMap() {
	return commandMap
}

/* 
commandMap 초기화
*/
commandGuideLoad() {
	ahkFile := FileOpen(".\" A_ScriptName, "r", "UTF-8") 
	groupName := ""
	commandList := ""

	; 줄바꿈 문자로 config 구분 후 ":" 문자로 Key, Value 구분
	Loop Parse, ahkFile.Read(), "`n" {
		if (InStr(A_LoopField, "@")) {
			if (commandList != "" && groupName != "") {
				getCommandMap().Set(SubStr(groupName, 1, StrLen(groupName) - 1), groupName "`n" commandList)

				commandList := ""
			}

			groupName := StrSplit(A_LoopField, "@",, 2)[2]
		}

		hotkeyArr := StrSplit(A_LoopField, "::",, 2)

		; ::로 분리됐을 때 && 첫 번째 문자가 ';'(주석)가 아닐 때
		if (hotkeyArr.Length = 2 && SubStr(hotkeyArr[1], 1, 1) != ";") {
			valueArr := StrSplit(hotkeyArr[2], ";#",, 2)

			if (valueArr.Length = 2) {
				commandList := commandList "`n" hotkeyArr[1] "  -->  " valueArr[2]
			}			
		}
	}

	ahkFile.Close()
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
++ @Common
++++++++++++++++++++++++++++++++++++++++
*/
!/::MsgBox(getCommandMap().Get("Common"))

*XButton2::SendInput("{XButton2}") Sleep(100) ; 마우스 사이드 버튼 중복 입력 방지
*XButton1::SendInput("{XButton1}") Sleep(100) ; 마우스 사이드 버튼 중복 입력 방지

#`::runEXE("notepad++") ;# 노트패드 실행
#1::runEXE("obsidian") ;# 옵시디언 실행
#2::runWaitEXE("slack", slackSendToMe) ;# 슬랙 내 채널 열기
; #2::Run("slack://channel?team=T047TLC218Q&id=D0476MC9TPE") ;# 슬랙 내 채널 열기

#Left::maxSizeMove() ;# 현재 포커싱된 창 왼쪽 모니터의 전체 화면으로 전환
#Right::maxSizeMove(false) ;# 현재 포커싱된 창 오른쪽 모니터의 전체 화면으로 전환

#XButton2::SendInput("^#{Left}") ;# 왼쪽 가상 데스크탑
#XButton1::SendInput("^#{Right}") ;# 오른쪽 가상 데스크탑

!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T") ;# CapsLock 토글
*ScrollLock::blockAllInput() ; 관리자 권한으로 실행 필요

^XButton2::SendInput("^{Home}") ;# 스크롤 맨 위로
^XButton1::SendInput("^{End}") ;# 스크롤 맨 아래로
+XButton1::runPopupBlockedInput(GOOGLE_TRANSLATE_URL, GOOGLE_TRANSLATE_UUID_KEY,,, "{Blind}{Shift Up}") ;# 구글 번역 팝업
+XButton2::runPopupBlockedInput(NAVER_EN_DIC_URL, NAVER_EN_DIC_UUID_KEY,, true, "{Blind}{Shift Up}") ;# 네이버 영어사전 팝업

!+c::encryptClipboard() ;# 클립보드 암호화
!+x::decryptClipboard() ;# 클립보드 복호화

; 현재 온메모리 상태의 config의 특정 map값을 NULL로 수정(파일 수정 X) -> 팝업 UUID 잘못됐을 때 refresh용으로 사용
^+XButton1::getConfigMap().Set(GOOGLE_TRANSLATE_UUID_KEY, "NULL") ;# 구글 config 초기화
^+XButton2::getConfigMap().Set(NAVER_EN_DIC_UUID_KEY, "NULL") ;# 네이버 영어사전 config 초기화

Pause:: {
	ToolTip("Reload")
	Reload
}

F1::runPopup(NAVER_KO_DIC_URL, NAVER_KO_DIC_UUID_KEY, true, true) ;# 네이버 국어사전 입력받아 열기
F3::runPopup(NAVER_EN_DIC_URL, NAVER_EN_DIC_UUID_KEY, true, true) ;# 네이버 영어사전 입력받아 열기
F4::runPopup(GOOGLE_TRANSLATE_URL, GOOGLE_TRANSLATE_UUID_KEY, true) ;# 구글 번역 입력받아 열기

VK19 & F1::Spotify.popupRun() ;# 스포티파이 팝업으로 실행
VK19 & F2::setUUID(SPOTIFY_UUID_KEY) ;# 스포티파이 팝업에 UUID 지정
VK19 & Up::setMultiHotkey(, () => Spotify.like(false), () => Spotify.like(true)) ;# 스포티파이 좋아요(2번 입력 시 좋아요 취소)
VK19 & Down::Spotify.replay() ;# 스포티파이 곡 반복
VK19 & Right::Spotify.playBarClick(5) ;# 스포티파이 다음 곡
VK19 & Left::Spotify.playBarClick(3) ;# 스포티파이 이전 곡

Hotstring(":*:gm.", GMAIL)
Hotstring(":*:na.", NAVER_MAIL)
Hotstring(":*:123.", PHONE_NUM)

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

class Spotify {
	static title     := "ahk_exe Spotify.exe"
	static isBrowser := false
	
	/*
	핸들 가져오기
	*/
	static getHandle() {
		try {
			return UIA.ElementFromHandle(Spotify.title)
	} catch {
			msg("핸들 가져오기 실패")
		}
	}

	/*
	Elements 가져오기
	*/
	static getPlayingElement() {
		try {
			return Spotify.getHandle().FindElement([{Type:"Group", LocalizedType:"내용 정보"}])
		} catch {
			msg("Elements 가져오기 실패")
		}
	}
	
	/*
	UIA를 통한 작업이 실행될 수 있게 스포티파이를 세팅
	*/
	static run() {
		; Spotify가 최소화돼있을 시 or 브라우저일 시 활성화
		if (WinGetMinMax(Spotify.title) = -1 || Spotify.isBrowser) {
			WinActivate(Spotify.title)

			if (WinWaitActive(Spotify.title,, 3)) {
				WinMoveBottom(Spotify.title)

				if (Spotify.isBrowser) {
					if (WinGetTransparent(Spotify.title) != 0) {
						WinSetTransparent(0, Spotify.title)
					}
				} else {
					; 화면 바깥으로 보내기
					WinMove(6000, 6000,,, Spotify.title)
				}
			}
		}
	}

	/*
	Spotify 브라우저 팝업으로 실행
	*/
	static popupRun() {
		runPopup(SPOTIFY_URL, SPOTIFY_UUID_KEY, false)
		Spotify.setUUIDTitle(getConfigMap().Get(SPOTIFY_UUID_KEY))
	}

	/*
	Spotify 브라우저 팝업으로 실행
	*/
	static setUUIDTitle(uuid) {
		Spotify.title := "ahk_id " uuid
	}

	/*
	현재 재생 상태 바의 버튼 클릭
	*/
	static playBarClick(index) {
		Spotify.run()
		Spotify.getPlayingElement()[index].Click()
	}

	/*
	현재 재생 상태 바의 버튼 클릭
	*/
	static replay() {
		Spotify.run()

		playingBarEl := Spotify.getPlayingElement()[6]
		clickCount := 1
		isReplay := true
		
		if (playingBarEl.name = "반복 비활성화하기") {
			isReplay := false
		} else if (playingBarEl.name = "반복 활성화하기"){
			clickCount := 2
		}

		msg(isReplay ? "반복 활성화" : "반복 종료")

		Loop clickCount {
			playingBarEl.Click()
			Sleep(1000)
		}
	}

	/*
	좋아요/삭제 처리
	*/
	static like(unlike := false) {
		Spotify.run()

		; 현재 재생 목록의 1번째 자식 요소 중 N번째 자식 요소(좋아요 버튼)
		likeButton := Spotify.getPlayingElement()[1][spotifyLikeIndex]

		; 저장 가능한 상태고 삭제 요청이 아니라면 저장
		if (InStr(likeButton.name, "저장") && !unlike || InStr(likeButton.name, "삭제") && unlike) {
			likeButton.Click()
		}

		msg(unlike ? "삭제됨" : "저장됨")
	}
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
		runMultiHotkey(set, clear, func)
	}

	set() {
		return pressCount
	}

	clear() {
		pressCount := 0
	}
}

/*
멀티 핫키 실행
#param Function set       : return static 변수값
#param Function clear     : static 변수값 0으로 초기화
#param Function[] funcArr : function 배열
*/
runMultiHotkey(getCount, clear, funcArr) {
	count := getCount()

	if (count > funcArr.Length) {
		msg("키 입력 개수 초과")
		clear()
		return
	}

	; 에러가 발생해도 메세지박스 출력 후 무조건 clear되게 처리
	try {
		funcArr[count]()
	} catch Error {
		MsgBox("멀티 핫키 처리 중 에러 발생")
	}
	
	clear()
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
runPopupBlockedInput(url, uuidKey, inputFlag := false, enterFlag := false, input := "") {
	BlockInput True
	SendInput(input)
	runPopup(url, uuidKey,, inputFlag, enterFlag)
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
runPopup(url, uuidKey, dataFlag := true, inputFlag := false, enterFlag := false) {
	if (inputFlag) {
		inputText := showInputBox("URL 실행")

		if (inputText = "") {
			return
		}
	}

	if (dataFlag) {
		A_Clipboard := ""

		if (inputFlag) {
			A_Clipboard := inputText
		} else {
			SendInput("^c")
		}
	}

	; data를 넘기는 작업이 아니면 패스
	if (!dataFlag || ClipWait(1)) {
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

		runParamUrl(url, dataFlag ? A_Clipboard : "", uuidKey)
		return
	}

	msg("실패")
}

/*
해당 창의 UUID를 직접 지정
#param String uuidKey : config에 저장할 UUID의 key name
*/
setUUID(uuidKey) {
	msg(uuidKey "에 저장 시작")
	getConfigMap().Set(uuidKey, WinGetID("A"))
	configSave()
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
runEXE(exeFileName, runHook?) {
	if WinExist("ahk_exe " exeFileName ".exe") {
		WinActivate
	} else {
		Run(exeFileName ".exe")
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
슬랙 내 채널 바로가기
*/
slackSendToMe() {
	SendInput("^k권동한")
	Sleep(100)
	SendInput("`n")
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
#HotIf WinActive("ahk_exe Obsidian.exe")
!/::MsgBox(getCommandMap().Get("Obsidian"))

+Enter::SendInput("{End}`n") ;# 다음 줄로 이동
^Enter::SendInput("{Home}`n{Up}") ;# 윗 줄 추가
!Enter::SendText("<br>`n`n") ;# 줄바꿈(<br>)
^+Enter::SendInput("{Home}`n{Up}") ;# 윗 줄 추가

;# 콜아웃
::/ca1::> [{!}TIP] TIP
::/ca2::> [{!}QUESTION] QUESTION
::/ca3::> [{!}EXAMPLE] EXAMPLE
::/ca4::> [{!}WARNING] WARNING

; 체크박스
::/-::- [ ] 
::/?::- [?] 
::/>::- [>] 

/*
########################################
## @IntelliJ
########################################
*/
#HotIf WinActive("ahk_exe idea64.exe")
!/::MsgBox(getCommandMap().Get("IntelliJ"))

;~ CapsLock::SendInput("^y")
^+w::SendInput("^{F4}") ;# 창 닫기
!+w::SendInput("!i") ; IntelluJ 기본 키설정을 해당 키로 변경 ;# 핀 제외 닫기
; ^.::SendInput("!+h") ; 메서드 Document 주석 달기(IntelliJ JavaDoc plugin 키설정을 해당 키로 변경)
^.::SendInput("/**`n") ;# 주석 달기(IntelliJ 설정에 따라 Doc 자동 생성됨)
^+.::SendInput("^!+[") ; "Keymap - Other - Fix doc comment"의 단축키를 "Ctrl + Alt + Shift + [" 로 변경 (fix가 좀 애매하게 됨) ;# 주석 업데이트
!z::SendInput("!^o") ;# 안 쓰는 Imports 제거
!x::SendInput("^!v") ;# return값으로 변수 자동 생성
!c::SendInput("^!m") ;# 메서드화
!q::SendInput("^e") ;# 최근 파일 검색
!w::SendInput("^+n") ;# 파일 검색
!p::SendInput("!u") ; IntelluJ 기본 키설정을 해당 키로 변경 ;# 핀으로 고정
; !e::SendInput("!7") ; Structure
; !a::SendInput("+{F10}") ; 마지막 모듈 run
; !s::SendInput("+{F9}") ; 마지막 모듈 debug
`::SendInput("^y") ;# 라인 DELETE
!`::SendInput("``") ;# 백틱 입력
^Enter::SendInput("{Home}^{Enter}") ;# 윗 라인 추가 후 이동

/* 
기본 단축키들 도움말 출력용
^+f:: ;# 문자열로 검색
^p:: ;# Parameter Info
^F1:: ;# Stash Changes(키 지정)
!F1:: ;# Unstash Changes(키 지정)
^F12:: ;# Show Local History(키 지정)
^+F12:: ;# Show Local History for Selection(키 지정)
!F12:: ;# Put Label(Local History)(키 지정)
!Insert:: ;# Getter 등등 다양하게 추가
*/



/*
########################################
## @Chrome
########################################
*/
#HotIf WinActive("ahk_exe chrome.exe")
!/::MsgBox(getCommandMap().Get("Chrome"))

^q::SendInput("!+d") ;# 창 복사(확장 프로그램 : Duplicate Tab Shortcut)
!q::SendInput("{F10}{Left 2}{Space}") ;# 사이드 패널 열기
!a::SendInput("^t") ;# 새 탭 열기
!s::SendInput("^+n") ;# 시크릿 모드 창 열기
!w::translate() ;# 페이지 번역
!`::SendInput("!+j") ;# Tab Manager Plus for Chrome 열기

/*
구글 번역 확장 프로그램을 통한 웹 페이지 번역
*/
translate() {
	SendInput("+{F10}")

	if (WinWait("ahk_class Chrome_WidgetWin_2",, 1)) {
		SendInput("t")
	} else {
		msg("실패")
	}
}

/*
########################################
## @DBeaver
########################################
*/
#HotIf WinActive("ahk_exe dbeaver.exe")
!/::MsgBox(getCommandMap().Get("DBeaver"))

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
## @Azure Data Studio
########################################
*/
#HotIf WinActive("ahk_exe azuredatastudio.exe")
!/::MsgBox(getCommandMap().Get("Azure Data Studio"))

`::SendInput("^+k") ;# 라인 지우기
!`::SendInput("``") ;# 백틱 입력
^+c::SendInput("^+h") ;# Header 복사
+Enter::SendInput("^{Enter}") ;# 다음 줄 추가
^Enter::SendInput("{Home}{Enter}{Up}") ;# 윗 줄 추가 후 이동
^+/::SendInput("!+a") ;# 블록 주석 토글

/*
########################################
## @VSCode
########################################
*/
#HotIf WinActive("ahk_exe Code.exe")
!/::MsgBox(getCommandMap().Get("VSCode"))

`::SendInput("^+k") ;# 라인 지우기
!`::SendInput("``") ;# 백틱 입력
!c::SendInput("console.log(){Left}") ;# js 콘솔 자동입력
+Enter::SendInput("^{Enter}") ;# 다음 줄 추가
^Enter::SendInput("{Home}{Enter}{Up}") ;# 윗 줄 추가 후 이동
^+/::SendInput("!+a") ;# 블록 주석 토글

/*
########################################
## @Slack
########################################
*/
#HotIf WinActive("ahk_exe slack.exe")
!/::MsgBox(getCommandMap().Get("Slack"))

!q::copyImage() ;# 이미지 복사

/*
이미지 클릭된 상태일 때 이미지 복사
*/
copyImage() {
	WinGetPos(,, &x, &y, "A")
	ControlClick("x" (x / 2) " y" (y / 2), "A",, "Right")
	Sleep(50)
	SendInput("{Down}{Enter}")
}

/*
########################################
## @Millie
########################################
*/
#HotIf WinActive("ahk_exe millie.exe")
!/::MsgBox(getCommandMap().Get("Millie"))

^x::copyText() ;# 내용 복사 후 뒤에 잡소리 제거

/*
내용 복사 후 뒤에 잡소리 제거
*/
copyText() {
	splitedText := StrSplit(A_Clipboard, " - <")[1]
	A_Clipboard := ""
	A_Clipboard := splitedText
	if (ClipWait(3)) {
		msg("복사됨")
		return
	}

	msg("실패")
}

/*
########################################
## @Lightroom
########################################
*/
#HotIf WinActive("ahk_exe Lightroom.exe")
!/::MsgBox(getCommandMap().Get("Lightroom"))

!z::SendInput("^y") ;# 되돌리기 취소


/*
########################################
## @Photoshop
########################################
*/
#HotIf WinActive("ahk_exe Photoshop.exe")
!/::MsgBox(getCommandMap().Get("Photoshop"))

!z::SendInput("^+z") ;# 되돌리기 취소

; @
