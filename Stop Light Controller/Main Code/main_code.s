		INCLUDE tm4c123gh6pm_constants.s 
		AREA DATA, READWRITE
oneSecDELAY EQU 2666666 ;.5sec to account for code read
oneSec	   EQU 5333333  ;1 second delay
fiveSEC	   EQU 13333333 ;2.5sec to account for code read
speed      EQU 1 ;clock value to speed up passing of values
        AREA    |.text|, CODE, READONLY
        IMPORT  PORTB_Init
		IMPORT	PORTB_Output
		IMPORT  PORTE_Init
		IMPORT	PORTE_Output_green
		IMPORT  PORTE_Output_red
		IMPORT	PORTB_Int_Init
		THUMB
		EXPORT  delay
		EXPORT  sevenSEG
		EXPORT  loop
		EXPORT  GPIOPortB_Handler
        EXPORT  Start
			
	
Start

		BL  PORTB_Init                                    ; Initialize port B
		BL  PORTE_Init                                    ; Initialize port E
		BL  PORTB_Int_Init								  ; Initialize port B interrupt
	
seg7inHEX DCB  0x67, 0x7F, 0x07, 0x7D, 0x6D, 0x66, 0x4F, 0x5B, 0x06, 0x3F, 0x00  ;Hexadecimal value array 
loop
		LDR R2, =seg7inHEX                                ; Initialize register for passing 7 seg array
		MOV R3, #0										  ; Set for array pointer
		BL  TurnOnLED									  ; Branch to Green LED turn on
			


sevenSEG ; 7 segment loop subroutine 
		CMP R5, #0x01									  ; compare with interrupt check value
		BEQ redLIGHT									  ; If R5 equals 1 then branch to red LED ON routine
		LDR R1, =GPIO_PORTE_DATA_R						  ; LED port pointer register
		MOV R0, #0x02									  ; set value for particular color from port E
		STR R0, [R1]		
		CMP R3, #0x0B									  ; 7 seg array check
		BEQ redLIGHT
		ADD R3, #1
		LDR R0, [R2], #1								  ; counts through the array until all values have been gone through,
		BL PORTB_Output									  ;     then once all are read it will move from the Yellow LED to the red LED
		LDR R0, =oneSecDELAY	
		BL delay
		BL sevenSEG
		

TurnOnLED
		MOV R5, #0x00                                     ; Green light LED pass to the port E driver
		MOV R0, #0x01									  ; 
		BL PORTE_Output_green
				
		
redLIGHT
		MOV R5, #0x00 									  ; Red light LED pass to the port E driver
		MOV R0, #0x04
		BL PORTE_Output_red

		
;------------delay------------
delay
		CMP R5, #0x01									  ; General delay with check from interrupt check value
		BEQ intDELexit
		SUBS R0, R0, #1
		BNE delay                       
		BX  LR    

intDELexit
		LDR R0, =speed									  ; Interrupt delay loop to prevent interval between interrupt and return to program 
		SUBS R0, R0, #1
		BNE delay                       
		BX  LR  

;_____________Pedestrian Switch______________________
GPIOPortB_Handler
		LDR R1, =GPIO_PORTB_ICR_R
		MOV R0, #0x80
		STR R0, [R1]									  ; Interrupt value pointer
		MOV R5, #0x01
		LDR R0, =fiveSEC
counter		
		SUBS R0, R0, #1
		BNE counter										  ; Initializes the LED color and prepares the 7 segment loop

		LDR R1, =GPIO_PORTE_DATA_R
		MOV R0, #0x02
		STR R0, [R1]

		LDR R2, =seg7inHEX
		MOV R3, #0
forLoop	
		CMP R3, #0x0B
		BEQ endLoop
		ADD R3, #1
		LDR R0, [R2], #1
		LDR R1, =GPIO_PORTB_DATA_R 
		STR R0, [R1]
		LDR R0, =oneSec
count		
		SUBS R0, R0, #1                                    ; Passes back to teh main program
		BNE count
		B forLoop 
		
endLoop 
		MOV R5, #0x01
		;LDR R0, =speed
		BX LR
		
;____________________________________________________
    ALIGN                           
    END                             
