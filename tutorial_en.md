# DBCraft

# **Guide to Defining Tables with DBCraft**

**¡Welcome to the guide for defining tables with DBCraft!** 

In this documentation, we will show you how to use **DBCraft** attributes to create tables in standardized databases easily and effectively. This guide is designed to be understandable by anyone, whether they are programmers or database analysts.

## **Introduction to DBCraftt**

DBCraft is a tool that simplifies the creation of tables in databases, regardless of the programming language you are using. It uses a simple syntax inspired by YAML to describe tables and their fields, making the definition process much more comprehensible and organized.

## **General Table Attributes**

### **`name`**

This attribute defines the name of the table you want to create. Make sure the name is unique within your database.

Example:

```yaml
- table:
  name: customers
```

### **`description`**

Here you can provide an optional description for the table you are defining. This can help other developers understand the purpose of the table.

Example:

```yaml
- table:
  name: customers
  description: "Table that stores customer information."
```

> ***NOTE:** Names with spaces should be enclosed in double or single quotes.*

## **Field Definitions**

### **`fields`**

The **`fields`** attribute is used to define the list of fields or columns that the table will have. Each field has its own attributes that detail its properties.

### Field Attributes

- **`name`**: The name of the field you are defining.
- **`type`**: [The data type](data_types.md) of the field, such as **`int`**, **`varchar`**, **`date`**, etc.
- **`size`**: The length of the data type (mandatory for **`char`**).
- **`decimal`**: The number of decimals for numeric fields.
- **`allowNull`**: Indicates whether the field allows null values (**`true`** o **`false`**).
- **`default`**: Default value for the field.
- **`description`**: A comment for the field.
- **`autoIncrement`**: Indicates whether the field is auto-incrementable (**`true`** o **`false`**).
- **`primaryKey`**: Indicates whether the field is a primary key (**`true`** o **`false`**).
- **`index`**: Defines an index for the field.

### Field Definition Example

```yaml
- table:
  name: customers
  fields:
    - name: id
      type: int
      size: 11
      primaryKey: true
    - name: customer_name
      type: varchar
      size: 100
```

> ***NOTE:** Have you noticed that all attributes are aligned with each other? That's because whitespace counts, so make sure to align your attributes properly.*

## **Composite Indexes**

### **`composed`**

This attribute allows you to define composite indexes, which are indexes that involve multiple columns.

### Composite Index Attributes

- **`columns`**: An array with the names of the columns that will form the index.
- **`name`**: The name of the composite index.
- **`sort`**: The order of the index (**`asc`** o **`desc`**).
- **`unique`**: Indicates whether the index is unique or not (**`true`** o **`false`**).

### Composite Index Example

```yaml
- table:
  name: invoices
  composed:
    -columns: [customer_id, date]
    name: idx_invoices_customers_date
    sort: asc
    unique: false
```

## **Conclusion**

Congratulations! You now have a basic understanding of how to use DBCraft attributes to define tables in databases. With this tool, table creation becomes more organized and comprehensible. Feel free to explore more about DBCraft and experiment with different attributes to customize your tables according to your needs.

---

We hope this guide has helped you understand how to use DBCraft to define tables in databases. Remember that practice is key to perfecting your skills. Have fun exploring and creating with DBCraft! If you have more questions, don't hesitate to consult the official documentation or seek help from the community.

**Useful Links:**

- **[DBCraft Repository Link](https://github.com/Irwin1985/DBCraft)**

Happy table creation with DBCraft! 🎉

[Examples using DBCraft](examples.md)

[Data Types](data_types.md)
