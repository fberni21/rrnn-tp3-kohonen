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



// vim: lbr
