CREATE TABLE SimilarityMatrix AS 
    SELECT a.docid AS row,
           b.docid AS col,
           SUM(a.count * b.count) AS val
      FROM Frequency AS a,
           Frequency AS b
      WHERE a.term = b.term
        AND a.docid = '10080_txt_crude' 
        AND b.docid = '17035_txt_earn' 
   GROUP BY a.docid, b.docid;
