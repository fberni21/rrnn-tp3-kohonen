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

// vim: lbr
