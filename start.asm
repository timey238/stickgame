INCLUDE Irvine32.inc

main EQU start@0

.data
outputHandle DWORD ?            ; 控制台句柄
cellsWritten DWORD ?            ; 實際寫入的字元數

;定義開始畫面的文字
start1 BYTE "  _________ __                 __   ", 0
start2 BYTE " /   _____//  |______ ________/  |_ ", 0
start3 BYTE " \_____  \\   __\__  \\_  __ \   __\", 0
start4 BYTE " /        \|  |  / __ \|  | \/|  |  ", 0
start5 BYTE "/_______  /|__| (____  /__|   |__|  ", 0
start6 BYTE "        \/           \/             ", 0
start_xy COORD <40, 5>

exit1 BYTE "___________      .__  __   ", 0
exit2 BYTE "\_   _____/__  __|__|/  |_ ", 0
exit3 BYTE " |    __)_\  \/  /  \   __\", 0
exit4 BYTE " |        \>    <|  ||  |  ", 0
exit5 BYTE "/_______  /__/\_ \__||__|  ", 0
exit6 BYTE "        \/      \/         ", 0
exit_xy COORD <45, 15>

selectBlock BYTE "--"
selectBlock_xy COORD <80, 8>

; 定義 cat ASCII 圖形的每一行
cat1 BYTE " \    /\", 0
cat2 BYTE "  )  ( ')", 0
cat3 BYTE " (  /  )", 0
cat4 BYTE "  \(__)|", 0
cat_xy COORD <2, 21>
cat_destination_xy COORD <2, 21>
; 定義初始平台的字符 (平台寬度為 8)
platform0 BYTE "========", 0
; 定義生成目標平台的字符和其中心座標
platformb BYTE "=", 0
platformb_xy COORD <75, 25>
; 定義隨機的平台寬度
randomnum WORD ?
; 定義垂直線 * 的字串和長度
verticalLine BYTE "*"
; 起始座標和生成限制
xyVertical COORD <10, 25>      ; 設定垂直線的生成座標
testCoord COORD <76, 10>
verticalCount DWORD 0          ; 當前生成數量
verticalMax DWORD 100           ; 最大生成數量
blankLine BYTE "        ", 0   ; 每行的空白字元，寬度要與 ASCII 藝術圖一致

;outputHandle DWORD ?
;cellsWritten DWORD ?

.code
SetConsoleOutputCP PROTO STDCALL :DWORD

PrintStartMenu PROC
    ; 打印標題
    lea ecx, start1
    call PrintStart
    lea ecx, start2
    call PrintStart
    lea ecx, start3
    call PrintStart
    lea ecx, start4
    call PrintStart
    lea ecx, start5
    call PrintStart
    lea ecx, start6
    call PrintStart

    ; 打印底部文字
    lea ecx, exit1
    call PrintExit
    lea ecx, exit2
    call PrintExit
    lea ecx, exit3
    call PrintExit
    lea ecx, exit4
    call PrintExit
    lea ecx, exit5
    call PrintExit
    lea ecx, exit6
    call PrintExit

    lea ecx, selectBlock
    call PrintselectBlock

    ret
PrintStartMenu ENDP

PrintStart PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF start1,     ; 每行字元數
        start_xy,            ; 當前座標
        ADDR cellsWritten
    inc (COORD PTR start_xy).Y
    ret
PrintStart ENDP

PrintExit PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF exit1,     ; 每行字元數
        exit_xy,            ; 當前座標
        ADDR cellsWritten
    inc (COORD PTR exit_xy).Y
    ret
PrintExit ENDP

PrintselectBlock PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF selectBlock,     ; 每行字元數
        selectBlock_xy,            ; 當前座標
        ADDR cellsWritten
    ret
PrintselectBlock ENDP

