 ; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "SnakeGame"                 ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst            ; Start of application

AppEntry                call pintarFondo        ; Paso 1: Pintar todo el fondo de la pantalla
                        call pintarBorde        ; Paso 2: Delimitar bordes de la pantalla
                        call randomSer          ; Paso 3: Elegir una posicion random para la serpiente
                        call randomFru          ; Paso 4: Elegir una posicion random para la fruta
                        call main               ; Paso 5: Pintar todo el fondo de la pantalla
                        jp AppEntry

pintarFondo             ld b, 255               ; indice del bucle en b
                        ld ix, 5800h            ; primer bloque de posición de memoria en IX

bucleFondo1             ld a, 105               ; se asigna a A el color
                        ld (ix), a              ; se pinta el valor de IX con el color de A
                        inc ix                  ; se incrementa en uno IX
                        dec b                   ; se decrementa en uno IX
                        ld a, 0                 ; se carga un 0 en a
                        cp a, b                 ; se compara a y b en busca de que ambos sean ceros
                        jp nz, bucleFondo1      ; en el caso en que b todavia no sea 0, se vuelve al bucle

                        ld b, 255
                        ld ix, 5900h            ; se repite con el segundo bloque de posición de memoria en IX

bucleFondo2             ld a, 105
                        ld (ix), a
                        inc ix
                        dec b
                        ld a, 0
                        cp a, b
                        jp nz, bucleFondo2

                        ld b, 255
                        ld ix, 5A00h            ; se repite con el tercer bloque de posición de memoria en IX

bucleFondo3             ld a, 105
                        ld (ix), a
                        inc ix
                        dec b
                        ld a, 0
                        cp a, b
                        jp nz, bucleFondo3
                        ld a, 75
                        ld (ix), a
                        ld a, 0
                        ret

pintarBorde             ld de, 31               ; parametros para pintar la
                        ld b, 32                ; primera fila de la pantalla
                        ld ix, 5800h            ; como borde

bucleBorde1             ld a, 75                ; se asigna a A el color
                        ld (ix), a              ; se pinta el valor de IX con el color de A
                        inc ix                  ; se incrementa en uno IX
                        dec b                   ; se decrementa en uno IX
                        ld a, 0
                        cp a, b                 ; se compara para si se llego al final de la fila
                        jp nz, bucleBorde1      ; sino se repite el bucle con la nueva posicion

                        ld b, 22                ; se repite con parametros para pintar los
                        ld ix, 5820h            ; laterales de la pantalla como bordes

bucleBorde2             ld a, 75
                        ld (ix), a
                        add ix, de              ; se le agrega el registro "de" (31) a IX en cada bucle para pintar en la otra punta
                        ld (ix), a
                        inc ix
                        dec b
                        ld a, 0
                        cp a, b
                        jp nz, bucleBorde2

                        ld b, 32                ; se repite con parametros para pintar la
                        ld ix, 5AE0h            ; ultima fila de la pantalla como bordes

bucleBorde3             ld a, 75
                        ld (ix), a
                        inc ix
                        dec b
                        ld a, 0
                        cp a, b
                        jp nz, bucleBorde3
                        ret

traduce                 ld hl, 5800h            ; direccion inicial de pantalla
                        ld a, (coordSer)        ; en a se pasa la fila de la serpiente
                        ld b, a                 ; en b se guarda la fila de la serpiente
                        ld a, 0
                        cp a, b
                        jp z, sumarColumnaSer   ; en el caso que la fila sea 0, se dirige a sumar la columna
                        ld d, 0
                        ld e, 32
bucleTraduce            add hl, de              ; se le suman 32 veces 32 a hl para simular la multiplicacion
                        djnz bucleTraduce
sumarColumnaSer         ld a, (coordSer + 1)
                        ld e, a                 ; en e se guarda la columna de la serpiente
                        ld d, 0
                        add hl, de              ; se guarda todo en hl
                        ret

traduceFru              ld hl, 5800h            ; direccion inicial de pantalla
                        ld a, (coordFru)        ; en a se pasa la fila de la fruta
                        ld b, a                 ; en b se guarda la fila de la fruta
                        ld a, 0
                        cp a, b
                        jp z, sumarColumnaFru   ; en el caso que la fila sea 0, se dirige a sumar la columna
                        ld d, 0
                        ld e, 32
bucleTraduceFru         add hl, de              ; se le suman 32 veces 32 a hl para simular la multiplicacion
                        djnz bucleTraduceFru
sumarColumnaFru         ld a, (coordFru + 1)
                        ld e, a                 ; en e se guarda la columna de la serpiente
                        ld d, 0
                        add hl, de              ; se guarda todo en hl
                        ret

snake                   call traduce            ; se obtienen las cordenadas de la serpiente
                        ld (hl), 85             ; en la posicion se pinta de rojo
                        ret

