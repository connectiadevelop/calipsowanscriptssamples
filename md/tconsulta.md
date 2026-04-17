# Documentación Técnica Avanzada: Clase TConsulta

## Propósito

La clase `TConsulta` es el componente central para el armado dinámico y flexible de consultas SQL en el framework, permitiendo desacoplar la lógica de acceso a datos del motor de base de datos. Facilita la generación de consultas complejas, joins, campos calculados y condiciones, y soporta distintos formatos de resultado según las necesidades del sistema.

---

## Métodos principales

- **addtabla(tabla As String)**
  - Agrega una tabla principal o adicional (para joins) a la consulta.
- **addconstante(campo As String, [alias As String])**
  - Incorpora un campo, expresión o valor constante al SELECT.
- **addcondicion(condición As String)**
  - Añade una condición al WHERE (se pueden sumar varias condiciones).
- **execute / exec**
  - Ejecuta la consulta y retorna un `ADODB.Recordset`.
- **executecontainer**
  - Ejecuta la consulta y retorna un `TOBJContainer`, ideal para acceso orientado a objetos y uso en sistemas OO y APIs.

---

## Ejemplo de uso: Recordset clásico

```vb
Dim q As New TConsulta
q.addtabla "Clientes"
q.addconstante "Nombre"
q.addconstante "Ciudad"
q.addcondicion "Ciudad = 'Rosario'"
q.addcondicion "Estado = 'A'"
Dim rs As ADODB.Recordset
Set rs = q.execute

Do While Not rs.EOF
    Debug.Print rs("Nombre"), rs("Ciudad")
    rs.MoveNext
Loop
```

---

## Ejemplo de uso: TOBJContainer

```vb
Dim q As New TConsulta
q.addtabla "Clientes"
q.addconstante "Nombre"
q.addconstante "Ciudad"
q.addcondicion "Ciudad = 'Rosario'"
q.addcondicion "Estado = 'A'"
Dim container As TOBJContainer
Set container = q.executecontainer

Dim item As Object
For Each item In container
    Debug.Print item.Nombre, item.Ciudad
Next
```

---

## Buenas Prácticas

- Utilizar siempre los métodos de la clase para armar la consulta, evitando concatenar SQL manualmente.
- Elegir `execute` para integraciones con controles clásicos y reporting tradicional.
- Usar `executecontainer` para lógica de negocio OO, APIs, vistas complejas y manipulación avanzada de datos.
- Separar la lógica de armado de consulta del procesamiento de resultados para facilitar el testeo y la reutilización.

---

## Diferenciación de métodos de obtención de resultados

| Método             | Retorna           | Uso recomendado                                          |
|--------------------|-------------------|----------------------------------------------------------|
| `execute`          | Recordset (ADO)   | Grillas, DataReport, integraciones clásicas VB6          |
| `executecontainer` | TOBJContainer     | APIs, lógica OO, serialización, vistas avanzadas         |

---

## Ejemplo genérico para ambos métodos

```vb
Function ObtenerDatos(tipoResultado As String) As Object
    Dim q As New TConsulta
    q.addtabla "Pedidos"
    q.addconstante "Numero"
    q.addconstante "Fecha"
    q.addconstante "Cliente"
    q.addcondicion "Fecha >= '2024-01-01'"
    q.addcondicion "Estado = 'Pendiente'"

    If tipoResultado = "recordset" Then
        Set ObtenerDatos = q.execute
    ElseIf tipoResultado = "container" Then
        Set ObtenerDatos = q.executecontainer
    End If
End Function
```

---

## Referencias cruzadas

- Ver ejemplos de uso en reporting, REST, createview y scripts de explorador.
- Consultar la sección de Anexos en el README para enlaces y contexto adicional.

---
