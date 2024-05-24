#Include "./library/Class_CNG.ahk"
#Include "./library/StringToBase64.ahk"
#Include "./library/JSON.ahk"
#Include "./library/Gdip_All.ahk"
#Include "./library/Gdip_ImageSearch.ahk"

/*
########################################
## 임시 기능 선언
########################################
*/

F2:: {
	hOpencv := DllCall("LoadLibrary", "str", ".\dll\opencv_world470.dll", "ptr")
	hOpencvCom := DllCall("LoadLibrary", "str", ".\dll\autoit_opencv_com470.dll", "ptr")
	DllCall(".\dll\autoit_opencv_com470.dll\DllInstall", "int", 1, "wstr", A_IsAdmin = 0 ? "user" : "", "cdecl")

	cv := ComObject("OpenCV.cv")

	cv.matchTemplate()

	img := cv.imread("C:\Users\dhkwon\Pictures\ahk_capture\test.png", 1)
	cv.imshow("Image", img)
	cv.imwrite
	cv.waitKey()
	cv.destroyAllWindows()
}

F1:: {
	gdipToken := Gdip_Startup()

	pHaystack := Gdip_BitmapFromHWND(WinExist("인공지능"))
	; pHaystack := Gdip_BitmapFromHWND(WinExist("hotkeys"))
	; pHaystack := Gdip_BitmapFromScreen()

	Gdip_SetBitmapToClipboard(pHaystack)
	; pHaystack := Gdip_BitmapFromHWND(WinExist("디지털 트랜스"))
	pNeedle := Gdip_CreateBitmapFromFile("C:\Users\dhkwon\Pictures\ahk_capture\test.png")

	result := Gdip_ImageSearch(pHaystack, pNeedle, &position,,,,, 30)

	msg("result : " result ", position : " position)

	Gdip_Shutdown(gdipToken)
	; auto()
}

auto() {
	; if (ImageSearch(&x, &y, 1268, 674, 1334, 1000, "C:\Users\dhkwon\Pictures\ahk capture\a1.png")) {
	; 	ControlClick("x" x " y" y, "개인정보",,,, "NA")
	; }
	Loop 10 {
		ControlClick("x1340 y" 720 + (A_Index * 20), "개인정보",,,, "NA")
	}
	
	SetTimer(() => auto(), 5000)
}

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

; PC 목록
mainPC := "PAY-331"
subPC  := "DESKTOP-2SVBCIT"
homePC := "DESKTOP-4AJLHVU"

; Default Run Param app Browser
; global runAppBrowser := "chrome.exe"
global runAppBrowser := A_AppData "/../Local/Vivaldi/Application/vivaldi.exe"

; Default Browser 설정 리스트
; useWhaleList := [mainPC]

; PC별 변동값 설정용
laptopList       := [subPC]
desktopList      := [mainPC, homePC]
ratio25List      := [subPC]

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

global spotifyActivateFlag := false

/*
++++++++++++++++++++++++++++++++++++++++
++ 기본 기능 설정
++++++++++++++++++++++++++++++++++++++++
*/
SetControlDelay -1

config()
; alarm()

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
	; File Config 불러오기
	; configLoad()

	; 스포티파이 User Aceess Token 획득
	; Spotify.refreshUserAccessToken()

	; Guide 불러오기
	guideLoad()

	; 특정 PC만 울리게 설정
	if (findValue(waterAlarmList, A_ComputerName)) {
		global waterAlarm := true
	}

	; 화면 비율 설정(좌표 초기화용)
	if (findValue(ratio25List, A_ComputerName)) {
		global ratioNow := RATIO_X25
	}
}

