;==================================================================================
; 파일명 : TemplateMatch.ahk
; 설명 : OpenCV 템플릿 매칭 라이브러리
; 버전: v2.1
; 사용환경 : AutoHotkey Unicode 64bit
; 라이센스: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/deed.ko)
; 설치방법: #Include TemplateMatch.ahk
; 제작자: https://catlab.tistory.com/ (fty816@gmail.com)
;==================================================================================

;==================================================================================
; 개발 로그 :
; 1. HWND 값 검출 좌표값 지정 추가
; 2. 메모리 누수 보안
;==================================================================================


; 전체 화면으로부터 객체를 검출 / 일치율을 반환
TemplateMatch(&Out_X, &Out_Y, Find_X1, Find_Y1, Find_X2, Find_Y2, SearchImage, Method := "TM_SQDIFF") {
	Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	maxVal := DllCall("OpenCVTemplateMatch_x64\TemplateMatch"
										, "int*", Out_X, "int*", Out_Y
										, "int", Find_X1, "int", Find_Y1
										, "int", Find_X2, "int", Find_Y2
										, "AStr", SearchImage, "AStr", Method, "double")
	DllCall("FreeLibrary", "UInt", Module) ; ,	Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox, 16, Error, ErrorCode : %ErrorLevel%
	;~ else
	;~ return maxVal
}

; 전체 화면으로부터 다중 객체를 검출 / 검색된 객체의 좌표를 X1,Y1 (엔터) X2,Y2 (엔터) X3,Y3 ... 형식으로 반환 - 추후 파싱 필요.
;~ MultiTemplateMatch(Find_X1, Find_Y1, Find_X2, Find_Y2, Threshold, SearchImage, Method:="TM_SQDIFF")
;~ {
	;~ Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	;~ Pos_Find := DllCall("OpenCVTemplateMatch_x64.dll\MultiTemplateMatch"
										;~ , "int", Find_X1, "int", Find_Y1
										;~ , "int", Find_X2, "int", Find_Y2
										;~ , "double", Threshold
										;~ , "AStr", SearchImage, "AStr", Method, "AStr")
	;~ DllCall("FreeLibrary", "UInt", Module), Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox(16, Error, ErrorCode ":" ErrorLevel)
	;~ else
	;~ return Pos_Find
;~ }

;~ ; 이미지로부터 객체를 검출 / 일치율을 반환
;~ TemplateMatchFromImage(InputImage, SearchImage, ByRef Out_X, ByRef Out_Y, Method:="TM_SQDIFF")
;~ {
	;~ Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	;~ maxVal := DllCall("OpenCVTemplateMatch_x64.dll\TemplateMatch_Image"
										;~ , "AStr", InputImage
										;~ , "AStr", SearchImage
										;~ , "int*", Out_X, "int*", Out_Y
										;~ , "AStr", Method, "double")
	;~ DllCall("FreeLibrary", "UInt", Module), Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox, 16, Error, ErrorCode : %ErrorLevel%
	;~ else
		;~ return maxVal
;~ }

;~ ; 이미지로부터 다중 객체를 검출 / 검색된 객체의 좌표를 X1,Y1 (엔터) X2,Y2 (엔터) X3,Y3 ... 형식으로 반환
;~ MultiTemplateMatchFromImage(InputImage, SearchImage, Threshold, Method:="TM_SQDIFF")
;~ {
	;~ Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	;~ Pos_Find := DllCall("OpenCVTemplateMatch_x64.dll\MultiTemplateMatch_Image"
										;~ , "AStr", InputImage
										;~ , "AStr", SearchImage
										;~ , "double", Threshold
										;~ , "AStr", Method, "AStr")
	;~ DllCall("FreeLibrary", "UInt", Module), Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox, 16, Error, ErrorCode : %ErrorLevel%
	;~ else
		;~ return Pos_Find
;~ }

;~ ; HWND값으로 부터 단일 객체를 검출 / 일치율 반환
;~ TemplateMatchFromHWND(ByRef Out_X, ByRef Out_Y, Input_HWND, SearchImage, Method:="TM_SQDIFF", Find_X1:=-1, Find_Y1:=-1, Find_X2:=-1, Find_Y2:=-1)
;~ {
	;~ Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	;~ maxVal := DllCall("OpenCVTemplateMatch_x64.dll\TemplateMatch_HWND"
										;~ , "int*", Out_X, "int*", Out_Y
										;~ , "int", Find_X1, "int", Find_Y1
										;~ , "int", Find_X2, "int", Find_Y2
										;~ , "int", Input_HWND
										;~ , "AStr", SearchImage, "AStr", Method, "double")
	;~ DllCall("FreeLibrary", "UInt", Module), Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox, 16, Error, ErrorCode : %ErrorLevel%
	;~ else
		;~ return maxVal
;~ }

;~ ; HWND값으로 부터 다중 객체를 검출 / 검색된 객체의 좌표를 X1,Y1 (엔터) X2,Y2 (엔터) X3,Y3 ... 형식으로 반환
;~ MultiTemplateMatchFromHWND(Input_HWND, Threshold, SearchImage, Method:="TM_SQDIFF", Find_X1:=-1, Find_Y1:=-1, Find_X2:=-1, Find_Y2:=-1)
;~ {
	;~ Module := DllCall("LoadLibrary", "Str", "OpenCVTemplateMatch_x64.dll")
	;~ Pos_Find := DllCall("OpenCVTemplateMatch_x64.dll\MultiTemplateMatch_HWND"
										;~ , "int", Find_X1, "int", Find_Y1
										;~ , "int", Find_X2, "int", Find_Y2
										;~ , "int", Input_HWND
										;~ , "AStr", SearchImage
										;~ , "double", Threshold
										;~ , "AStr", Method, "AStr")
	;~ DllCall("FreeLibrary", "UInt", Module), Module := ""
	;~ if ErrorLevel != 0
		;~ MsgBox, 16, Error, ErrorCode : %ErrorLevel%
	;~ else
		;~ return Pos_Find
;~ }

; 다중 객체 검출 좌표값 파싱 예시함수
;~ ParsePos(Position)
;~ {
	;~ if !Position
	;~ {
		;~ MsgBox("검색된 객체가 없습니다.")
		;~ return
	;~ }
	;~ else
	;~ {
		;~ List := ""
		;~ Loop, Parse, Position, `n
		;~ {
			;~ RegExMatch(A_LoopField, "(.*),(.*)", ov)
			;~ List .= A_Index " 번 검출 좌표`nX 좌표 : " ov1 "`nY 좌표 : " ov2 "`n"
		;~ }
		;~ MsgBox(List)
	;~ }
;~ }