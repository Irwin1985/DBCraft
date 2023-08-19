# Tipos de Datos Soportados por DBCraft

**DBCraft** admite varios tipos de datos que pueden ser utilizados para definir campos en las tablas. A continuación, se presenta una lista de los tipos de datos soportados, junto con una breve descripción y un ejemplo:

## `char`

Un tipo de dato que almacena cadenas de longitud fija.
Ejemplo:

```yaml
- name: codigo
  type: char
  size: 6
```

## `currency`

Un tipo de dato que almacena valores monetarios.
Ejemplo:

```yaml
- name: precio
  type: currency
```

## date

Un tipo de dato que almacena fechas.
Ejemplo:

```yaml
- name: fecha_nacimiento
  type: date
```

## datetime

Un tipo de dato que almacena fechas y horas.
Ejemplo:

```yaml
- name: fecha_creacion
  type: datetime
```

## double

Un tipo de dato que almacena números de punto flotante de doble precisión.
Ejemplo:

```yaml
- name: valor
  type: double
  size: 10   # si usas size entonces
  decimal: 4 # decimal es obligatorio
```

> ***NOTA:** tanto `double` como `float` admiten **opcionalmente** los atributos `size` y `decimal.`*
> 

## float

Un tipo de dato que almacena números de punto flotante de precisión simple.
Ejemplo:

```yaml
- name: estimacion
  type: float
```

## int

Un tipo de dato que almacena números enteros.
Ejemplo:

```yaml
- name: cantidad
  type: int
```

## bool

Un tipo de dato que almacena valores booleanos *(verdadero o falso)*.
Ejemplo:

```yaml
- name: activo
  type: bool
```

## text

Un tipo de dato que almacena texto de longitud variable.
Ejemplo:

```yaml
- name: descripcion
  type: text
```

## numeric

Un tipo de dato que almacena números decimales.
Ejemplo:

```yaml
- name: calificacion
  type: numeric
  size: 10
  decimal: 2
```

## varbinary

Un tipo de dato que almacena datos binarios de longitud variable.
Ejemplo:

```yaml
- name: imagen
  type: varbinary
```

## string

Un alias para el tipo de dato varchar.
Ejemplo:

```yaml
- name: titulo
  type: string
  size: 150 # este atributo es opcional
```

## varchar

Un tipo de dato que almacena cadenas de longitud variable.
Ejemplo:

```yaml
- name: nombre
  type: varchar
  size: 50 # este atributo es opcional

```

## blob

Un tipo de dato que almacena datos binarios grandes.
Ejemplo:

```yaml
- name: archivo
  type: blob
```

## guid

Un tipo de dato que almacena identificadores únicos globales *(GUID)*.
Ejemplo:

```yaml
- name: uid
  type: guid
```

Estos son los tipos de datos que **DBCraft** soporta para definir campos en las tablas. Utiliza el tipo de dato adecuado según los requisitos de tu base de datos y aplicación.
