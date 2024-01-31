; Цей код - незавершений. Можливо, колись я його допишу. :) - Anderson

BODY_X = $20   ; Масив X-координат тіла змійки
BODY_Y = $40   ; Масив Y-координат тіла змійки
BODY_LEN = $60  ; Довжина тіла змійки
DIR = $61   ; Напрямок руху (0 - вправо, 1 - вниз, 2 - вліво, 3 - вгору)
FOOD_X = $62   ; X-координата їжі
FOOD_Y = $63   ; Y-координата їжі

; Бітові маски кнопок
UP = %00100000
DOWN = %00010000
LEFT = %00001000
RIGHT = %00000100

snake:
        ; Ініціалізувати їжу
        LDA #15
        STA FOOD_X
        LDA #2
        STA FOOD_Y

        ; Ініціалізувати тіло змійки
        LDA #1
        STA BODY_Y
        STA BODY_Y + 1
        STA BODY_Y + 2
        LDA #1
        STA BODY_X
        INC
        STA BODY_X + 1
        INC
        STA BODY_X + 2

        ; Ініціалізувати довжину тіла змійки
        LDA #3
        STA BODY_LEN

        ; Ініціалізувати напрямок руху
        LDA #0
        STA DIR

    @loop:
        ; Намалювати змійку
        JSR draw_snake
        LDA BUTTONS
        ; Перемістити змійку
        JSR move_snake
        JMP @loop

        RTS


; Намалювати змійку
draw_snake:
        PHA
        PHX
        PHY

        ; Намалювати голову
        LDX BODY_X
        LDY BODY_Y
        JSR gotoxy
        LDA #'@'
        JSR putchar

        ; Намалювати тіло
        LDX BODY_LEN
        DEX
    @body:
        PHX
        LDY BODY_Y, X
        LDA BODY_X, X
        TAX
        JSR gotoxy
        LDA #'O'
        JSR putchar
        PLX
        DEX
        CMP #0
        BNE @body

        PLY
        PLX
        PLA

        RTS

; Перемістити змійку
; Встановлює прапорець Carry, якщо змійка з'їла їжу
move_snake:
        PHA
        PHX

        CLC
        ; Перемістити тіло (голова стає другим елементом)
        LDX BODY_LEN
        ; К-сть елементів в тілі змійки завжди більша на 1 за BODY_LEN, щоб легко можна було збільшити тіло
    @body:
        DEX
        LDA BODY_X, X
        INX
        STA BODY_X, X
        DEX
        CMP #0
        BNE @body

        ; Перемістити голову
        LDA DIR
        CMP #0
        BEQ @right
        CMP #1
        BEQ @down
        CMP #2
        BEQ @left
        CMP #3
        BEQ @up
    @right:
        LDA BODY_X
        INC
        CMP #40
        BNE :+          ; Якщо не вийшли за межі екрану
        LDA #0          ; Інакше перейти на початок рядка
    :
        STA BODY_X
    @down:
        LDA BODY_Y
        INC
        CMP #4
        BNE :+          ; Якщо не вийшли за межі екрану
        LDA #0          ; Інакше перейти на перший рядок
    :
        STA BODY_Y
    @left:
        LDA BODY_X
        DEC
        CMP #$FF
        BNE :+          ; Якщо не вийшли за межі екрану
        LDA #39         ; Інакше перейти на кінець рядка
    :
        STA BODY_X
    @up:
        LDA BODY_Y
        DEC
        CMP #$FF
        BNE :+          ; Якщо не вийшли за межі екрану
        LDA #3          ; Інакше перейти на останній рядок
    :
        STA BODY_Y

        LDA BODY_X
        CMP FOOD_X
        BNE :+          ; Якщо не з'їли їжу
        LDA BODY_Y
        CMP FOOD_Y
        BNE :+          ; Якщо не з'їли їжу
        INC BODY_LEN    ; Збільшити тіло
        SEC
    :

        PLX
        PLA

        RTS
