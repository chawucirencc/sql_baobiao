-- 预制发票(ACC30.采购发票)
-- 条件
SELECT A.F_INVID, A.F_INVDATE, A.F_SELLERNAME, A.F_PURCHASERNAME 
FROM ACC_INVHEAD A 
WHERE A.F_INVID = :INVID 

-- 采购发票表
-- v1.0
SELECT  CONCAT(" ", A.F_INVID, "\'") AS 发票号码, 
        DATE_FORMAT(A.F_INVDATE, '%%Y-%%m-%%d') AS 发票日期, 
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

-- 修改
-- v2.0
SELECT  CONCAT(" ", A.F_INVID, "\'") AS 发票号码, 
        DATE_FORMAT(A.F_INVDATE, '%%Y-%%m-%%d') AS 发票日期, 
        CONCAT("公司名称：", A.F_PURCHASERNAME) AS 购方名称, 
        CONCAT("纳税人识别号：", D.F_TAXCODE) AS 购方纳税人识别号, 
        CONCAT("开票地址：", D.F_ADDRESS) AS 购方地址,
        CONCAT("电话：", D.F_TEL) AS 电话, 
        CONCAT("开户银行：", D.F_BANK) AS 购方开户行,
        CONCAT("银行账号：", D.F_BANKACCOUNT) AS 银行账号, 
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
LEFT JOIN DB_ORGS D ON A.F_PURCHASERNAME = D.F_NAME
WHERE A.F_INVID=:ID 
WHERE A.F_INVID=66201911050022
---------------------
-- v3.0
SELECT  CONCAT(" ", A.F_INVID, "\'") AS 发票号码, 
        DATE_FORMAT(A.F_INVDATE, '%%Y-%%m-%%d') AS 发票日期, 
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
LEFT JOIN BAS_HSGOODS D ON C.F_ID = D.F_HSGOODSID 
WHERE A.F_INVID=:ID 
GROUP BY  B.F_PRICE 
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

-- 明细账(暂未做完) V1（找不到连表的字段）
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

-- 入库明细表（TT25）
-- 参数columns处应该在每行前面加一个空格，以区分多参数。
SELECT A.F_STATUS AS 状态, B.F_SUPPLIER AS 供应商, C.F_CONTRACTNO AS 合同号, E.F_GOODSCODE AS 物料代码, 
E.F_GOODSNAME AS 物品名称, E.F_GOODSMODEL AS 规格, 
E.F_GOODSPACKAGEMODEL AS 包装规格, D.F_REFUNIT AS 常用单位, round(D.F_PRICE*D.F_EXRATE, 4) AS 采购单价, 
(B.F_ACTQTY/D.F_EXRATE) AS 实发生数量, SUM(round((B.F_ACTQTY/D.F_EXRATE), 2)) AS 总数量, 
round(((D.F_PRICE*D.F_EXRATE)*(B.F_ACTQTY/D.F_EXRATE)), 3) AS 金额, 
SUM(round(((D.F_PRICE*D.F_EXRATE)*(B.F_ACTQTY/D.F_EXRATE)), 3)) AS AMT, 
C.F_SERVICETYPE AS 发货代码, D.F_EXRATE

FROM MPS_PREBODY B
LEFT JOIN MPS_PREHEAD A ON A.F_BILLID = B.F_PBILLID 
LEFT JOIN PUR_ORDERHEAD C ON B.F_BILLID = C.F_BILLID 
LEFT JOIN PUR_ORDERBODY D ON (B.F_BILLID = D.F_BILLID AND B.F_GOODSID = D.F_GOODSID) 
LEFT JOIN BAS_GOODS E ON B.F_GOODSID = E.F_GOODSID 

WHERE B.F_WORKNO = :F_WORKNO AND (A.F_STATUS >0 OR A.F_STATUS IS NULL)
GROUP BY B.F_SUPPLIER, C.F_CONTRACTNO, E.F_GOODSCODE, 采购单价, C.F_SERVICETYPE

