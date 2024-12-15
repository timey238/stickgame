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

; 定義垂直線 * 的字串和長度
verticalLine BYTE "*", 0
verticalLineLen DWORD SIZEOF verticalLine - 1

; 起始座標和生成限制
xyVertical COORD <14, 25>      ; 設定垂直線的生成座標
verticalCount DWORD 0          ; 當前生成數量
verticalMax DWORD 100           ; 最大生成數量

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

    ; 初始化生成數量
    mov verticalCount, 0

    ; 進入按鍵監聽循環
KeyLoop:
    call ReadChar          ; 等待並讀取按鍵輸入
    mov ah, 0              ; 清除高位掃描碼，只保留 ASCII 值

    ; 如果按下空白鍵，執行生成 * 的邏輯
    cmp al, 32             ; 檢查是否為空白鍵 (ASCII 值 32)
    je GenerateVerticalLine

    ; 按其他鍵則繼續等待
    jmp KeyLoop

GenerateVerticalLine:
    ; 檢查是否達到最大生成數量
    mov eax, verticalCount
    cmp eax, verticalMax
    jae KeyLoop            ; 如果達到最大數量，返回監聽循環

    ; 打印 * 到當前位置
    lea ecx, verticalLine
    mov eax, verticalLineLen
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ecx,             ; 字符串 * 的地址
           eax,             ; 字符串的長度
           xyVertical,      ; 打印位置
           OFFSET count     ; 實際寫入的字元數

    ; 更新座標和生成計數
    inc xyVertical.X        ; 向上移動一行
    inc verticalCount       ; 增加生成數量

    ; 返回按鍵監聽
    jmp KeyLoop


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
