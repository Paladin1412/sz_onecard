-- =============================================
-- AUTHOR:		liuhe
-- CREATE DATE: 2012-09-04
-- DESCRIPTION:	礼金卡批量售卡调用，售卡返销
-- =============================================
CREATE OR REPLACE PROCEDURE SP_CG_BatchSaleCardRollback
(
    P_ID              CHAR, -- 返销现金台账ID 
    P_CARDNO          CHAR, -- 读卡-卡号
    P_CARDTRADENO     CHAR, -- 读卡-联机交易序号
    P_WALLET1         INT , -- 读卡-电子钱包余额1
    P_CURRCARDNO      CHAR, -- 操作员卡号
	P_TRADEID       OUT CHAR,--台账ID
    P_CURROPER        CHAR,
    P_CURRDEPT        CHAR,
    P_RETCODE     OUT CHAR,
    P_RETMSG      OUT VARCHAR2
)
AS
    V_SEQ           CHAR(16);
    V_SUPPLYMONEY     INT;
    V_DEPOSIT         INT;
	V_CANCELTRADEID   CHAR(16);
    V_OPTIME          DATE := NULL;
    V_PREVTRADENO     TF_CARD_TRADE.CARDTRADENO%TYPE;
    V_NEXTTRADENO     TF_CARD_TRADE.NEXTCARDTRADENO%TYPE;
    V_EX EXCEPTION;
BEGIN

	--1) 判断当日当班
	V_CANCELTRADEID := NULL;

	FOR V_CUR IN 
	(
		SELECT * FROM TF_B_TRADE 
		WHERE  CARDNO = P_CARDNO AND OPERATESTAFFNO = P_CURROPER
		AND    OPERATETIME BETWEEN TRUNC(SYSDATE, 'DD') AND SYSDATE
		AND    CANCELTAG = '0' AND CANCELTRADEID IS NULL
		ORDER BY OPERATETIME DESC
	)
	LOOP
		IF V_OPTIME IS NULL THEN
			V_OPTIME := V_CUR.OPERATETIME;
		END IF;
		
		EXIT WHEN V_OPTIME <> V_CUR.OPERATETIME;
		
		IF V_CUR.TRADETYPECODE IN('50', '51') THEN
			V_CANCELTRADEID := V_CUR.TRADEID;
			EXIT;
		END IF;
	END LOOP;

	IF V_CANCELTRADEID IS NULL THEN
		P_RETCODE := '-20101';
		P_RETMSG  := '没有当日当班可以返销的售卡交易';
		RETURN;
	END IF;
   
   --) 2 判断余额是否为0
	IF P_WALLET1 != 0 THEN
		P_RETCODE := '-20102';
		P_RETMSG  := '当前钱包1余额不为0，不能返销';
		RETURN;
	END IF;

	--3) 判断交易序号是否发生变化
	SELECT CARDTRADENO, NEXTCARDTRADENO
	INTO   V_PREVTRADENO, V_NEXTTRADENO
	FROM   TF_CARD_TRADE
	WHERE  TRADEID = V_CANCELTRADEID;

	IF P_CARDTRADENO != V_PREVTRADENO THEN
		P_RETCODE := '-20104';
		P_RETMSG  := '当前卡片钱包1余额为0，但是卡片交易序号已经发生变化，不能返销';
		RETURN;
	END IF;


	-- 5) 调用售卡返销存储过程
	SP_PB_SALECARDROLLBACK
	(
		P_ID, P_CARDNO , P_CARDTRADENO, 0, 0, 0,
		V_CANCELTRADEID, 0, 0, '112233445566', P_CURRCARDNO, V_SEQ, 
		P_CURROPER, P_CURRDEPT, P_RETCODE, P_RETMSG
	);
	P_TRADEID := V_SEQ;
	IF P_RETCODE != '0000000000' THEN
		ROLLBACK; RETURN;
	END IF;

	BEGIN	
		-- 修正费用
		SELECT CARDDEPOSITFEE, SUPPLYMONEY
		INTO   V_DEPOSIT, V_SUPPLYMONEY
		FROM   TF_B_TRADEFEE
		WHERE  TRADEID = V_CANCELTRADEID;

		UPDATE TF_B_TRADEFEE T
		SET    T.SUPPLYMONEY = -V_SUPPLYMONEY,
			   T.CARDDEPOSITFEE = -V_DEPOSIT
		WHERE  T.TRADEID = V_SEQ;

		-- 如果是回收卡再售卡，需要修正库存状态为回收
		UPDATE TL_R_ICUSER SET RESSTATECODE = '04'
		WHERE  CARDNO = P_CARDNO
		AND    EXISTS (
			SELECT 1 FROM TF_B_TRADE
			WHERE TRADEID = V_CANCELTRADEID 
			AND   TRADETYPECODE = '51');		
			
		EXCEPTION WHEN OTHERS THEN
		P_RETCODE := 'S009009911';
		P_RETMSG  := '返销后修正台账表失败';
		ROLLBACK; RETURN;
	END;
	
		
	-- 代理营业厅抵扣预付款，根据保证金修改可领卡额度，ADD BY LIUHE 20111230
	 BEGIN
	   SP_PB_DEPTBALFEEROLLBACK(V_SEQ, V_CANCELTRADEID,
			'3' ,--1预付款,2保证金,3预付款和保证金
			 - V_SUPPLYMONEY - V_DEPOSIT,
					 P_CURROPER,P_CURRDEPT,P_RETCODE,P_RETMSG);
						 
	   IF P_RETCODE != '0000000000' THEN RAISE V_EX; END IF;
		  EXCEPTION
		  WHEN OTHERS THEN
			  ROLLBACK; RETURN;
	 END;

    P_RETCODE := '0000000000';
    P_RETMSG  := '';
    COMMIT; RETURN;


END;

/
SHOW ERRORS

