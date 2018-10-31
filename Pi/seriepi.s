	AREA |.text|, CODE, READONLY, ALIGN=2
THUMB
	EXPORT Start; Si se desea trabajar con varios archivos .s se deben exportar e importar.


Start
	VMOV.F32 S1, #-1; -1 del numerador
	VMOV.F32 S2, #1;   1 del denominador
	VMOV.F32 S3, #2;   2 del denominador
	VMOV.F32 S4, #1;   1 del exponente
	VMOV.F32 S5, #4;   4 que multiplica
	VMOV.F32 S6, #1;   k del denominador y exponente
	VMOV.F32 S7, #1;   exponente
	VMOV.F32 S8, #1;   NUMERADOR
	VMOV.F32 S9, #1;   DENOMINADOR
	VMOV.F32 S10, #1;  DIVISION
	VMOV.F32 S11, #1;  MULTIPLICACION
	VMOV.F32 S13, #-1
	MOV R1, #1;        CONTADOR
	
	B Numerador
	
Numerador
	;VADD.F32 S7, S6, S4; S7=K+1
	VMUL.F32 S1, S13
	VMOV.F32 S8, S1; S8 = S1
	B Denominador
	
Denominador
	VMUL.F32 S9, S3, S6; S9 = 2K
	VSUB.F32 S9, S2; S9=S9-1
	
	B Resultado

Resultado
	VDIV.F32 S10, S8, S9; S10 = S8/S9
	VMUL.F32 S11, S5, S10; S11 = S5*S10
	VADD.F32 S12, S12, S11
	VADD.F32 S6, S4; k++
	BL Comparacion
	
Comparacion
	CMP R1, #50; tope final del la serie
	ADD R1, R1, #1
	BEQ L;si lo anterior es cierto manda al siguiente
	BL Numerador	

L
	B Stop

	
Stop
    NOP
	NOP
	
	ALIGN
    END
    