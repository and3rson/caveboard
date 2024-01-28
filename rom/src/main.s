        .org $C000

BTN_VAL = $10   ; Адреса, де ми зберігатимемо значення останнього стану кнопок

BUTTONS = $4000
LCD_CMD = $8000
LCD_DAT = $8001

main:
        LDX #0
    @wait:
        LDY #0
    @wait1:
        INY
        BNE @wait1
        INX
        BNE @wait

        LDA #$AA        ; 10101010 в двійковій системі

        ; Ініціалізація диплею
        LDA #$38        ; 8-бітний режим, 2 рядки, шрифт 5x7
        STA LCD_CMD
        JSR lcd_busy

        ; LDA #$0F        ; Увімкнути дисплей, увімкнути курсор, увімкнути блимання курсора
        LDA #$0C        ; Увімкнути дисплей, вимкнути курсор, вимкнути блимання курсора
        STA LCD_CMD
        JSR lcd_busy

        LDA #$06        ; Переміщувати курсор при виведенні символів
        STA LCD_CMD
        JSR lcd_busy

        LDA #$01        ; Очистити дисплей
        STA LCD_CMD
        JSR lcd_busy

        LDA #$80        ; Перемістити курсор на початок екрану
        STA LCD_CMD
        JSR lcd_busy

        ; Вивести текст на екран
        LDX #0
    @next:
        LDA msg, X
        BEQ @done
        INX
        STA LCD_DAT
        JMP @next
    @done:

    @loop:
        LDA #($80 | 20) ; Перемістити курсор на початок третього рядка
        STA LCD_CMD
        JSR lcd_busy

        LDA BUTTONS     ; Прочитати стан кнопок
        CMP BTN_VAL     ; Порівняти зі станом, який був останній раз
        BEQ @loop       ; Якщо стан не змінився, то повторити цикл
        STA BTN_VAL
        LDX #8
    @next_bit:
        TAY
        AND #1
        CLC
        ADC #'0'
        STA LCD_DAT     ; Вивести 0, якщо натиснена, 1 - якщо ні
        TYA
        ROR
        DEX
        BNE @next_bit
        JMP @loop

        STP

msg:    .byte "Hello, UkrTube!", 0

; Зупиняє програму, доки дисплей не буде доступний
lcd_busy:
        PHA

    @wait:
        LDA LCD_CMD
        AND #$80
        BNE @wait

        PLA

        RTS

        .res $FFFA - *

        .word 0
        .word main
        .word 0
