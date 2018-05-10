# Algoritmos de optimización: heurística y multi-objetivo
Descripción y códigos de los algoritmos de optimización heurística y multi-objetivo. 

# Optimización heurística

Son algoritmos que encuentran soluciones intermedias sin definir si éste es el óptimo global en medio del algoritmo.

Características:
- Usan aproximaciones
- No deterministas
- No genéricos (no específicos a un problema)

### Búsqueda aleatoria

```cpp
while(!isMet(stop_criteria)){
  x = generaCandidatoAleatorio();
  if(fObj(x) < fOBj(current_best_candidate)){
    current_best_candidate = x;
  }
}
```

## Algoritmos de optimización moderna

PSO, UPSO, HS

## Algoritmos evolutivos

Aprender a adaptar la población hacia un fitness.

Características: 

- Basado en población
- Orientado en el fitness
- Variation driven

### Algoritmo evolutivo genérico (Generic EA)

```cpp
// 1. Inicializar la población P con individuos aleatorios (dentro del rango)
// 2. Evaluar el fitness de cada individuo

while(!isMet(stop_criteria)){
  // 3. Seleccionar los padres de la población actual
  // 4. Aplicar a los padres los operadores evolutivos para generar un nuevo individuo hijo
  // 5. Evaluar al hijo
  // 6. Seleccionar individuos para la nueva población
}
```

### Evolution Stategy (ES) - Estrategia evolutiva

- La mutación es la fuente principal de variación
- La selección de individuos para recombinar es imparcial
- Los individuos consisten de parámetros de decisión + parámetros de estrategia

# Optimización multi-objetivo

Encontrar un vector de variables que satisfaga un conjunto de restricciones (igualdad/desigualdad) y optimice un vector de funciones objetivo, de manera que se obtengan valores aceptables para todos los objetivos.

Categorías de objetivos:
- sin conflicto
- totalmente en conflicto
- parcialmente en conflicto

Pueden variar los objetivos (maximizar/minimizar). **Es necesario usar el principio de dualidad para hacer que todos sean del mismo tipo.**

```
maximizar (f(x)) es equivalente a minimizar (-f(x))
```

### Espacios
- espacio de las variables de decisión
- espacio de objetivos

### Dominación
Se usa para determinar si una solución domina sobre otra. 

*X1 domina sobre X2 si para todas las funciones objetivo, no hay ninguna en donde X2 domine sobre X1, pero sí hay al menos una en donde X1 domina sobre X2.*

#### Dominación fuerte
X1 domina fuertemente sobre X2 si X1 es mejor que X2 en **todos** los objetivos.

#### Dominación débil
X1 domina débilmente sobre X2 si X1 es mejor que X2 en **al menos en un objetivo y no es peor en el resto de los objetivos**. 

### Pareto

#### Óptimo de Pareto 
X1 es el óptimo de Pareto si no hay ninguna solución X2 que la domine sin empeorar en otros aspectos.

#### Conjunto óptimo de Pareto
El conjunto de soluciones que son pareto-óptimas.

#### Frente de Pareto
La gráfica de las soluciones que conforman el conjunto óptimo de Pareto.

### Soluciones especiales

#### Vector objetivo ideal
El vector de soluciones para el vector de funciones objetivo si optimizaramos cada una de estas individualmente (como si no fueran multi-objetivo).

#### Vector objetivo útopico
Si obtenemos un vector que tenga mejores valores que el ideal, se le denomina utópico.

#### Vector objetivo Nadir
En un problema de minimización: el **vector objetivo ideal** representa el límite inferior de los objetivos; mientras que el **vector objetivo Nadir** representa el límite superior de los objetivos. En un problema de maximización, sería lo inverso.

### Algoritmos evolutivos
Se usan en problemas de optimización multi-objetivo para encontrar varias soluciones en el conjunto óptimo de Pareto en una sola ejecución. PErmiten esto porque están basados en una población de soluciones. 

#### Elitismo
- Conserva las mejores soluciones encontradas. 
- En multi-objetivo: todas las soluciones no-dominadas son igual de buenas.
  - Selección más
  - Población secundaria
 
##### Selección más
- Se unen las poblaciones padre e hija, **se forma una nueva población P.**
- A partir de P, se determinan soluciones **no-dominadas. Éstas se seleccionan.**

##### Población secundaria
- En una población P2 se guardan todas las soluciones no-dominadas.
- Sólo se guarda una solución si ésta es no-dominada con respecto a los individuos existentes.
- Si la insertada domina sobre otros existentes, se eliminan los existentes.

### Métricas de evaluación de algoritmos multi-objetivos

#### Consideraciones de diseño
 - Minimizar la distancia del frente de Pareto generado al frente de Pareto real
 - Maximizar la diversidad entre las soluciones
 - Maximizar el número de soluciones contenidas en el frente de Pareto generado

#### Tasa de error

- Porcentaje (%) de soluciones obtenidas que **no** forman parte del frente de Pareto.

![](https://latex.codecogs.com/gif.latex?ER&space;=&space;\frac{\sum_{i=1}^{n}&space;e_{i}}{n})
- n = número de soluciones encontradas por el algoritmo
- e<sub>i</sub> toma un valor de 0 si la i-ésima solución no está en el frente de Pareto, y un valor de 1 si sí forma parte.

#### Distancia generacional

- Distancia promedio entre el **frente de Pareto generado** y el **frente de Pareto verdadero**.

![](https://latex.codecogs.com/gif.latex?GD&space;=&space;\frac{\sum_{i=1}^{n}&space;d_{i}}{n})
- n = número de soluciones encontradas por el algoritmo
- d<sub>i</sub> = medida de distancia entre la i-ésima solución y la solución más cercana contenida en el **frente de Pareto verdadero**.

#### Hiper-volumen

- Estimado del volumen (en el espacio de objetivos) cubierto por los miembros del frente de Pareto generado
- Sirve cuando todos los objetivos tienen que ser minimizados

![](https://latex.codecogs.com/gif.latex?HV&space;=&space;volumen(\cup&space;_{i=1}^{n}&space;v_{i}))

- n= número de soluciones encontradas por el algoritmo
- v<sub>i</sub> = cada solución i hay un hiper-cubo v<sub>i</sub>

#### Espaciamiento

- Estimación de la diversidad entre las soluciones no-dominadas encontradas.
- Usa la distancia relativa entre las soluciones consecutivas.

#### Espaciamiento

- Métrica que permite estimar la diversidad entre las soluciones


#### Esparcimiento

- Métrica que permite estimar la diversidad entre las soluciones

#### Conjunto cubierto

- Compara dos conjuntos no-dominados
- Calcula la fracción en la que uno es cubierto (dominado) por el otro
- Se debe realizar dos veces: C(A, B) y C(B, A)
