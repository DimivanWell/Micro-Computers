		INCLUDE tm4c123gh6pm_constants.s
        AREA    |.text|, CODE, READONLY

tenSec	   EQU 34666666	;6.5sec to account for code read
thirtySec  EQU 98666666 ;18.5seconds to account for code read			
        THUMB
        EXPORT  PORTE_Init
	EXPORT	PORTE_Output_green
	EXPORT	PORTE_Output_red
	IMPORT  delay
	IMPORT  sevenSEG
	IMPORT  loop
	IMPORT	PORTB_Int_Init

;------------PORTE_Init------------
PORTE_Init
    LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                 
    ORR R0, R0, #0x10               
    STR R0, [R1]                  
    NOP
    NOP                             
    LDR R1, =GPIO_PORTE_LOCK_R     
    LDR R0, =0x4C4F434B            
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_CR_R        
    MOV R0, #0xFF                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AMSEL_R    
    MOV R0, #0                      
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_PCTL_R      
    MOV R0, #0x00000000             
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_DIR_R      
    MOV R0, #0x07                    
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AFSEL_R     
    MOV R0, #0                       
    STR R0, [R1]                                      
	LDR R1, =GPIO_PORTE_DEN_R       
    MOV R0, #0xFF                   
    STR R0, [R1]                   
    BX  LR      



;------------PORTE_Output------------
PORTE_Output_green
	LDR R1, =GPIO_PORTE_DATA_R 
    STR R0, [R1]               
	LDR R0, =thirtySec	
	BL delay
	MOV R0, #0x00
	STR R0, [R1]
	BL sevenSEG
	BX LR
	
	
PORTE_Output_red
	LDR R1, =GPIO_PORTE_DATA_R 
    STR R0, [R1] 
	MOV R0, #0x04
	STR R0, [R1]
	LDR R0, =tenSec               
	BL delay
	MOV R0, #0x00
	STR R0, [R1]
    BL loop                    


    ALIGN                           
    END                             
