#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      _Franco Berni_
      #h(1fr)
      TP3: Redes de Kohonen
    ]
  }
)
#set text(
  font: "New Computer Modern",
  size: 10pt,
  lang: "es",
  region: "AR",
)
#set par(
  justify: true,
)

#show heading: smallcaps
#show heading: set text(weight: "regular")
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")
#set figure(numbering: "1")

#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el == none or el.func() != eq { return it }
  link(el.location(), numbering(
    el.numbering,
    ..counter(eq).at(el.location())
  ))
}

#set document(title: [Trabajo Práctico 3:\ Redes de Kohonen])

#show title: smallcaps
#show title: set text(size: 17pt)

#align(center)[
  #image("img/fiuba.png", width: 60%)

  #title()

  Franco Berni \
  #link("mailto:fberni@fi.uba.ar") \
  110007
]

#v(2em)
#align(center)[#smallcaps[Resumen]]
#text(style: "italic")[]

#let sgn = math.op("sgn")
#let erf = math.op("erf")

= Aprendizaje de distribuciones uniformes con Red de Kohonen

Las redes de Kohonen muestran un comportamiento emergente de auto-organización, preservando la topología de los datos de entrenamiento. Esto significa que las neuronas se "organizan" de forma tal que las activaciones de neuronas vecinas son "similares" para eventos que se encuentran cerca en el espacio. Para evaluar esto, se desarrolló una red de Kohonen, la cual se entrenó con diferentes distribuciones uniformes en formas geométricas, analizando la preservación de la topología durante y al finalizar el entrenamiento.

== Comportamiento de la red sobre figuras geométricas básicas

Como primer ejemplo, se entrenó a la red con un conjunto de datos aleatorios uniformemente distribuidos sobre el círculo unitario. El entrenamiento utilizó una función de vecindad gaussiana con una varianza que decae linealmente a medida que transcurren las épocas, desde un valor inicial de 1.0 hasta anularse al final. La tasa de aprendizaje empleada fue 0.1, y el entrenamiento duró 800 épocas. Se utilizaron 25 neuronas, distribuidas en una grilla de $5 times 5$.

En la @fig:circle se muestra el conjunto de datos de entrenamiento y el mapa topológico de los pesos para las épocas 1, 2, 300 y 800. Los pesos se encuentran conectados si son vecinos, definiendo como "vecino" a las cuatro neuronas adyacentes lateral o verticalmente. Inicialmente, los pesos fueron elegidos al azar, por lo que no hay ningún tipo de estructura entre las neuronas. Apenas una iteración después, ya vemos que los pesos comienzan a distribuirse en forma uniforme, aunque aún no cubriendo la totalidad del círculo. Este cambio repentino se debe a la alta varianza inicial del entrenamiento, que afecta a neuronas con un largo alcance. En la iteración 300, la red ya tiene una cobertura amplia y uniforme del círculo, pero tardará 500 iteraciones más ---debido a la disminución de la varianza de la función vecindad--- en converger. En la iteración 800 vemos como las neuronas se encuentran casi perfectamente distribuidas sobre toda la distribución de datos originales, en forma uniforme y respetando bastante bien la estructura topológica (las neuronas vecinas se encuentran cerca unas de otras en el espacio de los pesos). Notar que hay excepciones, sobre todo cerca del centro de la figura, donde neuronas vecinas no quedan tan cerca, aunque es un fenómeno infrecuente.

#figure(
  placement: auto,
  image("img/ej1/circle.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos en un círculo.],
) <fig:circle>

Como segundo experimento, se realizó el mismo procedimiento pero con un conjunto de datos uniforme sobre el cuadrado $[-1, 1]^2$. Los parámetros y función vecindad utilizados fueron los mismos que con el círculo, modificando la tasa de aprendizaje a 0.01 y el número de épocas a 1000.

La @fig:square muestra la evolución del mapa de preservación de topología y los datos de entrenamiento, para las épocas 1, 2, 300 y 1000. Similarmente al caso anterior, en un principio tenemos neuronas que responden desordenadamente y no siguen la topología de los datos. En la segunda iteración vemos como las neuronas comienzan a organizarse, pero todavía están lejos de un orden. En este caso, la organización tarda más en lograrse debido a la reducción de la tasa de aprendizaje. Para la época 300, las neuronas ya tienen una topología cuadrada como la de los datos de entrenamiento, pero "comprimida". Tardarán unas 700 épocas más en converger a la distribución final, que preserva la distribución original en forma correcta. Las neuronas vecinas en la grilla son también cercanas en el espacio de los pesos, tal como se busca.

#figure(
  placement: auto,
  image("img/ej1/square.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos en un cuadrado.],
) <fig:square>

El tercer experimento consistió en replicar el anterior, pero con un conjunto de datos uniformemente distribuidos sobre un triángulo de vértices $(-1, -1)$, $(0, 1)$, y $(1, -1)$. Los demás parámetros utilizados fueron los mismos que para el cuadrado.

