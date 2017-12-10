-- =============================================
-- AUTHOR:		LIUHE
-- CREATE DATE: 2011-07-11
-- DESCRIPTION:	取得流水号12位NUMBER,日期6+SEQ6
-- =============================================
CREATE OR REPLACE PROCEDURE SP_GETTRADEID(
    SEQNAME           IN VARCHAR2,  --SELNAME
    TRADEID  		 OUT  NUMBER
)
AS
    V_DATE             VARCHAR2(10);
    V_SEQNAME          VARCHAR2(30);
    V_SQLSTR           VARCHAR2(200);
    V_SEQ              VARCHAR2(20);
BEGIN
    V_SEQNAME := LOWER(TRIM(SEQNAME));
    V_SQLSTR := 'SELECT '||V_SEQNAME||'.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQLSTR INTO V_SEQ;

    SELECT  TO_CHAR(SYSDATE,'YYMMDD') INTO V_DATE FROM DUAL;
    TRADEID:= V_DATE || SUBSTR('000000' || V_SEQ, -6);
  
EXCEPTION
    WHEN OTHERS THEN
    TRADEID :=NULL;RAISE;
END;


/

SHOW ERRORS