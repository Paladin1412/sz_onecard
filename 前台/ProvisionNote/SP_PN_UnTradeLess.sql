/* ------------------------------------
COPYRIGHT (C) 2010-2015 LINKAGE SOFTWARE 
 ALL RIGHTS RESERVED.
<AUTHOR>JIANGBB</AUTHOR>
<CREATEDATE>2015-07-09</CREATEDATE>
<DESCRIPTION>不匹配业务帐务确认</DESCRIPTION>
------------------------------------ */
CREATE OR REPLACE PROCEDURE SP_PN_UNTRADELESS
(
	P_SESSIONID			VARCHAR2,	--SESSIONID
	
	P_CURROPER          CHAR,
    P_CURRDEPT          CHAR,
    P_RETCODE   		OUT CHAR, -- RETURN CODE
    P_RETMSG    		OUT VARCHAR2  -- RETURN MESSAGE
)
AS		
	V_EX				EXCEPTION;
BEGIN

	FOR V_C IN (SELECT F1 FROM TMP_COMMON WHERE F0 = P_SESSIONID) LOOP
		--业务数据
		BEGIN
		UPDATE TF_F_BFJ_TRADERECORD T
		SET T.ISNEEDMATCH = '0'
		WHERE T.TRADEID = V_C.F1;
		EXCEPTION
			WHEN OTHERS THEN
				P_RETCODE := 'S05001C002'; P_RETMSG  := '更新系统业务账单表失败,' || SQLERRM;
				ROLLBACK; RETURN;
		END;
	END LOOP;

	
	

    P_RETCODE := '0000000000'; P_RETMSG := '';
    COMMIT;RETURN;
END;
/

SHOW ERRORS