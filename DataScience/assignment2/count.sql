
SELECT COUNT(DISTINCT docid)
FROM Frequency
WHERE count > 0
  AND term = 'parliament';


