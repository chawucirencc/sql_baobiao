-- 收付款单
-- 主表
SELECT A.F_RPID, DATE_FORMAT(A.F_DATE, "%%Y-%%m-%%d") AS 日期, A.F_DEPTID, A.F_CURRENCY, A.F_EXRATE, A.F_SERVICETYPE, 
        A.F_WORKNO, A.F_HUBID, A.F_CONTRACTNO, A.F_DEALINGSNAME, A.F_AMT, A.F_USAGE, A.F_REMARK, A.F_EMPNAME,  
        A.F_BILLTYPE, A.F_CATEGORY
FROM ACC_RPBILLHEAD A 
LEFT JOIN ACC_RPBILLBODY B ON A.F_RPID = B.F_RPID 
WHERE A.F_RPID = :F_RPID 
-- 收付款单 
-- 表体
SELECT CONCAT(A.F_RPID) AS 单据号, DATE_FORMAT(A.F_DATE, "%%Y-%%m-%%d") AS 日期, A.F_DEPTID AS 部门ID, A.F_DEPTNAME 部门名称, 
        A.F_CURRENCY AS 币种, 
        A.F_EXRATE AS 汇率, A.F_SERVICETYPE AS 发货代码, A.F_WORKNO AS 工作号, A.F_HUBID AS 结算号, 
        B.F_CONTRACTNO AS 合同号, 
        FORMAT(SUM(B.F_AMT), 2) AS 金额, A.F_USAGE AS 用途, A.F_REMARK AS 备注, A.F_EMPNAME AS 制单人, A.F_CATEGORY AS 类别, 
        A.F_CCNAME 成本中心, A.F_TICKETNAME 支付对象, 
        CASE 
        WHEN A.F_DEALINGSNAME = C.F_NAME  AND C.F_SNAME IS NOT NULL AND C.F_SNAME <> ''  THEN C.F_SNAME
        WHEN A.F_DEALINGSNAME IS NOT NULL THEN  A.F_DEALINGSNAME  
        ELSE A.F_EMPNAME  END AS 对方单位, 
        CASE 
        WHEN A.F_CATEGORY="11" THEN "预收款单(结算)" 
        WHEN A.F_CATEGORY="12" THEN "结算收款单" 
        WHEN A.F_CATEGORY="13" THEN "销售退款" 
        WHEN A.F_CATEGORY="21" THEN "付款单(预付)" 
        WHEN A.F_CATEGORY="22" THEN "付款单(结算)" 
        WHEN A.F_CATEGORY="23" THEN "采购退款单" 
        WHEN A.F_CATEGORY="24" THEN "预付结转单"  
        WHEN A.F_CATEGORY="25" THEN "付款单(预结算)" 
        WHEN A.F_CATEGORY="31" THEN "采购付款单" 
        WHEN A.F_CATEGORY="32" THEN "个人报销付款单" 
        WHEN A.F_CATEGORY="33" THEN "还款单" 
        WHEN A.F_CATEGORY="34" THEN "借款单" 
        WHEN A.F_CATEGORY="35" THEN "借款结转单" 
        WHEN A.F_CATEGORY="2" THEN "付款单" 
        ELSE " " END  AS 单据类型 
FROM ACC_RPBILLHEAD A 
LEFT JOIN ACC_RPBILLBODY B ON A.F_RPID = B.F_RPID 
LEFT JOIN DB_ORGS C ON A.F_DEALINGSNAME = C.F_NAME 
WHERE A.F_RPID = :ID 
/*------------------------------------------------------------------------------------------------------------*/

--费用报销单(后勤采购)
SELECT A.F_ARPID, A.F_DATE, A.F_SERVICETYPE, A.F_CCNAME, A.F_CURRENCY, A.F_EMPNAME, 
        A.F_AMT, A.F_REMARK, B.F_PURBILLID, A.F_PLANID 预算单号 
