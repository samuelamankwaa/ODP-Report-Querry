SELECT Age = DATEDIFF(day, S.OPEN_DATE, GETDATE())
FROM Share  S
INNER JOIN TIEREDNSFACCOUNT T ON T.DL_LOAD_DATE = S.DL_LOAD_DATE AND T.MEMBER_NBR = S.MEMBER_NBR AND t.SHARE_NBR = s.SHARE_NBR
INNER JOIN ID.MonthEnd_DL_Load_Dates I ON S.DL_LOAD_DATE = I.dl_load_Date AND I.sequence = 1
