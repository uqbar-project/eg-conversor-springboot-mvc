# Conversor de medidas en Spring Boot

[![Build Status](https://travis-ci.org/uqbar-project/eg-conversor-springboot-mvc.svg?branch=master)](https://travis-ci.org/uqbar-project/eg-conversor-springboot-mvc)

<img src="https://cloud.githubusercontent.com/assets/4549002/17750101/fa2f7334-6496-11e6-864f-6f57e8d7bc67.png" height="150" width="150"/>

 Conversor de unidades de medida que trabaja con servicios REST + templating a html con Spring MVC y [Thymeleaf](https://es.wikipedia.org/wiki/Thymeleaf)
 
# Thymeleaf

Thymeleaf es un motor de plantillas para aplicaciones, tanto web como standalone, construido sobre estándares HTML5. 

Nos provee el dialecto SpringStandard Dialect que usa el Spring Expression Language. Nos sirve para trabajar con Spring.

# Dominio

Tenemos la clase Conversor:

```xtend
@Accessors
class Conversor {
  Integer millas = 1

  def kilometros() {
    millas * 1.609344
  }
  
}
```

Que cuenta con el atributo millas (por defecto vale 1). Los kilometros se calculan en base a las millas.

# Modo de uso

## Cómo levantar

### Opción A: Desde Eclipse

1. Importar este proyecto en Eclipse como **Maven project**.
2. Ejecutar `org.uqbar.conversor.app.ConversorApplication`, que levanta servidor en el puerto 8080.

### Opción B: Desde línea de comandos

1. Generar jar con dependencias: `mvn clean compile assembly:single`
2. Ejecutar el jar generador: `java -jar target/conversor-xtrest-0.0.1-SNAPSHOT-jar-with-dependencies.jar`

Esta opción requiere menos recursos de sistema porque no es necesario ejecutar Eclipse.

## Cómo probar

![image](https://user-images.githubusercontent.com/26492157/88363584-ecaf1480-cd56-11ea-88a5-b898c2ca5d87.png)

La URL http://localhost:8080 nos redirige a http://localhost:8080/conversor y visualizamos la página donde podemos ingresar el valor en millas.

Al hacer click en el botón Convertir, se hace un submit del formulario, lo que provoca una llamada a http://localhost:8080/convertir. 

## Atributos del dialecto de ThymeLeaf

Vemos la definición del formulario:

```html
    <form action="#" th:action="@{/convertir}" th:object="${conversor}" method="post">
        <fieldset>
            <p for="titulo">Millas
                <input type="number" th:field="*{millas}" required="true" name="millas" class="form-control"
                    placeholder="Valor en millas" autofocus="autofocus" />
            </p>
            <p for="kilometros">Kilometros: 
            <strong><span class="lead" th:text="*{kilometros()}"></span></strong>
            </p>
            <button type="submit" class="btn btn-primary">Convertir</button>
        </fieldset>
    </form>
```

### `th:action`

Es la acción que se ejecuta al clickear en el boton "convertir". Le asginamos el valor `"@{/convertir}"` que es una expresión para redirigir a una URL. 

Esto nos dirige endpoint `/converitr`, haciendo un pedido POST.

### `th:object`

Representa el model object que se usa para recolectar los datos que se ingresan en el formulario (las millas).

También se usa para mostrar el valor de los kilómetros. 

Le seteamos `"${conversor}"`. El signo $ sirve para obtener una variable de contexto (también llamadas "atributos del modelo").

`th:object="${conversor}"` sería equivalente a la siguiente línea de código en SpEL (Spring Expression Language): 

```SpEL

(Conversor)context.getVariable("conversor")

```

Despúes veremos como se relaciona esto con la clase de dominio Conversor.

### `th:field`

Es un campo del formulario.

Le asignamos `"*{millas}"`. El * es una expresión de selección. Entre las llaves puedo poner un atributo o método del model object (el conversor).

También puedo seguir encadenando mensajes, pero en este caso no es necesario.

`*{millas}` es equivalente a `"${conversor.millas}"` y en SpEL a 

```SpEL

((Conversor)context.getVariable("conversor")).getMillas()

```

### `th:text`

Evalua la expresión que pongamos como valor y setea el resultado de esta evaluación como body del tag.

Lo usamos para mostrar el valor de los kilometros.

`th:text="*{kilometros()}"``.

## ConversorController

### @GetMapping("/")

```xtend
	@GetMapping("/")
	def redirectToConversor() {
		return 'redirect:/conversor'
	}
```

Es la ruta por defecto cuando ingresamos a http://localhost:8080. Nos redirige a "/conversor"

### @GetMapping("/conversor")

```xtend
	@GetMapping("/conversor")
	def index(Model model) {
		if (model.getAttribute("conversor") === null) {
			model.addAttribute(new Conversor)
		}
		return 'conversor'
	}
```
Va a renderizar la vista "conversor.html" que se encuentra en el directorio "templates".

Si el modelo no tiene el atributo "conversor" se le asigna una nueva instancia de Conversor con `model.addAttribute(new Conversor)`.

Si a `addAttribute` no le pasamos el nombre del atributo a agregar, lo determina en base al tipo concreto recibido con el método [getVariableName](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/Conventions.html#getVariableName-java.lang.Object-).

### @PostMapping("/convertir")

Al clickear en "convertir" hacemos un pedido POST a convertir:

```xtend
	@PostMapping("/convertir")
	def convertir(Conversor conversor, RedirectAttributes redirectAttributes) {
		redirectAttributes.addFlashAttribute(conversor) // addFlashAttribute me permite guardar un objeto y addAttribute solo primitivos
		redirectToConversor
	}
```

El método convertir recibe el model object de la vista que es del tipo Conversor. 

Agrega como atributo de redirección el conversor que recibió y nos redirige a "/conversor".

Esto genera que se vuelva a la página inicial con los kilómetros actualizados.
