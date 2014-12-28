
SELECT COUNT(DISTINCT term)
FROM Frequency
WHERE count = 1
  AND docid IN ( '10398_txt_earn', '925_txt_trade' );


SELECT COUNT(DISTINCT term)
FROM (
    SELECT *
      FROM Frequency
     WHERE docid = '10398_txt_earn'
       AND count = 1
    UNION 
    SELECT *
      FROM Frequency
     WHERE docid = '925_txt_trade'
       AND count = 1
);

