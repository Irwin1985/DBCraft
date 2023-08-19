# Ejemplos usando DBCraft
---

```yaml
# Definición de la tabla "Clientes"
- table:
  name: clientes
  description: "Tabla que almacena información de los clientes."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: nombre
      type: varchar
      size: 100
    - name: direccion
      type: varchar
      size: 200
    - name: email
      type: varchar
      size: 100
    - name: telefono
      type: varchar
      size: 20

# Definición de la tabla "Proveedores"
- table:
  name: proveedores
  description: "Tabla que almacena información de los proveedores."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: nombre
      type: varchar
      size: 100
    - name: contacto
      type: varchar
      size: 100
    - name: telefono
      type: varchar
      size: 20

# Definición de la tabla "Productos"
- table:
  name: productos
  description: "Tabla que almacena información de los productos."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: nombre
      type: varchar
      size: 100
    - name: precio
      type: double
      size: 10
      decimal: 2
    - name: stock
      type: int
      size: 11
    - name: proveedor_id
      type: int
      size: 11
      foreignKey:
        fkTable: proveedores
        fkField: id
        onDelete: cascade
        onUpdate: restrict

# Definición de la tabla "Facturas"
- table:
  name: facturas
  description: "Tabla que almacena información de las facturas."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: cliente_id
      type: int
      size: 11
      foreignKey:
        fkTable: clientes
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: fecha
      type: date

# Definición de la tabla "DetalleFactura"
- table:
  name: detalle_factura
  description: "Tabla que almacena el detalle de las facturas."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: factura_id
      type: int
      size: 11
      foreignKey:
        fkTable: facturas
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: "producto_id"
      type: int
      size: 11
      foreignKey:
        fkTable: productos
        fkField: id
        onDelete: restrict
        onUpdate: restrict
    - name: cantidad
      type: int
      size: 11
    - name: precio_unitario
      type: double
      size: 10
      decimal: 2
```

```yaml
# Definición de la tabla "Usuarios"
- table:
  name: usuarios
  description: "Tabla que almacena información de los usuarios del sistema."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100
    - name: correo
      type: varchar
      size: 100
    - name: contrasena
      type: varchar
      size: 100

# Definición de la tabla "Roles"
- table:
  name: roles
  description: "Tabla que almacena los roles de usuario."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 50

# Definición de la tabla "UsuariosRoles" (relación muchos a muchos)
- table:
  name: usuarios_roles
  description: "Tabla intermedia para relacionar usuarios y roles."
  fields:
    - name: usuario_id
      type: int
      size: 11
      foreignKey:
        fkTable: usuarios
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: rol_id
      type: int
      size: 11
      foreignKey:
        fkTable: roles
        fkField: id
        onDelete: cascade
        onUpdate: restrict

# Definición de la tabla "Posts"
- table:
  name: posts
  description: "Tabla que almacena publicaciones de usuarios."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: titulo
      type: varchar
      size: 200
    - name: contenido
      type: text
    - name: usuario_id
      type: int
      size: 11
      foreignKey:
        fkTable: usuarios
        fkField: id
        onDelete: restrict
        onUpdate: restrict
```

```yaml
# Definición de la tabla "Empleados"
- table:
  name: empleados
  description: "Tabla que almacena información de los empleados de una empresa."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100
    - name: puesto
      type: varchar
      size: 50
    - name: fecha_contratacion
      type: date
    - name: salario
      type: double
      size: 10
      decimal: 2

# Definición de la tabla "Departamentos"
- table:
  name: departamentos
  description: "Tabla que almacena información de los departamentos de la empresa."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100
    - name: ubicacion
      type: varchar
      size: 200

# Definición de la tabla "Proyectos"
- table:
  name: proyectos
  description: "Tabla que almacena información de los proyectos en la empresa."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 200
    - name: descripcion
      type: text
    - name: fecha_inicio
      type: date
    - name: fecha_fin
      type: date
    - name: presupuesto
      type: double
      size: 12
      decimal: 2

# Definición de la tabla "Asignaciones"
- table:
  name: asignaciones
  description: "Tabla que registra la asignación de empleados a proyectos."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: empleado_id
      type: int
      size: 11
      foreignKey:
        fkTable: empleados
        fkField: id
        onDelete: restrict
        onUpdate: restrict
    - name: proyecto_id
      type: int
      size: 11
      foreignKey:
        fkTable: proyectos
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: horas_asignadas
      type: int
      size: 11
```

```yaml
# Definición de la tabla "Autores"
- table:
  name: autores
  description: "Tabla que almacena información de los autores de libros."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100
    - name: nacionalidad
      type: varchar
      size: 50

# Definición de la tabla "Libros"
- table:
  name: libros
  description: "Tabla que almacena información de los libros."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: titulo
      type: varchar
      size: 200
    - name: autor_id
      type: int
      size: 11
      foreignKey:
        fkTable: autores
        fkField: id
        onDelete: restrict
        onUpdate: restrict

# Definición de la tabla "Categorias"
- table:
  name: categorias
  description: "Tabla que almacena las categorías de los libros."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: nombre
      type: varchar
      size: 100

# Definición de la tabla "LibrosCategorias" (relación muchos a muchos)
- table:
  name: libros_categorias
  description: "Tabla intermedia para relacionar libros y categorías."
  fields:
    - name: libro_id
      type: int
      size: 11
      foreignKey:
        fkTable: libros
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: categoria_id
      type: int
      size: 11
      foreignKey:
        fkTable: categorias
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: fecha_relacion
      type: datetime

# Definición de la tabla "Comentarios"
- table:
  name: comentarios
  description: "Tabla que almacena comentarios de los usuarios en los libros."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: libro_id
      type: int
      size: 11
      foreignKey:
        fkTable: libros
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: contenido
      type: text
    - name: fecha
      type: datetime
    - name: autor_id
      type: int
    - name: categoria_id
      type: int

# Definición de índices normales y compuestos
  composed:
    -columns: [autor_id, fecha]
     name: idx_libros_autor_fecha2
     sort: asc
     unique: false
    -columns: [categoria_id, libro_id]
     name: idx_libros_categorias2
     sort: asc
     unique: true
```
