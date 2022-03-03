with table1 as
(
  SELECT *,
  ROW_NUMBER() OVER() AS row_count,
  (fiscal_year % 100) -(ROW_NUMBER() OVER()) AS diff FROM dividend
),

table2 as
(
  SELECT *,
  COUNT(*) OVER(PARTITION BY diff) AS record_count FROM table1
),

result AS
(
  SELECT DISTINCT company as value_stocks FROM table2
  WHERE record_count >= 3 ORDER BY company
)
SELECT JSONB_AGG(value_stocks) AS value_stocks FROM result;