/*------------------------------------------------------------------------------------------------------------*/
-- 参考（出入库明细）
SELECT A.F_APPROVETIME,A.F_BILLID,A.F_BILLTYPE,A.F_FROMORGID,A.F_FROMORGNAME,A.F_TOORGID,A.F_TOORGNAME,
        A.F_SUPPLIERID,C.F_SNAME,A.F_GOODSID,B.F_GOODSCODE,B.F_GOODSNAME,B.F_GOODSMODEL,B.F_MPSUNIT,
        A.INQTY/B.F_MPSUNITEXRATE AS INQTY  ,A.INPRICE*B.F_MPSUNITEXRATE AS INPRICE,A.INAMT,
        A.OUTQTY/B.F_MPSUNITEXRATE AS OUTQTY,A.OUTPRICE*B.F_MPSUNITEXRATE AS OUTPRICE ,A.OUTAMT,
        (A.INQTY-A.OUTQTY)/B.F_MPSUNITEXRATE  AS 结存数量,A.INAMT-A.OUTAMT AS 结存金额,
        A.CK,A.F_SOURCEBILLID,A.F_CONTRACTNO,B.F_CURRENCY
FROM
(
SELECT B.F_APPROVETIME,B.F_BILLTYPE,B.F_BILLID,IFNULL(A.F_FROMORGID,B.F_FROMORGID) AS F_FROMORGID,
        IFNULL(A.F_FROMORGNAME,B.F_FROMORGNAME) AS F_FROMORGNAME,IFNULL(A.F_TOORGID,B.F_TOORGID) AS F_TOORGID,
        IFNULL(A.F_TOORGNAME,B.F_TOORGNAME) AS F_TOORGNAME,A.F_SUPPLIERID,A.F_GOODSID,A.F_REFUNIT,
        A.F_ACTQTY AS INQTY,A.F_PRICE AS INPRICE,A.F_AMT AS INAMT,0 AS OUTQTY, 0 AS OUTPRICE, 
        0 AS OUTAMT,CONCAT_WS('',IFNULL(A.F_FROMORGNAME,B.F_FROMORGNAME),
        IFNULL(A.F_TOORGNAME,B.F_TOORGNAME)) AS CK,A.F_SOURCEBILLID,A.F_CONTRACTNO
FROM INV_CHANGEBODY A
JOIN INV_CHANGEHEAD B ON A.F_BILLID=B.F_BILLID
WHERE (B.F_BILLTYPE='0' OR B.F_BILLTYPE='A' OR B.F_BILLTYPE='I' OR B.F_BILLTYPE='2' OR B.F_BILLTYPE='X') AND B.F_STATuS>=5
UNION ALL
SELECT B.F_APPROVETIME,B.F_BILLTYPE,B.F_BILLID,IFNULL(A.F_FROMORGID,B.F_FROMORGID) AS F_FROMORGID,
        IFNULL(A.F_FROMORGNAME,B.F_FROMORGNAME) AS F_FROMORGNAME,IFNULL(A.F_TOORGID,B.F_TOORGID) AS F_TOORGID,
        IFNULL(A.F_TOORGNAME,B.F_TOORGNAME) AS F_TOORGNAME,A.F_SUPPLIERID,A.F_GOODSID,A.F_REFUNIT,0 AS INQTY,
        0 AS INPRICE,0 AS INAMT,A.F_ACTQTY AS OUTQTY, A.F_PRICE AS OUTPRICE, A.F_AMT AS OUTAMT,
        CONCAT_WS('',IFNULL(A.F_FROMORGNAME,B.F_FROMORGNAME),IFNULL(A.F_TOORGNAME,B.F_TOORGNAME)) AS CK,
        A.F_SOURCEBILLID,A.F_CONTRACTNO
FROM INV_CHANGEBODY A 
JOIN INV_CHANGEHEAD B ON A.F_BILLID=B.F_BILLID 
WHERE (B.F_BILLTYPE='3' OR B.F_BILLTYPE='O' OR B.F_BILLTYPE='2' OR B.F_BILLTYPE='1' OR B.F_BILLTYPE='X' ) AND B.F_STATuS>=5
) A 
LEFT JOIN BAS_GOODS B ON A.F_GOODSID=B.F_GOODSID 
LEFT JOIN DB_ORGS C ON A.F_SUPPLIERID=C.F_ID
WHERE A.F_APPROVETIME>=:START_DATE AND A.F_APPROVETIME<=DATE_ADD(:END_DATE,interval 1 day)
AND ( :物料编码='' OR B.F_GOODSCODE LIKE CONCAT('%', :物料编码,'%'))
AND ( :物料名称='' OR B.F_GOODSNAME LIKE CONCAT('%', :物料名称,'%'))
AND ( :供应商='' OR C.F_SNAME LIKE CONCAT('%', :供应商,'%'))
AND ( :仓库='' OR A.CK LIKE CONCAT('%',:仓库,'%'))
AND ( :合同号='' OR A.F_CONTRACTNO LIKE CONCAT('%',:合同号,'%'))
ORDER BY F_APPROVETIME,F_GOODSID
LIMIT 15000

