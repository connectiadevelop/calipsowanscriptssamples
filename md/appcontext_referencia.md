# Referencia Técnica de appcontext

Guía de referencia rápida para el uso del objeto `appcontext` en el framework IntranetAppServer.

---

## Índice
1. [Objeto appcontext](#objeto-appcontext)
2. [Acceso a Base de Datos (db)](#acceso-a-base-de-datos)
3. [Gestión de Objetos (objref)](#gestión-de-objetos)
4. [Creación de Vistas (createview)](#creación-de-vistas)
5. [Motor de Scripting (scr)](#motor-de-scripting)
6. [Evaluación de Expresiones (evalvalor)](#evaluación-de-expresiones)
7. [Ejemplos Completos](#ejemplos-completos)

---

## Objeto appcontext

`appcontext` es el núcleo del framework. Actúa como punto central de acceso a todos los servicios del sistema:
- Base de datos
- Objetos de negocio
- Vistas y consultas
- Motor de scripting
- Evaluación de expresiones

**Disponibilidad**: Instancia global disponible en todos los scripts VBScript del sistema.

---

## Acceso a Base de Datos

### appcontext.db

Provee acceso directo al objeto de conexión ADO (ADODB.Connection).

#### Métodos principales:

**Execute** - Ejecuta comandos SQL directamente

```vbscript
' Truncar tabla
appcontext.db.Execute "truncate table tablaaux20"

' Update simple
appcontext.db.Execute "update O_SALES_DATA Set SELLERGROUP1 = u.nombre from O_FRONERI_SUCS s, intusers u where O_SALES_DATA.SUBSIDIARYID = s.id And s.EJECUTIVO = u.codigo"

' Delete con filtro
appcontext.db.Execute "delete from o_froneri_objetivos where cuentaid='" & cuentaID & "'"

' Insert desde select
sql = "insert into O_FRONERI_OBJETIVOS (id,CUENTAID,SELLER) select max(v.id),v.cuentaid,v.seller from O_SALES_DATA v where " & filtro
appcontext.db.Execute sql
```

#### Uso con funciones helper:

```vbscript
' Con timeout personalizado (1200 segundos)
f.dbexecute appcontext.db, "update TABLAAUX20 set CAMPONUM1=...", False, 1200
```

---

## Gestión de Objetos

### appcontext.objref(tabla, [id])

Crea o recupera una instancia de un objeto de negocio mapeado a una tabla.

#### Sintaxis:

```vbscript
Set objeto = appcontext.objref("nombre_tabla", [id_opcional])
```

#### Crear nuevo objeto:

```vbscript
' Crear nuevo registro de sincronización
With appcontext.objref("o_syncs")
    .id = f.getnewguid
    .Name = "FRONERI - " & f.formato(Now, "yyyy/mm/dd HH:MM:ss")
    .sync_type = "froneri"
    .Insert
End With

' Crear upload
Set upload = appcontext.objref("o_uploads")
upload.cuentaID = UCase(cuentaID)
upload.u_type = "file"
upload.p_format = "dsm1"
upload.m_data = file.path
upload.Insert
```

#### Actualizar objeto existente:

```vbscript
' Recuperar por ID y actualizar
Set oupload = appcontext.objref("o_uploads", upload("id"))
oupload.s_status = "Y"
oupload.Update
```

#### Crear notificación:

```vbscript
Set notif = appcontext.objref("o_notifications")
notif.cuentaID = UCase(cuentaID)
notif.s_msg = msg
notif.s_icon = icon
notif.Insert
```

#### Objetos disponibles comunes:
- `o_syncs` - Sincronizaciones
- `o_uploads` - Archivos cargados
- `o_notifications` - Notificaciones
- `o_accounts` - Cuentas/subsidiarias
- `o_froneri_pdv` - Puntos de venta
- `intusers` - Usuarios del sistema

---

## Creación de Vistas

### appcontext.createview([tabla], [campos], [condicion], [orden])

Crea un objeto de consulta tipo "view" para recuperar datos de la base de datos.

#### Sintaxis básica:

```vbscript
Set v = appcontext.createview("tabla", "campos", "condicion", "orden")
For Each registro In v.executecontainer
    ' procesar registro
Next
```

#### Ejemplos:

**Vista simple con todos los campos:**

```vbscript
Set v = appcontext.createview("o_accounts", "id")
For Each cuenta In v.executecontainer
    ' procesar cuenta
Next
```

**Vista con filtro:**

```vbscript
Set v = appcontext.createview("o_accounts", "s_uploads_path,id", "s_uploads_path<>''")
For Each cuenta In v.executecontainer
    ' procesar cuentas que tienen path de uploads
Next
```

**Vista con múltiples parámetros:**

```vbscript
Set v = appcontext.createview("o_uploads", "id,m_data", _
    "cuentaid='" & LCase(cuentaID) & "' and m_data like '%" & tipo & "%' and s_status=''")
v.addorden "id"
For Each upload In v.executecontainer
    ' procesar uploads
Next
```

**Vista inline (sin ejecutar):**

```vbscript
For Each cuenta In appcontext.createview("o_accounts", "*", "s_uploads_path<>''").executecontainer
    ' procesar cuenta
Next
```

#### Construcción manual de vista:

```vbscript
Set v = appcontext.createview

' Configurar tabla y campos
v.addtabla "o_sales_data", "v"
v.addconstante "cuentaid"
v.addconstante "max(sale_date)", "fecha"
v.addgrupo "cuentaid"

' Ejecutar
For Each cuenta In v.executecontainer
    ' procesar
Next
```

#### Vista con múltiples tablas y joins:

```vbscript
Set v = appcontext.createview
v.addtabla "o_froneri_clientes", "c"
v.addconstante "distinct c.customerid"
v.addtabla "o_sales_data", "v"
v.addjoin "c.id=v.customerid"
v.addcondicion "c.cuentaid='" & cuentaID & "'"

Set datos = v.executecontainer
```

#### Propiedades de vista:

```vbscript
' Limitar resultados
v.top = 8

' Distinct
v.Distinct = True
```

#### Métodos adicionales:

```vbscript
' Agregar orden
v.addorden "campo desc"

' Agregar condición
v.addcondicion "campo='valor'"

' Agregar agrupamiento
v.addgrupo "campo"
```

---

## Motor de Scripting

### appcontext.scr

Provee acceso al motor de scripting para ejecutar procedimientos y evaluar expresiones.

#### executeprocedure

Ejecuta un procedimiento almacenado en la metadata/scripting.

**Sintaxis:**

```vbscript
resultado = appcontext.scr.executeprocedure(param1, param2, "nombre_procedimiento", arg1, arg2, ...)
```

**Ejemplos:**

```vbscript
' Obtener filtro de contexto
filtro = appcontext.scr.executeprocedure(True, True, "ri_context_filter", "v.sale_date", "lastperiod-12", cuentaID)

' Verificar si cuenta es padre
If appcontext.scr.executeprocedure(True, True, "ri_account_is_parent", cuentaID) Then
    ' es cuenta padre
End If

' Obtener filtros de usuario
userfilter = appcontext.scr.executeprocedure(True, True, "ri_get_user_filters", user("codigo"), "c")

' Generar WHERE IN para cuentas
whereClause = appcontext.scr.executeprocedure(True, True, "ri_account_where_in", cuentaID, "cuentaid")

' Obtener nombre de propiedad
propName = appcontext.scr.executeprocedure(True, True, "ri_propname", filter.Name, filter.Name)

' Generar reporte HTML
htmlTable = appcontext.scr.executeprocedure(True, True, "ri_dashboard_panel_report", panelId, cuentaID)
```

#### jevalbol

Evalúa una expresión booleana:

```vbscript
If appcontext.scr.jevalbol(dprop("t_eval_prop")) Then
    ' condición cumplida
End If
```

---

## Evaluación de Expresiones

### appcontext.evalvalor(expresion)

Evalúa una expresión y devuelve su valor.

**Ejemplos:**

```vbscript
' Llamar función del sistema
Dim periodoactual
periodoactual = appcontext.evalvalor("ri_periodo_ultimo(""FRONERI"")")

' Evaluar expresión almacenada en metadata
value = appcontext.evalvalor(dprop("t_expresion"))
pvalue = appcontext.evalvalor(dprop("t_expresion_p"))
```

---

## Ejemplos Completos

### Ejemplo 1: Procesar uploads pendientes

```vbscript
Private Sub froneri_accounts_upload_process()
    Dim cuenta
    Dim v
    Dim syncID
    
    ' Crear registro de sincronización
    With appcontext.objref("o_syncs")
        syncID = f.getnewguid
        .id = syncID
        .Name = "FRONERI - " & f.formato(Now, "yyyy/mm/dd HH:MM:ss")
        .sync_type = "froneri"
        .Insert
    End With
    
    ' Obtener cuentas
    Set v = appcontext.createview("o_accounts", "id")
    
    ' Procesar cada cuenta
    For Each cuenta In v.executecontainer
        ' Procesar diferentes tipos de archivos
        froneri_process_uploads "customer", cuenta("id"), syncID
        froneri_process_uploads "stock", cuenta("id"), syncID
        froneri_process_uploads "sel", cuenta("id"), syncID
    Next
    
    ' Actualizar datos relacionados
    appcontext.db.Execute "update O_FRONERI_CLIENTES Set TIPO2=O_FRONERI_CLI_CTA_CLAVE.CTACLAVE from O_FRONERI_CLI_CTA_CLAVE where O_FRONERI_CLI_CTA_CLAVE.CLIENTE=O_FRONERI_CLIENTES.ID"
End Sub
```

### Ejemplo 2: Consulta con filtros dinámicos

```vbscript
Private Sub obtener_uploads_pendientes(tipo, cuentaID)
    Dim upload
    Dim v
    
    ' Crear vista con filtros
    Set v = appcontext.createview("o_uploads", "id,m_data", _
        "cuentaid='" & LCase(cuentaID) & "' and m_data like '%" & tipo & "%' and s_status=''")
    v.addorden "id"
    
    ' Procesar registros
    For Each upload In v.executecontainer
        ' Abrir objeto para actualizar
        Set oupload = appcontext.objref("o_uploads", upload("id"))
        oupload.s_status = "P"
        oupload.Update
        
        ' Procesar upload...
    Next
End Sub
```

### Ejemplo 3: Vista agrupada con agregados

```vbscript
Private Sub verificar_fechas_actualizacion()
    Dim cuenta
    Dim v
    
    ' Crear vista con agregado
    Set v = appcontext.createview
    v.addtabla "o_sales_data", "v"
    v.addconstante "cuentaid"
    v.addconstante "max(sale_date)", "fecha"
    v.addgrupo "cuentaid"
    
    ' Procesar resultados
    For Each cuenta In v.executecontainer
        If DateDiff("d", cuenta("fecha"), Date) > 7 Then
            ' Enviar notificación
            ri_add_notif cuenta("cuentaid"), "Información desactualizada", "warning"
        End If
    Next
End Sub
```

### Ejemplo 4: Uso del motor de scripting

```vbscript
Private Sub refrescar_objetivos(cuentaID)
    Dim filtro
    Dim sql
    
    ' Obtener filtro desde procedimiento
    filtro = appcontext.scr.executeprocedure(True, True, "ri_context_filter", "v.sale_date", "lastperiod-12", cuentaID)
    
    ' Limpiar datos anteriores
    appcontext.db.Execute "delete from o_froneri_objetivos where cuentaid='" & cuentaID & "'"
    
    ' Insertar nuevos datos con filtro
    sql = "insert into O_FRONERI_OBJETIVOS (id,CUENTAID,SELLER,CUSTOMERID,N_MONTO) " & _
          "select max(v.id),v.cuentaid,v.seller,v.customerid,sum(n_amount) " & _
          "from O_SALES_DATA v where " & filtro & " and v.cuentaid='" & cuentaID & "' " & _
          "group by v.CUENTAID,v.SELLER,v.CUSTOMERID"
    
    appcontext.db.Execute sql
End Sub
```

### Ejemplo 5: Verificar cuenta padre y construir WHERE dinámico

```vbscript
Private Sub procesar_datos_cuenta(cuentaID)
    Dim v
    Dim isParent
    
    ' Verificar si es cuenta padre
    isParent = appcontext.scr.executeprocedure(True, True, "ri_account_is_parent", cuentaID)
    
    ' Crear vista de ventas
    Set v = appcontext.createview("o_sales_data")
    
    If isParent Then
        ' Si es padre, usar condición con prefijo "parent"
        v.addcondicion "parentcuentaid='" & cuentaID & "'"
    Else
        ' Si no es padre, condición normal
        v.addcondicion "cuentaid='" & cuentaID & "'"
    End If
    
    ' Procesar datos...
    For Each registro In v.executecontainer
        ' ...
    Next
End Sub
```

---

## Patrones Comunes

### Patrón 1: Crear-Insertar

```vbscript
Set obj = appcontext.objref("tabla")
obj.campo1 = valor1
obj.campo2 = valor2
obj.Insert
```

### Patrón 2: Recuperar-Actualizar

```vbscript
Set obj = appcontext.objref("tabla", id)
obj.campo = nuevoValor
obj.Update
```

### Patrón 3: Consultar-Procesar

```vbscript
Set v = appcontext.createview("tabla", "campos", "condicion")
For Each reg In v.executecontainer
    ' procesar reg
Next
```

### Patrón 4: Ejecutar SQL directo

```vbscript
appcontext.db.Execute "SQL statement"
```

### Patrón 5: Llamar procedimiento de negocio

```vbscript
resultado = appcontext.scr.executeprocedure(True, True, "nombre_proc", param1, param2)
```

---

## Notas Importantes

1. **Case sensitivity**: Los nombres de tabla suelen usarse en minúsculas en createview, pero en mayúsculas en objref
2. **Comillas en SQL**: Usar comillas simples para strings en SQL, duplicar comillas para escapar
3. **executecontainer**: Devuelve una colección iterable con For Each
4. **With statement**: Útil para configurar múltiples propiedades de objetos
5. **Set**: Obligatorio para asignar objetos en VBScript
6. **Transacciones**: appcontext.db es ADO Connection, soporta BeginTrans/CommitTrans/RollbackTrans

---

## Ver también

- [appcontext.md](appcontext.md) - Arquitectura general del framework
- Documentación de ADO (ADODB.Connection) para métodos de base de datos
- Guía de VBScript para sintaxis de scripting
