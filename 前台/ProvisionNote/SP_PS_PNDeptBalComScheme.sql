/* ------------------------------------
COPYRIGHT (C) 2010-2015 LINKAGE SOFTWARE 
 ALL RIGHTS RESERVED.
<AUTHOR>JIANGBB</AUTHOR>
<CREATEDATE>2014-08-08</CREATEDATE>
<DESCRIPTION>代理网点结算单元佣金方案关系维护存储过程</DESCRIPTION>
------------------------------------ */
CREATE OR REPLACE PROCEDURE SP_PS_PNDeptBalComScheme
(
	P_BALUNITNO     CHAR,			--结算单元编号
	P_COMSCHEMENO   CHAR,			--佣金编码
	P_BEGINTIME     CHAR, 			--起始日期
	P_ENDTIME       CHAR,			--结束日期
	P_BALCOMSID   	CHAR,			--关联表ID
	P_OPTYPE        CHAR,			--操作类型 ADD;MODIFY;DELETE
	
	P_CURROPER 		CHAR,
	P_CURRDEPT		CHAR,
	P_RETCODE		OUT CHAR,
	P_RETMSG		OUT VARCHAR2
)
AS		
	V_CURRDATE  	DATE := SYSDATE;
    V_SEQ			CHAR(16);
	V_BALCOMSID		CHAR(8);
	V_EX			EXCEPTION;		--错误信息
BEGIN
	--新增功能
	IF P_OPTYPE = 'ADD' THEN
		SP_GETBIZAPPCODE(1, 'D2', 8, V_BALCOMSID);
		BEGIN
			INSERT INTO TD_DLBALUNIT_FEESCHEME
			(ID,BALUNITNO,COMSCHEMENO,BEGINTIME,ENDTIME,
			USETAG,UPDATESTAFFNO,UPDATETIME,REMARK)
			VALUES
			(V_BALCOMSID,P_BALUNITNO,P_COMSCHEMENO,TO_DATE(P_BEGINTIME, 'YYYY-MM-DD HH24:MI:SS'),TO_DATE(P_ENDTIME, 'YYYY-MM-DD HH24:MI:SS'),
			'1',P_CURROPER,V_CURRDATE,'');
			EXCEPTION
				WHEN OTHERS THEN
				P_RETCODE :='S05001B012'; P_RETMSG :='更新代理充值-银行手续费对应关系表失败'|| SQLERRM;
				RETURN; ROLLBACK;
		END;
	--修改功能
	ELSIF P_OPTYPE = 'MODIFY' THEN
		BEGIN
			UPDATE TD_DLBALUNIT_FEESCHEME
			   SET COMSCHEMENO = P_COMSCHEMENO,
					BEGINTIME  = TO_DATE(P_BEGINTIME, 'YYYY-MM-DD HH24:MI:SS'),
					ENDTIME    = TO_DATE(P_ENDTIME, 'YYYY-MM-DD HH24:MI:SS')
			 WHERE ID = P_BALCOMSID;
			IF  SQL%ROWCOUNT != 1 THEN RAISE V_EX; END IF;
			EXCEPTION
				WHEN OTHERS THEN
				P_RETCODE :='S05001B013'; P_RETMSG :='修改代理充值-银行手续费对应关系表失败'|| SQLERRM;
				RETURN; ROLLBACK;
		END;
	--删除功能
	ELSIF P_OPTYPE = 'DELETE' THEN
		BEGIN
			DELETE TD_DLBALUNIT_FEESCHEME WHERE ID = P_BALCOMSID;
			IF  SQL%ROWCOUNT != 1 THEN RAISE V_EX; END IF;
			EXCEPTION
				WHEN OTHERS THEN
				P_RETCODE :='S05001B014'; P_RETMSG :='删除代理充值-银行手续费对应关系表失败'|| SQLERRM;
				RETURN; ROLLBACK;
		END;
	END IF;

    P_RETCODE := '0000000000'; P_RETMSG := '';
    COMMIT;RETURN;
END;
/

SHOW ERRORS