* Lcd1.asm ---- 16X2 LCD sample program for the Husky11 Rev. A board
*               (c)2003-2010, EVBplus.com, Written By Wayne Chu
*
*     Function:	This is the simplest way to displays a message on the
*		16X2 LCD display module. The cursor is off.
*		If more controls to the display are needed, see LCD2.asm
*
*

DB0:		equ	1
DB1:		equ	2

*
                org     $FFA0	; Buffalo I/O routines

upcase:         rmb     3
wchek:          rmb     3
dchek:          rmb     3
init_sci:       rmb     3
input:          rmb     3
output:         rmb     3
outlhlf:        rmb     3
outrhlf:        rmb     3
outa:           rmb     3
out1byt:        rmb     3
out1bsp:        rmb     3
out2bsp:        rmb     3
outcrlf:        rmb     3
outstrg:        rmb     3
outstrg0:	rmb	3
inchar:         rmb     3



*
STACK:		equ	$8FFF

ONE_MS		equ	167	; for 8 MHz    1000us/6us=167
FIVE_MS		equ	835
TEN_MS		equ	1670


PORTF   	equ	$2201
DDRF   		equ	$2203
d40us:		equ	15	; 15x6us= 90 us, 60us ok
REG_SEL:	equ	DB0	; 0=reg, 1=data
ENABLE:		equ     DB1
NOT_REG_SEL:	equ	$FE
NOT_ENABLE:	equ     $FD
  		org	0
temp1:		rmb	1
pfimg:		rmb	1
reset_seq:	rmb	1
disp_ram:	rmb	3
*
LCDimg:		equ	pfimg
LCD_RSimg:	equ	pfimg
LCD_ENimg:	equ	pfimg

LCD:		equ	PORTF
LCD_RS:		equ	PORTF
LCD_EN:		equ	PORTF
*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REGBAS  	EQU     $1000
PORTB   	EQU     $1004
PORTD   	EQU     $08
DDRD    	EQU     $09
PORTC   	EQU     $1003
COUNTER 	EQU     $D000
COUNTER2        EQU     $D000
RESET           EQU     $FFFE
NUM             RMB     1
ADDBIT1         RMB     1
ADDBIT2         RMB     1
DIFBIT1         RMB     1
DIFBIT2         RMB     1

SEG     FCB     $3f, $06, $5b, $4f, $66, $6d, $7d, $07
	FCB	$7f, $67, $3f, $06, $5b, $4f, $66, $6d
	FCB	$7d, $07, $7f, $67, $3f, $06, $5b, $4f
	FCB     $66, $6d, $7d, $07, $7f, $67, $3f, $06
	FCB     $5b, $4f, $66, $6d, $7d, $07, $7f, $67

dig0    rmb     1
dig1    rmb     1

dig0Ones    rmb     1
dig1Ones    rmb     1
dig0Tens    rmb     1
dig1Tens    rmb     1

DIP     RMB     1

	ORG     $D000
DATA    RMB     10
	ORG     $D0A0
	
	LDAB    COUNTER
	LDX     #DATA
	CLRA
	LDAB    #11
Init    STAA    0,X
	INX
	INCA
	DECB
	CMPB    #$00
	BNE     Init
	jmp     start

lcd_ini:
	ldaa	#$FF
	staa	DDRF
	clra
	staa	pfimg
	staa	PORTF
       	ldx	#inidsp1   		; point to init. codes.
	ldaa	#1
	staa	reset_seq		; need more delay for first reset seq.
       	jsr    	outins1    		; output codes.
       	ldx	#inidsp2   		; point to init. codes.
	clr	reset_seq
       	jsr    	outins2    		; output codes.
	rts
	
inidsp1:
	fcb	2		; number of instrutions
	fcb	$33		; reset char
	fcb	$32		; reste char
inidsp2:
	fcb	4		; number of instrutions
	fcb	$28   		; 4bit, 2 line, 5X7 dot
	fcb	$06		; cursor increment, disable display shift
	fcb	$0c		; display on, cursor off, no blinking
	fcb	$01		; clear display memory, set cursor to home pos
outins1:
	pshb            		; output instruction command.
       	jsr    	sel_inst
       	ldab   	0,x
       	inx
onext1:	ldaa   	0,x
       	jsr    	wrt_pulse    		; initiate write pulse.
       	inx
	jsr	d5ms
       	decb
       	bne    	onext1
       	pulb
       	rts
*
outins2:
	pshb            		; output instruction command.
       	jsr    	sel_inst
       	ldab   	0,x
       	inx
onext2:	ldaa   	0,x
       	jsr    	wrt_pulse    		; initiate write pulse.
       	inx
       	decb
       	bne    	onext2
	jsr	d5ms
       	pulb
       	rts
*
delay_10ms:
	nop
d10ms:  pshx
	ldx     #TEN_MS
  	bsr	del1
  	pulx
	rts
