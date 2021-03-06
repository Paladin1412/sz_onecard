CREATE OR REPLACE PROCEDURE SP_GETACCID_NEW(
    SEQNAME           IN VARCHAR2,  --SELNAME
    AREACODE          IN VARCHAR2,  --��������,2λ����
    ACCID             OUT  NUMBER
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

    SELECT SUBSTRB(AREACODE,1,2)|| substr(to_char(sysdate,'yyyyMMdd'),3,2) INTO V_DATE FROM DUAL;
    ACCID:= V_DATE || lpad(V_SEQ, 8, '0');

EXCEPTION 
    WHEN OTHERS THEN
    ACCID :=NULL;RAISE;
END;


/
show errors;
