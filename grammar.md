```
table           ::= HYPHEN 'table' COLON CRLF tableAttributes
tableAttributes ::= name | description | fields | composed
fields          ::= 'fields' COLON CRLF (fieldAttributes)*
fieldAttributes ::= name | type | size | decimal | allowNull | default | description | autoIncrement | primaryKey | index | foreignKey
foreignKey      ::= 'foreignKey' DOT CRLF foreignKeyAttributes
foreignKeyAttributes ::= 'fkTable' | 'fkField' | 'onDelete' | 'onUpdate'
composed        ::= 'composed' DOT CRLF composedAttributes
composedAttributes   ::= (columns)+
columns         ::= name | sort | unique
name            ::= 'name' DOT value
description     ::= 'description' DOT value
type            ::= 'type' DOT value
size            ::= 'size' DOT value
decimal         ::= 'decimal' DOT value
allowNull       ::= 'allowNull' DOT value
default         ::= 'default' DOT value
autoIncrement   ::= 'autoIncrement' DOT value
primaryKey      ::= 'primaryKey' DOT value
index           ::= 'index' DOT value
value           ::= STRING | IDENTIFIER | NUMBER | TRUE | FALSE | NULL | array
array           ::= LBRACKET (value)* RBRACKET
```
