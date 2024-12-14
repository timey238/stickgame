INCLUDE Irvine32.inc

.data
outputHandle DWORD 0           ; 控制台句柄
bytesWritten DWORD 0           ; 實際寫入字元數
count DWORD 0                  ; 寫入字元數量
xyPosition COORD <2, 21>       ; 開始輸出的位置 (左下角)

; 定義 ASCII 圖形的每一行和長度
asciiLine1 BYTE " \    /\", 0
line1Len DWORD SIZEOF asciiLine1 - 1

asciiLine2 BYTE "  )  ( ')", 0
line2Len DWORD SIZEOF asciiLine2 - 1

asciiLine3 BYTE " (  /  )", 0
line3Len DWORD SIZEOF asciiLine3 - 1

asciiLine4 BYTE "  \(__)|", 0
line4Len DWORD SIZEOF asciiLine4 - 1

; 定義平台的字符和長度 (平台寬度擴展到 14)
platformLine BYTE "==============", 0
platformLen DWORD SIZEOF platformLine - 1

main EQU start@0

.code
SetConsoleOutputCP PROTO STDCALL :DWORD

main PROC
    ; 設置控制台輸出編碼
    INVOKE SetConsoleOutputCP, 437

    ; 取得控制台輸出句柄
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax ; 保存控制台句柄
    call Clrscr           ; 清屏

    ; 打印 ASCII 圖形
    mov xyPosition.X, 2   ; 設定圖形的 X 起始位置 (左邊距)
    mov xyPosition.Y, 21  ; 設定圖形的 Y 起始位置 (接近底部)

    ; 打印第一行
    lea ecx, asciiLine1
    mov eax, line1Len
    call PrintAscii
    inc xyPosition.Y

    ; 打印第二行
    lea ecx, asciiLine2
    mov eax, line2Len
    call PrintAscii
    inc xyPosition.Y

    ; 打印第三行
    lea ecx, asciiLine3
    mov eax, line3Len
    call PrintAscii
    inc xyPosition.Y

    ; 打印第四行
    lea ecx, asciiLine4
    mov eax, line4Len
    call PrintAscii
    inc xyPosition.Y

    ; 打印平台 (左右各延伸 2 單位)
    mov xyPosition.X, 0   ; 平台從最左邊開始
    lea ecx, platformLine
    mov eax, platformLen  ; 平台的總寬度為 14
    call PrintAscii

    ; 等待並清屏
    call WaitMsg
    call Clrscr
    exit
main ENDP

; 打印 ASCII 圖形的子程序
PrintAscii PROC
    ; 實際打印圖形
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,        ; 控制台句柄
        ecx,                 ; ASCII 圖形的指針
        eax,                 ; 每行字符數量
        xyPosition,          ; 當前座標
        OFFSET count         ; 實際寫入的字元數量
    ret
PrintAscii ENDP

END main