d5ms:   pshx
	ldx     #FIVE_MS
  	bsr	del1
	pulx
	rts
del1:   ;ldx    #00            ; adddddddddddddddddddddddddddddddd 2
        dex
	inx
	dex
	bne	del1
	rts
*
*
sel_data:
	psha
;	bset	LCD_RSimg REG_SEL	; select instruction   ;aadddddddd
	ldaa	LCD_RSimg
	oraa	#REG_SEL
	bra	sel_i
sel_inst:
	psha
;	bclr	LCD_RSimg REG_SEL	; select instruction      adddddddddd
	
	ldaa	LCD_RSimg
	anda	#NOT_REG_SEL
sel_i:	staa	LCD_RSimg
	staa	LCD_RS
	pula
        rts
*

lcd_line1:
	jsr    	sel_inst		; select instruction
       	ldaa   	#$80     		; starting address for the line1
	bra	line3
lcd_line2:
	jsr    	sel_inst
       	ldaa   	#$C0    		; starting address for the line2
       	bra     LINE4
line3: 	jsr    	wrt_pulse
*
       	jsr    	sel_data
	jsr	msg_out
	rts
line4: 	jsr    	wrt_pulse
*
       	jsr    	sel_data
	jsr	msg_out1
	rts

msg_out1:
	PSHB
	PSHX
	LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAA    13,X
	CMPA    #10
	BLO     ZERO0
	CMPA    #20
	BLO     ONE1
	CMPA    #30
	BLO     TWO2
	JMP     THREE3

ZERO0   LDAA    #0
	JMP     BEGIN12
ONE1    LDAA    #1
	JMP     BEGIN12
TWO2    LDAA    #2
	JMP     BEGIN12
THREE3  LDAA    #3

BEGIN12 TAB
	PULX
	PSHX
	ABX
	LDAA    0,X
	PULX
	PULB
	jsr     wrt_pulse
	decb
	PSHB
	PSHX
	LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAA    13,X
	TAB
	PULX
	PSHX
	ABX
	LDAA    0,X
	PULX
	PULB
	JSR     wrt_pulse
	decb
	JMP     LOWER
	
msg_out:
	PSHB
	PSHX
	LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAA    12,X
	CMPA    #10
	BLO     ZERO00
	CMPA    #20
	BLO     ONE11
	CMPA    #30
	BLO     TWO22
	JMP     THREE33

ZERO00   LDAA    #0
	 JMP     BEGIN123
ONE11    LDAA    #1
	 JMP     BEGIN123
TWO22    LDAA    #2
	 JMP     BEGIN123
THREE33  LDAA    #3

BEGIN123 TAB
	PULX
	PSHX
	ABX
	LDAA    0,X
	PULX
	PULB
	jsr     wrt_pulse
	decb
	PSHB
	PSHX
	LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAA    12,X
	TAB
	PULX
	PSHX
	ABX
	LDAA    0,X
	PULX
	PULB
	jsr     wrt_pulse
	decb
	ldab    COUNTER
	ANDB    #1
	CMPB    #1
	BEQ     HERE
	JMP     SUB1
HERE    JMP     READ
	RTS

wrt_pulse:
	pshx
       	psha        			; save it tomporarily.
       	anda   #$f0     		; mask out 4 low bits.
       	staa   temp1 			; save nibble value.
       	ldaa   LCDimg    		; get LCD port image.
       	anda   #$0f     		; need low 4 bits.
       	oraa   temp1    		; add in low 4 bits.
       	staa   LCDimg    		; save it
       	staa   LCD    			; output data
*
	bsr	enable_pulse
	ldaa	reset_seq
	beq	wrtpls
	jsr	d5ms			; delay for reset sequence
*
wrtpls:	pula
 	asla            		; move low bits over.
	asla
      	asla
       	asla
       	staa   	temp1			; store temporarily.
*
       	ldaa   	LCDimg 			; get LCD port image.
       	anda   	#$0f   			; need low 4 bits.
       	oraa   	temp1  			; add in loiw 4 bits.
       	staa   	LCDimg    		; save it
       	staa   	LCD    			; output data
*
	bsr	enable_pulse
	pulx
       	rts
*
enable_pulse:
;	bset	LCD_ENimg ENABLE	; ENABLE=high          ;addddddd
	ldaa	LCD_ENimg
	oraa	#ENABLE
	staa	LCD_ENimg
	staa	LCD_EN
;	bclr	LCD_ENimg ENABLE	; ENABLE=low           ;adddddddd
	ldaa	LCD_ENimg
	anda	#NOT_ENABLE
	staa	LCD_ENimg
	staa	LCD_EN
	pshx
	ldx     #d40us
  	jsr	del1
	pulx
	rts
*
start:
	lds	#STACK

 ;  	jsr	delay_10ms	; delay 20ms during power up     addddddd
;    	jsr	delay_10ms                                       ;adddddd

    	JMP	SET		; initialize the LCD

STORE   LDX     #DATA
	TBA
