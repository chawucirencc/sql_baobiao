-- 预制发票(ACC30.采购发票)
-- 条件
SELECT A.F_INVID, A.F_INVDATE, A.F_SELLERNAME, A.F_PURCHASERNAME 
FROM ACC_INVHEAD A 
WHERE A.F_INVID = :INVID 

-- 采购发票表
SELECT  CONCAT(" ", A.F_INVID, "\'") AS 发票号码, DATE_FORMAT(A.F_INVDATE, '%%Y-%%m-%%d') AS 发票日期, 
        CONCAT("公司名称：", A.F_PURCHASERNAME) AS 购方名称, 
        CONCAT("纳税人识别号：", A.F_PURCHASERREGCODE) AS 购方纳税人识别号, 
        CONCAT("开票地址：", substring_index(A.F_PURCHASERADDRESS, "0", 1)) AS 购方地址,
        CONCAT("电话：", RIGHT(A.F_PURCHASERADDRESS, 13)) AS 电话, 
        CONCAT("开户银行：", substring_index(A.F_PURCHASERBANKINFO, "行", 2), "行") AS 购方开户行,
        CONCAT("银行账号：", substring_index(A.F_PURCHASERBANKINFO, "行", -1)) AS 银行账号, 
        A.F_SELLERNAME AS 售方名称, 
        A.F_SELLERREGCODE AS 售方纳税人识别号, 
        A.F_SELLERADDRESS AS 售方地址, 
        A.F_SELLERBANKINFO AS 售方开户行, 
        B.F_ITEMNAME AS 名称,B.F_ITEMTYPE AS 规格型号, B.F_UNIT AS 单位, B.F_QTY AS 数量, B.F_PRICE AS 单价, 
        CONVERT(B.F_NETAMT+B.F_TAX, decimal(10,2)) AS 金额, B.F_TAXRATE AS 税率, 
        CONVERT(B.F_TAX, decimal(10,2)) AS 税额, A.F_REMARK AS 备注, A.F_WORKNO AS 工作号, 
        DATE_FORMAT(C.F_ACTSHIPDATE, "%%Y-%%m-%%d") AS 装柜日期, A.F_WORKNO 工作号 
FROM ACC_INVHEAD A  
LEFT JOIN ACC_INVBODY B ON A.F_INVID = B.F_INVID 
LEFT JOIN MPS_SOWORKNO C ON A.F_WORKNO = C.F_WORKNO 
WHERE A.F_INVID=:ID 
WHERE A.F_INVID=66201911050022
/*------------------------------------------------------------------------------------------------------------*/

-- 收付款单(ACC31)
-- 主表
SELECT A.F_RPID, DATE_FORMAT(A.F_DATE, "%%Y-%%m-%%d") AS 日期, A.F_DEPTID, A.F_CURRENCY, A.F_EXRATE, A.F_SERVICETYPE, 
        A.F_WORKNO, A.F_HUBID, A.F_CONTRACTNO, A.F_DEALINGSNAME, A.F_AMT, A.F_USAGE, A.F_REMARK, A.F_EMPNAME,  
        A.F_BILLTYPE, A.F_CATEGORY
FROM ACC_RPBILLHEAD A 
LEFT JOIN ACC_RPBILLBODY B ON A.F_RPID = B.F_RPID 
WHERE A.F_RPID = :F_RPID 
-- 收付款单 
-- 表体 
-- 金额存在一点问题，应该取表头的金额，发生金额。（A.F_AMT）
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
-- GROUP BY A.F_RPID
/*------------------------------------------------------------------------------------------------------------*/
-- 测试
SELECT A.F_RPID, DATE_FORMAT(A.F_DATE, "%%Y-%%m-%%d") AS 日期, FORMAT(B.F_AMT, 2) AS 金额
FROM ACC_RPBILLHEAD A 
LEFT JOIN ACC_RPBILLBODY B ON A.F_RPID = B.F_RPID 
WHERE A.F_RPID =61201910310029 
/*------------------------------------------------------------------------------------------------------------*/

--费用报销单(后勤采购)(ACC32)
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
--个人费用报销(明细)(ACC33, ACC34)
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

-- 明细账(暂未做完) V1
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

-----
-- V2
SELECT A.F_CADATE AS 凭证日期, A.F_CASN AS 凭证号, B.F_SUBJECT AS 凭证摘要, B.F_DRAMT AS 借方金额, B.F_CRAMT AS 贷方金额, 
        

