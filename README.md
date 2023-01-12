# GoogleSheetsLibrary
Library written in Ruby for working with google sheets

 The library can return a two-dimensional array of table values
 It is possible to access a row via t.row(1), and access its elements using array syntax.
 An Enumerable module (each function) must be implemented, where all cells within the table are returned, from left to right.
 The library should take care of merged fields
 [ ] syntax must be enriched so that certain values can be accessed.
 The library returns the entire column when a query is made t["First Column"]
 The library provides access to values within a column using the following syntax t["First Column"][1] to access the second element of that column
 The library allows setting values inside a cell using the following syntax
 t["First Column"][1]= 2556
 The library allows direct access to columns, through methods of the same name.
 t.firstColumn, t.secondColumn, t.thirdColumn
 Subtotal/Average of a column can be calculated using the following syntaxes t.firstColumn.sum and t.firstColumn.avg
 An individual row can be extracted from each column based on the value of one of the cells. (we'll consider that cell to uniquely identify that row)
 Example syntax: t.index.rn2310, this code will return the student row whose index is rn2310
 The column must support functions such as map, select, reduce. For example: t.firstColumn.map { |cell| cell+=1 }
 The library recognizes if there is in any way the keyword total or subtotal inside the sheet, and ignores that line
 It is possible to add two tables, as long as their headers are the same. Eg t1+t2, where each represents a table within one of the worksheets. The result will return a   new table where the rows (without headers) of t2 are added inside t1. (SQL UNION operation)
 It is possible to subtract two tables, as long as their headers are the same. Eg t1-t2, where each represents a representation of one of the worksheets. The result will   return a new table where all rows from t2 are removed from t1, if they are identical.
 The library recognizes empty lines, which can be inserted apparently to work
