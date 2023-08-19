# DBCraft

# **Guía para Definir Tablas con DBCraft**

**¡Bienvenido a la guía para definir tablas con DBCraft!** 

En esta documentación, te mostraremos cómo utilizar los atributos de **DBCraft** para crear tablas en las bases de datos homologadas de manera fácil y efectiva. Esta guía está diseñada para que cualquier persona pueda entenderla, sin importar que sean programadores o analistas de bases de datos.

## **Introducción a DBCraft**

DBCraft es una herramienta que simplifica la creación de tablas en bases de datos, sin importar el lenguaje de programación que estés utilizando. Utiliza una sintaxis sencilla inspirada en **YAML** para describir las tablas y sus campos, lo que hace que el proceso de definición sea mucho más comprensible y organizado.

## **Atributos Generales de la Tabla**

### **`name`**

Este atributo define el nombre de la tabla que deseas crear. Asegúrate de que el nombre sea único dentro de tu base de datos.

Ejemplo:

```yaml
- table:
  name: clientes
```

### **`description`**

Aquí puedes proporcionar una descripción opcional para la tabla que estás definiendo. Esto puede ayudar a otros desarrolladores a entender el propósito de la tabla.

Ejemplo:

```yaml
- table:
  name: clientes
  description: "Tabla que almacena información de los clientes."
```

> ***NOTA:** los nombres con espacios en blanco deben estar delimitados con comillas dobles o simples.*

## **Definición de Campos**

### **`fields`**

El atributo **`fields`** se utiliza para definir la lista de campos o columnas que tendrá la tabla. Cada campo tiene sus propios atributos que detallan sus propiedades.

### Atributos de Campo

- **`name`**: El nombre del campo que estás definiendo.
- **`type`**: [El tipo de dato](tipos_de_datos.md) del campo, como **`int`**, **`varchar`**, **`date`**, etc.
- **`size`**: La longitud del tipo de dato (obligatorio para **`char`**).
- **`decimal`**: La cantidad de decimales para campos numéricos.
- **`allowNull`**: Indica si el campo permite valores nulos (**`true`** o **`false`**).
- **`default`**: Valor por defecto para el campo.
- **`description`**: Un comentario para el campo.
- **`autoIncrement`**: Indica si el campo es autoincrementable (**`true`** o **`false`**).
- **`primaryKey`**: Indica si el campo es clave primaria (**`true`** o **`false`**).
- **`index`**: Define un índice para el campo.

### Ejemplo de Definición de Campos

```yaml
- table:
  name: clientes
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100
```

> ***NOTA:** ¿has notado que todos los atributos están alineados con los demás? es porque los espacios en blanco cuentan así que asegúrate de alinear bien tus atributos.*

## **Índices Compuestos**

### **`composed`**

Este atributo te permite definir índices compuestos, que son índices que involucran múltiples columnas.

### Atributos de Índices Compuestos

- **`columns`**: Un array con los nombres de las columnas que formarán el índice.
- **`name`**: El nombre del índice compuesto.
- **`sort`**: El orden del índice (**`asc`** o **`desc`**).
- **`unique`**: Indica si el índice es único (**`true`** o **`false`**).

### Ejemplo de Índice Compuesto

```yaml
- table:
  name: ventas
  composed:
    -columns: [cliente_id, fecha]
    name: idx_ventas_cliente_fecha
    sort: asc
    unique: false
```

## **Conclusiones**

¡Felicitaciones! Ahora tienes una comprensión básica de cómo utilizar los atributos de DBCraft para definir tablas en bases de datos. Con esta herramienta, la creación de tablas se vuelve más organizada y comprensible. Siéntete libre de explorar más sobre DBCraft y experimentar con diferentes atributos para personalizar tus tablas según tus necesidades.

---

Esperamos que esta guía te haya ayudado a comprender cómo usar DBCraft para definir tablas en bases de datos. Recuerda que la práctica es clave para perfeccionar tus habilidades. ¡Diviértete explorando y creando con DBCraft! Si tienes más preguntas, no dudes en consultar la documentación oficial o buscar ayuda en la comunidad.

**Enlaces Útiles:**

- **[Enlace al Repositorio de DBCraft](https://github.com/Irwin1985/DBCraft)**

¡Feliz creación de tablas con DBCraft! 🎉

[Ejemplos usando DBCraft](ejemplos.md)

[Tipos de datos](tipos_de_datos.md)
