INCLUDE Irvine32.inc

main EQU start@0

.data
; 定義 cat ASCII 圖形的每一行
cat1 BYTE " \    /\", 0
cat2 BYTE "  )  ( ')", 0
cat3 BYTE " (  /  )", 0
cat4 BYTE "  \(__)|", 0
cat_xy COORD <2, 21>
; 定義初始平台的字符 (平台寬度為 14)
platform0 BYTE "==============", 0
; 定義生成目標平台的字符和其中心座標
platformb BYTE "=", 0
platformb_xy COORD <75, 25>
; 定義隨機的平台寬度
randomnum WORD ?
; 定義垂直線 * 的字串和長度
verticalLine BYTE "***", 0
; 起始座標和生成限制
xyVertical COORD <15, 25>      ; 設定垂直線的生成座標
verticalCount DWORD 0          ; 當前生成數量
verticalMax DWORD 20           ; 最大生成數量

outputHandle DWORD ?
cellsWritten DWORD ?

.code
SetConsoleOutputCP PROTO STDCALL :DWORD

main PROC
    ; Set the console code page to 437 (supports box drawing characters)
    INVOKE SetConsoleOutputCP, 437

    ; Get the console output handle
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    call Clrscr           ; 清屏

    ; Write the ASCII art to the console
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR cat1,         ; Pointer to ASCII art
           LENGTHOF cat1,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR cat2,         ; Pointer to ASCII art
           LENGTHOF cat2,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR cat3,         ; Pointer to ASCII art
           LENGTHOF cat3,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR cat4,         ; Pointer to ASCII art
           LENGTHOF cat4,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR platform0,         ; Pointer to platform0
           LENGTHOF platform0,       ; Length of platform0
           cat_xy,       ; Starting position (bottom of cat)
           ADDR cellsWritten ; Number of characters written

    call Randomize ; 設亂數種子
    mov eax, 19
    call RandomRange
    inc eax ; range 1~20 store in eax
    mov randomnum, ax

    mov ax, (COORD PTR platformb_xy).X ; 設生成起始位置
    sub ax, randomnum
    mov (COORD PTR platformb_xy).X, ax
    mov cx, randomnum ; 設為平台總長 (2*randomnum)
    add cx, randomnum

Generate_plat: ; 生成平台
    push ecx
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR platformb,        
           LENGTHOF platformb,      
           platformb_xy,      
           ADDR cellsWritten 
    inc (COORD PTR platformb_xy).X ; 每生成一格 X+1
    pop ecx
    loop Generate_plat

    mov ax, (COORD PTR platformb_xy).X ; 回復platformb_xy.X成原來的值
    sub ax, randomnum
    mov (COORD PTR platformb_xy).X, ax

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
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ADDR verticalLine,  ; 字符串 * 的地址
           LENGTHOF verticalLine,             ; 字符串的長度
           xyVertical,      ; 打印位置
           ADDR cellsWritten   ; 實際寫入的字元數

    ; 更新座標和生成計數
    inc xyVertical.X        ; 向上移動一行
    inc verticalCount       ; 增加生成數量

    ; 返回按鍵監聽
    jmp KeyLoop

    exit
main ENDP

END main