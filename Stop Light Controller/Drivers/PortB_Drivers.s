		INCLUDE tm4c123gh6pm_constants.s
        AREA    |.text|, CODE, READONLY
        THUMB
        EXPORT  PORTB_Init
		EXPORT	PORTB_Output
		EXPORT	PORTB_Int_Init
		

;------------PORTB_Init------------
PORTB_Init
    LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                 
    ORR R0, R0, #0x02               
    STR R0, [R1]                  
    NOP
    NOP                             
    LDR R1, =GPIO_PORTB_LOCK_R      
    LDR R0, =0x4C4F434B             
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_CR_R        
    MOV R0, #0xFF                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AMSEL_R     
    MOV R0, #0                      
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      
    MOV R0, #0x00000000             
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R       
    MOV R0, #0x7F                    
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     
    MOV R0, #0                       
    STR R0, [R1]                                      
	LDR R1, =GPIO_PORTB_DEN_R       
    MOV R0, #0xFF                   
    STR R0, [R1]                   
    BX  LR      

;------------PORTB_Int_Init------------
PORTB_Int_Init
	LDR R1, =GPIO_PORTB_IS_R         
	LDR R0, [R1]
    BIC R0, #0x80                   
    STR R0, [R1]                    
	LDR R1, =GPIO_PORTB_IBE_R ;checked        
    LDR R0, [R1]
    BIC R0, #0x80                  
    STR R0, [R1]                    
	LDR R1, =GPIO_PORTB_IEV_R         
    LDR R0, [R1]
    BIC R0, #0x80                   
    STR R0, [R1]                    
	LDR R1, =GPIO_PORTB_ICR_R         
	MOV R0, #0x80                   
    STR R0, [R1]                    
	LDR R1, =GPIO_PORTB_IM_R         
    LDR R0, [R1]
    ORR R0, #0x80                   
    STR R0, [R1]                    
	LDR R1, =NVIC_PRI0_R        
    LDR R0, [R1]                   
	AND R0, #0xFFFF0FFF
	ORR	R0, #0x00000000
	STR R0, [R1]                    
	LDR R1, =NVIC_EN0_R         
    LDR R0, =0x00000002                   
    STR R0, [R1]                    
	CPSIE I						
	BX LR

;------------PORTB_Output------------
PORTB_Output
    LDR R1, =GPIO_PORTB_DATA_R 
    STR R0, [R1]               
    BX  LR                    


    ALIGN                           
    END                             
