#Include Gdip_all.ahk
#Include Gdip_ImageSearch.ahk
#Include Search_img.ahk
#Include wincap.ahk

Title := "짜근햄"
ctl = TheRender     ;child Title(클래스명 아님)
winid := 0


Gui, Add, Edit, x137 y24 w130 h30 vWinTitle, 짜근햄
Gui, Add, Text, x27 y24 w100 h30 , 창타이틀
Gui, Add, Button, x27 y74 w160 h50 , 시작
Gui, Add, Button, x27 y134 w160 h50 , 캡쳐(창선택후 F11)
Gui, Add, Button, x27 y200 w160 h50 , 종료
Gui, Add, Button, x202 y69 w160 h50 , 숨김
Gui, Add, Button, x202 y129 w160 h50 , 복귀
Gui, Add, Button, x267 y4 w100 h30 , 검색
Gui, Add, Button, x267 y34 w100 h30 , 범위검색
; Generated using SmartGUI Creator for SciTE
Gui, Show, w397 h426, 비활성클릭테스트
return


F11::
{
	capture()
}
return

Button검색:
{
	Gui, Submit,nohide
	WinGet,winid,ID,%Title%

	a := A_TickCount
	if(Search_img("img/캐슬아이콘.bmp",winid,x,y,838,374,36,35,30)=1)
		{
			b := A_TickCount-a
			MsgBox, 찾음시간: %b% `, %x% `, %y%
			sleep, 100
		}else{
			b := A_TickCount-a
			MsgBox, 못찾음시간: %b%
		}

}
return

Button범위검색:
{
	Gui, Submit,nohide
	WinGet,winid,ID,%Title%

	a := A_TickCount
	if(Search_img("img/캐슬아이콘.bmp",winid,x,y,0,0,0,0,30)=1)
		{
			b := A_TickCount-a
			MsgBox, 찾음시간: %b% `, %x% `, %y%
			sleep, 100
		}else{
			b := A_TickCount-a
			MsgBox, 못찾음시간: %b%
		}
}
return



Button시작:
{
	Gui, Submit,nohide
	Title = %WinTitle%
	WinGet,winid,ID,%Title%
	goto, 시작
}
return


Button숨김:
{
	Gui, Submit,nohide
	Title = %WinTitle%
	WinGet,winid,ID,%Title%

   WinSet, Transparent, 0, %Title%
}
return

Button복귀:
{
	Gui, Submit,nohide
	Title = %WinTitle%
	WinGet,winid,ID,%Title%

   WinSet, Transparent, 255, %Title%
}
return

시작:
{
	Loop
	{
		if(Search_img("img/캐슬아이콘.bmp",winid,x,y,0,0,0,0,30)=1)
		{
			MsgBox, 찾음 %x% `, %y%
			ControlClick, x%x% y%y%, %Title%,,,,NA
			sleep, 100
		}else{
			MsgBox, 못찾음
		}

		sleep, 100
	}

}
return

Button종료:
{
	ExitApp
}
return

GuiClose:
ExitApp

Esc::
ExitApp

