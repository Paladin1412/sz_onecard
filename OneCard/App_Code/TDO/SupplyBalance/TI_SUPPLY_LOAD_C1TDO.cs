using System;
using System.Data;
using System.Configuration;
using System.Collections;
using Master;

namespace TDO.SupplyBalance
{
     // 非实时充值文件入库临时表
     public class TI_SUPPLY_LOAD_C1TDO : DDOBase
     {
          public TI_SUPPLY_LOAD_C1TDO()
          {
          }

          protected override void Init()
          {
               tableName = "TI_SUPPLY_LOAD_C1";

               columns = new String[18][];
               columns[0] = new String[]{"ID", "string"};
               columns[1] = new String[]{"ASN", "string"};
               columns[2] = new String[]{"CARDTRADENO", "string"};
               columns[3] = new String[]{"TRADETYPECODE", "string"};
               columns[4] = new String[]{"CARDTYPECODE", "string"};
               columns[5] = new String[]{"TRADEDATE", "string"};
               columns[6] = new String[]{"TRADETIME", "string"};
               columns[7] = new String[]{"TRADEMONEY", "Int32"};
               columns[8] = new String[]{"PREMONEY", "Int32"};
               columns[9] = new String[]{"SUPPLYLOCNO", "string"};
               columns[10] = new String[]{"SAMNO", "string"};
               columns[11] = new String[]{"POSNO", "string"};
               columns[12] = new String[]{"STAFFNO", "string"};
               columns[13] = new String[]{"TAC", "string"};
               columns[14] = new String[]{"TRADEID", "string"};
               columns[15] = new String[]{"TACSTATE", "string"};
               columns[16] = new String[]{"BATCHNO", "string"};
               columns[17] = new String[]{"RSRVCHAR", "string"};

               columnKeys = new String[]{
               };


               array = new String[18];
               hash.Add("ID", 0);
               hash.Add("ASN", 1);
               hash.Add("CARDTRADENO", 2);
               hash.Add("TRADETYPECODE", 3);
               hash.Add("CARDTYPECODE", 4);
               hash.Add("TRADEDATE", 5);
               hash.Add("TRADETIME", 6);
               hash.Add("TRADEMONEY", 7);
               hash.Add("PREMONEY", 8);
               hash.Add("SUPPLYLOCNO", 9);
               hash.Add("SAMNO", 10);
               hash.Add("POSNO", 11);
               hash.Add("STAFFNO", 12);
               hash.Add("TAC", 13);
               hash.Add("TRADEID", 14);
               hash.Add("TACSTATE", 15);
               hash.Add("BATCHNO", 16);
               hash.Add("RSRVCHAR", 17);
          }

          // 记录流水号
          public string ID
          {
              get { return  Getstring("ID"); }
              set { Setstring("ID",value); }
          }

          // IC应用序列号
          public string ASN
          {
              get { return  Getstring("ASN"); }
              set { Setstring("ASN",value); }
          }

          // IC交易序列号 
          public string CARDTRADENO
          {
              get { return  Getstring("CARDTRADENO"); }
              set { Setstring("CARDTRADENO",value); }
          }

          // 交易类型编码
          public string TRADETYPECODE
          {
              get { return  Getstring("TRADETYPECODE"); }
              set { Setstring("TRADETYPECODE",value); }
          }

          // 卡片类型编码
          public string CARDTYPECODE
          {
              get { return  Getstring("CARDTYPECODE"); }
              set { Setstring("CARDTYPECODE",value); }
          }

          // 交易日期
          public string TRADEDATE
          {
              get { return  Getstring("TRADEDATE"); }
              set { Setstring("TRADEDATE",value); }
          }

          // 交易时间
          public string TRADETIME
          {
              get { return  Getstring("TRADETIME"); }
              set { Setstring("TRADETIME",value); }
          }

          // 交易金额
          public Int32 TRADEMONEY
          {
              get { return  GetInt32("TRADEMONEY"); }
              set { SetInt32("TRADEMONEY",value); }
          }

          // 交易前余额
          public Int32 PREMONEY
          {
              get { return  GetInt32("PREMONEY"); }
              set { SetInt32("PREMONEY",value); }
          }

          // 充值点编号
          public string SUPPLYLOCNO
          {
              get { return  Getstring("SUPPLYLOCNO"); }
              set { Setstring("SUPPLYLOCNO",value); }
          }

          // SAM编号
          public string SAMNO
          {
              get { return  Getstring("SAMNO"); }
              set { Setstring("SAMNO",value); }
          }

          // POS编号
          public string POSNO
          {
              get { return  Getstring("POSNO"); }
              set { Setstring("POSNO",value); }
          }

          // 操作员号
          public string STAFFNO
          {
              get { return  Getstring("STAFFNO"); }
              set { Setstring("STAFFNO",value); }
          }

          // TAC认证码
          public string TAC
          {
              get { return  Getstring("TAC"); }
              set { Setstring("TAC",value); }
          }

          // 银行交易流水
          public string TRADEID
          {
              get { return  Getstring("TRADEID"); }
              set { Setstring("TRADEID",value); }
          }

          // TAC码验证结果
          public string TACSTATE
          {
              get { return  Getstring("TACSTATE"); }
              set { Setstring("TACSTATE",value); }
          }

          // 批次号
          public string BATCHNO
          {
              get { return  Getstring("BATCHNO"); }
              set { Setstring("BATCHNO",value); }
          }

          // 保留标志
          public string RSRVCHAR
          {
              get { return  Getstring("RSRVCHAR"); }
              set { Setstring("RSRVCHAR",value); }
          }

     }
}


