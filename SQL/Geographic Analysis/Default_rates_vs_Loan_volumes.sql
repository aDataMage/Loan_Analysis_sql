-- - Which states have the lowest default rates and highest loan volumes?
use creditrisk;

select
	UPPER(state) as State,
	FORMAT(sum(loan_amnt), 'C') loan_amount,
	ROUND(AVG(CAST(loan_status AS FLOAT) * 100), 3) AS default_rate
from Credit_Risk
group by state
order by default_rate ASC, loan_amount Desc