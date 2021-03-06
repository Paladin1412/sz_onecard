CREATE OR REPLACE PROCEDURE SP_WX_CardInfoSync
(
                                             P_RETCODE    OUT CHAR,     --错误编码
                                             P_RETMSG     OUT VARCHAR2 --错误信息
                                             ) AS
  V_EX       EXCEPTION;
  V_TRADETYPE     CHAR(1); --处理状态
  V_CURCARNO      VARCHAR2(50);--当前卡号
  V_ENDDATE        VARCHAR(8);
  V_ENDDATENUM    VARCHAR(12);
  V_RETCODE        VARCHAR(10);--出错编码
  V_RETMSG        VARCHAR(500);--出错信息
  V_TRADEID        VARCHAR(16);--交易流水
  V_SYNCCODE      VARCHAR(1);--同步标志
  V_CITYCODE      CHAR(4);--城市代码
  V_CARDTYPECODE  CHAR(2);--卡类型
  V_OPERATOR      CHAR(6);--操作员工
  V_OPERDEPT      CHAR(4);--操作部门
  V_SYNENDDATE    CHAR(8);      --休闲到期日
  V_SPARETIMES    INT;        --剩余次数
  V_PACKAGETYPECODE  CHAR(2);      --套餐类型
  V_ACCOUNTTYPE    CHAR(1);      --账户类型
    V_TODAY           DATE := SYSDATE;

  