La @fig:triangle muestra la evolución de los pesos sobre los datos de entrenamiento, para las épocas 1, 2, 300 y 1000. El comportamiento observado es similar al visto para el cuadrado. Es notable cómo las neuronas, distribuidas en su espacio nativo como una grilla, logran aprender una figura con un vértice menos, comprimiéndose y ajustando sus pesos para mapear la topología del triángulo. Observar que no lo hace perfectamente, viéndose cerca del vértice inferior derecho un par de neuronas vecinas que se encuentran a una distancia considerable en el espacio de pesos.

#figure(
  placement: auto,
  image("img/ej1/triangle.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos en un triángulo.],
) <fig:triangle>

== Comportamiento de la red para una distribución no homeomorfa a un cuadrado

El cuarto experimento realizado fue el entrenamiento sobre un conjunto de datos uniforme sobre una corona circular. El interés de este ejemplo es ver cómo logran distribuirse los pesos cuando hay orificios en la distribución, siendo que la grilla de neuronas no tiene ningún orificio. Los parámetros utilizados coinciden con los de los dos ejemplos anteriores.

La @fig:ring muestra la evolución del mapa de preservación de topología a lo largo de las épocas 1, 3, 300 y 1000. Aquí vemos un resultado muy interesante. Como la grilla de neuronas no es topológicamente equivalente a la corona circular (difieren en la cantidad de orificios), la red es incapaz de aprender la distribución con el mismo nivel de exactitud que lo podía hacer en los casos anteriores, donde sí había equivalencia#footnote([Recordar que dos objetos son topológicamente equivalentes u homeomorfos si cuentan con la misma cantidad de orificios, por lo que el círculo, el cuadrado y el triángulo son equivalentes al cuadrado que forma la grilla de neuronas.]). La grilla debe mantenerse "intacta", por lo que no puede bordear el agujero de la distribución objetivo, produciendo que una neurona quede localizada el centro, donde la densidad de datos es nula y no se esperaría _a priori_ ver neuronas.

#figure(
  placement: auto,
  image("img/ej1/ring.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos en una corona circular.],
) <fig:ring>

== Comportamiento de la red para figuras disconexas

El último experimento realizado en esta sección consistió en entrenar la red sobre un conjunto de datos disconexo. En particular, se eligió como conjunto de entrenamiento una distribución uniforme sobre tres formas de estrella#footnote([Naturalmente, la elección de las formas se hizo en función de las circunstancias deportivas que transcurren al momento del desarrollo de este trabajo.]), configuradas en forma de pirámide. Se utilizaron los mismos parámetros que para el caso anterior, pero con una tasa de aprendizaje de 0.1.

La @fig:stars muestra la evolución del mapa de preservación de topología a lo largo de las épocas 1, 2, 300 y 1000. En este caso, dado que la distribución de entrenamiento no es una figura conexa, vemos que las neuronas logran distribuirse dentro de cada "pieza" enforma correcta, pero deben conectarse entre vecinas uniendo las diferentes partes. La grilla, nuevamente, no puede "romperse" para separar las regiones disconexas. La preservación de la topología no es perfecta puesto que, como en el caso anterior, no hay un homeomorfismo entre el cuadrado (grilla) que forman las neuronas naturalmente, y la figura disconexa que tratan de aprender.

#figure(
  placement: auto,
  image("img/ej1/stars.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos entre tres estrellas.],
) <fig:stars>

= Resolución del Problema del Vendedor Viajero con Red de Kohonen

El problema del vendedor viajero (o _travelling salesman problem_, TSP) consiste, dada una lista de nodos (o ciudades) y las distancias entre ellos, en obtener el camino más corto que visita exactamente una vez cada nodo, regresando finalmente al la ciudad de origen. Este problema es notoriamente complejo de resolver cuando aumenta la cantidad $N$ de ciudades, pues pertenece a la clase computacional _NP-hard_. Por este motivo, se buscan formas de resolver más eficientemente el problema, aunque sea en forma aproximada.

Una forma de hacerlo, es entrenando una red de Kohonen con neuronas dispuestas en forma de anillo, es decir, donde cada neurona tiene dos vecinas (derecha e izquierda), conectadas en línea, y donde la primera y la última neuronas también se consideran vecinas para cerrar el camino. Si se entrena a la red mostrándole las diferentes posiciones de las ciudades, las neuronas ajustarán sus pesos de manera tal que se alineen aproximadamente con sus ubicaciones. Si las condiciones del entrenamiento son adecuadas, la red convergerá a una solución aproximada relativamente buena al TSP, uniendo los nodos en un camino de longitud no demasiado larga.