FROM ACC_ARPBILLHEAD A 
LEFT JOIN ACC_ARPBILLBODY B ON A.F_ARPID=B.F_ARPID 
LEFT JOIN DB_ORGS D ON A.F_DEALINGSNAME=D.F_NAME 
LEFT JOIN OW_MSG E ON A.F_FLOWDATAID=E.F_FLOWDATAID 
WHERE A.F_ARPID=:ID 
GROUP BY E.F_LOG 
ORDER BY E.F_MSGID 
/*------------------------------------------------------------------------------------------------------------*/
--个人费用报销(明细)
SELECT A.F_ARPID 单据号, DATE_FORMAT(A.F_DATE, "%%Y-%%m-%%d") 业务日期, A.F_SERVICETYPE 发货代码, A.F_CCNAME 部门, A.F_CURRENCY 币别,  
        A.F_EMPNAME 申请人, D.F_SNAME 供应商, A.F_PURBILLID 申请单号, A.F_PLANID 预算单号, FORMAT(SUM(B.F_AMT), 2) 金额, 
        A.F_REMARK 备注, A.F_SOURCETYPE 来源单据类型ID, IF(A.F_SOURCETYPE="5", "费用报销", "其他") 来源单据类型,  
        A.F_CLOSERID 结案人, A.F_CHECKERNAME 审核人, A.F_AFFIRMANTNAME 确认人, A.F_CHECKERID 审核人ID, B.F_ITEMNAME 摘要, 
        IF(A.F_CATEGORY="1", "后勤采购报销", "个人费用报销") 报销类别, A.F_STATUS 状态, 
        CONCAT("申请：", A.F_EMPNAME) 申请, A.F_SUBMITDATE 申请日期
FROM ACC_ARPBILLHEAD A 
LEFT JOIN ACC_ARPBILLBODY B ON A.F_ARPID=B.F_ARPID 
LEFT JOIN DB_ORGS D ON A.F_DEALINGSNAME=D.F_NAME 
WHERE A.F_ARPID=:ID 

---日志
SELECT A.F_MANID, A.F_MAN AS 人员, A.F_RESULT AS 过程, A.F_CONTENT AS 结果, A.F_ENDTIME AS 时间, B.F_ARPID, B.F_FLOWDATAID, 
CONCAT(IF(A.F_MAN=" ", (SELECT DISTINCT(F_MAN) 
FROM WF_TASK 
WHERE F_MANID = A.F_MANID LIMIT 1), A.F_MAN),": ", IFNULL(A.F_ACTION, " "), ": " , IFNULL(A.F_RESULT, " "), ": ", IFNULL(A.F_CONTENT, " ")) AS 日志 , A.* 
FROM WF_TASK A 
LEFT JOIN ACC_ARPBILLHEAD B ON A.F_FLOWDATAID=B.F_FLOWDATAID 
WHERE B.F_ARPID=:ID AND A.F_STATUS<9 

-- 明细
SELECT @rowNum:=@rowNum + 1 AS 行号, A.F_ITEMNAME AS 费项, FORMAT(A.F_AMT, 2) AS 金额, A.F_REMARK AS 备注 
FROM ACC_ARPBILLBODY A , (SELECT @rownum := 0) B 
WHERE A.F_ARPID = :ID 
/*------------------------------------------------------------------------------------------------------------*/

-- 明细账
SELECT A.F_CADATE AS 凭证日期, A.F_CASN AS 凭证号, B.F_SUBJECT AS 凭证摘要, B.F_DRAMT AS 借方金额, B.F_CRAMT AS 贷方金额, 
        F_ACCOUNT AS 科目ID, B.F_ACCOUNTNAME AS 科目名称, C.F_BALANCETYPE AS 余额方向, 
        IF(C.F_BALANCETYPE="1", (B.F_DRAMT-B.F_CRAMT), (B.F_CRAMT-B.F_DRAMT)) AS 余额 
FROM ACC_CAHEAD A 
JOIN ACC_CABODY B ON A.F_BILLID = B.F_BILLID 
LEFT JOIN BAS_SUBJECTS C ON B.F_ID = C.F_SUBJECTID 
WHERE A.F_CADATE >= :START_DATE AND A.F_CADATE <= DATE_ADD(:END_DATE, INTERVAL 1 DAY) 


WHERE A.F_CADATE >= "2018-11-19" AND A.F_CADATE <= DATE_ADD("2018-11-20", INTERVAL 1 DAY)
WHERE C.F_SUBJECTCODE = :ID 1403
WHERE B.F_ID = 20000016 
------------------------

SELECT * 
FROM ACC_CAHEAD A 
LEFT JOIN BAS_SUBJECTS B ON A.F_COID = B.F_SUBJECTCODE
WHERE B.F_SUBJECTCODE = 1002.01
