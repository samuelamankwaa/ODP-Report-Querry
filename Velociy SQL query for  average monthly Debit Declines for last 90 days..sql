SELECT (COUNT(OperationID)/90) as 'AVG_90_DEBIT_DECLINE'
FROM dbo.CATOperations a
where BIN = 477748 and a.DL_LOAD_DATE >= DATEADD(d,-90,Getdate())
group by (MemberNumber)



Select top 100 *
FROM dbo.CATOperations a
where BIN = 477748 and a.OperationDateTime >= DATEADD(d,-10,Getdate())
and OperationResponseType = 'DCL'
and OperationClass in ('PUR','WTH','ADJCT','ATHZ','CASHADV')