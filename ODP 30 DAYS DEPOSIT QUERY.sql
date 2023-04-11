SELECT member_nbr
,acct_nbr
,PRINCIPAL_AMT
  FROM [DataMart].[dbo].[ACCOUNTHISTORY]
  where member_nbr = 1130730
  and entry_date > '2023-1-01 00:00:00.000'
  and PRINCIPAL_AMT > 0
  and acct_nbr = 2
  --group by member_nbr, acct_nbr
