INCLUDE Irvine32.inc

main EQU start@0

.data
; 定義 cat ASCII 圖形的每一行
cat1 BYTE "\    /\"
cat2 BYTE " )  ( ')"
cat3 BYTE "(  /  )"
cat4 BYTE " \(__)|"
cat_xy COORD <9, 15>
cat_destination_xy COORD <16, 15>
; 定義組成平台的字符
platformb BYTE "="
; 定義初始平台的中心座標
platform0_xy COORD <9, 19>
; 定義生成目標平台的字符和其中心座標
platformb_xy COORD <85, 19>
; 定義隨機的平台寬度
randomnum WORD ?
; 定義垂直線 * 的字串和長度
verticalLine BYTE "*"
; 起始座標和生成限制
xyVertical COORD <16, 19>      ; 設定垂直線的生成座標
verticalCount DWORD 0          ; 當前生成數量
verticalMax DWORD 110        ; 最大生成數量
blankLine BYTE "        "   ; 每行的空白字元，寬度要與 ASCII 藝術圖一致
last_random WORD 7
outputHandle DWORD ?
cellsWritten DWORD ?
score_char BYTE "Score: 00000"
score_xy COORD <90, 1>

.code
SetConsoleOutputCP PROTO STDCALL :DWORD

DrawCat PROC
    push (COORD PTR cat_xy).Y
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
    pop (COORD PTR cat_xy).Y
    ret
DrawCat ENDP

ClearCat PROC
    ; 保存原始 Y 值
    push (COORD PTR cat_xy).Y
    ; 清除貓的每一行
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    inc (COORD PTR cat_xy).Y	; next line
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    ; 恢復原始 Y 值
    pop (COORD PTR cat_xy).Y
    ret
ClearCat ENDP

; 以platform_xy為中心，生成2*platform_hlen長的platform
GeneratePlatform PROC USES eax ecx, platform_xy:COORD, platform_hlen:WORD
    mov ax, platform_xy.X ; 設生成起始位置
    sub ax, platform_hlen
    mov platform_xy.X, ax
    mov cx, platform_hlen
    add cx, platform_hlen ; 設初始平台總長
Generate_plat: ; 生成平台
    push ecx
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR platformb,        
           LENGTHOF platformb,      
           platform_xy,      
           ADDR cellsWritten 
    inc platform_xy.X ; 每生成一格 X+1
    pop ecx
    loop Generate_plat
    mov ax, platform_xy.X ; 回復platformb_xy.X成原來的值
    sub ax, platform_hlen
    mov platform_xy.X, ax
    ret
GeneratePlatform ENDP

IncScore PROC
    inc score_char[11]
    cmp score_char[11], 58
    jne L1
    mov score_char[11], 48

    inc score_char[10]
    cmp score_char[10], 58
    jne L1
    mov score_char[10], 48

    inc score_char[9]
    cmp score_char[9], 58
    jne L1
    mov score_char[9], 48

    inc score_char[8]
    cmp score_char[8], 58
    jne L1
    mov score_char[8], 48
    
    inc score_char[7]
    cmp score_char[7], 58
    jne L1
    mov score_char[7], 48
L1:
    ret
IncScore ENDP

DrawScore PROC
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR score_char,         ; Pointer to ASCII art
           LENGTHOF score_char,       ; Length of ASCII art
           score_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    ret
DrawScore ENDP

; 顯示橋梁
ShowBridge PROC
    mov ecx, verticalCount
    cmp verticalCount, 0
    jz L2
L1:
    push ecx
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ADDR verticalLine,  ; 字符串 * 的地址
           LENGTHOF verticalLine,             ; 字符串的長度
           xyVertical,      ; 打印位置
           ADDR cellsWritten   ; 實際寫入的字元數
    inc (COORD PTR xyVertical).X
    INVOKE Sleep, 10
    pop ecx
    Loop L1
    mov verticalCount, 0
L2:
    ret
ShowBridge ENDP

