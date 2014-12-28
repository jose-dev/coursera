CREATE TABLE Frequency_2 AS 
    SELECT * FROM frequency
    UNION
    SELECT 'q' as docid, 'washington' as term, 1 as count 
    UNION
    SELECT 'q' as docid, 'taxes' as term, 1 as count
    UNION 
    SELECT 'q' as docid, 'treasury' as term, 1 as count;

CREATE TABLE SimilarityMatrix_2 AS 
    SELECT a.docid AS row,
           b.docid AS col,
           SUM(a.count * b.count) AS val
      FROM Frequency_2 AS a,
           Frequency_2 AS b
      WHERE a.term = b.term
        AND a.docid = 'q'
        AND a.docid <> b.docid
   GROUP BY a.docid, b.docid;