snakeErase              call traduce            ; se obtienen las cordenadas de la serpiente
                        ld (hl), 105            ; en la posicion se borra el color
                        ret

coordsUp                ld a, (coordSer)
                        dec a                   ; se decrementa la fila de la serpiente en uno
                        ld (coordSer), a        ; para simular el movimiento hacia arriba
                        ret

coordsDown              ld a, (coordSer)
                        inc a                   ; se incrementa la fila de la serpiente en uno
                        ld (coordSer), a        ; para simular el movimiento hacia abajo
                        ret

coordsRight             ld a, (coordSer + 1)
                        inc a                   ; se incrementa la columna de la serpiente en uno
                        ld (coordSer + 1), a    ; para simular el movimiento hacia la derecha
                        ret

coordsLeft              ld a, (coordSer + 1)
                        dec a                   ; se decrementa la columna de la serpiente en uno
                        ld (coordSer + 1), a    ; para simular el movimiento hacia la izquierda
                        ret

direccionUp             ld a, 1
                        ld (direccion), a       ; se guarda 1 (arriba) en direccion
                        ret

direccionDown           ld a, 2
                        ld (direccion), a       ; se guarda 2 (abajo) en direccion
                        ret

direccionRight          ld a, 3
                        ld (direccion), a       ; se guarda 3 (derecha) en direccion
                        ret

direccionLeft           ld a, 4
                        ld (direccion), a       ; se guarda 4 (izquierda) en direccion
                        ret

readKey                 ld a, 0dfh              ; se guarda en el acumulador el valor de la semifila donde estan las teclas que queremos leer
                        in a, (0feh)            ; se guardan los bits para luego verificar si alguno esta en cero (si se presiono alguna tecla)
                        bit 2, a
                        jp z, direccionUp
                        bit 3, a
                        jp z, direccionDown
                        bit 0, a
                        jp z, direccionRight
                        bit 1, a
                        jp z, direccionLeft
                        ret

coords                  ld a, (direccion)       ; se guarda la direccion en el acumulador para luego comparar su valor y simular el movimiento de la seripiente cambiandole sus coordenadas
                        ld b, 1
                        cp a, b
                        jp z, coordsUp
                        ld b, 2
                        cp a, b
                        jp z, coordsDown
                        ld b, 3
                        cp a, b
                        jp z, coordsRight
                        ld b, 4
                        cp a, b
                        jp z, coordsLeft
                        ret

retardo                 halt                    ; retardo del programa para que el usuario pueda interactuar a una velocidad razonable
                        halt
                        halt
                        halt
                        halt
                        halt
                        halt
                        halt
                        halt
                        ret

colisionBorde           jp AppEntry             ; si colisiona con el borde se resetea el programa

colisionFruta           call traduceFru         ; si colisiona con una fruta se obtienen las coordenadas y se le asigna una nueva posicion random a la misma
                        ld a, 105
                        ld (hl), a
                        call randomFru
                        ret

colisiones              call traduce            ; detecta las dos colisiones posibles de la serpiente (borde o fruta)
                        ld a, 75
                        cp a, (hl)
                        jp z, colisionBorde
                        ld a, 95
                        cp a, (hl)
                        jp z, colisionFruta
                        ret

fruta                   call traduceFru         ; guarda la posicion actual de la fruta en hl
                        ld (hl), 95             ; se pinta de color morado la fruta
                        ret

randomSer               ld a, r                 ; se agarra el registro "r" para simular un valor random
                        and a, 00001111b        ; se enmascara el valor para que sea un valor de rango maximo 15
                        ld (coordSer), a        ; el valor random se guarda en la fila de la serpiente
                        ld a, r                 ; se repite con la columna de la serpiente
                        and a, 00001111b
                        ld (coordSer + 1), a
                        ret

randomFru               ld a, r                 ; se agarra el registro "r" para simular un valor random
                        and a, 00001111b        ; se enmascara el valor para que sea un valor de rango maximo 15
                        ld (coordFru), a        ; el valor random se guarda en la fila de la fruta
                        ld a, r                 ; se repite con la columna de la fruta
                        and a, 00001111b
                        ld (coordFru + 1), a
                        call fruta
                        ret

main                    call snake              ; pintar serpiente
                        call readKey            ; lectura del teclado
                        call retardo            ; retardo del programa
                        call snakeErase         ; borrar serpiente
                        call coords             ; actualizar coordenadas
                        call colisiones         ; colisiones (fondo o fruta)
                        jp main                 ; vuelve al principio del bucle "main"

direccion               defb 1                  ; 1 - arriba, 2 - abajo, 3 - derecha, 4 - izquierda
coordFru                defb 5, 18              ; poscion de memoria para el valor random de la fruta
coordSer                defb 13, 10             ; poscion de memoria para el valor random de la serpiente

; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


