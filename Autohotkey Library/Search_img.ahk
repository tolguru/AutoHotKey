search_img(image,hwnd, byref vx, byref vy, sx=0, sy=0, w=0, h=0, vt=30) {
pToken:=Gdip_Startup() 

;자르는 좌표가 오류로 안먹힘으로 아래조건문추가
if(w=0 || h=0){
pBitmapHayStack:=Gdip_BitmapFromhwnd(hwnd)
}else{
	pBitmapHayStack:=Gdip_CropImage(Gdip_BitmapFromhwnd(hwnd), sx, sy, w, h)
}
pBitmapNeedle:=Gdip_CreateBitmapFromFile(image)

;Gdip_SaveBitmapToFile(pBitmapHayStack, "test.bmp") ; 파일로 저장

if Gdip_ImageSearch(pBitmapHayStack,pBitmapNeedle,list,0,0,0,0,vt,0x000000,1,1) {  
StringSplit, LISTArray, List, `, 

if(sx=0 || sy=0){
	vx:=LISTArray1 
	vy:=LISTArray2
}else{
	vx:=LISTArray1+sx 
	vy:=LISTArray2+sy
}

;CoordMode,ToolTip,Screen ;어느곳 스캔하는지 알기위해
;Tooltip, %image%_%vx%_%vy%,%tx%,%ty%, 2

Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
Gdip_Shutdown(pToken)
return true
}
else 
{
;CoordMode,ToolTip,Screen  ;어느곳 스캔하는지 알기위해
;Tooltip, %image%_%vx%_%vy%,%tx%,%ty%, 2

Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
Gdip_Shutdown(pToken)
return false
}
}


Gdip_CropImage(pBitmap, x, y, w, h)
{
pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
Gdip_DeleteGraphics(G2)
Gdip_DisposeImage(G2)
return pBitmap2
}