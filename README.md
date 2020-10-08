  
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
