;       ________      ______       _____     ______________ 
;       ___  __ \________  /_________  /_    ____  _/__    |
;       __  /_/ /  __ \_  __ \  __ \  __/     __  / __  /| |
;       _  _, _// /_/ /  /_/ / /_/ / /_      __/ /  _  ___ |
;       /_/ |_| \____//_.___/\____/\__/      /___/  /_/  |_|
;
;       By Aret o/  https://github.com/aretdev
;
;
;
;
;                                      ºGUÍAº                                
;
;  Voy a seguir la siguiente estructura para la info dinámica:     
;  robotIA positionR ?xr ?yr positionBox ?$boxes positionEnemies ?$enemies ammo ?a lastmove ?mov level ?level
; 
;  positionR ?xr ?yr -> posicion del robot en formato [x,y]
;  positionBox ?$boxes -> posiciones de las cajan en formato lista (bx [x,y] bx...)
;  positionEnemies ?$enemies -> posiciones de los enemigos en formato lista (eny[x,y] eny...)
;  ammo ?a -> munición
;
;  la estructura lastmove es para evitar bucles :D
;  level es para ir comprobando la profundidad
;
;
;  Estructura estática :
;  max-depth ?proof
;  stairs-location ?$stairs
;  void-location ?$voids
;  grid-dimension ?width ?heigh
;
;
;

(defglobal ?*nod-gen* = 0)

(deffunction inicio ()
        (reset)
        (printout t "Profundidad Maxima:= " )
        (bind ?prof (read))
        (printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
        (bind ?a (read))
        (if (= ?a 1)
               then    (set-strategy breadth)
               else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)
        ;;(assert (puzzle 2 8 3 1 6 4 7 0 5 nivel 0 movimiento nulo hecho 0))
        (assert (robotIA positionR 1 1 positionBox b 4 3 b 11 2 positionEnemies eny 4 2 eny 8 2 ammo 2 lastmove null level 0))
        (assert (max-depth ?prof))
        (assert (stairs-location 3 1 7 1 2 2))
        (assert (void-location vd 5 2 3 3))
        (assert (grid-dimension-depth 11 4))
        
)