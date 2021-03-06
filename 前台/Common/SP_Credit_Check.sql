CREATE OR REPLACE PROCEDURE SP_Credit_Check
(
		p_CARDNO	  char,
		p_currOper	char,
		p_currDept	char,
		p_retCode	  out char, -- Return Code
		p_retMsg 	  out varchar2  -- Return Message

)
AS
    v_USETAG            char(1);
    v_CARDSTATE         char(2);
    v_ACCUSETAG         char(1);
    v_CREDITSTATECODE   char(2);
    v_CREDITCONTROLCODE char(2);
		v_CURRENTTIME date  := sysdate;
    v_ex                exception;
BEGIN
		-- 1) Get Card Information
		BEGIN
		    SELECT
		        a.USETAG, a.CARDSTATE, b.USETAG, b.CREDITSTATECODE, b.CREDITCONTROLCODE
		    INTO v_USETAG,v_CARDSTATE,v_ACCUSETAG,v_CREDITSTATECODE,v_CREDITCONTROLCODE
		    FROM TF_F_CARDREC a,TF_F_CARDEWALLETACC b
		    WHERE  a.CARDNO = p_CARDNO AND a.CARDNO = b.CARDNO;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
	        p_retCode := 'A001107102';
	        p_retMsg  := 'Cardstate is wrong';
	        RETURN;
		END;

    IF  v_USETAG = '0' THEN
	    IF v_CARDSTATE = '00' THEN p_retCode := 'A001107103';

	    ELSIF v_CARDSTATE = '01' THEN p_retCode := 'A001107104';

	    ELSIF v_CARDSTATE = '02' THEN p_retCode := 'A001107105';

	    ELSIF v_CARDSTATE = '03' THEN p_retCode := 'A001107106';

	    ELSE p_retCode := 'A001107121';

        END IF;

    ELSIF v_CARDSTATE = '30' THEN p_retCode := 'A001100000';

	        p_retMsg  := 'Accstate is wrong' ;
      RETURN;
	  END IF;

    IF v_ACCUSETAG = '0' THEN
        p_retCode := 'A001107107';
        p_retMsg  := 'Accstate is wrong' ;
        RETURN;
    END IF;

    IF v_CREDITSTATECODE != '00' THEN -- 非正常 信用状态
       ----添加的黑名单对应编码，如需修改此编码请同步修改对应程序代码。
       IF v_CREDITSTATECODE = '01' THEN p_retCode := 'A001107199'; --0011
           p_retMsg  := '该卡为黑名单卡' ;
           RETURN;
      ELSE 
        p_retCode := 'A001107108';
        p_retMsg  := 'Accstate is wrong' ;
        RETURN;
      END IF;
    END IF;

    IF v_CREDITCONTROLCODE != '00' THEN
        p_retCode := 'A001107109';
        p_retMsg  := 'Accstate is wrong' ;
        RETURN;
    END IF;
  p_retCode := '0000000000';
	p_retMsg  := '';

  END;
/
SHOW ERRORS