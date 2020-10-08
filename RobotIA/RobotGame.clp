;       ________      ______       _____     ______________ 
;       ___  __ \________  /_________  /_    ____  _/__    |
;       __  /_/ /  __ \_  __ \  __ \  __/     __  / __  /| |
;       _  _, _// /_/ /  /_/ / /_/ / /_      __/ /  _  ___ |
;       /_/ |_| \____//_.___/\____/\__/      /___/  /_/  |_|
;
;       
;
;
;
;                                      ºGUÍAº                                
;
;  Voy a seguir la siguiente estructura para la info dinámica:     
;  robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level
; 
;  positionR ?xr ?yr -> posicion del robot en formato [x,y]
;  positionBox $?boxes -> posiciones de las cajan en formato lista ([x,y] bx...)
;  positionEnemies $?enemies -> posiciones de los enemigos en formato lista ([x,y] eny...)
;  ammo ?a -> munición
;
;  la estructura lastmove es para evitar bucles :D [izq,drch]
;  level es para ir comprobando la profundidad
;
;
;  Estructura estática :
;  max-depth ?prof
;  stairs-location $?stairs
;  void-location $?voids
;  grid-dimension ?width ?heigh
;
;
;

(defglobal ?*nod-gen* = 0)

(defrule go_right
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)
        (grid-dimension ?width ?heigh)
        (void-location $?voids)

        (test (< ?level ?prof))
        (test (and (neq ?xr ?width) (neq ?mov izq)))
        ;Con este test compruebo que la siguiente casilla no es un enemigo/vacio :D
        (test (and (not (member$ (create$ vd (+ ?xr 1) ?yr) $?voids)) (not (member$ (create$ en (+ ?xr 1) ?yr) $?enemies))))
        =>
        (assert (robotIA positionR (+ ?xr 1) ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove drch level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule go_left
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)
        (grid-dimension ?width ?heigh)
        (void-location $?voids)

        (test (< ?level ?prof))
        (test (and (neq ?xr 1) (neq ?mov drch)))
        ;Con este test compruebo que la siguiente casilla no es un enemigo/vacio aunque si viene de la derecha 
        ;no haría falta, no se si habrá un enemigo al subir la escalera asi que lo compruebo de todas formas
        (test (and (not (member$ (create$ vd (- ?xr 1) ?yr) $?voids)) (not (member$ (create$ en (- ?xr 1) ?yr) $?enemies))))
        =>
        (assert (robotIA positionR (- ?xr 1) ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove izq level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule go_upstairs
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)
        (stairs-location $?stairs)
        (grid-dimension ?width ?heigh)

        (test (< ?level ?prof))
        (test (neq ?mov justDown))
        (test (member$ (create$ st ?xr ?yr) $?stairs))
        =>
        (assert (robotIA positionR ?xr (+ ?yr 1) positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove justUp level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)
;Es completamente igual al go_upstairs , pero compruebo la celda inferior!
(defrule go_downstairs
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)
        (stairs-location $?stairs)
        (grid-dimension ?width ?heigh)

        (test (< ?level ?prof))
        (test (neq ?mov justUp))
        (test (member$ (create$ st ?xr (- ?yr 1)) $?stairs))
        =>
        (assert (robotIA positionR ?xr (- ?yr 1) positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove justDown level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule pickup_box
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)

        (test (< ?level ?prof))
        (test (member$ (create$ box ?xr ?yr) $?boxes))
        =>
        (assert (robotIA positionR ?xr ?yr positionBox (delete-member$ $?boxes (create$ box ?xr ?yr)) positionEnemies $?enemies ammo ?a lastmove null level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)
;(delete$ (create$ computer printer hard-disk) 1 1)
(defrule shot_enemy_right
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)

        (test (< ?level ?prof))
        (test (> ?a 0))
        (test (member$ (create$ en (+ ?xr 1) ?yr) $?enemies))
        =>
        (assert (robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies (delete-member$ $?enemies (create$ en (+ ?xr 1) ?yr)) ammo (- ?a 1) lastmove ?mov level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule shot_enemy_left
        ?f<-(robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
        (max-depth ?prof)

        (test (< ?level ?prof))
        (test (> ?a 0))
        (test (member$ (create$ en (- ?xr 1) ?yr) $?enemies))
        =>
        (assert (robotIA positionR ?xr ?yr positionBox $?boxes positionEnemies (delete-member$ $?enemies (create$ en (- ?xr 1) ?yr)) ammo (- ?a 1) lastmove ?mov level (+ ?level 1)))
        (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule objetivo
    (declare (salience 100))
    ?f<-(robotIA positionR ?xr ?yr positionBox positionEnemies $?enemies ammo ?a lastmove ?mov level ?level)
    
   =>
    (printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?level crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
    (printout t "HECHO OBJETIVO " ?f crlf)
    
    (halt))

(deffunction inicio()
        (reset)
        (printout t "Profundidad Maxima:= " )
        (bind ?prof (read))
        (printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
        (bind ?a (read))
        (if (= ?a 1)
               then    (set-strategy breadth)
               else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)
        ;DINAMIC
        (assert (robotIA positionR 1 1 positionBox box 4 3 box 11 2 box 3 4 positionEnemies en 4 2 en 8 2 en 8 4  ammo 2 lastmove null level 0))
        ;STATIC
        (assert (max-depth ?prof))
        (assert (stairs-location st 3 1 st 7 1 st 2 2 st 1 3 st 7 3 st 11 3 st 10 2))
        (assert (void-location vd 5 2 vd 3 3 vd 4 4 vd 5 4 vd 6 4 vd 8 3))
        (assert (grid-dimension 11 4))
        
)