/* AND ( 发货仓库='' OR A.F_FROMORGNAME LIKE CONCAT('%', 发货仓库,'%')) */
/* AND ( 收货仓库='' OR A.F_TOORGNAME LIKE CONCAT('%', 收货仓库,'%')) */

-- 参数
showFields=F_GOODSCODE,F_APPROVETIME,F_BILLTYPE,F_BILLID,F_SNAME,F_FROMORGNAME,F_TOORGNAME,F_GOODSNAME,F_GOODSMODEL,
F_MPSUNIT,INQTY,INPRICE,INAMT,OUTQTY,OUTPRICE,OUTAMT,结存数量,结存金额,F_SOURCEBILLID,F_CONTRACTNO,F_CURRENCY
columns=
  F_APPROVETIME=业务日期,,
 F_CONTRACTNO=合同号,,300
  F_BILLID=单据号,,180
  F_GOODSCODE=物品编码,,160
  F_GOODSNAME=物品名称,,
  F_SNAME=供应商名称,,180
  F_FROMORGNAME=发货仓库,,
  F_TOORGNAME=收货仓库,,
  F_GOODSMODEL=规格,,
  F_BILLTYPE=单据类型,INV_CHANGEHEAD.F_BILLTYPE,100
  F_MPSUNIT=单位,,90
  INQTY=入库数量,INV_CHANGEBODY.F_AMT,
  INPRICE=入库单价,INV_CHANGEBODY.F_PRICE,
  INAMT=入库金额,INV_CHANGEBODY.F_AMT,
  OUTQTY=出库数量,INV_CHANGEBODY.F_AMT,
  OUTPRICE=出库单价,INV_CHANGEBODY.F_PRICE,
  OUTAMT=出库金额,INV_CHANGEBODY.F_AMT,
  结存数量=结存数量,INV_CHANGEBODY.F_AMT,
  结存金额=结存金额,INV_CHANGEBODY.F_AMT,
  F_CURRENCY=币别,,

rowNumber=1
groupFields=F_GOODSID
sumFields=INQTY,INAMT,OUTQTY,OUTAMT,结存数量,结存金额
/*----------------------------------------------------------------------------------------------------*/

-- 资金明细（汇总）查看(ACC35&ACC37)
-- 如果按区域汇总，对国家进行分组，对金额进行汇总SUM.需要对总金额进行单独查询，使其成为新表的一列。
SELECT B.F_ROOTID, B.F_CI AS 国家标识, CASE
WHEN B.F_CI='1000' THEN '中国' 
WHEN B.F_CI='2000' THEN '坦桑'
WHEN B.F_CI='3000' THEN '南非'
WHEN B.F_CI='4000' THEN '肯尼亚'
WHEN B.F_CI='5000' THEN '莫桑楠普拉'
WHEN B.F_CI='6000' THEN '中国香港'
WHEN B.F_CI='7000' THEN '莫桑马普托'
WHEN B.F_CI='20000437' THEN '加纳'
WHEN B.F_CI='20000438' THEN '尼日利亚' 
END AS 国家,
B.F_ACCOUNTNAME, A.F_DATE, A.F_ORGNAME, B.F_BANKACCOUNT, A.F_CURRENCY, A.F_AMT, A.F_INAMT, A.F_ACCEPTAMT, A.F_OUTAMT, A.F_NETAMT, A.F_EXRATE, A.F_NETAMT_USD, 
 (A.F_NETAMT_USD/10000) AS 万美元, A.F_REMARK 
