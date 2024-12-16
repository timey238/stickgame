INCLUDE Irvine32.inc

main EQU start@0

.data
losed BYTE 0
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

;定義結束畫面的文字
retry1 BYTE "__________        __                 ", 0
retry2 BYTE "\______   \ _____/  |________ ___.__.", 0
retry3 BYTE " |       _// __ \   __\_  __ <   |  |", 0
retry4 BYTE " |    |   \  ___/|  |  |  | \/\___  |", 0
retry5 BYTE " |____|_  /\___  >__|  |__|   / ____|", 0
retry6 BYTE "        \/     \/             \/     ", 0
retry_xy COORD <40, 5>

toMenu1 BYTE "   _____                       ", 0
toMenu2 BYTE "  /     \   ____   ____  __ __ ", 0
toMenu3 BYTE " /  \ /  \_/ __ \ /    \|  |  \", 0
toMenu4 BYTE "/    Y    \  ___/|   |  \  |  /", 0
toMenu5 BYTE "\____|__  /\___  >___|  /____/ ", 0
toMenu6 BYTE "        \/     \/     \/       ", 0
toMenu_xy COORD <45, 15>

selectBlock BYTE "--"
selectBlock_xy COORD <80, 8>
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
; 定義生成目標平台的中心座標
platformb_xy COORD <85, 19>
; 定義隨機的平台寬度
randomnum WORD ?
; 定義水平線的字串
HorizontalLine BYTE "*"
; 起始座標和生成限制
xyHorizontal COORD <16, 19>      ; 設定水平線的生成座標
HorizontalCount DWORD 0          ; 當前生成數量
HorizontalMax DWORD 110        ; 最大生成數量
blankLine BYTE "        "   ; 每行的空白字元
last_random WORD 7
outputHandle DWORD ?
cellsWritten DWORD ?
score DWORD 0
score_char BYTE "Score: 00000"
score_xy COORD <90, 1>

.code
SetConsoleOutputCP PROTO STDCALL :DWORD
PrintStartMenu PROC
    call Clrscr
    mov start_xy.Y, 5
    mov exit_xy.Y, 15
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

DrawScore PROC
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR score_char,         
           LENGTHOF score_char,       
           score_xy,       
           ADDR cellsWritten 
    ret
DrawScore ENDP

PrintEndMenu PROC
    call Clrscr
    mov retry_xy.Y, 5
    mov toMenu_xy.Y, 15
    ; 打印標題
    lea ecx, retry1
    call PrintRetry
    lea ecx, retry2
    call PrintRetry
    lea ecx, retry3
    call PrintRetry
    lea ecx, retry4
    call PrintRetry
    lea ecx, retry5
    call PrintRetry
    lea ecx, retry6
    call PrintRetry

    ; 打印底部文字
    lea ecx, toMenu1
    call PrintToMenu
    lea ecx, toMenu2
    call PrintToMenu
    lea ecx, toMenu3
    call PrintToMenu
    lea ecx, toMenu4
    call PrintToMenu
    lea ecx, toMenu5
    call PrintToMenu
    lea ecx, toMenu6
    call PrintToMenu

    mov (COORD PTR score_xy).X, 55
    mov (COORD PTR score_xy).Y, 26
    INVOKE DrawScore

    lea ecx, selectBlock
    call PrintselectBlock

    ret
PrintEndMenu ENDP

PrintStart PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF start1,     
        start_xy,           
        ADDR cellsWritten
    inc (COORD PTR start_xy).Y
    ret
PrintStart ENDP

PrintExit PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF exit1,     
        exit_xy,            
        ADDR cellsWritten
    inc (COORD PTR exit_xy).Y
    ret
PrintExit ENDP

PrintRetry PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF retry1,     
        retry_xy,           
        ADDR cellsWritten
    inc (COORD PTR retry_xy).Y
    ret
PrintRetry ENDP

PrintToMenu PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ecx,
        LENGTHOF toMenu1,   
        toMenu_xy,            
        ADDR cellsWritten
    inc (COORD PTR toMenu_xy).Y
    ret
PrintToMenu ENDP

PrintselectBlock PROC
    INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR selectBlock,
        LENGTHOF selectBlock,    
        selectBlock_xy,            
        ADDR cellsWritten
    ret
PrintselectBlock ENDP

