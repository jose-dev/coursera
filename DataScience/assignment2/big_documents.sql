
SELECT COUNT(*)
FROM (
    SELECT docid,
           SUM(count) AS no
      FROM Frequency
      GROUP BY docid
    HAVING no > 300
);

