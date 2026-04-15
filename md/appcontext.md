# Documentación de Arquitectura y Funcionamiento (generada con Copilot.)

## Proyecto: IntranetAppServer

---

### 1. Introducción

IntranetAppServer es una solución desarrollada en Visual Basic 6, estructurada bajo principios de programación orientada a objetos y pensada para aplicaciones empresariales de alto nivel de personalización y flexibilidad. El sistema combina un núcleo de ejecución (appcontext) con motores de scripting (VBScript/JScript), permitiendo la extensión dinámica del comportamiento a partir de la metadata y la modelización de la aplicación.

---

### 2. Clases Principales y Roles

#### 2.1 appcontext (Contexto Principal)
- Es el núcleo de la aplicación, encargado de orquestar todas las operaciones durante la ejecución.
- Expone métodos y propiedades públicas para la interacción tanto de scripts como de otras clases del sistema.
- Permite el acceso y control de todas las funcionalidades relevantes mediante composición de objetos.

#### 2.2 appserver y appremote (Runtimes)
- **appserver**: Diseñada para responder a solicitudes web (modelo request/response). Su ciclo de vida es: iniciar, procesar una solicitud y responder.
- **appremote**: Pensada para procesos persistentes o batch. Mantiene una instancia de appcontext viva, sobre la cual se pueden procesar múltiples comandos o tareas secuenciales.
- Ambas inicializan una instancia de appcontext y exponen la funcionalidad de la aplicación mediante ella.

#### 2.3 Motor de scripting
- Utiliza motores compatibles con VBScript y JScript.
- Permite la ejecución de scripts definidos en la metadata/modelización.
- Los scripts interactúan directamente con appcontext y, a través de este, con todo el árbol de objetos y servicios de la aplicación.

---

### 3. Interacción entre Componentes

1. **Inicio**
   - El runtime (`appserver` o `appremote`) instancia `appcontext`.
   - Se inicializan componentes, conexiones a base de datos y carga de metadatos.

2. **Procesamiento**
   - **Web**: Se procesa cada solicitud usando appcontext y se responde.
   - **Batch/process**: Se ejecutan tareas múltiples sobre la misma instancia de appcontext.

3. **Ejecución de scripts**
   - Los scripts definidos en la capa de metadata se ejecutan en el contexto del motor de scripting.
   - Estos scripts pueden llamar a métodos/properties públicas de appcontext y manipular cualquier objeto expuesto.

---

### 4. Árbol de clases y funcionalidades principales

- **appcontext**: Nodo raíz que expone instancias de clases funcionales (explorador, objetos, workflow, reportes, buscador, etc).
  - **explorador**: Gestión y verificación de estructuras (tablas, vistas, parámetros).
  - **tableclass**: Definición y verificación de tablas (trabaja sobre modelo o base real).
  - **funciones, transac, objetos, etc.**: Clases para lógica de negocio, persistencia, operaciones de usuario y sistema.

---

### 5. Scripting y metadata

- Los scripts pueden ser VBScript/JScript y se definen en la metadata/modelización.
- El motor de scripting está integrado con appcontext, permitiendo acceso a todo el entorno de ejecución y servicios del sistema.

---

### 6. Ejemplo de flujo típico

#### 6.1 Web (appserver)
1. Un conector web (ISAPI, CGI) instancia appserver.
2. appserver crea una instancia de appcontext.
3. Se procesa la solicitud invocando métodos en appcontext.
4. Si la metadata requiere lógica adicional, se ejecuta un script mediante el motor de scripting, accediendo a appcontext.
5. Se genera y devuelve la respuesta al cliente.

#### 6.2 Batch/process (appremote)
1. Un proceso batch instancia appremote.
2. appremote mantiene una instancia de appcontext viva.
3. Se ejecutan múltiples comandos/tareas contra dicha instancia, con lógica personalizada vía scripting.
4. El proceso finaliza cuando no se requieren más ejecuciones.

---

### 7. Ventajas de la arquitectura

- **Extensibilidad**: Permite agregar lógica a partir de la metadata/modelización sin recompilar el núcleo.
- **Reutilización**: appcontext centraliza la funcionalidad y evita duplicaciones de código.
- **Flexibilidad**: Soporta tanto procesamiento web (request/response) como batch/persistente.
- **Integración**: El scripting puede acceder a todo el contexto y servicios del sistema.

---

### 8. Diagrama simplificado

```
[appserver/appremote]
        |
   [appcontext]
   /    |     \
explorador objetos ...
   |
tableclass
```
El motor de scripting puede interactuar con cualquier rama a través de appcontext.

---

### 9. Conclusión

IntranetAppServer es un framework robusto y flexible, pensado para aplicaciones empresariales modernas, con alta capacidad de personalización y extensión dinámica, gracias al motor de scripting y la exposición de todo el árbol de objetos a la capa de metadata/modelización.

---

## Anexos

- [Documentación avanzada TConsulta](./tconsulta.md): Descripción técnica, patrones de uso y ejemplos prácticos sobre la clase TConsulta y su integración en el framework.