ClearselectBlock PROC
    ; 用空格覆蓋之前的選擇區域
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ADDR blankLine,             ; 空格字串的地址
           2,               ; 長度為 2（覆蓋 "--"）
           selectBlock_xy,  ; 選擇區域的座標
           ADDR cellsWritten
    ret
ClearselectBlock ENDP

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
           outputHandle,    
           ADDR cat2,       
           LENGTHOF cat2,     
           cat_xy,       
           ADDR cellsWritten 
    inc (COORD PTR cat_xy).Y	
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,    
           ADDR cat3,      
           LENGTHOF cat3,      
           cat_xy,       
           ADDR cellsWritten
    inc (COORD PTR cat_xy).Y	
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR cat4,        
           LENGTHOF cat4,     
           cat_xy,       
           ADDR cellsWritten 
    inc (COORD PTR cat_xy).Y	
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
           outputHandle,     
           ADDR blankLine,         
           LENGTHOF blankLine,       
           cat_xy,       
           ADDR cellsWritten 
    inc (COORD PTR cat_xy).Y	
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR blankLine,        
           LENGTHOF blankLine,       
           cat_xy,       
           ADDR cellsWritten 
    inc (COORD PTR cat_xy).Y	
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR blankLine,         
           LENGTHOF blankLine,      
           cat_xy,      
           ADDR cellsWritten 
    ; 恢復原始 Y 值
    pop (COORD PTR cat_xy).Y
    ret
ClearCat ENDP

; 以platform_xy為中心，生成2*platform_hlen長的platform
GeneratePlatform PROC USES eax ecx esi, platform_xy:PTR COORD, platform_hlen:WORD
    mov esi, platform_xy
    mov ax, (COORD PTR [esi]).X ; 設生成起始位置
    sub ax, platform_hlen
    mov (COORD PTR [esi]).X, ax
    mov cx, platform_hlen
    add cx, platform_hlen ; 設初始平台總長
Generate_plat: ; 生成平台
    push ecx
    INVOKE WriteConsoleOutputCharacter, 
           outputHandle,     
           ADDR platformb,        
           LENGTHOF platformb,      
           (COORD PTR [esi]),      
           ADDR cellsWritten 
    inc (COORD PTR [esi]).X ; 每生成一格 X+1
    pop ecx
    loop Generate_plat
    mov ax, (COORD PTR [esi]).X ; 回復platformb_xy.X成原來的值
    sub ax, platform_hlen
    mov (COORD PTR [esi]).X, ax
    ret
GeneratePlatform ENDP

IncScore PROC
    inc score
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

; 顯示橋梁
ShowBridge PROC
    mov ecx, HorizontalCount
    cmp HorizontalCount, 0
    jz L2
L1:
    push ecx
    INVOKE WriteConsoleOutputCharacter,
           outputHandle,    ; 控制台句柄
           ADDR HorizontalLine,  ; 字符串 * 的地址
           LENGTHOF HorizontalLine,             ; 字符串的長度
           xyHorizontal,      ; 打印位置
           ADDR cellsWritten   ; 實際寫入的字元數
    inc (COORD PTR xyHorizontal).X
    INVOKE Sleep, 10
    pop ecx
    Loop L1
    mov HorizontalCount, 0
L2:
    ret
ShowBridge ENDP

RunGame PROC

    call Clrscr
    mov HorizontalCount, 0
    mov (COORD PTR platform0_xy).X, 9
    mov (COORD PTR platform0_xy).Y, 19
    mov (COORD PTR platformb_xy).X, 85
    mov (COORD PTR platformb_xy).Y, 19
    mov (COORD PTR cat_xy).X, 9
    mov (COORD PTR cat_xy).Y, 15
    mov (COORD PTR cat_destination_xy).X, 16
    mov (COORD PTR cat_destination_xy).Y, 15
    mov (COORD PTR xyHorizontal).X, 16
    mov (COORD PTR xyHorizontal).Y, 19
    mov score, 0
    mov score_char[7], 48
    mov score_char[8], 48
    mov score_char[9], 48
    mov score_char[10], 48
    mov score_char[11], 48
    mov last_random, 7
    mov randomnum, 0
    mov (COORD PTR score_xy).X, 90
    mov (COORD PTR score_xy).Y, 1

Start:
    INVOKE DrawScore
    call DrawCat

    invoke GeneratePlatform, ADDR platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 3
    invoke GeneratePlatform, ADDR platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 2
    invoke GeneratePlatform, ADDR platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    sub last_random, 1
    mov ecx, 8
