TITLE MASM Template						(main.asm)

;NOTAS:
;***CON NOTEPAD++ PUEDES DISTINGIR LAS COSAS POR COLORES :D
;***TODOS LAS VAIRABLES MENSAJES COMIENZAN CON "m"
;***LAS VARIABLES PARA SALUDO SOLO SE UTILIZAN UNA VEZ
;***PARA RECORRER EL ARRAY SE MULTIPLICA EL REGISTRO POR 4(CASI TODOS LOS ARRAYS SON FLOTANTES)
; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
;+--------------------------------------------------------------------------------------------------+
;|																									|
;| 	Aca se encuentra todas las variables, las tipo BYTE son para imprimir textos, mensajes al 		|
;|	usuario, estan variables para los vectores X,Y que guardan los puntos							|
;|																									|
;| 	también existen vectores llamados t,a,s que son usados para resolver el sistema de ecuaciones	|
;| (leer la explicacion en la página web: 															|
;|	http://www.sc.ehu.es/sbweb/fisica_//numerico/regresion/regresion1.html)							|
;|	existe un vector m que tambien es usado para hallar los coeficientes de la regresión, esta vector
;|	en realidad tiene la funcionalidad de una matriz 												|
;|	pero se encuentra implementando como un vector para así manejarlo mucho mas fácil				| 
;|																									|
;+--------------------------------------------------------------------------------------------------+


;////////VARIABLES PARA SALUDO <INICIO>////////////////
myMessage BYTE "Bievenido",0dh,0ah,0
myMessage2 BYTE "Asignatura: Arquitectura de computadores",0dh,0ah,0
myMessage3 BYTE "Año:2013  Semestre:2",0dh,0ah,0
myMessage4 BYTE "Jonathan Vallejo Muñoz - Jeison Rodrigo Higuita Sanchez",0dh,0ah,0
myMessage5 BYTE "El software desarrollado realiza una regresión linea simple o múltiple, ingresando la cantidad de variables y puntos de cada una",0dh,0ah,0
myMessage6 BYTE "para realizar las estimaciones y aproximaciones lineales, también retorna el error total, el coeficiente de determinación y coeficiente de correlación",0dh,0ah,0
m1 BYTE " ____   _                                 _      _",0dh,0ah,0      
m2 BYTE "|  _ \ (_)                               (_)    | |",0dh,0ah,0    
m3 BYTE "| |_) | _   ___  _ __ __   __ ___  _ __   _   __| |  ___",0dh,0ah,0    
m4 BYTE "|  _ < | | / _ \| '_ \\ \ / // _ \| '_ \ | | / _` | / _ \",0dh,0ah,0    
m5 BYTE "| |_) || ||  __/| | | |\ V /|  __/| | | || || (_| || (_) |",0dh,0ah,0    
m6 BYTE "|____/ |_| \___||_| |_| \_/  \___||_| |_||_| \__,_| \___/",0dh,0ah,0                                        



;/////////VARIABLES--ARRAYS S0LUCION<INICIO>////////////
arregloX REAL4 10000 DUP(?)	;array de datos X de los puntos
arregloY REAL4 10000 DUP(?)	;array de datos Y de los puntos
a REAL4 10000 DUP(?)	;Polinomio... a<0> + a<1>x + a<2>x^2...
t REAL4 10000 DUP(?)	;terminos independientes
s REAL4 10000 DUP(?)
m REAL4 10000 DUP(?)	;array coeficientes


;/////////////////VARIBLES DE ENTRDA Y DE PROCESO////////////
indicex DWORD ?  ;indice en x
indicey DWORD ?	;indice en y
variablereal REAL4 ?  ;variable para descongestionar la pila
grado DWORD ? 	;grado del polinomio
indice DWORD ?	;indice del polinomio


;/////////VARIABLES CONSTANTES Y OPERACIONES<INICIO>////////////
condicional DWORD 1   
uno DWORD 1		;constante uno
suma REAL4 0.0	;inicio de variable suma en cero
consuno REAL4 1.0	;constante uno
conscero REAL4 0.0	;constante cero
potencia REAL4 ?	;variable para calcular la potencia


;///////////////VARIABLES AUXILIARES////////////////
numpuntos DWORD ? 
auxfor DWORD ?  ;auxiliar indice primer for
auxfor2 DWORD ?	;auxiliar indice segundo for
auxnumpuntos DWORD ?	;auxiliar numero de puntos
valEntero DWORD ?		;valor del Entero
auxaux DWORD ?	


;///////////////VARIABLES PARA TEXTO<INICIO>////////////////
mx BYTE "X : ",0dh,0ah,0	;texto para preguntar o pedir
my BYTE "Y : ",0dh,0ah,0	;texto para preguntar o pedir
mgrado BYTE "Grado del polinomio : ",0dh,0ah,0	;texto para preguntar o pedir
mpuntos BYTE "Cantidad de puntos : ",0dh,0ah,0	;texto para preguntar o pedir
msalto BYTE " ",0dh,0ah,0	;texto para preguntar o pedir
mmodificar BYTE "Deseas Modificar algun punto? Si(1)-No(0) : ",0dh,0ah,0	;texto para preguntar o pedir
mmodificar2 BYTE "Posicion del dato a modificar [0,1,2,3...n]: ",0dh,0ah,0	;texto para preguntar o pedir



.code


main PROC
; *****************************IMPRESION MENSAJE DE BIENVENIDA***********************************
	call Clrscr	;limpio la pantalla
	mov	 edx,OFFSET m1 ;como cada mensaje es un array de bytes, entonnces utilizamos el offset
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET m2
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET m3	
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET m4
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET m5
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET m6
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET myMessage2
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET myMessage3
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET myMessage4
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET myMessage5
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET myMessage6
	call WriteString	;imprimir el mensaje
	mov	 edx,OFFSET mpuntos
	call WriteString	;imprimir el mensaje
	
	
	
	;************* LECTURA DE DATOS************
	call ReadInt
	mov numpuntos,eax   ;--> Leer numero de puntos en var numputos
	mov	 edx,OFFSET mgrado
	call WriteString	;imprime mensaje de grado
	call ReadInt  ;-->Leer grado de polinomio en grados
	mov grado,eax
	
	
	; -->este ciclo for L1 va llenando los datos de los puntos que el usuario va ingresando en los vectores arregloX y arregloY
	mov esi,0 ;-->indice para el manejo del array
	mov ecx,numpuntos ;contador para el for
	call Clrscr  ;limpiar pantalla
	L1:   
		mov	 edx,OFFSET mx  
		call WriteString	;imprime el mensaje de x	
		call ReadFloat
		fstp arregloX[esi*4]  ;-->Ingresar valor del array "x" y saco de la pila(la variable esi se multiplica por 4 por que es tipo byte y el arreglo es float)
		mov	 edx,OFFSET my		
		call WriteString	;imprime el mensaje de y	
		call ReadFloat
		fstp arregloY[esi*4];-->Ingresar valor del array "y" y saco de la pila(la variable esi se multiplica por 4 por que es tipo byte y el arreglo es float) 
		inc esi		;--> incrementa contador
	loop L1
	
	
	; Vamos a imprimir los datos ingresados por el usuario
	mov ecx,numpuntos
	mov esi,0  	;--> reedefinimos contador
	call Clrscr
	mov	 edx,OFFSET mgrado
	call WriteString	;imprime mensaje grado
	mov eax,grado	;imprime grado
	call WriteInt
	mov	 edx,OFFSET msalto ;imprime mensaje salto
	call WriteString
	mov	 edx,OFFSET mpuntos	;imprime mensaje puntos
	call WriteString
	mov eax,numpuntos	;imprime numero de puntos
	call WriteInt
	mov	 edx,OFFSET msalto	;imprime mensaje del salto
	call WriteString
	
	
	;*************VALIDACION  DE DATOS*********************
	; este ciclo for L2 imprime todo lo que se encuentra en los dos arreglos X y Y ingresados anteriormente
	L2:
	
		mov	 edx,OFFSET mx	;imprime mensaje x
		call WriteString
		fld arregloX[esi*4] 	;-->almacena valor en pila 
		call WriteFloat
		mov	 edx,OFFSET msalto	;mensaje de salto
		call WriteString
		fstp variablereal		;-->saaca valor de la pila
		mov	 edx,OFFSET my
		call WriteString
		fld arregloY[esi*4] 	;-->almacena valor en pila 
		call WriteFloat
		mov	 edx,OFFSET msalto	;mensje de salto
		call WriteString
		fstp variablereal		;-->saaca valor de la pila
		inc esi		;--> incrementa contador
	loop L2
;+--------------------------------------------------------------------------------------------------+
;|																									|
;| 	Este while tiene la funcionalidad de permitir cambiar datos de puntos en los arreglos X y Y ,	|
;|	el usuario debe decir que punto quiere cambiar dando su posición en el arreglo y a continuación	|
;|	los nuevos puntos X e Y, luego se preguntará si quiere cambiar mas datos y así continuará		|
;| 	hasta que el usuario lo desee																	|
;+--------------------------------------------------------------------------------------------------+
  @@while:
		mov	 edx,OFFSET mmodificar	;mensaje modificar
		call WriteString
		call ReadInt
		cmp eax,uno	;condicional, si es uno entra al while
		jne finwhile
			mov esi,1
			mov	 edx,OFFSET mmodificar2	;mensaje de modificar
			call WriteString
			call ReadInt
			mov indice,eax	;leer el indice
			mov esi,indice	;indicar el indice
			mov	 edx,OFFSET mx	;mensaje de x
			call WriteString
			call ReadFloat
			fstp arregloX[esi*4]	;leer float arreglo en la posicion  
			mov	 edx,OFFSET my
			call WriteString
			call ReadFloat
			fstp arregloY[esi*4]	;leer float arreglo en la posicion de esi
			mov esi,0
			mov ecx,numpuntos	
			call Clrscr
			; este ciclo  imprime todo lo que se encuentra en los dos arreglos X y Y 
			L3:
				mov	 edx,OFFSET mx
				call WriteString
				fld arregloX[esi*4]
				call WriteFloat
				mov	 edx,OFFSET msalto
				call WriteString
				fstp variablereal
				mov	 edx,OFFSET my
				call WriteString
				fld arregloY[esi*4]
				call WriteFloat
				mov	 edx,OFFSET msalto
				call WriteString
				fstp variablereal
				inc esi
			loop L3
		jmp @@while
  finwhile:
  
  
  
  
  
;+--------------------------------------------------------------------------------------------------+
;|																									|
;|		codigo solucion, se encuenra todo el proceso utilizado para la resolucion de el problema...
;|																									|
;+--------------------------------------------------------------------------------------------------+

  
  ; A partir de acá, se comienza  a implementar el algoritmo para encontrar los coeficientes de regresion del polinomio
  mov eax,0
 
  add eax,grado 
  add eax,grado
  add eax,1  ;--> 2grado + 1 
  mov auxaux,eax	
	mov ecx,eax  ; --> indice
   
	for1:
	    fld conscero  ;--> carga en la pila cero
	    mov auxfor,ecx	;auxiliar ecx
		mov ecx,numpuntos	
		mov esi,0	;indicador 
		for2:
			 mov auxfor2,ecx  ;indice for
			 mov eax,grado
			 add eax,grado
			 add eax,1	;2grado+1
			 sub eax,auxfor	;resta indice
			 mov ecx,eax
			 fstp suma	;saca pila en 1
			 fld consuno
			 for3:
				fmul arregloX[esi*4]  ;multiplica -- 2grado+1-auxfor veces, queda la potencia
			 loop for3	
			mov ecx,auxfor2
			inc esi
			fstp potencia
			fld suma
			fadd potencia
		loop for2
		mov ecx,auxfor
		mov eax,auxaux
		sub eax,ecx
		mov esi,eax
		fstp s[esi*4]
	loop for1
	
; Practicamente el algoritmo de arriba pero con unas pequeñas modificaciones
	 mov eax,0
  add eax,grado
  add eax,1
	mov ecx,eax
   
	for4:
	    fld conscero
	    mov auxfor,ecx
		mov ecx,numpuntos
		mov esi,0
		for5:
			
			 mov auxfor2,ecx
			 mov eax,grado
			 add eax,1
			 sub eax,auxfor
			 mov ecx,eax
			 fstp suma
			 fld consuno
			 for6:
				fmul arregloX[esi*4]
			 loop for6
			mov ecx,auxfor2
			 arregloY[esi*4]
			inc esi
			fstp potencia
			fld suma
			fadd potencia
		loop for5
		mov ecx,auxfor
		mov eax,grado
		add eax,1
		sub eax,ecx
		mov esi,eax
		fstp t[esi*4]
	loop for4
	
	;for de la matriz //////////////
	
	 mov eax,0
  add eax,grado
  add eax,1
	mov ecx,eax
   
	for7:

	    mov auxfor,ecx
		mov eax,grado
		add eax,1
		mov ecx,eax
		
		mov esi,0
		for8:
			mov eax,grado
			add eax,grado
			add eax,2
			sub eax,ecx
			sub eax,auxfor
			mov esi,eax
			
			fld s[esi*4]
			
			mov eax,0
			mov eax,grado
			sub eax,auxfor
			mul grado
			add eax,grado
			sub eax,ecx
			mov esi,eax
			
			fstp m[esi*4]
		loop for8
		mov ecx,auxfor
		
	loop for7
	
	exit
main ENDP

END main