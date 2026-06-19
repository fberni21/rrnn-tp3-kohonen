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
#text(style: "italic")[
  En este trabajo práctico se analiza la capacidad de autoorganización y preservación topológica de las Redes de Kohonen aplicadas a problemas de modelado de distribuciones, optimización combinatoria y agrupamiento de datos. En primer lugar, se evalúa el aprendizaje de distribuciones uniformes sobre diversas geometrías bidimensionales, examinando el impacto de la equivalencia homeomorfa en la convergencia de la red. Luego, se aborda el Problema del Viajante de Comercio para 200 ciudades mediante una topología unidimensional en anillo, validando la ruta aproximada obtenida mediante el Teorema de Beardwood-Halton-Hammersley. Finalmente, se implementa una grilla bidimensional para la reducción de dimensionalidad y el agrupamiento de un espacio de 100 dimensiones, utilizando la matriz de distancia unificada para contrastar exitosamente la estructura de clusters identificada mediante PCA.
]

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

El último experimento realizado en esta sección consistió en entrenar la red sobre un conjunto de datos disconexo. En particular, se eligió como conjunto de entrenamiento una distribución uniforme sobre tres formas de estrella, configuradas triangularmente. Se utilizaron los mismos parámetros que para el caso anterior, pero con una tasa de aprendizaje de 0.1.

La @fig:stars muestra la evolución del mapa de preservación de topología a lo largo de las épocas 1, 2, 300 y 1000. En este caso, dado que la distribución de entrenamiento no es una figura conexa, vemos que las neuronas logran distribuirse dentro de cada "pieza" enforma correcta, pero deben conectarse entre vecinas uniendo las diferentes partes. La grilla, nuevamente, no puede "romperse" para separar las regiones disconexas. La preservación de la topología no es perfecta puesto que, como en el caso anterior, no hay un homeomorfismo entre el cuadrado (grilla) que forman las neuronas naturalmente, y la figura disconexa que tratan de aprender.

#figure(
  placement: auto,
  image("img/ej1/stars.svg", width: 100%),
  caption: [Evolución del mapa de preservación de topología durante el entrenamiento de una red de Kohonen con datos uniformemente distribuidos entre tres estrellas.],
) <fig:stars>

= Resolución del Problema del Viajante de Comercio con Red de Kohonen

El problema del viajante de comercio (o _travelling salesman problem_, TSP) consiste, dada una lista de nodos (o ciudades) y las distancias entre ellos, en obtener el camino más corto que visita exactamente una vez cada nodo, regresando finalmente al la ciudad de origen. Este problema es notoriamente complejo de resolver cuando aumenta la cantidad $N$ de ciudades, pues pertenece a la clase computacional _NP-hard_. Por este motivo, se buscan formas de resolver más eficientemente el problema, aunque sea en forma aproximada.

Una forma de hacerlo, es entrenando una red de Kohonen con neuronas dispuestas en forma de anillo, es decir, donde cada neurona tiene dos vecinas (derecha e izquierda), conectadas en línea, y donde la primera y la última neuronas también se consideran vecinas para cerrar el camino. Si se entrena a la red mostrándole las diferentes posiciones de las ciudades, las neuronas ajustarán sus pesos de manera tal que se alineen aproximadamente con sus ubicaciones. Si las condiciones del entrenamiento son adecuadas, la red convergerá a una solución aproximada relativamente buena al TSP, uniendo los nodos en un camino de longitud no demasiado larga.

Se modificó entonces la red implementada en la sección anterior, de manera tal que permita el entrenamiento de redes unidimensionales en forma de anillo. En primer lugar, se entrenó con 20 ciudades, representadas por puntos elegidos al azar dentro del cuadrado $[-1, 1]^2$. Se entrenó durante 1000 épocas, utilizando una varianza inicial de 5 y una tasa de aprendizaje de 0.04. Debido a que los pesos de las neuronas no convergen exactamente a las posiciones de las ciudades, es conveniente elegir un número mayor de neuronas que de ciudades, por lo que se utilizaron 40 neuronas.

