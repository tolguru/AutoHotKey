#Include TemplateMatch.ahk

F1::
Check := TemplateMatch(Out_X, Out_Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\auto_image\seat3.png", "TM_SQDIFF_NORMED")
MsgBox,% "검색 X좌표 : " Out_X "`n검색 Y좌표 : " Out_Y "`n일치율 : " Check
return

Pause:: Reload