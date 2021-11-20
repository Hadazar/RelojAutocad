	
;Funci�n que extrae la hora (horas, minutos y segundos) en una lista
(defun partir(tiempo / entero smh x)

  ;Se crea una lista, una variable con la fecha y hora, y otra con la parte entera de este n�mero (es decir, solo con la fecha)
  (setq smh '())
  (setq x tiempo)
  (setq entero(atoi(rtos tiempo)))

  ;Se extraen sucesivamente las horas, los minutos y los segundos en cada etapa del ciclo, y se guardan en la lista antes creada
  (repeat 3
    
    (setq x(- x entero))
    (setq x(* 100 x))
    (setq entero(atoi(rtos x)))
    (setq smh(cons entero smh))
    
  )
)

;Funci�n que convierte un n�mero (que representa las horas, los minutos o los segundos) en su �ngulo equivalente de inclinaci�n en pi-radianes
(defun conversion(numero / angulo)
  
  (setq angulo (* pi (/ numero 30.0)))
  
)

;Funci�n que rota un objeto dado (horero, minutero o segundero) en un �ngulo dado (definido implicitamente por el n�mero)
(defun rotar(objeto numero / propiedades)

  (setq angulo(conversion numero))
  (setq propiedades (entget objeto))
  (setq propiedades (subst (cons 50 angulo) (assoc 50 propiedades) propiedades ))
  (entmod propiedades)

)

;Funci�n que edita el texto del reloj digital
(defun digi(digital hora / propiedades)

  (setq propiedades (entget digital))
  (setq propiedades (subst (cons 1 hora) (assoc 1 propiedades) propiedades ))
  (entmod propiedades)

)

;Se cargan en variables todos los entity name de los objetos que se van a modificar
(setq eje(entnext))
(setq minutero (entnext eje))
(setq segundero (entnext minutero))
(setq horero (entnext segundero))
(setq digital1 (entnext horero))

;Se le solicita al usuario una duraci�n de funcionamiento en minutos
(setq duracion (* 60 (getint "Por favor introduzca la duraci�n de funcionamiento del reloj (en minutos): ")))

;Se encapsula todo en un ciclo, para actualizar el dibujo cada segundo
(repeat duracion

  ;Se extrae la fecha y hora del sistema, y se crea una lista con las horas, minutos y segundos
  (setq tiempo(getvar "cdate"))
  (setq smh(partir tiempo))

  ;Se extraen las horas, los minutos y los segundos en variables independientes
  (setq segundos (car smh))
  (setq minutos (+ (car (cdr smh)) (/ segundos 60.0)))
  (setq horas (+ (caddr smh) (/ minutos 60.0)))

  ;Se crea el texto para editar el reloj digital
  (setq hora (strcat (rtos (caddr smh)) ":" (rtos (car (cdr smh))) ":" (rtos (car smh)) "\\P"))
  (digi digital1 hora)

  ;Se rotan el segundero, minutero y horero
  (rotar Segundero (- 60 segundos))
  (rotar Minutero (- 60 minutos))
  (rotar Horero (* 5.0 (- 60 horas)))

  ;Se genera un retardo de un segundo
  (command "_delay" 1000)
)