CREATE TABLE C AS 
    SELECT a.row_num AS row,
           b.col_num AS col,
           SUM(a.value * b.value) AS val
      FROM a, b
      WHERE a.col_num = b.row_num
   GROUP BY a.row_num, b.col_num;
