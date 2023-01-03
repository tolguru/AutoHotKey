wincap(image,hwnd) {
	
	pToken:=Gdip_Startup()
	pBitmapHayStack:=Gdip_BitmapFromhwnd(hwnd)	
	Gdip_SaveBitmapToFile(pBitmapHayStack, image ".bmp")
	Gdip_DisposeImage(pBitmapHayStack)
	Gdip_Shutdown(pToken)

}

capture()
{
	actWin := WinExist("A")
	MsgBox, %actWin%
	FormatTime, CurrentDateTime,, yyyyMMddHHmmss%A_msec%	
	wincap("cap/"CurrentDateTime,actWin)
}