La~@fig:20_map muestra la evolución del camino, superpuesto sobre las 20 ciudades. El camino está formado por las uniones entre los pesos de las neuronas vecinas. En un principio, los pesos se inciarion con forma circular. Tras 20 eṕocas, vemos como las neuronas ajustan sus pesos deformando el anillo, que continúa hasta converger, en la época 1000, a una solución muy adecuada del TSP. Si se mira adecuadamente, se verá que el camino no pasa exactamente sobre las ciudades, pero la solución es sorprendentemene adecuada dado que en ningún momento se le "indica" a la red que debe minimizar la longitud del camino. El autor no observa de forma sencilla un camino más corto que el obtenido por la red de Kohonen.

#figure(
  placement: auto,
  image("img/ej2/20_map.svg", width: 100%),
  caption: [Evolución del camino aprendido por la red para el TSP de 20 ciudades.],
) <fig:20_map>

En la~@fig:20_length se muestra la evolución del largo del camino formado por la red. Notar que aumenta casi monotónicamente hasta converger. Este aumento se debe a que inicialmente el camino forma un anillo que no pasa por ninguna de las ciudades, lo que lo hace muy corto. Posteriormente, la ruta comienza a acercarse a los nodos, lo que requiere de un estiramiento del camino. Al final, la red converge a un camino de longitud 8.33.

#figure(
  placement: auto,
  image("img/ej2/200_length.svg", width: 50%),
  caption: [Evolución de la longitud del camino aprendido por la red para el TSP de 20 ciudades.],
) <fig:20_length>

El segundo experimento consistió en aumentar el tamaño del conjunto de ciudades a visitar a 200, un número considerablemente más difícil de atacar con algoritmos exactos. El número de neuronas utilizado fue de 400, nuevamente para mejorar el acercamiento del camino a las posiciones de las ciudades. La varianza inicial fue de 100, con una tasa de aprendizje de 0.2. Se entrenó nuevamente durante 1000 épocas.

La~@fig:200_map muestra la evolución del camino aprendido por la red, superpuesto con las 200 ciudades para visitar. Luego del inicio circular, vemos como los pesos se van deformando a lo largo de las épocas, y al final se obtiene un camino que pasa cerca de prácticamente todas las ciudades. Al igual que en el caso anterior, el camino no pasa exactamente por las posiciones de las ciudades. Sin embargo, como solución aproximada del TSP el resultado es satisfactorio, y vuelve a ser difícil encontrar intuitivamente una solución mejor.

#figure(
  placement: auto,
  image("img/ej2/200_map.svg", width: 100%),
  caption: [Evolución del camino aprendido por la red para el TSP de 200 ciudades.],
) <fig:200_map>

En la~@fig:200_length se muestra la evolución del largo del camino formado por la red. Como en el caso anterior, aumenta casi monotónicamente hasta la convergencia. El valor final alcanzado es de 21.3. Gracias al Teorema de Beardwood-Halton-Hammersley~@Beardwood_Halton_Hammersley_1959, se sabe que, en promedio y para $N$ grande, el camino cerrado más corto $L_N$ está dado por la expresión
$ L_N approx beta sqrt(A N), $ <eq:bhh>
con $A$ el área de la región (en este caso, $A=4$), y $beta$ una constante cuyo valor es aproximadamente 0.7, según estimaciones computacionales~@applegate2011traveling. Utilizando esta aproximación, vemos que el camino más corto en promedio será $L_(200) approx 19.8$, un valor cercano al obtenido por la red. Cabe notar que el resultado de~@eq:bhh es apenas una aproximación. Sin embargo, da un orden de magnitud para la solución óptima, y permite dar confianza en que el resultado obtenido por la red de Kohonen no es demasiado lejano al ideal.

#figure(
  placement: auto,
  image("img/ej2/200_length.svg", width: 50%),
  caption: [Evolución de la longitud del camino aprendido por la red para el TSP de 200 ciudades.],
) <fig:200_length>

