TITLE Creación de un archivo (CrearArchivo.asm)

INCLUDE Irvine32.inc

TAM_BUFER = 501


.data
bufer BYTE TAM_BUFER DUP(?)
nombrearchivo BYTE "salida.txt",0
manejadorArchivo HANDLE ?
longitudCadena DWORD ?
bytesEscritos DWORD ?
cad1 BYTE "No se puede crear el archivo",0dh,0ah,0
cad2 BYTE "Bytes escritos en el archivo [salida.txt]:",0
cad3 BYTE "Escriba hasta 500 caracteres y oprima "
BYTE "[Intro]: ",0dh,0ah,0


.code
main PROC


; Crea un nuevo archivo de texto.
	mov edx,OFFSET nombrearchivo
	call CreateOutputFile
	mov manejadorArchivo,eax

; Comprueba errores.
		cmp eax, INVALID_HANDLE_VALUE ; ¿se encontró un error?
		jne archivo_ok ; no: salta
		mov edx,OFFSET cad1 ; muestra el error
		call WriteString
		jmp terminar
	archivo_ok:

; Pide al usuario que introduzca una cadena.
	mov edx,OFFSET cad3 ; "Escriba hasta ...."
	call WriteString
	mov ecx,TAM_BUFER ; Recibe una cadena como entrada
	mov edx,OFFSET bufer
	call ReadString
	mov longitudCadena,eax ; cuenta los caracteres introducidos

; Escribe el búfer en el archivo de salida.
	mov eax,manejadorArchivo
	mov edx,OFFSET bufer
	mov ecx,longitudCadena
	call WriteToFile
	mov bytesEscritos,eax ; guarda el valor de retorno
	call CloseFile

; Muestra el valor de retorno.
	mov edx,OFFSET cad2 ; "Bytes escritos"
	call WriteString
	mov eax,bytesEscritos
	call WriteDec
	call Crlf
terminar:
exit
main ENDP
END main