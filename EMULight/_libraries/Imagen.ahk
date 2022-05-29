Imagen( Filename, Options:="", ByRef hBitmap:=0 ) {               ; Imagen v3.22 by SKAN on D07L/D46D @ tiny.cc/IMAGEN
Local                                                             ; Requires AutoHotkey v1.1.33.02 +
Static GdiplusStartupInput, RECT

  If !VarSetCapacity(GdiplusStartupInput)
      VarSetCapacity(GdiplusStartupInput, 24, 0),  NumPut(1, GdiplusStartupInput, "Int")
  Options := (A_Space . Options . A_Space), Bpp := 0, sBM := 0, hCtrl := 0, hBitmap := 0

  If ( f := InStr(Options, " ahk_id",, 0) )
  If ( hCtrl := Format("0x{:x}", SubStr(Options, f+7)) )
  {
      WinGetClass, Class, ahk_id %hCtrl%
      If ( Class!="Static" )
          Return (ErrorLevel := 1)*0
      WinSet, Style, +0x20E, ahk_id %hCtrl%
      
      VarSetCapacity(RECT, 16)
      DllCall("user32.dll\GetClientRect", "Ptr",hCtrl, "Ptr",&RECT)
      W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      H := NumGet(RECT,12, "Int") - NumGet(RECT, 4, "Int")
      If ( W<1 || H<1 )
          Return (ErrorLevel := 2)*0
      Options .= "Scale "
  }

  If ( f := InStr(FileName, "HBITMAP:",, 0) )
  {
      DontDelete := ( SubStr(Filename, f+8, 1) = "*" )
      sBM := Format("{1:d}", SubStr(FileName, f+8+DontDelete))
      VarSetCapacity(BITMAP, 32, 0)
      If ( !DllCall("gdi32.dll\GetObject", "Ptr",sBM, "Int",A_PtrSize=8? 32:24, "Ptr",&BITMAP) )
          Return (ErrorLevel := 3)*0
      Bpp := NumGet(BITMAP, 18, "Short")
  }

  If ( !sBM && !FileExist(FileName) && StrLen(FileName) )
      Return (ErrorLevel := 4)*0

  hMod := DllCall("kernel32.dll\LoadLibrary", "Str","GdiPlus.dll", "Ptr"),  pToken := 0
  DllCall("gdiplus.dll\GdiplusStartup", "PtrP",pToken, "Ptr",&GdiplusStartupInput, "Int",0)
  SX := 0, SY := 0, SW := 0, SH := 0, pBits := 0, pBitmap := 0, pGraphics := 0, pBMtemp := 0, pAttr := 0
  PARGB := 925707, RGB := 139273

  If ( StrLen(FileName)=0 )
      DllCall("gdiplus.dll\GdipCreateBitmapFromScan0"
            , "Int",SW:=2, "Int",SH:=2, "Int",0, "Int",PARGB, "Ptr",0, "PtrP",pBitmap)

  Else If ( Bpp=0 )
      DllCall("gdiplus.dll\GdipCreateBitmapFromFile", "WStr",Filename, "PtrP",pBitmap)

  Else
  Switch ( Bpp ) {

  Default :
  DllCall("gdiplus.dll\GdipCreateBitmapFromHBITMAP", "Ptr",sBM, "Ptr",0, "PtrP",pBitmap)
  If ( DontDelete=False )
  DllCall("gdi32.dll\DeleteObject", "Ptr",sBM)

  Case 32 :
  SW := NumGet(BITMAP, 04, "UInt"),   Stride := NumGet(BITMAP, 12, "UInt")
  SH := NumGet(BITMAP, 08, "UInt"),   Bytes  := Stride * SH

  VarSetCapacity(BITMAPINFO, 40, 0),  pBMI := &BITMAPINFO
  NumPut(Bpp, NumPut(1,NumPut(0-SH,NumPut(SW,NumPut(40,pBMI+0,"Int"),"Int"),"Int"),"Short"),"Short")
  tBM := DllCall("gdi32.dll\CreateDIBSection", "Ptr",0, "Ptr",pBMI, "Int",0, "PtrP",pBits, "Ptr",0, "Int", 0, "Ptr")

  tDC := DllCall("gdi32.dll\CreateCompatibleDC", "Ptr",0, "Ptr")
  DllCall("gdi32.dll\SaveDC", "Ptr",tDC)
  sDC := DllCall("gdi32.dll\CreateCompatibleDC", "Ptr",0, "Ptr")
  DllCall("gdi32.dll\SaveDC", "Ptr",sDC)
  DllCall("gdi32.dll\SelectObject", "Ptr",tDC, "Ptr",tBM)
  DllCall("gdi32.dll\SelectObject", "Ptr",sDC, "Ptr",sBM)

  DllCall("gdi32.dll\GdiAlphaBlend"
        , "Ptr",tDC, "Int",0, "Int",0, "Int",SW, "Int",SH
        , "Ptr",sDC, "Int",0, "Int",0, "Int",SW, "Int",SH, "Int",AM := 0x01FF0000)

  If ! ( Numget(pBits+0,"Int")
   || DllCall("ntdll.dll\RtlCompareMemory", "Ptr",pBits, "Ptr",pBits+1, "Ptr",Bytes-1)!=Bytes-1 )

      DllCall("gdi32.dll\GdiAlphaBlend"
            , "Ptr",tDC, "Int",0, "Int",0, "Int",SW, "Int",SH
            , "Ptr",sDC, "Int",0, "Int",0, "Int",SW, "Int",SH, "Int",AM := 0x00FF0000)

  DllCall("gdi32.dll\RestoreDC", "Ptr",sDC, "Int",-1)
  DllCall("gdi32.dll\DeleteDC", "Ptr",sDC)
  DllCall("gdi32.dll\RestoreDC", "Ptr",tDC, "Int",-1)
  DllCall("gdi32.dll\DeleteDC", "Ptr",tDC)

  VarSetCapacity(BITMAPDATA, 40, 0),  NumPut(Stride, BITMAPDATA, 8, "Int"),    PixFmt := (AM=0x01FF0000 ? PARGB : RGB)
  DllCall("gdiplus.dll\GdipCreateBitmapFromScan0", "Int",SW, "Int",SH, "Int",0, "Int",PixFmt, "Ptr",0, "PtrP",pBitmap)
  DllCall("gdiplus.dll\GdipBitmapLockBits", "Ptr",pBitmap, "Ptr",0, "Int",0x1, "Int",PixFmt, "Ptr",&BITMAPDATA)
  DllCall("kernel32.dll\RtlMoveMemory","Ptr",NumGet(BITMAPDATA, 16, "Ptr"), "Ptr",pBits, "Ptr",Bytes)
  DllCall("gdiplus.dll\GdipBitmapUnlockBits", "Ptr",pBitmap, "Ptr",&BITMAPDATA)

  DllCall("gdi32.dll\DeleteObject", "Ptr",tBM),  
  If (DontDelete=False)
    DllCall("gdi32.dll\DeleteObject", "Ptr",sBM)
  } ; End Switch

  If ( pBitmap && SW=0 && SH=0)
       DllCall("gdiplus.dll\GdipGetImageWidth", "Ptr",pBitmap, "PtrP",SW)
     , DllCall("gdiplus.dll\GdipGetImageHeight","Ptr",pBitmap, "PtrP",SH)

  If ( pBitmap=0 || SW<1 || SH<1 )
  {
       DllCall("gdiplus.dll\GdiplusShutdown", "Ptr",pToken)
       DllCall("kernel32.dll\FreeLibrary", "Ptr",hMod)
       Return (ErrorLevel := 6)*0
  }

  If ( !hCtrl )
       W := ( (f := InStr(Options, " W",, 0)) ? Format("{:d}", SubStr(Options, f+2)) : 0 )
     , H := ( (f := InStr(Options, " H",, 0)) ? Format("{:d}", SubStr(Options, f+2)) : 0 )

  SAF := Round(SW/SH, 8)
  If ( W>0 )
       TW := W,  TH := (H=0 ? (H:=SH) : H<0 ? (H:=Ceil(TW/SAF)) : H)
  Else If ( H>0 )
       TH := H,  TW := (W=0 ? (W:=SW) : W<0 ? (W:=Ceil(TH*SAF)) : W)
  Else TW := (W := SW),  TH := (H := SH)
  TAF := Round(TW/TH, 8)

  Upscale := InStr(Options, " Upscale",, 0)
  If ( InStr(Options, " Scale",, 0) || Upscale )
       D :=  ( !Upscale && SW<=TW && SH<=TH ) ? { "W": SW, "H": SH }
         :   ( SAF=1 && TAF>=1 ) ? { "W": TH, "H": TH }
         :   ( SAF=1 && TAF< 1 ) ? { "W": TW, "H": TW }
         :   ( SAF < TAF ) ? { "W": Ceil( (TW/TAF) * SAF ), "H": TH }
         :   ( SAF > TAF ) ? { "H": Ceil( (TH/SAF) * TAF ), "W": TW }
         :   { "W": TW, "H": TH }
     , TW := D.W,  TH := D.H

  Zoom := ( InStr(Options, " Zoom",, 0) )
  Real := ( !hCtrl && !Zoom && InStr(Options, " Real",, 0) )
  CW := ( Real ? TW : W ),   TX := ( (CW-TW)//2 )
  CH := ( Real ? TH : H ),   TY := ( (CH-TH)//2 )

  If ( Zoom && !(TW=W && TH=H) )
       If ( TW!=CW && TH=CH )
            TH := Round(TH*(CW/TW)), TW := CW, TX := 0, TY := (CH-TH)//2
       Else
       If ( TW=CW && TH!=CH )
            TW := Round(TW*(CH/TH)), TH := CH, TY := 0, TX := (CW-TW)//2

  BG := StrSplit(( (f := InStr(Options, " Background",,0)) ? SubStr(Options, f+11) : "" ), A_Space)[1]
  BG := ( BG="Trans" ? "Trans" : BG=""
     ? Format("0x{2:02X}{3:02X}{4:02X}", n := DllCall("user32.dll\GetSysColor", "Int",15, "UInt")
             ,(n & 255), ((n>>8) & 255), ((n>>16) & 255))
     :  DllCall("msvcrt.dll\_wcstoui64", "WStr",BG, "Int",0, "Int",16, "Int64") )
  BG := Format("0x{1:08X}", (hCtrl || BG<0x001000000) ? BG|0xFF000000 : BG)

  _X := StrSplit( (f := InStr(Options," ?",, 0)) ? SubStr(Options,f+2) : "", A_Space)[1]
  _X := StrSplit(_X, ":")
  X  := _X.1


  If (StrLen(X)!=200 )
  Switch ( X ) {
  Default          : X := ""
  Case "Normal"    : X := "0000803f00000000000000000000000000000000000000000000803f0000000000000000000000000000000000"
    . "0000000000803f00000000000000000000000000000000000000000000803f00000000000000000000000000000000000000000000803f"
  Case "Grayscale" : X := "8716993e8716993e8716993e0000000000000000a245163fa245163fa245163f0000000000000000d578e93dd5"
    . "78e93dd578e93d00000000000000000000000000000000000000000000803f00000000000000000000000000000000000000000000803f"
  Case "Invert"    : X := "000080bf0000000000000000000000000000000000000000000080bf0000000000000000000000000000000000"
    . "000000000080bf00000000000000000000000000000000000000000000803f000000000000803f0000803f0000803f000000000000803f"
  Case "Sepia"     : X := "4c37c93e21b0b23e96438b3e00000000000000002fdd443fb29d2f3f39b4083f00000000000000003789413e31"
    . "082c3edd24063e00000000000000000000000000000000000000000000803f00000000000000000000000000000000000000000000803f"
  }

  If ( StrLen(X)=200 && VarSetCapacity(CM,100,0) )
  {
   X:=DllCall("Crypt32.dll\CryptStringToBinary", "Str",X, "Int",200, "Int",4, "Ptr",&CM, "IntP",100, "Int",0, "Int",0)
   Z := Format("{:0.7f}", _X.2)
   If ( Z>0 && Z<255 )
        NumPut(Z/255, CM, 72, "Float")
  }

  DllCall("gdiplus.dll\GdipCreateBitmapFromScan0", "Int",CW, "Int",CH, "Int",0, "Int",PARGB, "Ptr",0, "PtrP",pBMtemp)
  DllCall("gdiplus.dll\GdipGetImageGraphicsContext", "Ptr",pBMtemp, "PtrP",pGraphics)
  DllCall("gdiplus.dll\GdipSetSmoothingMode", "Ptr",pGraphics, "Int",2)
  DllCall("gdiplus.dll\GdipSetInterpolationMode", "Ptr",pGraphics, "Int",7)
  DllCall("gdiplus.dll\GdipGraphicsClear", "Ptr",pGraphics, "Int",BG)
  
  If ( X!=1 )
      DllCall("gdiplus\GdipDrawImageRectRect", "Ptr",pGraphics, "Ptr",pBitmap
             , "Float",TX, "Float",TY, "Float",TW, "Float",TH, "Float",SX, "Float",SY, "Float",SW, "Float",SH
             , "Int",UnitPixel:=2, "Ptr",pAttr, "Ptr",0, "Ptr",0 )
  Else
  {
      DllCall("gdiplus\GdipCreateImageAttributes", "PtrP",pAttr)
      DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "Ptr",pAttr, "Int",1, "Int",1, "Ptr",&CM, "Ptr",0, "Int",0)
      DllCall("gdiplus\GdipDrawImageRectRect", "Ptr",pGraphics, "Ptr",pBitmap
             , "Float",TX, "Float",TY, "Float",TW, "Float",TH, "Float",SX, "Float",SY, "Float",SW, "Float",SH
             , "Int",UnitPixel:=2, "Ptr",pAttr, "Ptr",0, "Ptr",0 )
      DllCall("gdiplus\GdipDisposeImageAttributes", "Ptr",pAttr)
  }

  DllCall("gdiplus.dll\GdipDisposeImage", "Ptr",pBitmap),   pBMtemp := (pBitmap := pBMtemp)*0
  DllCall("gdiplus.dll\GdipDeleteGraphics", "Ptr",pGraphics)

  VarSetCapacity(BITMAPINFO, 40, 0),  pBMI := &BITMAPINFO, Stride := CW*4, Bpp := 32
  NumPut(Bpp, NumPut(1,NumPut(CH,NumPut(CW,NumPut(40,pBMI+0,"Int"),"Int"),"Int"),"Short"),"Short")
  hBM := DllCall("gdi32.dll\CreateDIBSection", "Ptr",0, "Ptr",pBMI, "Int",0, "PtrP",pBits, "Ptr",0, "Int", 0, "Ptr")

  VarSetCapacity( BitmapData, A_PtrSize = 8 ? 32 : 24, 0 )
  NumPut( 0 - Stride, BitmapData, 8, "Int" )
  NumPut( pBits + ( Stride * CH ) - Stride, BitmapData, 16, "Ptr" ) ; 0x5 =ImageLockModeRead|ImageLockModeUserInputBuf
  DllCall("gdiplus.dll\GdipBitmapLockBits", "Ptr",pBitmap, "Ptr",0, "Int",0x5, "Int",PARGB, "Ptr",&BitmapData)
  DllCall("gdiplus.dll\GdipBitmapUnlockBits", "Ptr",pBitmap, "Ptr",&BitmapData)
  DllCall("gdiplus.dll\GdipDisposeImage","Ptr",pBitmap)
  DllCall("gdiplus.dll\GdiplusShutdown", "Ptr",pToken)
  DllCall("kernel32.dll\FreeLibrary", "Ptr",hMod)

  If ( !hCtrl )
      Return ((hBitmap:=hBM)*0)+1

  Avals := 255, Delay := 0, Chk := 0, Cur := 0
  If ( AnimN := ( f := InStr(Options, " FadeIn",, 0) ) ? Format("{1:d}", SubStr(Options, f+7)) : 0 )
  {
      Avals := ( (Avals := StrSplit( (f := InStr(Options,"ms<",, 0)) ? SubStr(Options,f+3) : "", ">")[1])
             ?    Avals : "5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,24,27,31,36,42,49,57,65,90,124,165,204,255" )
      StrReplace(AVals, ",", ",", Frames), Frames += 1
      Delay := Round( (AnimN/Frames)*10000 )
  }

  mDC := DllCall("gdi32.dll\CreateCompatibleDC", "Ptr",0, "Ptr")
  DllCall("gdi32.dll\SaveDC", "Ptr",mDC)
  DllCall("gdi32.dll\SelectObject", "Ptr",mDC, "Ptr",hBM)
  sDC := DllCall("user32.dll\GetDC", "Ptr",hCtrl, "Ptr")

  SetBatchLines, % (-1, SBL := A_BatchLines)
  Loop, Parse, Avals, CSV
  {
        DllCall("gdi32.dll\GdiAlphaBlend"
              , "Ptr",sDC, "Int",0, "Int",0, "Int",W, "Int",H
              , "Ptr",mDC, "Int",0, "Int",0, "Int",W, "Int",H, "Int", Format("0x01{:02x}0000", A_LoopField))
        If ( Delay )
        {
            DllCall("kernel32.dll\GetSystemTimeAsFileTime", "Int64P",Cur),    Chk := Cur+Delay
            While ( Cur<Chk )
            {
                DllCall("kernel32.dll\GetSystemTimeAsFileTime", "Int64P",Cur)
                Sleep 0
            }
        }
  }
  SetBatchLines, %SBL%

  DllCall("user32.dll\ReleaseDC", "Ptr",hCtrl, "Ptr",sDC)
  DllCall("gdi32.dll\RestoreDC", "Ptr",mDC, "Int",-1)
  DllCall("gdi32.dll\DeleteDC", "Ptr",mDC)

  DllCall("user32.dll\SendMessage", "Ptr",hCtrl, "Int",0x00B, "Ptr",0, "Ptr",0, "Ptr")
  oBM := DllCall("user32.dll\SendMessage", "Ptr",hCtrl, "Int",0x172, "Ptr",0, "Ptr",hBM, "Ptr")
  DllCall("user32.dll\SendMessage", "Ptr",hCtrl, "Int",0x00B, "Ptr",1, "Ptr",0, "Ptr")

  DllCall("gdi32.dll\DeleteObject", "Ptr",oBM)
  DllCall("gdi32.dll\DeleteObject", "Ptr",hBM)
Return 1
}
