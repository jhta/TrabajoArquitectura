TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
grado REAL4 ?
p REAL4 10000 DUP(?)  
auxauxfor2 DWORD ?
auxfor2 DWORD ?
auxfor DWORD ? ;almacenar para el procedimiento
auxManejo REAL4 0	;para manejar el indice de array m
verror REAL4 0
max REAL4 0
numAux REAL4 0.001

;val1 DWORD ?
;val2 DWORD ?
;result DWORD ?
.code
main PROC

	mov esi,0 ;-->indice para el manejo del array
	mov eax, grado
	mov auxfor, eax
	mov ecx,auxfor ;contador para el for
	call Clrscr  ;limpiar pantalla
	
	L1:   
			;///este es el proceso para manejar la matriz como array esi=grado*indice+indice
			mov eax,0
			mov eax,grado
			sub eax,aux
			mul grado
			add eax,grado
			sub eax,ecx
			mov esi,eax
			;//cierra manejar como array
			
			;fstp m[esi*4]
			fld m[esi*4]
			fstp auxManejo ;//almaceno lo que hay en la posicion buscada del vector
				
			inc esi		;--> incrementa contador
			
			mov eax, grado
			mov auxfor2, eax
			mov  auxauxfor2, eax ;para retornar al indice de el primer for
			mov ecx,auxfor2 ;contador para el for
	
			L2:
					mov eax,0
					mov eax,grado
					sub eax,auxfor
					mul grado
					add eax,grado
					sub eax,ecx
					mov esi,eax
					
					;fstp m[esi*4]
					fld m[esi*4]

					;fstp auxManejo ;//almaceno lo que hay en la posicion buscada del vector
					
					;mov eax, auxManejo
					  	
					fdiv auxManejo
					;fmul negar lo que hay en la pila
					fstp m[esi*4]
					
					
			loop L2
			mov ecx, auxauxfor2	;retorna al indice
			mov eax, grado
			sub eax,ecx
			mov esi, eax
			;fstp t[esi*4]
			fld t[esi*4]
			;fstp auxManejo
			fdiv auxManejo	;/t[i]=t[i]/aux
			fstp t[esi*4]
			
			
			mov eax,0
			mov eax,grado
			sub eax,aux
			mul grado
			add eax,grado
			sub eax,ecx
			mov esi,eax
			;//cierra manejar como array
			
			fld m[esi*4]
			fsub m[esi*4]
			fstp m[esi*4] ; hago m[i]=0
			
			
			
	loop L1
	mov esi, 0
	fld t[esi]
	fstp p[esi]	;p[0]=t[0]
	
	
	
	
	;mov esi,consuno ;-->indice para el manejo del array
	mov eax, grado
	mov auxfor, eax
	add eax, consuno
	mov ecx,auxfor ;contador para el for
	call Clrscr  ;limpiar pantalla
	L3:
			mov eax, grado
			sub eax, ecx
			add eax, consdos  ;constante de dos
			mov esi, eax
			
			
			fld conscero
			fstp p[esi*4]
			
			
			inc esi
	loop L3
	
 @@while:
		mov max,eax
		sub eax, max
		
		
		
		
		mov eax, max  
		cmp eax,numAux	;si es mayor que 0.001
		jng finwhile
				
			;aqui arranca el for
			
			mov ecx,grado ;contador para el for
			
			call Clrscr  ;limpiar pantalla
			;arranca el for
			L4:
			
				mov eax, grado 
				sub eax, ecx
				mov esi, eax ;indice del for en la matriz
				
				fld t[esi*4]
				fstp a[esi*4]	;a[i]=t[i]
				
				;**********************************segundo for
				
				mov auxauxfor, esi
				mov  auxfor, ecx	;guardo el indice del primer for
				mov ecx, esi
				
				
				L5:
					;registro esi para m
					mov eax,0
					mov eax, auxauxfor
					sub eax, ecx
					mul auxauxfor
					add eax,auxaxfor
					sub eax,ecx
					mov esi,eax
								
					fld m[esi*4] 	;agrego m[i][j]
					
					
					mov eax, auxauxfor
					sub eax, ecx
					mov esi, eax
					fmul a[esi*4]	;ultplico m[i][j]*a[j]
					
					mov esi, auxauxfor
					fadd a[esi*4]	;sumo a[i]+m[i][j]*a[j]
					
					fstp a[esi*4]	;a[i]+= m[i][j]*a[j]
				loop L5
				
				mov ecx, auxfor ;regreso el indice del primer for
				
				;************************************tercer for
				
				
				
				mov auxauxfor, esi
				mov  auxfor, ecx	;guardo el indice del primer for
				mov ecx, esi
				
				
				L6:
					;registro esi para m
					mov eax,0
					mov eax, auxauxfor
					sub eax, ecx
					mul auxauxfor
					add eax,auxaxfor
					sub eax,ecx
					mov esi,eax
								
					fld m[esi*4] 	;agrego m[i][j]
					
					
					mov eax, auxauxfor
					sub eax, ecx
					mov esi, eax
					fmul p[esi*4]	;ultplico m[i][j]*p[j]
					
					mov esi, auxauxfor
					fadd a[esi*4]	;sumo a[i]+m[i][j]*p[j]
					
					fstp a[esi*4]	;a[i]+= m[i][j]*p[j]
				loop L6
				
				mov ecx, auxfor ;regreso el indice del primer for
				
				;************calculo error
				
				mov eax, grado
				sub eax, ecx
				mov esi, eax
				
				fld a[esi*4] ;	a[i]
				fsub p[esi*4]	;a[i]-p[i]
				fdiv a[esi*4]	;(a[i]-p[i])/a[i]
				fabs
				fstp verror		;verror=(a[i]-p[i])/a[i]
				
				mov eax,verror
				cmp eax, max
				jg L10
				L10: mov max, error  ; ni puta idea de como validar este condicional
				
				
			loop L4
			
			
			mov ecx,grado
			;for de afuera
			L7:
			mov eax, grado
			sub eax, ecx
			mov esi, eax
			
			fld a[esi*4]
			fstp p[esi*4]	;p[i]=a[i]
			loop L7
			
		jmp @@while
  finwhile:
 
	
	
	
;call ReadInt
;mov val1,eax
;call ReadInt
;mov val2,eax
;mov eax,val1
;add eax,val2
;mov result,eax
;MOV edx, OFFSET result
;call WriteDec
;call Crlf
	

main ENDP
END main
