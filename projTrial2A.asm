DB0:		equ	1
DB1:		equ	2
*
                org     $FFA0	; Buffalo I/O routines
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
**************************************************************************

main    equ     $D000   	;Init main
reg     equ     $1000   	;Init register base
portd   equ     $08     	;Init port d
portb   equ     $04     	;Init port b
porta   equ     $00     	;Init port a
ddrd    equ     $09     	;Init DDRD
portc   equ     $03     	;dip switch port
Ones    rmb     1               ;ones placement   ***remember to edit dig0***
Tens    rmb     1               ;tens placement    ***dig 1 ***
sum     rmb     1
dif     rmb     1
temp2   rmb     1 ;addition
temp0   rmb     1
DigAOnes rmb    1
DigATens rmb    1
DigBOnes rmb    1
DigBTens rmb    1
temp4    rmb    1  ;subtraction
temp5    rmb    1

tempAO    rmb    1
tempAT    rmb    1
tempSO    rmb    1
tempST    rmb    1
sum1    rmb     1


CCR     rmb     1

hex   	fcb     $3f,$06,$5b,$4f,$66,$6d,$7d,$07        ;0-7
        fcb     $7f,$67,$77,$39,$7c,$5e,$79,$71        ;8-F
        
LCDASC  fcb     $30,$31,$32,$33,$34,$35,$36,$37        ;0-7
        fcb     $38,$39


        ORG     main
*********************
      ;LDAA      #$30
      ;STAA      tempAO
***************************
        ldaa    #$01
        staa    sum1
        staa    dif
        jmp     start ;lcd code

MAIN1   LDX     #reg         	;load register x with content in variable reg
    	BSET    ddrd,X $3F      ;configure the data direction register of port D to use the lower 4-bits as output data
	BSET    portd,X $3C

loop    LDAA    porta,x		;load acc A with the value of port A
    	ANDA   	#$01    	;check if the bit '0' of portA was pushed
    	BNE   	loop   		;if the button was pressed continue, if not loop back to 'loop'

    	LDY    	#$ffff
    
done1   DEY
    	BNE    	done1

one    	LDAA    porta,x
    	CMPA   	#$01
    	BEQ   	one

Begin   ;jmp    start
	LDAA   portc,x      	;load acc A with dip switch value
    	ANDA   #$0f         	;acquire only the least 4 bits of port C
    	STAA   Ones    	;store the least 4 bits at location for ones placement
    	LDAA   portc,x 	;load acc A with dip switch value
    	LDAB   #$04    	;load Acc b with hex $04 to use as loop counter

Rotate  RORA    		;rotate Acc A right
    	DECB
    	BGT   Rotate   	;if B is still greater than 0, rotate Acc A again

    	ANDA   #$0f     	;acquire only the least 4 bits of Acc A
    	STAA   Tens    	;store what is in Acc A in variable dig1

AddDisp LDAA   Ones    	;load Acc A with value in ones placement
    	LDAB   Tens    	;load Acc B with value in tens placement
    	ABA   		;add Acc A + Acc B , store value in Acc A
    	STAA   sum     	;store the sum value in variable 'sum'

    	LDAA    sum
    	LDAB  #$00
    	CMPA   #$09
    	BGT   comADD
    	BRA   store
    
comADD  INCB
    	SUBA   #$0A
    	CMPA   #$09
	BGT   comADD

store   STAA   temp0
    	STAB    temp2

    	JSR    Disp

SubDisp LDAA   Tens    	;load Acc A with value in tens placement
    	LDAB   Ones    	;load Acc B with value in ones placement
    	
	JSR     COMPARE ;added
    	
    	SBA         		;subtract Acc A - Acc B , store value in Acc A
    	STAA    dif     	;store the sum value in variable 'sum'
	;jmp start
    	LDAA   dif
    	LDAB   #$00
    	CMPA    #$09
    	BGT    comSUB
    	BRA     store1
comSUB  INCB
    	SUBA    #$0A
    	CMPA   #$09
    	BGT   comSUB

store1  STAA   temp4;changed used to be temp0
    	STAB   temp5;changed used to be temp2

*************************
	JSR     FunctionSplitA
	JSR     FunctionSPlitB
	;JSR     setADDL
	;JSR     setSUBL
	;JMP     start2
*************************
    	JSR     Disp

    	BRA	Begin

Disp    LDY    #hex
    	LDAB    DigAOnes;temp0  ;disp ones place
    	ABY
    	LDAB    0,y
    	LDX    #reg    	;load register x with content in variable reg
    	BCLR   	portd,x 4
    	BSET   	portd,x 8
    	BSET   	portd,x $10
    	BSET   	portd,x $20
    	STAB	portb,x 	;store what in ACC b, to port b (create output)
     	LDY   	#$ff
delay
    	DEY
    	BNE    delay

	LDY   #hex
    	LDAB   DigATens;temp2  ;disp 10''s place
    	ABY
    	LDAB    0,y
    	LDX    #reg    	;load register x with content in variable reg.
    	BSET   portd,x 4
    	BCLR   portd,x 8
    	BSET   portd,x $10
    	BSET   portd,x $20
    	STAB   portb,x 	;store what in ACC b, to port b (create output)
    	LDY    #$ff
    	
************************
	JSR    Disp2
************************

delay2  DEY
    	BNE    delay2

    	LDAA    porta,x 	;load acc A with the value of port A
    	ANDA    #$01    	;check if the bit '0' of portA was pushed
    	BNE     Disp    	;if the button was pressed continue, if not loop back to 'Disp'

    	LDY    #$ffff
