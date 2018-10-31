SYSCTL_RCGCGPIO_R 	   	EQU 0x400FE608; activar reloj
	
GPIO_PORTB_AMSEL_R 		EQU 0x40005528
GPIO_PORTB_PCTL_R  		EQU 0x4000552C
GPIO_PORTB_DIR_R   		EQU 0x40005400
GPIO_PORTB_AFSEL_R 		EQU 0x40005420
GPIO_PORTB_DEN_R   		EQU 0x4000551C
PB						EQU 0X4000501C;0-2
	
;PE
GPIO_PORTE_AMSEL_R      EQU 0x40024528; activacion puerto E, desactivacion del puerto de forma analogica
GPIO_PORTE_PCTL_R		EQU 0x4002452C; activa el puerto E como GPIO
GPIO_PORTE_DIR_R		EQU 0X40024400; direccion del registro
GPIO_PORTE_AFSEL_R      EQU 0x40024420; elimina cualquier otra funcion anterior
GPIO_PORTE_DEN_R      	EQU 0x4002451C; activacion commo puerto digital
PE3						EQU 0x40024020; para puerto E3	

TIEMPO					EQU 8000000; 12000000*2s/3  
TIEMPO1					EQU 1066666  ; 0.2 SEGUNDOS (aproximadamente)
	
	AREA |.text|, CODE, READONLY, ALIGN=2
THUMB
	EXPORT Start; Si se desea trabajar con varios archivos .s se deben exportar e importar.

Start

	LDR R1, =SYSCTL_RCGCGPIO_R; Inicio activacion de reloj
	LDR R0, [R1]; 
	ORR R0, R0, #0x02; ACTIVA EL RELOJ
	STR R0, [R1]
	NOP
	NOP
	
	LDR R1, =GPIO_PORTB_AMSEL_R; Inicio de desactivacion de la funcion analogica
	LDR R0, [R1];
	BIC R0, R0, #0xFF; pin 1 puerto F
	STR R0, [R1];
		
	LDR R1, =GPIO_PORTB_PCTL_R; GPIO
	LDR R0, [R1]
	BIC R0, R0, #0xF000000
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_DIR_R; Direccion del registro, (output)
	LDR R0, [R1]
	ORR R0, R0, #0xFF
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_AFSEL_R; Otras funciones
	LDR R0, [R1]
	BIC R0, R0, #0xFF
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_DEN_R; Puerto digital
	LDR R0, [R1]
	ORR R0, R0, #0xFF
	STR R0, [R1]
	
	B ENTRADA
	
ENTRADA	

	LDR R6, =SYSCTL_RCGCGPIO_R ; ACTIVAR EL RELOJ 
    LDR R5, [R6]                 
    ORR R5, R5, #0x1C               
    STR R5, [R6]                  
    NOP
    NOP                             
                                    ; EL PUERTO B NO NECESITA DESBLOQUEARSE                
    LDR R6, =GPIO_PORTE_AMSEL_R     ; DESACTIVAR LA FUNCION DIGITAL
    LDR R5, [R6]                    
    MOV R5, #0x00                   
    STR R5, [R6]                    
    LDR R6, =GPIO_PORTE_PCTL_R      ; HABILITAR COMO GPIO
    LDR R5, [R6]                    
    MOV R5, #0x0000F000             ; PUERTO 0 0x0000000F, PUERTO 1 0x000000F0, PUERTO 2 0x00000F00...
    STR R5, [R6]                  
    LDR R6, =GPIO_PORTE_DIR_R       ;  INPUT,  si fuera OUTPUT seria #0x20
    LDR R5, [R6]                    
    MOV R5, #0x00                   ; 0X00 ES SALIDA 0X20 ENTRADA
    STR R5, [R6]                    
    LDR R6, =GPIO_PORTE_AFSEL_R     ; DESHABILITA OTRAS FUNCIONES
    LDR R5, [R6]                    
    MOV R5, #0x00                   ; 0X00 LO DESHABILITA 0X20 LO HABILITARIA
    STR R5, [R6]                                 
    LDR R6, =GPIO_PORTE_DEN_R       ; HABILITA LA FUNCION DIGITAL
    LDR R5, [R6]                    
    MOV R5, #0x08                   ; 0X20 LO HABILITA
    STR R5, [R6]      
	
	
	 LDR R5, =TIEMPO1
	 
	 
delay
    SUBS R5, R5, #1                 ; R0 = R0 - 1 
    BNE delay                       ; REGRESA A DELAY
    BL	Boton

Boton
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ CERO
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	BEQ.W APAGADO	
	
CERO
	LDR R1, =PB
	MOV R0, #0x00					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay0				
    SUBS R0, R0, #1                 
    BNE Delay0  
	B Delay00
	
Delay00
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ UNO
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay00
	B CERO
	
UNO
	LDR R1, =PB
	MOV R0, #0x01					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay1				
    SUBS R0, R0, #1                 
    BNE Delay1  
	B Delay11
	
Delay11
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ DOS
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay11
	B UNO

DOS
	LDR R1, =PB
	MOV R0, #0x02					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay2			
    SUBS R0, R0, #1                 
    BNE Delay2  
	B Delay22
	
Delay22
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ TRES
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay22
	B DOS	

TRES
	LDR R1, =PB
	MOV R0, #0x03					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay3			
    SUBS R0, R0, #1                 
    BNE Delay3  
	B Delay33
	
Delay33
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ CUATRO
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay33
	B TRES
	
CUATRO
	LDR R1, =PB
	MOV R0, #0x04					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay4			
    SUBS R0, R0, #1                 
    BNE Delay4  
	B Delay44
	
Delay44
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ CINCO
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay44
	B CUATRO
	
CINCO
	LDR R1, =PB
	MOV R0, #0x05					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay5			
    SUBS R0, R0, #1                 
    BNE Delay5  
	B Delay55
	
Delay55
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ SEIS
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay55
	B CINCO	

SEIS
	LDR R1, =PB
	MOV R0, #0x06					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay6			
    SUBS R0, R0, #1                 
    BNE Delay6  
	B Delay66
	
Delay66
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ SIETE
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay66
	B SEIS	
	
SIETE
	LDR R1, =PB
	MOV R0, #0x07					; ENCIENDE EL LED
	STR R0, [R1];
		LDR R0, = TIEMPO
		
Delay7			
    SUBS R0, R0, #1                 
    BNE Delay7  
	B Delay77
	
Delay77
	LDR R6, =PE3					; ASIGNA EL VALOR DE PB5 A R1
    LDR R5, [R6]               		 
    AND R5,R5,#0x08  				; REALIZA UNA OPERACION AND ENTRE EL PIN Y EL VALOR 0X20
	
	CMP R5, #0x08                   ; R0 == 0x20 SALTA A ACTIVAR
    BEQ APAGADO
	
	CMP R5, #0x00					; R0 == 0x00 SALTA A APAGAR
	SUBS R0, R0, #1 
	BNE Delay77
	B SIETE	
	
APAGADO
	LDR R1, =PB
	MOV R0, #0x00					; APAGA EL LED
	STR R0, [R1];
	LDR R5, =TIEMPO1
	BL delay		
	
STOP
	NOP
	NOP

	ALIGN
    END; Finalización del programa