= Reducción de dimensionalidad y _clustering_ usando Red de Kohonen

Si se desea reducir la dimensionalidad de los datos y hallar grupos entre los datos (_clustering_), pueden utilizarse redes de Kohonen. En particular, en este caso se tomará un conjunto de datos de 100 dimensiones, y se entrenará una red de Kohonen con neuronas dispuestas en una grilla bidimensional, con el objetivo de aprender la topología subyacente de los datos de entrenamiento. Si los datos pueden ser bien representados en dos dimensiones, la red podrá aprender correctamente su topología, lo que permitirá posteriormente analizar la presencia de _clusters_ en forma visual, algo imposible si se trabaja con el conjunto original.

Para realizar _clustering_ sobre los datos reducidos, puede utilizarse la matriz de distancia unificada $bold(U)$, construida a partir de los pesos de la red de la siguiente manera
$ U_(i, j) = 1/N_v sum_((m, n) in V(i, j)) d(arrow(w)_(i, j), arrow(w)_(m, n)), $
donde $V(i, j)$ es el conjunto de vecinas (arriba, abajo, derecha e izquierda, en caso de que existan) de la neurona $(i, j)$, $N_v$ es la cantidad de vecinas (4, excepto para las de los bordes), $arrow(w)$ son los pesos, y $d(dot, dot)$ es la distancia euclídea. Esta matriz tendrá valores bajos cuando las neuronas se organizan cerca unas de otras, sugiriendo la presencia de un grupo. En cambio, en los bordes entre grupos, neuronas vecinas tenderán a tener pesos considerablemente diferentes dependiendo a qué grupo hayan sido "atraídos" sus pesos. Por lo tanto, allí veremos valores grandes de $bold(U)$ que sugerirán una separación entre _clusters_.

Para la reducción de dimensiones, se entrenó una red de Kohonen con una grilla de $30 times 30$ neuronas, durante 500 épocas a una tasa de aprendizaje de 0.1 y con una varianza inicial de 5. Posteriormente, se calculó la matriz $bold(U)$, la cual se muestra la @fig:u_matrix#footnote([Por simplicidad, se ignoraron los bordes de la matriz, computando solo los valores $U_(i, j)$ para las neuronas centrales. Esto no cambia el resultado visual, dado que el comportamiento de interés ocurre lejos de las neuronas de borde.]). Puede observarse que hay cuatro regiones bien marcadas (valores bajos de las entradas de $bold(U)$, separados por fronteras de valores altos. Podemos entonces, con cierta certeza, asegurar que hay cuatro _clusters_ en el conjunto de datos, y que además pueden ser bien representados en solo dos dimensiones.

#grid(columns: (5fr, 4fr), gutter: 1.5em,
grid.cell([
  #figure(
    placement: auto,
    image("img/ej3/U.svg", width: 100%),
    caption: [Matriz $U$ de una red de Kohonen entrenada sobre el conjunto de 100 dimensiones.],
  ) <fig:u_matrix>
]),
grid.cell([
  #figure(
    placement: auto,
    image("img/ej3/pca.svg", width: 100%),
    caption: [Reducción de dimensionalidad con PCA del conjunto de 100 dimensiones.],
  ) <fig:pca>
]))

A modo de comparación, se realizó una reducción de dimensiones utilizando análisis de componentes principales (PCA). La @fig:pca muestra el conjunto de datos reducido a sus dos primeras componentes principales, las cuales explican el 52.9 % de la varianza total. Puede verse que aparenta haber cuatro grupos bien definidos. La primera componente principal permite distinguir entre tres, mientras que el agregado de la segunda componente distingue un cuarto grupo. Esto ayuda a confirmar el resultado obtenido por el algoritmo de Kohonen, que además lo hace sin explicitar en ningún momento el objetivo de encontrar direcciones de máxima varianza.

#bibliography("refs.bib")

// vim: lbr