Gen_init_plat:
    invoke GeneratePlatform, ADDR platform0_xy, last_random
    inc (COORD PTR platform0_xy).Y
    loop Gen_init_plat
    
    call Randomize ; 設亂數種子

    mov ecx, 9  ; 生成平台的寬度的機率分布是 binomial distribution
    mov edx, 0
Trial:
    mov eax, 2
    call RandomRange
    add edx, eax
    loop Trial
    mov eax, edx
    
    add eax, 7
    cmp score, 20
    jg Skip
    inc eax
    cmp score, 15
    jg Skip
    inc eax
    cmp score, 10
    jg Skip
    inc eax
    cmp score, 5
    jg Skip
    inc eax
    cmp score, 2
    jg Skip
    inc eax

Skip:
    mov randomnum, ax

    ; 隨機選取生成平台中心點
    mov ax, 50
    call RandomRange
    add ax, (COORD PTR cat_xy).X
    add ax, 37
    mov (COORD PTR platformb_xy).X, ax
    
    invoke GeneratePlatform, ADDR platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 3
    invoke GeneratePlatform, ADDR platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 2
    invoke GeneratePlatform, ADDR platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    sub randomnum, 1
    mov ecx, 8
Gen_plat:
    invoke GeneratePlatform, ADDR platformb_xy, randomnum
    inc (COORD PTR platformb_xy).Y
    loop Gen_plat
    add randomnum, 6 ; 回復randomnum
  
KeyLoop:                   ; 進入按鍵監聽循環
    call ReadChar          ; 等待並讀取按鍵輸入
    mov ah, 0              ; 清除高位掃描碼，只保留 ASCII 值
    ; 如果按下空白鍵，執行生成 * 的邏輯
    cmp al, 32             ; 檢查是否為空白鍵 (ASCII 值 32)
    je GenerateHorizontalLine
    ; 按下c鍵，移動至目標地
    cmp al, 99

    je ShowTheBridge

    cmp al, 112
    je Cheat

    ; 按其他鍵則繼續等待
    jmp KeyLoop

Cheat: ;for test 按p鍵增加分數
    INVOKE IncScore
    INVOKE DrawScore
    jmp KeyLoop

GenerateHorizontalLine:
    ; 檢查是否達到最大生成數量
    mov eax, HorizontalCount
    cmp eax, HorizontalMax
    jae KeyLoop            ; 如果達到最大數量，返回監聽循環
    
    
    inc HorizontalCount       ; 增加生成數量
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

Success:
    call Clrscr
    mov HorizontalCount, 0
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
    mov (COORD PTR xyHorizontal).X, bx
    mov (COORD PTR xyHorizontal).Y, 19
    mov bx, randomnum
    mov last_random, bx
    INVOKE IncScore
    jmp Start

Fail:
    mov losed, 1
    call PrintEndMenu

    ret
RunGame ENDP

main PROC

    INVOKE SetConsoleOutputCP, 437
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE

    mov outputHandle, eax
    call Clrscr
    call PrintStartMenu


KeyLoop_StartMenu:
    call ReadChar
    .IF ax == 4800h ; UP ARROW
        call ClearselectBlock      ; 清除之前的選擇區域
        mov (COORD PTR selectBlock_xy).Y, 8 ; 更新 Y 座標
        call PrintselectBlock      ; 繪製新的選擇區域
        jmp KeyLoop_StartMenu
    .ENDIF
    .IF ax == 5000h ; DOWN ARROW
        call ClearselectBlock      ; 清除之前的選擇區域
        mov (COORD PTR selectBlock_xy).Y, 18 ; 更新 Y 座標
        call PrintselectBlock      ; 繪製新的選擇區域
        jmp KeyLoop_StartMenu
    .ENDIF
    cmp al, 0Dh
    je pressEnter
    jmp KeyLoop_StartMenu


pressEnter:
    movzx eax, (COORD PTR selectBlock_xy).Y
    .if eax == 8
        mov losed, 0
        call RunGame
        jmp KeyLoop_StartMenu
    .endif
    cmp losed, 1
    je toMenu
    .if eax == 18
        exit
    .endif

toMenu:
    call Clrscr
    mov losed, 0
    mov (COORD PTR selectBlock_xy).Y, 8
    call PrintStartMenu
    call ClearselectBlock
    call PrintselectBlock
    jmp KeyLoop_StartMenu

    exit
main ENDP

END main