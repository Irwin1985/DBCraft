# Examples Using DBCraft
---

```yaml
# Definición de la tabla "Clientes"
- table:
  name: customers
  description: "Table that stores information about customers."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: "name" # don't use keywords as field name without delimit them with single or double quotes.
      type: varchar
      size: 100
    - name: address
      type: varchar
      size: 200
    - name: email
      type: varchar
      size: 100
    - name: phone
      type: varchar
      size: 20

# Definición de la tabla "Proveedores"
- table:
  name: providers
  description: "Table that stores information about providers."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: "name"
      type: varchar
      size: 100
    - name: contact
      type: varchar
      size: 100
    - name: phone
      type: varchar
      size: 20

# Definition of the "Products" Table
- table:
  name: products
  description: "Table that stores information about products."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: "name"
      type: varchar
      size: 100
    - name: price
      type: double
      size: 10
      decimal: 2
    - name: stock
      type: int
      size: 11
    - name: provider_id
      type: int
      size: 11
      foreignKey:
        fkTable: providers
        fkField: id
        onDelete: cascade
        onUpdate: restrict

# Definition of the "Invoices" Table
- table:
  name: invoices
  description: "Table that stores information about invoices."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: customer_id
      type: int
      size: 11
      foreignKey:
        fkTable: customers
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: "date"
      type: date

# Definition of the "InvoiceDetails" Table
- table:
  name: InvoiceDetail
  description: "Table that stores details of invoices."
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
      autoIncrement: true
    - name: invoice_id
      type: int
      size: 11
      foreignKey:
        fkTable: invoices
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: "product_id"
      type: int
      size: 11
      foreignKey:
        fkTable: products
        fkField: id
        onDelete: restrict
        onUpdate: restrict
    - name: quantity
      type: int
      size: 11
    - name: unit_price
      type: double
      size: 10
      decimal: 2
```

```yaml
# Definition of the "Users" Table
- table:
  name: users
  description: "Table that stores information about system users."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 100
    - name: email
      type: varchar
      size: 100
    - name: password
      type: varchar
      size: 100

# Definition of the "Roles" Table
- table:
  name: roles
  description: "Table that stores user roles."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 50

# Definition of the "UsersRoles" Table (Many-to-Many Relationship)
- table:
  name: users_roles
  description: "Intermediate table to relate users and roles."
  fields:
    - name: user_id
      type: int
      size: 11
      foreignKey:
        fkTable: users
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

# Definition of the "Posts" Table
- table:
  name: posts
  description: "Table that stores user posts."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: tittle
      type: varchar
      size: 200
    - name: content
      type: text
    - name: user_id
      type: int
      size: 11
      foreignKey:
        fkTable: users
        fkField: id
        onDelete: restrict
        onUpdate: restrict
```

```yaml
# Definition of the "Employees" Table
- table:
  name: employees
  description: "Table that stores information about company employees."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 100
    - name: position
      type: varchar
      size: 50
    - name: hire_date
      type: date
    - name: salary
      type: double
      size: 10
      decimal: 2

# Definition of the "Departments" Table
- table:
  name: departments
  description: "Table that stores information about company departments."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 100
    - name: location
      type: varchar
      size: 200

# Definition of the "Projects" Table
- table:
  name: proyectos
  description: "Table that stores information about projects in the company."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 200
    - name: "description"
      type: text
    - name: start_date
      type: date
    - name: end_date
      type: date
    - name: budget
      type: double
      size: 12
      decimal: 2

# Definition of the "Assignments" Table
- table:
  name: assignments
  description: "Table that records employee assignments to projects."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: employee_id
      type: int
      size: 11
      foreignKey:
        fkTable: employees
        fkField: id
        onDelete: restrict
        onUpdate: restrict
    - name: project_id
      type: int
      size: 11
      foreignKey:
        fkTable: projects
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: assigned_hours
      type: int
      size: 11
```

```yaml
# Definition of the "Authors" Table
- table:
  name: authors
  description: "Table that stores information about book authors."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 100
    - name: nationality
      type: varchar
      size: 50

# Definition of the "Books" Table
- table:
  name: books
  description: "Table that stores information about books."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: tittle
      type: varchar
      size: 200
    - name: author_id
      type: int
      size: 11
      foreignKey:
        fkTable: authors
        fkField: id
        onDelete: restrict
        onUpdate: restrict

# Definition of the "Categories" Table
- table:
  name: categories
  description: "Table that stores book categories."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: "name"
      type: varchar
      size: 100

# Definition of the "BooksCategories" Table (Many-to-Many Relationship)
- table:
  name: books_categories
  description: "Intermediate table to relate books and categories."
  fields:
    - name: book_id
      type: int
      size: 11
      foreignKey:
        fkTable: books
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: category_id
      type: int
      size: 11
      foreignKey:
        fkTable: categories
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: relation_date
      type: datetime

# Definition of "Comments" table
- table:
  name: comments
  description: "Table that stores user comments on books."
  fields:
    - name: id
      type: int
      size: 11
      autoIncrement: true
      primaryKey: true
    - name: book_id
      type: int
      size: 11
      foreignKey:
        fkTable: books
        fkField: id
        onDelete: cascade
        onUpdate: restrict
    - name: content
      type: text
    - name: "date"
      type: datetime
    - name: author_id
      type: int
    - name: category_id
      type: int

# Definition of Normal and Composite Indexes
  composed:
    -columns: [author_id, "date"]
     name: idx_books_author_date2
     sort: asc
     unique: false
    -columns: [category_id, book_id]
     name: idx_books_categories2
     sort: asc
     unique: true
```
