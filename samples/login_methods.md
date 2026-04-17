# Ejemplos de ejecución de métodos por url

## Con parámetros de login

Es posible realiar ejecuciones de métodos/procedimientos directamente por invocaciones de url (endpoint) esto se puede realizar de 2 maneras dependiendo de las disponibilidades de plataforma.

### Métodos

* Appserver (/appserver/)
* API (/appserver/api/)

## Appserver

Es el método mas directo y para el mismo se necesita contar con 3 parámetros fundamentales. El alias de instancia (alias) el usuario que realizará la ejecución (userid) y la password del mismo (p). El método a ejecutar se pasa en el parámetro (execmethod) pudiendo ser esto una expresión scripting (vbscript).
Es necesario entender que esta herramienta conllega un riesto y es hacer publica esta url. Esto ya queda en la responsabilidad del equipo que implementa esta solución (no recomendada para ambientes publicos, para ello utilizar el método 2).

## Ejemplos

Obtener id de usuario
```
http://server/appserver/explorar?mod=start&alias=INSTANCIA&userid=USUARIO&p=PASSWORD&execmethod=f.userid
```
Función con parámetros
```
http://server/appserver/explorar?mod=start&alias=INSTANCIA&userid=USUARIO&p=PASSWORD&execmethod=enletras(123)
```