BEGIN

  -- 循环从同步表中读入一条数据,增加CITYCODE字段用于区分无锡常州和常熟
  FOR V_CUR IN (
    SELECT  TRADEID,
        ID,
        CARDNO,
        ASN,
        NAME,
        CIPHERNAME,
        PAPERTYPECODE,
        PAPERNO,
        CIPHERPAPERNO,
        PACKAGETYPE,
        ENDTIME,
        TIMES,
        TRADETYPE,
        OLDCARDNO,
        PHOTO,
        BUSINESSTIME,
        CITYCODE
    FROM TF_B_WXPARK_SYNC
    WHERE SYNCCODE IN ('0','2')
    ORDER BY BUSINESSTIME ASC) LOOP

    BEGIN

  --业务类型(1：开通 2：补换卡 3：取消开通 4:修改资料)
  V_TRADETYPE := V_CUR.TRADETYPE;--业务类型
  
  V_CITYCODE := V_CUR.CITYCODE;--城市代码
  
  BEGIN
   --查询相应城市代码对应的操作员工、操作部门、卡类型
    SELECT T.OPERATOR,T.OPERDEPT,T.CARDTYPECODE INTO V_OPERATOR,V_OPERDEPT,V_CARDTYPECODE FROM TD_M_CITYPARAM T WHERE T.CITYCODE=V_CITYCODE AND T.USETAG='1';
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_RETCODE := 'S001P00000';
        V_RETMSG  := '未找到相关的城市配置信息表';
        RAISE V_EX;
  END;

  IF V_TRADETYPE = '1' THEN --开通
    BEGIN
    --调用开通存储过程,新增传入卡类型、卡面类型
    SP_WX_RELAXCARDOPEN(V_CUR.CARDNO,  V_CUR.ASN,  V_CUR.PACKAGETYPE,  V_CUR.NAME,  V_CUR.PAPERTYPECODE,  V_CUR.PAPERNO,
        V_CUR.CIPHERNAME,  V_CUR.CIPHERPAPERNO,V_CITYCODE, V_OPERATOR,  V_OPERDEPT,  V_RETCODE,  V_RETMSG);
    IF V_RETCODE != '0000000000' THEN RAISE V_EX; END IF;

    --插入照片
    MERGE INTO TF_F_CARDPARKPHOTO_SZ C
    USING (
     SELECT COUNT(1) COUNTS
     FROM  TF_F_CARDPARKPHOTO_SZ
     WHERE CARDNO = V_CUR.CARDNO
    )D ON(D.COUNTS > 0)
    WHEN MATCHED THEN
    UPDATE
    SET PICTURE = V_CUR.PHOTO
    WHERE CARDNO = V_CUR.CARDNO
    WHEN NOT MATCHED THEN
    INSERT(CARDNO, PICTURE, OPERATESTAFFNO, OPERATEDEPARTID, OPERATETIME)
    VALUES(V_CUR.CARDNO,  V_CUR.PHOTO,  V_OPERATOR,  V_OPERDEPT,  sysdate);
    IF SQL%ROWCOUNT != 1 THEN
      RAISE V_EX;
    END IF;
    END;

  ELSIF V_TRADETYPE = '2' THEN --补换卡
    --1.查询账户信息
    BEGIN
    BEGIN
      SELECT ENDDATE,RERVCHAR INTO V_ENDDATE,V_ENDDATENUM
      FROM TF_F_CARDXXPARKACC_SZ
      WHERE CARDNO = V_CUR.OLDCARDNO;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_RETCODE := 'S001P00001';
        V_RETMSG  := '未找到相关的账户信息';
        RAISE V_EX;
    END;

    --2.判断旧卡是否过期
    IF TO_CHAR(sysdate,'yyyymmdd') >= V_ENDDATE THEN
      V_RETCODE := 'S001P00002';
      V_RETMSG  := '旧卡过期';
      RAISE V_EX;
    END IF;

  --3.调用新卡售卡存储过程,新增传入卡类型、卡面类型
    SP_WX_NewCardSell(V_CUR.CARDNO,  V_CUR.ASN,  V_CUR.PACKAGETYPE,  V_CUR.NAME,  V_CUR.PAPERTYPECODE,  V_CUR.PAPERNO,
        V_CUR.CIPHERNAME,  V_CUR.CIPHERPAPERNO, V_CITYCODE, V_OPERATOR,  V_OPERDEPT,  V_RETCODE,  V_RETMSG);
    IF V_RETCODE != '0000000000' THEN RAISE V_EX; END IF;

    --3.调用换卡的存储过程
      SP_AS_RelaxCardChange(V_CUR.ID,  V_CUR.OLDCARDNO,  V_CUR.CARDNO,  V_CUR.ASN,  '',
              '',  '',  V_CUR.PACKAGETYPE,  V_CUR.CIPHERNAME,  '',
              '',  V_CUR.PAPERTYPECODE,  V_CUR.CIPHERPAPERNO,  '',  '',
              '',  '',  '',  V_CUR.PAPERNO,  V_CUR.NAME,
              '1',V_CITYCODE,  V_OPERATOR,  V_OPERDEPT,  V_RETCODE,  V_RETMSG);

  --4.更新照片对应表中的卡号
    BEGIN
      UPDATE TF_F_CARDPARKPHOTO_SZ
      SET  CARDNO = V_CUR.CARDNO
      WHERE　CARDNO = V_CUR.OLDCARDNO;
    END;


      IF V_RETCODE != '0000000000' THEN RAISE V_EX; END IF;
    END;

  ELSIF V_TRADETYPE = '3' THEN --取消开通
    BEGIN
      --1.查询账户信息
    BEGIN
      SELECT CARDNO INTO V_CURCARNO
      FROM TF_F_CARDXXPARKACC_SZ
      WHERE CARDNO = V_CUR.CARDNO AND SPARETIMES = 100 AND USETAG = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_RETCODE := 'S001P00003';
        V_RETMSG  := '未找到相关的账户信息';
        RAISE V_EX;
    END;

      --2.查询开通时的交易流水
    BEGIN
      SELECT TRADEID INTO V_TRADEID FROM (SELECT * FROM TF_B_TRADE
      WHERE  CARDNO = V_CUR.CARDNO
      AND    OPERATETIME BETWEEN ADD_MONTHS(SYSDATE, -1) AND SYSDATE
      AND    CANCELTAG = '0' AND CANCELTRADEID IS NULL AND TRADETYPECODE = '25'
      ORDER BY OPERATETIME DESC ) where ROWNUM = 1;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_RETCODE := 'S001P00004';
        V_RETMSG  := '未找到开通时的交易流水';
        RAISE V_EX;
    END;

      --3.调用返销存储过程
    SP_AS_RelaxCardNewRollback(V_CUR.ID,  V_CUR.CARDNO,  '0000',  V_CUR.ASN,  '',
                  '112233445566',  'FFFFFFFFFFFF',  V_ENDDATENUM,  V_TRADEID,  '1',
                  '',  V_CUR.PAPERTYPECODE,  V_CUR.PAPERNO,  V_CUR.NAME,V_CITYCODE, V_OPERATOR,
                  V_OPERDEPT,  V_RETCODE,  V_RETMSG);
    IF V_RETCODE != '0000000000' THEN RAISE V_EX; END IF;

      --4.删除入库信息
    DELETE FROM TL_R_ICUSER WHERE CARDNO = V_CUR.CARDNO;
    DELETE FROM TF_F_CARDREC WHERE CARDNO = V_CUR.CARDNO;
    DELETE FROM TF_F_CARDEWALLETACC WHERE CARDNO = V_CUR.CARDNO;
    DELETE FROM TF_F_CUSTOMERREC WHERE CARDNO = V_CUR.CARDNO;
    END;

    ELSIF V_TRADETYPE = '4' THEN --修改资料
    BEGIN
	BEGIN
    --调用修改资料存储过程
    SP_PB_ChangeUserInfo(V_CUR.CARDNO,  V_CUR.ASN,  V_CARDTYPECODE,  V_CUR.CIPHERNAME,  '',
              '',  V_CUR.PAPERTYPECODE,  V_CUR.CIPHERPAPERNO,  '',  '',
              '',  '',  '',  '29',  V_TRADEID,
              V_OPERATOR,  V_OPERDEPT,  V_RETCODE,  V_RETMSG);
    IF V_RETCODE != '0000000000' THEN RAISE V_EX; END IF;
	END;

	BEGIN
    --备份历史数据
    INSERT INTO TB_F_CARDPARKPHOTO_SZ (CARDNO, PICTURE, OPERATESTAFFNO, OPERATEDEPARTID, OPERATETIME)
        SELECT CARDNO, PICTURE, OPERATESTAFFNO, OPERATEDEPARTID, OPERATETIME
        FROM TF_F_CARDPARKPHOTO_SZ
        WHERE CARDNO = V_CUR.CARDNO;
    IF SQL%ROWCOUNT != 1 THEN
      V_RETCODE := 'S001P00005';
      V_RETMSG :='插入历史照片表失败';
      RAISE V_EX;
    END IF;
	END;

	BEGIN
    --更新照片
    UPDATE TF_F_CARDPARKPHOTO_SZ SET PICTURE = V_CUR.PHOTO WHERE CARDNO = V_CUR.CARDNO;
    EXCEPTION
    WHEN OTHERS THEN
      V_RETCODE := 'S001P00006';
      V_RETMSG  := '更新照片失败';
      RAISE V_EX;
	END;
	
	---)获取卡截止时间
	BEGIN
	SELECT ENDDATE,SPARETIMES,PACKAGETYPECODE,ACCOUNTTYPE INTO V_SYNENDDATE,V_SPARETIMES,V_PACKAGETYPECODE,V_ACCOUNTTYPE
	FROM  TF_F_CARDXXPARKACC_SZ
	WHERE  CARDNO=V_CUR.CARDNO;
	EXCEPTION WHEN OTHERS THEN
	  P_RETCODE := 'A00505B501'; P_RETMSG  := '获取休闲年卡数据失败';
	  RETURN;
	END;
	
	--获取流水号
	SP_GetSeq(seq => v_TradeID);
	
	--同步资料给APP
	BEGIN
	SP_AS_SYNGARDENXXCARD(V_CUR.CARDNO,V_CUR.ASN,V_CUR.PAPERTYPECODE,V_CUR.CIPHERPAPERNO,V_CUR.CIPHERNAME,
                    V_SYNENDDATE,V_SPARETIMES,'4',V_TODAY,'','',V_TRADEID,
                    V_PACKAGETYPECODE,V_ACCOUNTTYPE,V_CITYCODE,
                    V_OPERATOR,V_OPERDEPT,P_RETCODE,P_RETMSG);
	END;
    END;

  END IF;

  V_SYNCCODE := '1';--同步成功

  EXCEPTION
  WHEN OTHERS THEN
    V_SYNCCODE := '2';--同步失败
    V_RETMSG  := V_RETMSG || '' || V_RETCODE || SQLERRM;
    ROLLBACK;
  END;

   --更新同步标志
  UPDATE TF_B_WXPARK_SYNC SET SYNCCODE = V_SYNCCODE, SYNCINFO = V_RETMSG WHERE TRADEID = V_CUR.TRADEID;
  COMMIT;
  V_RETMSG := '';
  V_RETCODE := '';


    END LOOP;

  P_RETCODE := '0000000000';
  P_RETMSG  := 'OK';



END;

/
show errors