Se modificó entonces la red implementada en la sección anterior, de manera tal que permita el entrenamiento de redes unidimensionales en forma de anillo. En primer lugar, se entrenó con 20 ciudades, representadas por puntos elegidos al azar dentro del cuadrado $[-1, 1]^2$. Se entrenó durante 1000 épocas, utilizando una varianza inicial de 10 y una tasa de aprendizaje de 0.04. Debido a que los pesos de las neuronas no convergen exactamente a las posiciones de las ciudades, es conveniente elegir un número mayor de neuronas que de ciudades, por lo que se utilizaron 40 neuronas.

La~@fig:20_map muestra la evolución del camino, superpuesto sobre las 20 ciudades. El camino está formado por las uniones entre los pesos de las neuronas vecinas. En un principio, los pesos son aleatorios por lo que el camino es completamente caótico. Tras 20 eṕocas, vemos como las neuronas ajustan sus pesos hasta formar un anillo, que continúa deformándose hasta converger, en la época 1000, a una solución muy adecuada del TSP. Si se mira adecuadamente, se verá que el camino no pasa exactamente sobre las ciudades, pero la solución es sorprendentemene adecuada dado que en ningún momento se le "indica" a la red que debe minimizar la longitud del camino. El autor no observa de forma sencilla un camino más corto que el obtenido por la red de Kohonen.

#figure(
  placement: auto,
  image("img/ej2/20_map.svg", width: 100%),
  caption: [Evolución del camino aprendido por la red para el TSP de 20 ciudades.],
) <fig:20_map>

En la~@fig:20_length se muestra la evolución del largo del camino formado por la red. Notar que luego de bajar abruptamente, comienza a aumentar levemente hasta converger. Este aumento se debe a que inicialmente el camino forma un anillo que no pasa por ninguna de las ciudades, lo que lo hace muy corto. Posteriormente, la ruta comienza a acercarse a los nodos, lo que requiere de un estiramiento del camino. Al final, la red converge a un camino de longitud 8.13.

#figure(
  placement: auto,
  image("img/ej2/200_length.svg", width: 50%),
  caption: [Evolución de la longitud del camino aprendido por la red para el TSP de 20 ciudades.],
) <fig:20_length>

El segundo experimento consistió en aumentar el tamaño del conjunto de ciudades a visitar a 200, un número considerablemente más difícil de atacar con algoritmos exactos. El número de neuronas utilizado fue de 400, nuevamente para mejorar el acercamiento del camino a las posiciones de las ciudades. La varianza inicial fue de 50, con una tasa de aprendizje de 0.05. Se entrenó nuevamente durante 1000 épocas.

La~@fig:200_map muestra la evolución del camino aprendido por la red, superpuesto con las 200 ciudades para visitar. Luego del inicio aleatorio, vemos como los pesos se van "desenrollando" a lo largo de las épocas, y al final se obtiene un camino que pasa cerca de prácticamente todas las ciudades. Al igual que en el caso anterior, el camino no pasa exactamente por las posiciones de las ciudades, en algunos casos apenas acercándose ligeramente. Sin embargo, como solución aproximada del TSP el resultado es satisfactorio. Por otro lado, en este caso es más evidente que el algoritmo no alcanza una solución óptima. En particular, cerca del origen de coordenadas vemos que el camino se cruza sobre sí mismo, algo que intuitivamente parece ser mejorable.

#figure(
  placement: auto,
  image("img/ej2/200_map.svg", width: 100%),
  caption: [Evolución del camino aprendido por la red para el TSP de 200 ciudades.],
) <fig:200_map>

En la~@fig:200_length se muestra la evolución del largo del camino formado por la red. Como en el caso anterior, primero baja abruptamente, para luego aumentar ligeramente hasta la convergencia. El valor final alcanzado es de 21.1. Gracias al Teorema de Beardwood-Halton-Hammersley~@Beardwood_Halton_Hammersley_1959, se sabe que, en promedio y para $N$ grande, el camino cerrado más corto $L_N$ está dado por la expresión
$ L_N approx beta sqrt(A N), $ <eq:bhh>
con $A$ el área de la región (en este caso, $A=4$), y $beta$ una constante cuyo valor es aproximadamente 0.7, según estimaciones computacionales~@applegate2011traveling. Utilizando esta aproximación, vemos que el camino más corto en promedio será $L_(200) approx 19.8$, un valor cercano al obtenido por la red. Cabe notar que el resultado de~@eq:bhh es apenas una aproximación. Sin embargo, da un orden de magnitud para la solución óptima, y permite dar confianza en que el resultado obtenido por la red de Kohonen no es demasiado lejano al ideal.

#figure(
  placement: auto,
  image("img/ej2/200_length.svg", width: 50%),
  caption: [Evolución de la longitud del camino aprendido por la red para el TSP de 200 ciudades.],
) <fig:200_length>

#bibliography("refs.bib")

// vim: lbr