/*
(미사용)
configMap 스태틱 변수 return
*/
getConfigMap() {
	return configMap
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
(미사용)
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
(미사용)
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
(미사용)
화면 비율에 맞춰 좌표 문자열 생성 (format = "x좌표 y좌표")
*/
screenRatioSet(x := 0, y := 0) {
	return "x" Floor(x * ratioNow) " " "y" Floor(y * ratioNow)
}

/*
(미사용)
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
########################################
## @Common
########################################
*/
#/::MsgBox(getGuideMap().Get("Common"))

#f::activateTitle("Everything") ;# Everything 열기

*XButton2::SendInput("{XButton2}") Sleep(200) ; 마우스 사이드 버튼 중복 입력 방지
*XButton1::SendInput("{XButton1}") Sleep(200) ; 마우스 사이드 버튼 중복 입력 방지

#`::runEXE("notepad++") ;# 노트패드 실행
#1::runEXE("obsidian") ;# 옵시디언 실행
#2::activateTitle("- Vivaldi") ;# 비발디 열기
; #2::runWaitEXE("slack", slackSendToMe) ;# 슬랙 내 채널 열기
; #2::Run("slack://channel?team=T047TLC218Q&id=D0476MC9TPE") ;# 슬랙 내 채널 열기

#Left::maxSizeMove() ;# 현재 포커싱된 창 왼쪽 모니터의 전체 화면으로 전환
#Right::maxSizeMove(false) ;# 현재 포커싱된 창 오른쪽 모니터의 전체 화면으로 전환
#XButton2::maxSizeMove() ;# 현재 포커싱된 창 왼쪽 모니터의 전체 화면으로 전환
#XButton1::maxSizeMove(false) ;# 현재 포커싱된 창 오른쪽 모니터의 전체 화면으로 전환
#WheelUp::SoundSetVolume("+10") msg(Ceil(SoundGetVolume())) ;# 볼륨 업
#WheelDown::SoundSetVolume("-10") msg(Ceil(SoundGetVolume())) ;# 볼륨 다운
#MButton:: { ;# 사운드 토글
	SoundSetMute(-1)
	
	if (WinExist("Whale")) {
		WinMinimize
	}

	msg(SoundGetMute() ? "Mute On" : "Mute Off")
}

; #XButton2::SendInput("^#{Left}") ;# 왼쪽 가상 데스크탑
; #XButton1::SendInput("^#{Right}") ;# 오른쪽 가상 데스크탑

!+F12::Suspend
^\::SetCapsLockState !GetKeyState("CapsLock", "T") ;# CapsLock 토글
*ScrollLock::blockAllInput() ; 관리자 권한으로 실행 필요

^XButton2::SendInput("^{Home}") ;# 스크롤 맨 위로
^XButton1::SendInput("^{End}") ;# 스크롤 맨 아래로
+XButton1::runPopupBlockedInput(googleTranslatePopup,, "{Blind}{Shift Up}") ;# 구글 번역 팝업
+XButton2::runPopupBlockedInput(naverEnDicSearchPopup, true, "{Blind}{Shift Up}") ;# 네이버 영어사전 팝업

Pause:: {
	ToolTip("Reload")
	Reload
}

#F9::runPopup(naverKoDicPopup) ;# 네이버 국어사전 열기
#F10::runPopup(naverEnDicPopup) ;# 네이버 영어사전 열기
#F11::runPopup(googleTranslatePopup) ;# 구글 번역 열기
^#F11::runPopupBlockedInput(googleTranslatePopup,, "{Blind}{LWin Up}{LCtrl Up}") ;# 구글 번역 팝업
^#F10::runPopupBlockedInput(naverEnDicSearchPopup, true, "{Blind}{LWin Up}{LCtrl Up}") ;# 네이버 영어사전 팝업

VK19 & F1::global spotifyActivateFlag := !spotifyActivateFlag msg(!spotifyActivateFlag ? "온" : "오프") ;# 스포티파이 단축키 온/오프 플래그 토글

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

class SpotifyAuthError extends Error {
}

class Spotify {
	static SPOTIFY_API_HOST := "https://api.spotify.com/v1"
	static CONTROL_BASE_URL := this.SPOTIFY_API_HOST "/me/player/"
	static CONTROL_PLAYLIST_BASE_URL := this.SPOTIFY_API_HOST "/playlists/"
	static CONTROL_NEXT := "next"
	static CONTROL_PREVIOUS := "previous"
	static CONTROL_REPEAT_TRACK := "repeat?state=track"
	static CONTROL_REPEAT_CONTEXT := "repeat?state=context"
	static CONTROL_REPEAT_OFF := "repeat?state=off"
	static CONTROL_SHUFFLE_ON := "shuffle?state=true"
	static CONTROL_SHUFFLE_OFF := "shuffle?state=false"
	static CONTROL_CURRENTLY_PLAYING_TRACK := "currently-playing"
	static CONTROL_PLAYLIST := "/tracks"

	static PLAYLIST_ID := "0thPzS6Bb5bsjJnTIuqqsm"
	
	static PLAYLIST_CONTROL_TYPE_ADD := "add"
	static PLAYLIST_CONTROL_TYPE_REMOVE := "remove"

