# GoogleSheetsLibrary

A Ruby library for working with Google Sheets, providing functionality for accessing and manipulating sheet data in a structured way.

## Features

### Accessing Table Values
- The library returns a two-dimensional array of table values.
- Access a specific row using `t.row(1)`, and access its elements using standard array syntax.

### Enumerable Module
- The library implements an Enumerable module with an `each` method, allowing iteration over all cells in the table from left to right.
- It handles merged cells effectively.

### Column Access
- Access an entire column with syntax: `t["First Column"]`.
- Access specific elements within a column using: `t["First Column"][1]` to retrieve the second element.
- Set values in a cell using: `t["First Column"][1] = 2556`.

### Direct Column Methods
- Directly access columns with methods corresponding to their names: 
  - `t.firstColumn`
  - `t.secondColumn`
  - `t.thirdColumn`

### Calculations
- Calculate subtotal and average of a column using:
  - `t.firstColumn.sum`
  - `t.firstColumn.avg`

### Row Extraction
- Extract individual rows based on the value of a unique cell (e.g., student index):
  - Example: `t.index.rn2310` returns the student row whose index is `rn2310`.

### Functional Programming Support
- Columns support functions such as `map`, `select`, and `reduce`:
  - Example: `t.firstColumn.map { |cell| cell += 1 }`

### Ignoring Specific Rows
- The library recognizes any row containing the keywords "total" or "subtotal" and ignores those rows during operations.

### Table Manipulation
- **Addition of Tables:** You can add two tables with the same headers:
  - Example: `t1 + t2` returns a new table with the rows of `t2` added to `t1` (similar to SQL UNION).
  
- **Subtraction of Tables:** You can subtract two tables with the same headers:
  - Example: `t1 - t2` returns a new table with rows from `t2` removed from `t1`, if they are identical.

### Handling Empty Lines
- The library recognizes and can manage empty lines in the sheets, allowing for flexible data manipulation.

This library simplifies interactions with Google Sheets, making data retrieval and manipulation intuitive and efficient.