FROM FC_ACCLOG A 
LEFT JOIN DB_ORGS B ON A.F_ORGID = B.F_ID 
WHERE A.F_STATUS = 1 
AND (:国家标识=' ' OR B.F_CI=:国家标识) 
AND (:银行账号名称=' ' OR A.F_ORGNAME LIKE CONCAT('%',:银行账号名称,'%')) 
ORDER BY 国家 


-- 发货统计（ACC36）
SELECT A.F_WORKNO AS 工作号, A.F_APPROVETIME AS 审核日期, 
        A.F_SENDNAME AS 发货人, A.F_RECVNAME AS 收货人, A.F_STATUS AS 状态 
FROM MPS_SOWORKNO A 
WHERE A.F_STATUS >= 5 
AND A.F_APPROVETIME>=:START_DATE AND A.F_APPROVETIME<=:END_DATE 
AND (:工作号=' ' OR A.F_WORKNO LIKE CONCAT('%',:工作号,'%'))
AND (:发货人=' ' OR A.F_SENDNAME LIKE CONCAT('%',:发货人,'%'))
AND (:收货人=' ' OR A.F_RECVNAME LIKE CONCAT('%',:收货人,'%'))

-- 单据状态
dicts.C_BillStatus = [["0", "草稿"], ["1", "待确认"], ["2", "待预审"], ["3", "待审核"], ["4", "待批准"], 
                        ["5", "已批准"], ["6", "已结算"], ["8", "已结案"], ["9", "已终止"]]; 

dicts.C_ACC_BILLTYPE=[['1', '应收'], ['2', '应付'], ['3', '费用']];

//来源单费用类型		
dicts.C_SOURCEBILLTYPE=[
	['1', '清关费用'], 
	['2', '单证费用'], 
	['3', '货款'], 
	['4', '运输费用'], 	
	['5', '费用报销'],
	['6', '销售货款'],
	['7', '采购货款'],
	['8', '采购发票']
];
// 单据状态
dicts.C_BillStatus = [["0", "草稿"], ["1", "待确认"], ["2", "待预审"], 
                ["3", "待审核"], ["4", "待批准"], ["5", "已批准"], 
                ["6", "已结算"], ["8", "已结案"], ["9", "已终止"]];

-- 肯尼亚财务(TT05-4)
SELECT CONCAT(B.F_ARPID,'_') AS 单据编号,B.F_STATUS,DATE_FORMAT(B.F_DATE,'%%Y-%%m-%%d') AS 业务日期,
DATE_FORMAT(B.F_CHECKDATE,'%%Y-%%m-%%d')  AS  审核日期,B.F_WORKNO AS 工作号,B.F_SERVICETYPE AS 发货代码,
IFNULL(A.F_ITEMNAME,1) AS 费用名称,C.F_SNAME AS 供应商,
 (CASE WHEN B.F_SETTLETYPE=0 THEN '月结' WHEN B.F_SETTLETYPE=1 THEN '票结'  ELSE ' ' END) AS 结算方式,B.F_CURRENCYID AS 币种,
