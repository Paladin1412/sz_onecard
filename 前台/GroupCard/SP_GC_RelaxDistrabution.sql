CREATE OR REPLACE PROCEDURE SP_GC_RelaxDistrabution
(
		P_SESSIONID			CHAR,			--SESSIONID
		
		P_CURROPER			CHAR,
		P_CURRDEPT			CHAR,
		P_RETCODE	        OUT CHAR, 		-- RETURN CODE
		P_RETMSG     	    OUT VARCHAR2	-- RETURN MESSAGE
)
AS
    V_EX          		EXCEPTION;
	V_ORDERCOUNT		INT;
	V_TODAY				DATE := SYSDATE;
    V_SEQNO				CHAR(16);			--流水号
BEGIN
	FOR V_CUR IN (SELECT F0,F1,F2,F3 FROM TMP_ORDER WHERE F0 = P_SESSIONID)
	LOOP
		--判断子订单是否制卡完成
		BEGIN
			SELECT COUNT(ORDERDETAILID) INTO V_ORDERCOUNT 
			FROM TF_F_XXOL_ORDERDETAIL 
			WHERE ORDERNO = V_CUR.F1 AND DETAILSTATES != '1';
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN NULL;
		END;
		
		IF (V_ORDERCOUNT > 0) THEN
			P_RETCODE := 'I094780015';
			P_RETMSG  := '该订单下还有未制卡完成的子订单';
			ROLLBACK; RETURN;
		END IF;
		
		--更新联机休闲年卡订单表
		BEGIN
			UPDATE TF_F_XXOL_ORDER 
				SET ORDERSTATES		= '2',
					TRACKINGCOPCODE = V_CUR.F2,
					TRACKINGNO		= V_CUR.F3,
					UPDATESTAFFNO	= P_CURROPER,
					UPDATEDEPARTID	= P_CURRDEPT,
					UPDATETIME		= V_TODAY
			WHERE	ORDERNO 		= V_CUR.F1;
		   EXCEPTION
			  WHEN OTHERS THEN
				P_RETCODE := 'S094780091';
				P_RETMSG := '更新订单表失败' || SQLERRM;
			  ROLLBACK;RETURN;
		END;
		
		FOR V_CR IN (SELECT ORDERDETAILID FROM TF_F_XXOL_ORDERDETAIL WHERE ORDERNO = V_CUR.F1)
		LOOP
		
			--获取流水号
			SP_GETSEQ(SEQ => V_SEQNO);
			--记录订单台帐表
			BEGIN
				INSERT INTO TF_B_XXOL_TRADE(
				TRADEID			, ORDERNO			,ORDERDETAILID		, TRADETYPECODE	,
				UPDATEDEPARTID	, UPDATESTAFFNO		,OPERATETIME    )
			  SELECT 
				V_SEQNO			,V_CUR.F1			,ORDERDETAILID		, '03'			,
				P_CURRDEPT		, P_CURROPER		,V_TODAY
			  FROM TF_F_XXOL_ORDERDETAIL WHERE ORDERDETAILID = V_CR.ORDERDETAILID;
			EXCEPTION
				  WHEN OTHERS THEN
					P_RETCODE := 'S094780092';
					P_RETMSG  := '记录订单台帐表失败'||SQLERRM;
					ROLLBACK; RETURN;
			END;
		END LOOP;
	END LOOP;
   
	P_RETCODE := '0000000000';
	P_RETMSG  := '';
	COMMIT; RETURN;
END;

/

SHOW ERRORS

 