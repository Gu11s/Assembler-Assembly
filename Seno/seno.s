	AREA |.text|, CODE, READONLY, ALIGN=2
THUMB
    EXPORT Start; Si se desea trabajar con varios archivos .s se deben exportar e importar.

Start
    VMOV.F32 S1, #1; 	parte para -1 del numerador
    VMOV.F32 S2, #-1; 	2 Parte para -1 del numerador
    VMOV.F32 S3, #1; 	Constante 1
	VMOV.F32 S4, #2; 	Constante 2
	VMOV.F32 S5, #1; 	donde se almacenará el x al cuadrado
    VMOV.F32 S27, #1; 	Inicio del factorial 
	VMOV.F32 S11, #5; 	Parametro x
	VMOV.F32 S26, #1;
	VMOV.F32 S29, #2;
	VMOV.F32 S31, #1;
	
	MOV R1, #1; 		CONTADOR
	B Contador; 		Dirige a la Subrutina 	

Contador
	CMP R1, #25; 		Compara si R1 es igual a 25
    BEQ Resultado; 		Si la comparación anterior es igual a 25, se dirige a la subrutina resultado.
    BL MenosUno; 		Si la comparación NO es igual a 25	

MenosUno
	VMUL.F32 S1, S1, S2; Multiplica 1 (S1) por S2, es el menos uno del numerador
    B Suma; 			Dirige a subrutina Suma

Suma
	VMUL.F32 S5, S5, S11;
	VMUL.F32 S5, S5, S11;
	VMUL.F32 S6, S5, S11;
	VMUL.F32 S6, S6, S1;
    B fac; 				Dirige a la subrutina fac.	

fac
	VMUL.F32 S26, S26, S29; 
	VADD.F32 S29, S31; 	SUMA 1
	VMUL.F32 S26, S26, S29;
	VADD.F32 S29, S31;	SUMA 1
    BL Division

Division
    VDIV.F32 S12, S6, S26; realiza la division de s6 con s26 y lo asigna en s12
	ADD R1, R1, #1; 	A R1 se le irá sumando en cada iteración un 1 hasta llegar a 25
	VADD.F32 S13, S13, S12
    BL Contador;	 

Resultado
   	VADD.F32 S13, S13, S11; suma termino cuando contador es cero
    B Stop; 			Final de la serie.

Stop
    NOP
    
	ALIGN
    END; Finalización del programa