main PROC
    ; Set the console code page to 437 (supports box drawing characters)
    INVOKE SetConsoleOutputCP, 437

    ; Get the console output handle
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax

Start:
    INVOKE DrawScore
    call DrawCat

    invoke GeneratePlatform, platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 3
    invoke GeneratePlatform, platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 2
    invoke GeneratePlatform, platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 1
    mov ecx, 8
Gen_init_plat:
    invoke GeneratePlatform, platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    loop Gen_init_plat
    
    call Randomize ; 設亂數種子
    mov eax, 15
    call RandomRange
    add eax, 7 ; range 7~27 store in eax
    mov randomnum, ax
    invoke GeneratePlatform, platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 3
    invoke GeneratePlatform, platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 2
    invoke GeneratePlatform, platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 1
    mov ecx, 8
Gen_plat:
    invoke GeneratePlatform, platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    loop Gen_plat
    mov randomnum, ax
  
KeyLoop:                   ; 進入按鍵監聽循環
    call ReadChar          ; 等待並讀取按鍵輸入
    mov ah, 0              ; 清除高位掃描碼，只保留 ASCII 值
    ; 如果按下空白鍵，執行生成 * 的邏輯
    cmp al, 32             ; 檢查是否為空白鍵 (ASCII 值 32)
    je GenerateVerticalLine
    ; 按下c鍵，移動至目標地
    cmp al, 99

    je ShowTheBridge

    cmp al, 112
    je Cheat

    ; 按其他鍵則繼續等待
    jmp KeyLoop

Cheat:
    INVOKE IncScore
    INVOKE DrawScore
    jmp KeyLoop

GenerateVerticalLine:
    ; 檢查是否達到最大生成數量
    mov eax, verticalCount
    cmp eax, verticalMax
    jae KeyLoop            ; 如果達到最大數量，返回監聽循環
    
    inc verticalCount       ; 增加生成數量
    ; 設定目標座標
    mov ax, (COORD PTR cat_destination_xy).X
    inc ax
    mov (COORD PTR cat_destination_xy).X, ax
    ; 返回按鍵監聽
    jmp KeyLoop

; 顯示橋梁
ShowTheBridge:
    INVOKE ShowBridge
    jmp GoToNextPlatform

; 移動至目標地
GoToNextPlatform:
    mov ax, (COORD PTR cat_destination_xy).X
    cmp (COORD PTR cat_xy).X, ax
    jne moving

    mov ax, (COORD PTR platformb_xy).X
    sub ax, randomnum
    cmp ax, (COORD PTR cat_destination_xy).X
    jg Fail
    mov ax, (COORD PTR platformb_xy).X
    add ax, randomnum
    sub ax, 7
    cmp ax, (COORD PTR cat_destination_xy).X
    jl Fail
    jmp Success

moving:
    call ClearCat
    inc (COORD PTR cat_xy).X
    call DrawCat
    INVOKE Sleep, 25
    jmp GoToNextPlatform

Fail:
    jmp KeyLoop

Success:
    call Clrscr ; 清屏
    mov verticalCount, 0
    mov (COORD PTR platform0_xy).X, 9  
    mov (COORD PTR platform0_xy).Y, 19
    mov (COORD PTR platformb_xy).X, 85
    mov (COORD PTR platformb_xy).Y, 19    
    mov bx, (COORD PTR platform0_xy).X
    add bx, randomnum
    sub bx, 7
    mov (COORD PTR cat_xy).X, bx
    mov (COORD PTR cat_xy).Y, 15
    mov bx, (COORD PTR platform0_xy).X
    add bx, randomnum
    mov (COORD PTR cat_destination_xy).X, bx
    mov (COORD PTR cat_destination_xy).Y, 15
    mov bx, (COORD PTR platform0_xy).X
    add bx, randomnum
    mov (COORD PTR xyVertical).X, bx
    mov (COORD PTR xyVertical).Y, 19
    mov bx, randomnum
    mov last_random, bx
    INVOKE IncScore
    jmp Start
    exit
main ENDP
END main