ClearPreviousCat PROC
    ; 保存原始 Y 值
    push (COORD PTR cat_xy).Y

    ; 清除貓的每一行
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    dec (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    dec (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    dec (COORD PTR cat_xy).Y	; next line

    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR blankLine,         ; Pointer to ASCII art
           LENGTHOF blankLine,       ; Length of ASCII art
           cat_xy,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    dec (COORD PTR cat_xy).Y	; next line
    pop (COORD PTR cat_xy).Y
    ret
ClearPreviousCat ENDP

DrawCat PROC
    ; 保存原始 Y 值
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

    ; 恢復原始 Y 值
    pop (COORD PTR cat_xy).Y
    ret
DrawCat ENDP

; 生成起始平台
DrawInit PROC
    add cat_xy.Y, 4
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR platform0,         ; Pointer to platform0
           LENGTHOF platform0,       ; Length of platform0
           cat_xy,       ; Starting position (bottom of cat)
           ADDR cellsWritten ; Number of characters written
    sub cat_xy.Y, 4
    ret
DrawInit ENDP

SetDestination PROC
    call Randomize ; 設亂數種子
    mov eax, 19
    call RandomRange
    inc eax ; range 1~20 store in eax
    mov randomnum, ax


    mov ax, (COORD PTR platformb_xy).X ; 設生成起始位置
    sub ax, randomnum
    mov (COORD PTR platformb_xy).X, ax
    mov cx, randomnum ; 設為平台總長 randomnum
    add cx, randomnum
        ret
SetDestination ENDP

RunGame PROC
    
    call Clrscr           ; 清屏
    INVOKE DrawCat
    INVOKE DrawInit
    INVOKE SetDestination 

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

KeyLoop:   ; 進入按鍵監聽循環
    call ReadChar          ; 等待並讀取按鍵輸入
    mov ah, 0              ; 清除高位掃描碼，只保留 ASCII 值

    ; 如果按下空白鍵，執行生成 * 的邏輯
    cmp al, 32             ; 檢查是否為空白鍵 (ASCII 值 32)
    je GenerateVerticalLine

    ; 按下c鍵，移動至目標地
    cmp al, 99
    je GoToNextPlatform

    ; 按其他鍵則繼續等待
    jmp KeyLoop

GenerateVerticalLine:
    ; 檢查是否達到最大生成數量
    mov eax, verticalCount
    cmp eax, verticalMax
    jae KeyLoop            ; 如果達到最大數量，返回監聽循環

    ; 打印 * 到當前位置
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ADDR verticalLine,  ; 字符串 * 的地址
           LENGTHOF verticalLine,             ; 字符串的長度
           xyVertical,      ; 打印位置
           ADDR cellsWritten   ; 實際寫入的字元數
       

    ; 更新座標和生成計數
    inc xyVertical.X        ; 向上移動一行
    inc verticalCount       ; 增加生成數量

    ; 設定目標座標
    mov ax, (COORD PTR cat_destination_xy).X
    inc ax
    mov (COORD PTR cat_destination_xy).X, ax

    ; 返回按鍵監聽
    jmp KeyLoop



; 移動至目標地
GoToNextPlatform:
    mov ax, (COORD PTR cat_destination_xy).X
    add ax, 6        ; magic!
    cmp (COORD PTR cat_xy).X, ax
    jne moving

    mov ax, (COORD PTR cat_destination_xy).X
    add ax, 8
    mov (COORD PTR testCoord).X, ax

    
    mov (COORD PTR testCoord).Y, 9
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR platform0,         ; Pointer to ASCII art
           1,       ; Length of ASCII art
           testCoord,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    mov (COORD PTR testCoord).Y, 10


    mov ax, (COORD PTR platformb_xy).X
    sub ax, randomnum
    cmp ax, (COORD PTR testCoord).X
    jg Fail
    mov ax, (COORD PTR platformb_xy).X
    add ax, randomnum
    sub ax, 6
    cmp ax, (COORD PTR testCoord).X
    jl Fail
    jmp Success
    ; jmp KeyLoop


moving:
    call ClearPreviousCat
    inc (COORD PTR cat_xy).X
    INVOKE DrawCat

    INVOKE Sleep, 25
    jmp GoToNextPlatform

       
Fail:
    jmp KeyLoop

Success:
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     ; Console output handle
           ADDR platform0,         ; Pointer to ASCII art
           1,       ; Length of ASCII art
           testCoord,       ; Starting position (top-left corner)
           ADDR cellsWritten ; Number of characters written
    ; 清屏
    call Clrscr
    mov (COORD PTR cat_xy).X, 2
    mov (COORD PTR cat_xy).Y, 21
    mov (COORD PTR cat_destination_xy).X, 2
    mov (COORD PTR cat_destination_xy).Y, 21
    INVOKE DrawCat
    INVOKE DrawInit
    INVOKE SetDestination

    mov (COORD PTR xyVertical).X, 10
    mov (COORD PTR xyVertical).Y, 25
    jmp Generate_plat


    ; jmp KeyLoop
RunGame ENDP

main PROC

    INVOKE SetConsoleOutputCP, 437
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE

    mov outputHandle, eax
    call Clrscr
    call PrintStartMenu


KeyLoop_StartMenu:
    call ReadChar
    cmp al, 0Dh
    je pressEnter
    cmp al, 48h
    je selectStart
    cmp al, 50h
    je selectExit
    jmp KeyLoop_StartMenu

selectStart:
    mov (COORD PTR selectBlock_xy).Y, 8
    call PrintselectBlock
    jmp KeyLoop_StartMenu

selectExit:
    mov (COORD PTR selectBlock_xy).Y, 18
    call PrintselectBlock
    jmp KeyLoop_StartMenu

pressEnter:
    movzx eax, (COORD PTR selectBlock_xy).Y
    cmp eax, 8
    je RunGame
    cmp eax, 18
    je ExitGame

ExitGame:
    exit

    exit
main ENDP

END main