;	STAA    dig0                   ;;;;;;;;attempted nothing changed;;;;;;;
	LDAB    COUNTER
	ABX
	TAB
	STAB    13,X
	JMP     START1
STORE1  LDX     #DATA
	TBA
;	STAA    dig1                     ;;;;;;;;;;attempted nothing changed;;;;
	LDAB    COUNTER
	ABX
	TAB
	STAB    12,X
	JMP     SUB9

SET     LDX     #REGBAS
	BSET    DDRD,X $3F
	BSET    PORTD,X $3C

WAIT    LDAA    REGBAS
	ANDA    #$01
	CMPA    #$00
	BNE     WAIT
	LDY     #$FFFF
	
delay   DEY
	BNE     delay
	JMP     ADD
	
READ    LDAA    REGBAS
	ANDA    #$01
	CMPA    #$00
	BNE     ADD1
	LDY     #$FFFF

del     dey
	bne     del
	INC     COUNTER
	JMP     SUB4

SUB9    LDAB    PORTC
	ANDB    #$0F
	LDAA    PORTC
	LSRA
	LSRA
	LSRA
	LSRA
	CBA
	BLS     SWAP
 	idiv
	TAB
	JMP     STORE

SWAP    STAB    NUM
	TAB
	LDAA    NUM
	SBA
	TAB
	JMP     STORE
	
SUB4    LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAB    12,X
	JMP     SUB

SUB1    LDAA    REGBAS
	ANDA    #$01
	CMPA    #$00
	BNE     SUB4
	LDY     #$FFFF

dela    dey
	INC     COUNTER
	JMP     WAIT
	
ADD     LDAB    PORTC
	ANDB    #$0F
	LDAA    PORTC
	LSRA
	LSRA
	LSRA
	LSRA
************************************************
	STAB    dig0
	STAA    dig1
	JSR     Split1
	JSR     Split2
****************************************************
 	ABA
	TAB
	JMP     STORE1
	
ADD1    LDX     #DATA
	LDAB    COUNTER
	ABX
	LDAB    12,X
	
SUB     LDX     #DIP
	STAB    0,X
	LDY     #SEG
	ABY
	LDAA    0,Y
	LDX     #REGBAS
	BCLR    PORTD,X 4
	BSET    PORTD,X 8
	BSET    PORTD,X $10
	BSET    PORTD,X $20
	LDX     #PORTB
	STAA    0,X
	LDY     #$F

delay1  dey
	bne     delay1
	CMPB    #10
	BLO     START3
	CMPB    #20
	BLO     ONE
	CMPB    #30
	BLO     TWO
	JMP     THREE
	
ONE     LDAB    #1
	JMP     BEGIN
TWO     LDAB    #2
	JMP     BEGIN
THREE   LDAB    #3
	JMP     BEGIN
	
START3  LDAB    #dig0Ones
BEGIN   LDX     #DIP ;digoOnes
	LDY     #SEG
	ABY
	LDAA    0,Y
	LDX     #REGBAS
	BSET    PORTD,X 4
	BCLR    PORTD,X 8
	BSET    PORTD,X $10
	BSET    PORTD,X $20
	LDX     #PORTB
	STAA    0,X
	LDY     #$F
delay2  dey
	bne     delay2
*************************************************************************
START4  LDAB    #dig0Ones
BEGIN1  LDX     #DIP
	LDY     #SEG
	ABY
	LDAA    0,Y
	LDX     #REGBAS
	BSET    PORTD,X 4
	BSET    PORTD,X 8
	BCLR    PORTD,X $10
	BSET    PORTD,X $20
	LDX     #PORTB
	STAA    0,X
	LDY     #$F
delay3  dey
	bne     delay3
**************************************************************************
START5  LDAB    #dig0Tens
BEGIN2  LDX     #DIP
	LDY     #SEG
	ABY
	LDAA    0,Y
	LDX     #REGBAS
	BSET    PORTD,X 4
	BSET    PORTD,X 8
	BSET    PORTD,X $10
	BCLR    PORTD,X $20
	LDX     #PORTB
	STAA    0,X
	LDY     #$F
delay4  dey
	bne     delay4
***************************************************************************

***************************************************************************
	LDAB    COUNTER
	ANDB    #1
	CMPB    #1
	BEQ     HERE4
	JMP     SUB1
HERE4   JMP     READ

START1  jsr     lcd_ini

back:   ldx     #MSG1
	ldab    #2
	jsr     lcd_line2
	
LOWER   ldx     #MSG1
	ldab    #2
	jsr     lcd_line1
	jsr     delay_10ms
	jsr     delay_10ms
	jmp     back          ;addddddddddddddddddddd
	
MSG1    FCB     48,49,50,51,52,53,54,55,56,57,48,49,50,51,52,53,54,55,56,57
	FCB     48,49,50,51,52,53,54,55,56,57,48,49,50,51,52,53,54,55,56,57

	end
	

	
	
	
	