/*------------------------------------------------------------------------------------------------------------*/
-- 采购订单(CG05)
-- 主表 
-- 这里遇到了一个比较奇怪的bug，主要是自己没有理解清楚多条记录和表头的关系，两者用不同的逻辑和方法。
-- 原表暂时不用变。添加了一些合同里面的字段。
SELECT A.F_SUPPLIER AS 供应商, DATE_FORMAT(A.F_CREATETIME, '%%Y-%%m-%%d') AS 下单时间, 
(CASE 
WHEN A.F_SERVICETYPE='01' THEN '佛山市博亿达进出口有限公司' 
WHEN A.F_SERVICETYPE='02' THEN '佛山市万通亿达进出口有限公司' 
WHEN A.F_SERVICETYPE='03' THEN '广东博航建材有限公司' 
WHEN A.F_SERVICETYPE='04' THEN '佛山博亿达供应链有限公司' END) AS 退税公司中文名, 
A.F_CONTRACTNO AS 合同编号 
FROM PUR_ORDERHEAD A 
WHERE A.F_BILLID = :ID

-- -- -- -- -- -- -- -- - --  - - - - - --
SELECT A.F_SUPPLIER AS 供应商, C.F_GOODSTYPENAME AS 物料名称, C.F_GOODSCODE AS 物品编码, C.F_GOODSMODEL AS 规格, 
        B.F_QTY AS 采购数量, B.F_RECVQTY AS 已收到数量, B.F_REFUNIT AS 单位, B.F_PRICE AS 单价,  
        C.F_GOODSPACKAGEMODEL AS 包装规格, B.F_AMT AS 金额, A.F_REMARK AS 备注, C.F_PY AS 助记码
FROM PUR_ORDERHEAD A  
LEFT JOIN PUR_ORDERBODY B ON B.F_BILLID=A.F_BILLID 
LEFT JOIN BAS_GOODS C ON C.F_GOODSID=B.F_GOODSID 
WHERE A.F_BILLID=32201910190008 

SELECT A.F_SUPPLIER AS 供应商, C.F_GOODSMODEL AS 规格,C.F_GOODSTYPENAME AS 物料名称, C.F_GOODSCODE AS 物品编码, 
        B.F_AMT AS 金额,CAST((B.F_PRICE*B.F_EXRATE) AS DECIMAL(10,2)) AS 单价, IF(A.F_PAYTYPE='0', '月结', '票结') AS 结算方式, 
   SUM(CEILING(B.F_QTY*IFNULL(C.F_GOODSPACKAGEQTY,1)/C.F_GOODSPACKAGEUNITEXRATE)) AS 采购数量,  
   C.F_HSCODE AS HS编码,C.F_PY AS 助记码, substr(C.F_GOODSPACKAGEUNIT,1,instr(C.F_GOODSPACKAGEUNIT,'(')-1) AS 件数单位, 
   C.F_GOODSPACKAGEMODEL AS 包装规格  
   FROM PUR_ORDERHEAD A  
   LEFT JOIN PUR_ORDERBODY B ON B.F_BILLID=A.F_BILLID 
  LEFT JOIN BAS_GOODS C ON C.F_GOODSID=B.F_GOODSID 
  WHERE A.F_BILLID=:ID 
  GROUP BY C.F_GOODSCODE 
-------------------------------------------------------------------------------
--合同条款
SELECT A.F_PRICEDESC AS 发票费, A.F_INVDAYS AS 发票天数, A.F_QC AS 质量标准, A.F_PACKAGEHINTS AS 包装要求, 
        A.F_DELIVERYDATE AS 交货时间, A.F_DELIVERYADDR AS 交货地点, A.F_FEEOWNER_ZX AS 装卸承担方, A.F_FEEOWNER_YS AS 运输承担方,  
        A.F_PRECENT AS 赔偿百分比, A.F_DISP1 AS 仲裁, A.F_DISP2 AS 所在地 , IF(A.F_PAYTYPE='0', '月结', '票结') AS 结算方式, 
        A.F_BALANCETYPE AS 付款方式
FROM PUR_ORDERHEAD A 
WHERE A.F_BILLID = :ID 
/*------------------------------------------------------------------------------------------------------------*/