	static clientId := EnvGet("aaSpotifyClientId")
	static clientSecret := EnvGet("aaSpotifyClientSecret")
	static basicKey := StringToBase64(this.clientId ":" this.clientSecret)
	static refreshToken := EnvGet("aaSpotifyRefreshToken")
	static userAccessToken := ""

	static next() {
		this.control(this.CONTROL_NEXT)
	}

	static previous() {
		this.control(this.CONTROL_PREVIOUS)
	}
	
	static repeatTrack() {
		this.control(this.CONTROL_REPEAT_TRACK, "PUT")
	}
	
	static repeatContext() {
		this.control(this.CONTROL_REPEAT_CONTEXT, "PUT")
	}
	
	static repeatOff() {
		this.control(this.CONTROL_REPEAT_OFF, "PUT")
	}
	
	static shuffleOn() {
		this.control(this.CONTROL_SHUFFLE_ON, "PUT")
	}
	
	static shuffleOff() {
		this.control(this.CONTROL_SHUFFLE_OFF, "PUT")
	}

	static addToPlaylist() {
		this.controlPlaylist(this.AddToPlaylistRequestDTO, "POST")
		msg("플레이리스트에 등록")
	}

	static removeFromPlaylist() {
		this.controlPlaylist(this.RemoveFromPlaylistRequestDTO, "DELETE")
		msg("플레이리스트에서 삭제")
	}

	static controlPlaylist(requestDtoClass, method) {
		try {
			response := this.control(this.CONTROL_CURRENTLY_PLAYING_TRACK, "GET")
			trackUri := this.parseCurrentPlayingTrackResponseBody(response.ResponseText)
			requestBody := JSON.stringify(requestDtoClass(trackUri))

			this.control(this.CONTROL_PLAYLIST, method, this.CONTROL_PLAYLIST_BASE_URL this.PLAYLIST_ID, requestBody)
		} catch Any as e {
			MsgBox("Playlist 컨트롤 실패, message : " e)
		}
	}

	static control(controlType, method := "POST", baseUrl := this.CONTROL_BASE_URL, requestBody := "") {
		try {
			return this.requestControlAPI(controlType, method, baseUrl, requestBody)
		} catch SpotifyAuthError as e {
			this.deleteOldUserAccessKey()
			this.refreshUserAccessToken()

			if (this.userAccessToken) {
				return this.control(controlType, method, baseUrl)
			}
		} catch Any as e {
			MsgBox(e)
		}
	}

	static parseCurrentPlayingTrackResponseBody(responseBody) {
		try {
			playingInfo := JSON.parse(responseBody)

			return playingInfo["item"]["uri"]
		} catch UnsetItemError {
			throw("성공 응답에서 트랙 URI를 찾지 못했음")
		}
	}

	static requestControlAPI(controlType, method, baseUrl, requestBody) {
		url := baseUrl controlType

		headers := Map()
		headers.Set("Authorization", "Bearer " this.userAccessToken)

		response := this.request(method, url, headers, requestBody)
	
		if (response.Status = 400 || response.Status = 401) {
			throw SpotifyAuthError(response.ResponseText)
		} else if (response.Status != 200 && response.Status != 204) {
			throw("컨트롤 실패, Status : " response.Status ", Status Text : " response.StatusText ", Body : " response.ResponseText)
		} else {
			return response
		}
	}
	
	static deleteOldUserAccessKey() {
		this.userAccessToken := ""
	}

	static refreshUserAccessToken() {
		try {
			msg("Spotify 토큰 재발급 진행")

			responseBody := this.requestAccessTokenAPI()
			this.userAccessToken := this.parseUserAccessTokenResponseBody(responseBody)
		} catch Any as e {
			MsgBox("refresh 실패`n" e)
		}
	}

	static requestAccessTokenAPI() {
		url := "https://accounts.spotify.com/api/token"
		requestBody := "grant_type=refresh_token&refresh_token=" this.refreshToken

		headers := Map()
		headers.Set("content-type", "application/x-www-form-urlencoded")
		headers.Set("Authorization", "Basic " this.basicKey)

		response := this.request("POST", url, headers, requestBody)

		if (response.Status = 200) {
			return response.ResponseText
		} else {
			throw("HTTP Status : " response.Status "`nResponse Body : " response.ResponseText)
		}
	}

	static parseUserAccessTokenResponseBody(responseBody) {
		try {
			parsedResponseBody := JSON.parse(responseBody)

			return parsedResponseBody["access_token"]
		} catch UnsetItemError {
			throw("성공 응답에서 토큰을 찾지 못했음")
		}
	}

