SELECT COUNT(*)
FROM (
    SELECT docid,
           COUNT(*) AS no
      FROM Frequency
      WHERE term IN ( 'transaction', 'world' )
      GROUP BY docid
      HAVING no = 2
);

