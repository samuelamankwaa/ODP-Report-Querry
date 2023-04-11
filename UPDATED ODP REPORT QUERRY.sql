select s.MEMBER_NBR
,s.SHARE_NBR
,DateDiff(YY,i.birth_date,GETDATE()) -
Case
when DATEADD(YY,DATEDIFF(YY,i.birth_date,Getdate()),i.birth_date)
> getdate()
then 1
else 0
End as AGE
,i.FIRST_NAME
,i.LAST_NAME
,i.BIRTH_DATE
,t.TIERED_NSF_OPTION_SET_NBR
,s.BALANCE
,s.AVG_DAILY1_BAL
,s.AVG_DAILY2_BAL
,s.AVG_DAILY3_BAL
,s.CLOSED
,p.PRODUCT_NAME
,coalesce (avg30.PRINCIPAL_AMT,0) as AVG_DEP_30_DAY
,coalesce (avg60.PRINCIPAL_AMT,0) as AVG_DEP_60_DAY
,coalesce (avg90.PRINCIPAL_AMT,0) as AVG_DEP_90_DAY
,DATEDIFF(m,m.OPEN_DATE,Convert(date,Getdate())) as MEM_AGE_MONTHS
from id.MonthEnd_DL_Load_Dates d
join share s
on d.dl_load_Date = s.DL_LOAD_DATE
join MEMBERSHIPPARTICIPANT mp
on s.DL_LOAD_DATE = mp.DL_LOAD_DATE
and s.MEMBER_NBR = mp.MEMBER_NBR
join INDIVIDUAL i
on i.DL_LOAD_DATE = mp.DL_LOAD_DATE
and i.INDIVIDUAL_ID = mp.INDIVIDUAL_ID
join TIEREDNSFACCOUNT t
on t.DL_LOAD_DATE = s.DL_LOAD_DATE
and t.MEMBER_NBR = s.MEMBER_NBR
and t.SHARE_NBR = s.SHARE_NBR
join dbo.PRODUCT p
on p.PRODUCT_CATEGORY_CODE = 1
AND p.PRODUCT_CLASS_CODE = 1
and s.SHARE_TYPE = p.FXP_TYPE_NBR
join dbo.MEMBERSHIP m
 on s.DL_LOAD_DATE = m.DL_LOAD_DATE
 AND s.MEMBER_NBR = m.MEMBER_NBR
  LEFT Join
(
Select a.MEMBER_NBR
,convert(decimal(12,2),Avg(a.PRINCIPAL_AMT)) as PRINCIPAL_AMT
from dbo.ACCOUNTHISTORY a
where a.ENTRY_DATE >= DATEADD(d,-30,Getdate())
and a.PRINCIPAL_AMT > 0
Group by a.MEMBER_NBR
) avg30 on s.MEMBER_NBR = AVG30.MEMBER_NBR
 LEFT Join
(
Select a.MEMBER_NBR
,convert(decimal(12,2),Avg(a.PRINCIPAL_AMT)) as PRINCIPAL_AMT
from dbo.ACCOUNTHISTORY a
where a.ENTRY_DATE >= DATEADD(d,-60,Getdate())
and a.PRINCIPAL_AMT > 0
Group by a.MEMBER_NBR
) avg60 on s.MEMBER_NBR = AVG60.MEMBER_NBR
LEFT Join
(
Select a.MEMBER_NBR
,convert(decimal(12,2),Avg(a.PRINCIPAL_AMT)) as PRINCIPAL_AMT
from dbo.ACCOUNTHISTORY a
where a.ENTRY_DATE >= DATEADD(d,-90,Getdate())
and a.PRINCIPAL_AMT > 0
Group by a.MEMBER_NBR
) avg90 on s.MEMBER_NBR = AVG90.MEMBER_NBR
where d.[sequence] = 1
and s.SHARE_TYPE not in (129,128,34)
and (s.CLOSED is null or s.CLOSED = 0)
and mp.PARTICIPATION_TYPE = 101

order by s.CLOSED desc