	static request(method, url, headers := Map(), requestBody := "") {
		httpObj := ComObject("WinHTTP.WinHTTPRequest.5.1")
	
		httpObj.Open(method, url)

		For key, value in headers {
			httpObj.SetRequestHeader(key, value)
		}

		httpObj.Send(requestBody)

		httpObj.WaitForResponse

		return httpObj
	}

	class AddToPlaylistRequestDTO {
		__New(trackUri) {
			this.uris := Array(trackUri)
			this.position := 0
		}
	}

	class RemoveFromPlaylistRequestDTO {
		__New(trackUri) {
			this.tracks := Array(Map("uri", (trackUri)))
		}
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
runPopup(popupObject, dataFlag := false, enterFlag := false) {
	if (dataFlag) {
		A_Clipboard := ""

		SendInput("^c")
	}

	; data를 넘기는 작업이 아니면 패스
	if (!dataFlag || ClipWait(1)) {
		findParam := popupObject.needle

		if (WinExist(findParam)) {
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
(미사용)
해당 창의 UUID를 직접 지정
#param String uuidKey : config에 저장할 UUID의 key name
*/
setUUID(uuidKey) {
	msg(uuidKey "에 저장 시작")
	getConfigMap().Set(uuidKey, WinGetID("A"))
	configSave()
}

/*
(미사용)
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
(미사용)
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
(미사용)
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

#HotIf spotifyActivateFlag

VK19 & Right::Spotify.next() ;# 스포티파이 다음곡
VK19 & Left::Spotify.previous() ;# 스포티파이 이전곡
VK19 & Down::setMultiHotkey(, () => Spotify.repeatTrack(), () => Spotify.repeatOff()) ;# 스포티파이 한 곡 반복/취소
VK19 & Up::setMultiHotkey(, () => Spotify.addToPlaylist(), () => Spotify.removeFromPlaylist()) ;# 스포티파이 플레이리스트 저장/삭제

/*
########################################
## @Obsidian
########################################
*/
#HotIf WinActive("ahk_exe Obsidian.exe")
#/::MsgBox(getGuideMap().Get("Obsidian"))

+Enter::SendInput("{End}`n") ;# 다음 줄로 이동
; ^Enter::SendInput("{Home}`n{Up}") ;# 윗 줄 추가

;# 콜아웃
:*:/cat::> [{!}TIP] TIP`n> `
:*:/caq::> [{!}QUESTION] QUESTION`n> `
:*:/cae::> [{!}EXAMPLE] EXAMPLE`n> `
:*:/caw::> [{!}WARNING] WARNING`n> `

; 체크박스
:*:/-::- [ ] `
:*:/?::- [?] `
:*:/>::- [>] `

/* 
기본 단축키들 도움말 출력용
::;#
^+i:: ;# 개발자 도구
::;#
::;# ---- Excalidraw ----
스페이스바 드래그:: ;# 화면 이동
::;#
^!c:: ;# 스타일 복사
^!v:: ;# 스타일 붙여넣기
::;#
+s or g:: ;# 선 or 채우기 색 스포이드
s or g:: ;# 선 or 채우기 색 선택(팔레트 창 켜져있을 때)
::;#
^+> or <:: ;# 폰트 키우기 줄이기
::;#
^g:: ;# 그룹화
^+g:: ;# 그룹화 해제
::;#
^+L:: ;# 잠금, 잠금 해제
::;#
+h or v:: ;# horizon, vertical 뒤집기
::;#
!+c:: ;# png로 복사
::;#
!e:: ;# Elbow connectors
!r:: ;# Reverse arrows
::;#
!a:: ;# Toggle grid
::;#
::;# ---- 일반 ----
::;#
^Tab:: ;# 저장하고 다른 작업공간 레이아웃 불러오기
^h:: ;# 하이라이트
!z:: ;# Clear formatting
^+d:: ;# omnisearch
*/

/*
########################################
## @IntelliJ
########################################
*/
intelliJGuideGui := createGuideGui("IntelliJ.txt")

#HotIf WinActive("ahk_exe idea64.exe")
#/::intelliJGuideGui.Show()

; ^.::SendInput("/**`n") ;# 주석 달기(IntelliJ 설정에 따라 Doc 자동 생성됨)

/* 
기본 단축키들 도움말 출력용
::;#
::;#
::;# ---- 키 지정 라인 ----
::;#
!z:: ;# Optimize Imports -> 안 쓰는 Imports 제거
!x:: ;# Introduce Variable -> return값으로 변수 자동 생성
!q:: ;# Recent Files -> 최근 파일 검색
!w:: ;# Go to File -> 파일 검색
^q:: ;# Pin Active Tab
^w:: ;# Close Tab
^+w:: ;# Close All but Pinned
^e:: ;# Extend Selection
^+f:: ;# Find in Files -> 문자열로 파일에서 찾기
^p:: ;# Parameter Info
^F1:: ;# Stash Changes
!F1:: ;# Unstash Changes
^F12:: ;# Show Local History
^+F12:: ;# Show Local History for Selection
!F12:: ;# Put Label(Local History)
!Insert:: ;# Generate -> Getter 등등 다양하게 추가
^+.:: ; "Keymap - Other - Fix doc comment"의 단축키를 "Ctrl + Alt + Shift + [" 로 변경 (fix가 좀 애매하게 됨) ;# 주석 업데이트
*/

/*
########################################
## @Vivaldi
########################################
*/
#HotIf WinActive("ahk_exe vivaldi.exe")
#/::MsgBox(getGuideMap().Get("Vivaldi"))

!`::SendInput("!0") ;# Window Workspaces로 변경

:*:/af::
{
	SendText("after:2024-01-01")
}
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
## @Chrome
########################################
*/
#HotIf WinActive("ahk_exe chrome.exe")
#/::MsgBox(getGuideMap().Get("Chrome"))

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
## @VSCode
########################################
*/
#HotIf WinActive("ahk_exe Code.exe")
#/::MsgBox(getGuideMap().Get("VSCode"))

!c::SendInput("console.log(){Left}") ;# js 콘솔 자동입력
^+/::SendInput("!+a") ;# 블록 주석 토글

/*
########################################
## @Slack
########################################
*/
/*
브라우저를 통해 Slcak에 접근할 때 필요한 쿠키
*/
SLACK_AUTH_COOKIE := EnvGet("aaSlackAuthCookie")

/*
Canvas URL을 저장하는 Map object
KEY : 현재 Slack 창의 Needle
VALUE : Canvas URL
*/
slackCanvasMap := Map()
slackCanvasMap["bpmg"] := "https://w1666144998-jxs393006.slack.com/docs/T047TLC218Q/F069J6ULU6S"
slackCanvasMap["colorstreet_api"] := "https://w1666144998-jxs393006.slack.com/docs/T047TLC218Q/F06M86P5HUY"
slackCanvasMap["colorstreet_batch"] := "https://w1666144998-jxs393006.slack.com/docs/T047TLC218Q/F06MF2ER34Y"

#HotIf WinActive("ahk_exe slack.exe")
#/::MsgBox(getGuideMap().Get("Slack"))

!`::openCanvas(slackCanvasMap) ;# 캔버스 열기

openCanvas(map) {
	presentTitle := WinGetTitle("A")

	For key, url in map {
		if (InStr(presentTitle, key)) {
			httpSend("GET", url, [["Cookie", SLACK_AUTH_COOKIE]])
		}
	}
}

:*:/s::
{
	SendText("is:saved ")
}
:*:/f::
{
	SendText("from:@")
}

/*
^g::;# 검색
::;#
::;#----- 키워드 -----
/s:: ;# is:saved
/f:: ;# from:@
::;#
::;#----- 검색 필터 -----
::;#
::;# in:#채널명 in:@사람이름
::;# is:saved -> 저장된 항목만 검색
::;# during: before: after: on:... today, 8월... -> 특정 기간, 날짜 내에서 검색
::;#
*/

/*
########################################
## @Millie
########################################
*/
#HotIf WinActive("ahk_exe millie.exe")
#/::MsgBox(getGuideMap().Get("Millie"))

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
#/::MsgBox(getGuideMap().Get("Lightroom"))

!z::SendInput("^y") ;# 되돌리기 취소

/*
########################################
## @Photoshop
########################################
*/
#HotIf WinActive("ahk_exe Photoshop.exe")
#/::MsgBox(getGuideMap().Get("Photoshop"))

!z::SendInput("^+z") ;# 되돌리기 취소

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
## @DBeaver
########################################
*/
#HotIf WinActive("ahk_exe dbeaver.exe")
#/::MsgBox(getGuideMap().Get("DBeaver"))

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

; # @
