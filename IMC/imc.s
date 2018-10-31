	AREA |.text|, CODE, READONLY, ALIGN=2
THUMB
	EXPORT Start; Si se desea trabajar con varios archivos .s se deben exportar e importar.
		
Start
	VLDR.F32 S1, =90.5; peso en kg
	VLDR.F32 S2, =1.92; estatura en m
	VMOV.F32 S3, #1; denominador
	VMOV.F32 S4, #1; resultado
	
	B Operacion
	
Operacion
	VMUL.F32 S3, S2, S2; S3=s2*s2
	BL Resultado

Resultado
	VDIV.F32 S4, S1, S3; s4 = S1/S3
	B Stop
	
Stop
	NOP
	
	ALIGN
	END