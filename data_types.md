# Data Types Supported by DBCraft

**DBCraft** supports various data types that can be used to define fields in tables. Below is a list of the supported data types, along with a brief description and an example:

## `char`

A data type that stores fixed-length strings.
Example:

```yaml
- name: code
  type: char
  size: 6
```

## `currency`

A data type that stores monetary values.
Example:

```yaml
- name: price
  type: currency
```

## date

A data type that stores dates.
Example:

```yaml
- name: birth_date
  type: date
```

## datetime

A data type that stores dates and times.
Example:

```yaml
- name: creation_date
  type: datetime
```

## double

A data type that stores double-precision floating-point numbers.
Example:

```yaml
- name: value
  type: double
  size: 10   # if using size, then
  decimal: 4 # decimal is mandatory
```

> ***NOTA:** Both `double` and `float` **optionally** support attributes `size` y `decimal.`*
> 

## float

A data type that stores single-precision floating-point numbers.
Example:

```yaml
- name: estimation
  type: float
```

## int

A data type that stores integer numbers.
Example:

```yaml
- name: quantity
  type: int
```

## bool

A data type that stores boolean values *(verdadero o falso)*.
Example:

```yaml
- name: active
  type: bool
```

## text

A data type that stores variable-length text.
Example:

```yaml
- name: description
  type: text
```

## numeric

A data type that stores decimal numbers.
Example:

```yaml
- name: calificacion
  type: numeric
  size: 10
  decimal: 2
```

## varbinary

A data type that stores decimal numbers.
Example:

```yaml
- name: image
  type: varbinary
```

## string

An alias for the varchar data type.
Example:

```yaml
- name: title
  type: string
  size: 150 # this attribute is optional
```

## varchar

A data type that stores variable-length strings.
Example:

```yaml
- name: "name"
  type: varchar
  size: 50 # this attribute is optional

```

## blob

A data type that stores large binary data.
Example:

```yaml
- name: file
  type: blob
```

## guid

A data type that stores Global Unique Identifiers *(GUID)*.
Example:

```yaml
- name: uid
  type: guid
```

These are the data types that **DBCraft** supports for defining fields in tables. Use the appropriate data type based on your database and application requirements.
