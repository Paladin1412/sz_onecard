CREATE OR REPLACE PROCEDURE SP_WA_IMPORTGRAYLIST
(
    P_SESSIONID       CHAR,
    P_CURROPER        CHAR,
    P_CURRDEPT        CHAR,
    P_RETCODE         OUT CHAR, -- RETURN CODE
    P_RETMSG          OUT VARCHAR2  -- RETURN MESSAGE
)
AS
    V_TODAY           DATE:=SYSDATE;
    V_EX              EXCEPTION;

    V_CARDNO          VARCHAR2(16);       --卡号

BEGIN
  FOR V_C IN (SELECT * FROM TMP_BLACKLIST WHERE F0 = P_SESSIONID)
    LOOP
        --新增灰名单
        BEGIN
		INSERT INTO TF_B_WARN_GRAY
        (CARDNO			, CREATETIME	, WARNTYPE	, WARNLEVEL		,
        UPDATESTAFFNO	, UPDATETIME	, DOWNTIME	, REMARK		,
        GRAYSTATE		, GRAYTYPE		, GRAYLEVEL	, OVERTIMEMONEY	,
		CITYCODE)
		VALUES
        (V_C.F1			, V_TODAY		, NULL		, '1'			,
        P_CURROPER		, V_TODAY		, NULL		, '批量导入'	,
        '0'				, '0'			, '0'		, 0				,
		'2150');
          IF  SQL%ROWCOUNT != 1 THEN RAISE V_EX; END IF;
                EXCEPTION
                WHEN OTHERS THEN
                  P_RETCODE := 'S002W01089';
                  P_RETMSG  := '新增灰名单表失败'||SQLERRM;
                  ROLLBACK; RETURN;
        END;

           -- 生成备份台账
  BEGIN
    INSERT INTO TH_B_WARN_GRAY
    (HSEQNO			, BACKTIME		, BACKSTAFF		, BACKWHY		,
	CARDNO			, CREATETIME	, WARNTYPE		, WARNLEVEL		,
    UPDATESTAFFNO	, UPDATETIME	, DOWNTIME		, REMARK		,
    GRAYSTATE		, GRAYTYPE		, GRAYLEVEL		, OVERTIMEMONEY ,
	CITYCODE)
    SELECT
	TH_B_WARN_GRAY_SEQ.NEXTVAL, V_TODAY, P_CURROPER	,  '5'			,
	CARDNO			, CREATETIME	, WARNTYPE		, WARNLEVEL		,
	UPDATESTAFFNO	, UPDATETIME	, DOWNTIME		, REMARK		,
	GRAYSTATE		, GRAYTYPE		, GRAYLEVEL		,OVERTIMEMONEY	,
	CITYCODE
    FROM	TF_B_WARN_GRAY
    WHERE	CARDNO = V_C.F1;

    EXCEPTION
          WHEN OTHERS THEN
              P_RETCODE := 'S002W01090';
              P_RETMSG  := '新增灰名单备份表失败' || SQLERRM;
              ROLLBACK; RETURN;
    END;
    END LOOP;

  P_RETCODE := '0000000000';
  P_RETMSG  := '';
  COMMIT; RETURN;

END;
/
SHOW ERRORS