B.F_CURRENCY,B.F_EXRATE AS 汇率,A.F_AMT AS 金额,B.F_EXRATE*A.F_AMT AS 金额RMB,
A.F_REMARK AS 费项明细备注 ,B.F_REMARK AS 单据总备注,B.F_USAGE,B.F_DEPTNAME AS 部门,B.F_EMPNAME 
FROM ACC_ARPBILLBODY A
JOIN   ACC_ARPBILLHEAD B ON B.F_ARPID=A.F_ARPID
JOIN DB_ORGS C ON C.F_ID=B.F_DEALINGSID
WHERE B.F_STATUS>=2 AND A.F_AMT>0  
AND B.F_DATE>='2018-12-01'
AND B.F_DATE>=:START_DATE  AND  B.F_DATE<=DATE_ADD(:END_DATE,interval 1 day)
AND (:工作号='' OR B.F_WORKNO LIKE CONCAT('%',:工作号,'%')) 
AND ( :费用名称=''  OR A.F_ITEMNAME  LIKE CONCAT('%',:费用名称,'%'))
AND B.F_CI=4000 OR B.F_CI=1000
ORDER BY  B.F_WORKNO,B.F_DATE 
/*---------------------------------------------------------------------------*/
-- 参数
showFields=单据编号,F_STATUS,业务日期,审核日期,工作号,发货代码,费用名称,供应商,结算方式,F_CURRENCY,汇率,金额,费项明细备注,
单据总备注,F_USAGE,部门,F_EMPNAME
columns=
 发货代码=发货代码,,70
 业务日期=业务日期,,110
 供应商=供应商,,180
 工作号=工作号,,150
 结算方式=结算方式,,65
 F_CURRENCY=币别,,65
 汇率=汇率,,65
 金额=金额,INV_CHANGEBODY.F_AMT,120
  金额RMB=金额RMB,INV_CHANGEBODY.F_AMT,120
 费项表体备注=费项表体备注,,180
 单据表头备注=单据表头备注,,180
 F_STATUS=单据状态,ACC_ARPBILLHEAD.F_STATUS,

sumFields=金额,金额RMB
rowNumber=1

/*---------------------------------------------------------------------------*/
-- 国内财务（TT05）
SELECT CONCAT(B.F_ARPID,'_') AS 单据编号,B.F_STATUS,DATE_FORMAT(B.F_DATE,'%%Y-%%m-%%d') AS 业务日期,
B.F_WORKNO AS 工作号,B.F_SERVICETYPE AS 发货代码,
IFNULL(A.F_ITEMNAME,1) AS 费用名称,C.F_SNAME AS 供应商,
 (CASE WHEN B.F_SETTLETYPE=0 THEN '月结' WHEN B.F_SETTLETYPE=1 THEN '票结'  ELSE ' ' END) AS 结算方式,B.F_CURRENCYID AS 币种,
B.F_CURRENCY,B.F_EXRATE AS 汇率,A.F_AMT AS 金额,B.F_EXRATE*A.F_AMT AS 金额RMB,
A.F_REMARK AS 费项明细备注 ,B.F_REMARK AS 单据总备注,B.F_USAGE,B.F_DEPTNAME AS 部门,B.F_EMPNAME 
FROM ACC_ARPBILLBODY A
JOIN   ACC_ARPBILLHEAD B ON B.F_ARPID=A.F_ARPID
JOIN DB_ORGS C ON C.F_ID=B.F_DEALINGSID
WHERE B.F_STATUS>=2 AND B.F_BILLTYPE=2 AND B.F_SOURCETYPE=2 AND A.F_AMT>0 
AND B.F_DATE>='2018-12-01'
AND  B.F_DATE>=:START_DATE  AND  B.F_DATE<=DATE_ADD(:END_DATE,interval 1 day)
AND (:工作号='' OR B.F_WORKNO LIKE CONCAT('%',:工作号,'%'))   
AND (:费用名称=''  OR A.F_ITEMNAME  LIKE CONCAT('%',:费用名称,'%'))
AND (:供应商='' OR C.F_SNAME LIKE CONCAT('%',:供应商,'%'))
AND B.F_CI=1000
ORDER BY  B.F_WORKNO,B.F_DATE 

INV_CHANGEBODY.F_AMT