done    DEY
    	BNE    done

     	RTS

    	;bra    Disp
    	
COMPARE
	CMPA    Ones
	BGE     SKIP
	TPA
	STAA    CCR

 	;BGE     SKIP

 	ANDA    #$08
	CMPA    #$00
	BNE     SWAP

	BEQ     SKIP
	
SKIP	RTS
SWAP
	LDAA    CCR
	TAP
	LDAA    Ones
	LDAB    Tens
	BRA     SKIP
*******************************************************************************
;adding functinality to disp individual digits from each number we are adding
FunctionSplitA
	LDAA   Ones
    	LDAB   #$00
    	CMPA    #$09
    	BGT    comSUBA
    	BRA     storeA
comSUBA  INCB
    	SUBA    #$0A
    	CMPA   #$09
    	BGT   comSUBA

storeA  STAA   DigAOnes
    	STAB   DigATens
	RTS
	
FunctionSplitB
	LDAA   Tens
    	LDAB   #$00
    	CMPA    #$09
    	BGT    comSUBB
    	BRA     storeB
comSUBB INCB
    	SUBA    #$0A
    	CMPA   #$09
    	BGT   comSUBB

storeB  STAA   DigBOnes
    	STAB   DigBTens
	RTS
	
Disp2

delay1
    	DEY
    	BNE    delay1
    	
	LDY    #hex
    	LDAB    DigBOnes;temp0  ;disp ones place
    	ABY
    	LDAB    0,y
    	LDX    #reg    	;load register x with content in variable reg
    	BSET   portd,x 4
    	BSET   portd,x 8
    	BCLR   portd,x $10
    	BSET   portd,x $20
    	STAB    portb,x 	;store what in ACC b, to port b (create output)
     	LDY   	#$ff
delay0
    	DEY
    	BNE    delay0

	LDY   #hex
    	LDAB   DigBTens;temp2  ;disp 10''s place
    	ABY
    	LDAB    0,y
    	LDX    #reg    	;load register x with content in variable reg.
    	BSET   portd,x 4
    	BSET   portd,x 8
    	BSET   portd,x $10
    	BCLR   portd,x $20
    	STAB   portb,x 	;store what in ACC b, to port b (create output)
    	LDY    #$ff
	RTS
**********************************************************************
setADDL
	LDY    #LCDASC
    	LDAB    temp0
    	ABY
    	LDAB    0,y;#temp0,y
    	STAB    tempAO

	LDY    #LCDASC
    	LDAB    temp2
    	ABY
    	LDAB    0,y
    	STAB    tempAT
	RTS
*********************************************************************
setSUBL
 	LDY    #LCDASC
    	LDAB    temp4
    	ABY
    	LDAB    0,y
    	STAB    tempSO

	LDY    #LCDASC
    	LDAB    temp5
    	ABY
    	LDAB    0,y
    	STAB    tempST
    	;jmp     start
    	RTS
*************************************************************************
*******************************************************************************
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
del1:	dex
	inx
	dex
	bne	del1
	rts
*
*
sel_data:
	psha
*	bset	LCD_RSimg REG_SEL	; select instruction
	ldaa	LCD_RSimg
	oraa	#REG_SEL
	bra	sel_i
sel_inst:
	psha
*	bclr	LCD_RSimg REG_SEL	; select instruction
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
       	ldaa   	#$C0     		; starting address for the line2
line3: 	jsr    	wrt_pulse
*
       	jsr    	sel_data
	jsr	msg_out
	rts

* at entry, x must point to the begining of the message,
*           b = number of the character to be sent out
*
msg_out:
	ldaa   	0,x
       	jsr    	wrt_pulse
       	inx
       	decb
       	bne    	msg_out
	rts

*
*       @ enter, a=data to output
*
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
*	bset	LCD_ENimg ENABLE	; ENABLE=high
	ldaa	LCD_ENimg
	oraa	#ENABLE
	staa	LCD_ENimg
	staa	LCD_EN
*	bclr	LCD_ENimg ENABLE	; ENABLE=low
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
   	jsr	delay_10ms	; delay 20ms during power up
    	jsr	delay_10ms

    	jsr	lcd_ini		; initialize the LCD

back:
	ldab    #sum1
	ldx    	#MSG1
	abx
	;tempAO	; MSG1 for line1, x points to MSG1

***************************************************************************
;LoadADD	ldab    sum1
;	inx
;	subb    #$01
;	cmpb    #$00
;	bne     LoadADD
	
***************************************************************************
	ldab    #02             ; send out 16 characters
    	jsr	lcd_line1
*
    	ldx    	#MSG2		; MSG2 for line2, x points to MSG2
        ldab    #01             ; send out 16 characters
     	jsr	lcd_line2
     	jsr	delay_10ms
     	jsr	delay_10ms
     	jmp     MAIN1

MSG1:   FCC	'00'
	FCC	'01'
	FCC	'02'
	FCC	'03'
	FCC	'04'
	FCC	'05'
	FCC	'06'
	FCC	'07'
	FCC	'08'
	FCC	'09'
	FCC	'10'
	FCC 	'11'
	FCC	'12'
	FCC	'13'
	FCC	'14'
	FCC	'15'
	FCC	'16'
	FCC	'17'
	FCC	'18'
	FCC	'19'
	FCC	'20'
	FCC 	'21'
	FCC	'22'
	FCC	'23'
	FCC	'24'
	FCC	'25'
	FCC	'26'
	FCC	'27'
	FCC	'28'
	FCC	'29'
	FCC	'30'
;tempAT,tempAO
;,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42
MSG2:   FCB     $31


