# CALIPSO WAN - Scripts y Ejemplos

## Descripción

Este repositorio tiene como objetivo brindar **asistencia y ejemplos prácticos** a implementadores y desarrolladores que trabajan con **CALIPSO WAN**, proporcionando recursos de referencia, código de ejemplo y documentación para facilitar la implementación y personalización del sistema.

## Propósito

CALIPSO WAN es una plataforma empresarial desarrollada en Visual Basic 6 que utiliza motores de scripting (VBScript/JScript) para permitir la extensión dinámica del comportamiento de las aplicaciones. Este repositorio recopila ejemplos reales y documentación técnica que ayudan a:

- Comprender la arquitectura y funcionamiento del sistema
- Implementar eventos personalizados en formularios y componentes DAF
- Manipular vistas y consultas dinámicamente
- Extender funcionalidades mediante scripts

## Contenido del Repositorio

### 📁 `/daf` - Ejemplos de Eventos DAF

Contiene ejemplos prácticos de eventos del **Data Access Framework (DAF)** de CALIPSO WAN:

- **`eventos_samples.vbs`**: Ejemplos de eventos DAF que incluyen:
  - **`daf_onbeforeexecute2`**: Evento que permite alterar propiedades de las columnas del DAF dinámicamente, controlando la visibilidad de campos según condiciones específicas (cotización, saldo inicial, etc.)
  - **`daf_onbeforeview`**: Evento "pre-vista" que permite modificar completamente la estructura de una vista SQL antes de su ejecución, agregando tablas, joins, columnas calculadas, condiciones y agrupamientos

### 📁 `/md` - Documentación Técnica

Documentación de referencia sobre la arquitectura y componentes del sistema:

#### **`appcontext.md`** - Arquitectura del Framework
Documentación completa sobre la arquitectura de IntranetAppServer/CALIPSO WAN:
- Descripción de las clases principales (appcontext, appserver, appremote)
- Motor de scripting y su interacción con el sistema
- Árbol de clases y funcionalidades
- Diagramas de flujo para procesamiento web y batch
- Ventajas de la arquitectura y patrones de extensibilidad

#### **`appcontext_referencia.md`** - Guía de Referencia Rápida
Guía práctica con ejemplos de código para el uso del objeto `appcontext`:

**Acceso a Base de Datos (db)**
- Ejecución directa de comandos SQL (INSERT, UPDATE, DELETE, TRUNCATE)
- Uso con funciones helper y timeout personalizado
- Ejemplos de consultas complejas con joins

**Gestión de Objetos de Negocio (objref)**
- Creación de nuevos registros (o_syncs, o_uploads, o_notifications)
- Actualización de objetos existentes por ID
- Mapeo objeto-relacional con tablas del sistema
- Operaciones Insert/Update sobre objetos

**Creación de Vistas y Consultas (createview)**
- Vistas simples con filtros y ordenamiento
- Construcción manual de vistas complejas
- Vistas con múltiples tablas y joins
- Agrupaciones y funciones agregadas
- Iteración sobre resultados con executecontainer

**Motor de Scripting (scr)**
- Evaluación de expresiones dinámicas
- Integración con el contexto de aplicación

Todos los ejemplos incluyen código VBScript funcional listo para adaptar a casos de uso específicos.

## Uso de los Ejemplos

Los scripts de ejemplo están escritos en **VBScript** y están diseñados para ser integrados en los eventos de formularios y componentes DAF dentro de CALIPSO WAN. Cada ejemplo incluye comentarios explicativos sobre su funcionamiento y casos de uso.

### Ejemplo de Implementación

Los eventos DAF se implementan típicamente en la configuración de formularios del sistema, donde pueden:
- Controlar la visibilidad y comportamiento de campos
- Modificar consultas SQL dinámicamente
- Aplicar lógica de negocio personalizada
- Manipular parámetros y condiciones de filtrado

## Contribución

Este es un repositorio de ejemplos recopilados de implementaciones reales de CALIPSO WAN, diseñado como recurso de aprendizaje y referencia para la comunidad de implementadores.

---

**Nota**: Este repositorio contiene ejemplos educativos y de referencia. Adapte los scripts según las necesidades específicas de su implementación.
