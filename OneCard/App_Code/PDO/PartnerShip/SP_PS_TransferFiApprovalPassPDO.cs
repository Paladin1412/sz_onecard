using System;
using System.Data;
using System.Configuration;
using System.Collections;
using Master;

namespace PDO.PartnerShip
{
     // 结算单元信息财务审核通过
     public class SP_PS_TransferFiApprovalPassPDO : PDOBase
     {
          public SP_PS_TransferFiApprovalPassPDO()
          {
          }

          protected override void Init()
          {
               InitBegin("SP_PS_TransferFiApprovalPass",32);

               AddField("@tradeId", "string", "16", "input");
               AddField("@tradeTypeCode", "string", "2", "input");
               AddField("@balUnitNo", "string", "8", "input");
               AddField("@balUnit", "String", "100", "input");
               AddField("@balUnitTypeCode", "string", "2", "input");
               AddField("@channelNo", "string", "4", "input");
               AddField("@sourceTypeCode", "string", "2", "input");
               AddField("@callingNo", "string", "2", "input");
               AddField("@corpNo", "string", "4", "input");
               AddField("@departNo", "string", "4", "input");
               AddField("@bankCode", "string", "4", "input");
               AddField("@bankAccno", "String", "20", "input");
               AddField("@serManagerCode", "string", "6", "input");
               AddField("@balLevel", "string", "1", "input");
               AddField("@balCycleTypeCode", "string", "2", "input");
               AddField("@balInterval", "Int32", "", "input");
               AddField("@finCycleTypeCode", "string", "2", "input");
               AddField("@finInterval", "Int32", "", "input");
               AddField("@finTypeCode", "string", "1", "input");
               AddField("@comFeeTakeCode", "string", "1", "input");
               AddField("@finBankCode", "string", "4", "input");
               AddField("@linkMan", "String", "10", "input");
               AddField("@unitPhone", "String", "20", "input");
               AddField("@unitAdd", "String", "50", "input");
               AddField("@uintEmail", "String", "200", "input");
               AddField("@remark", "String", "100", "input");
               AddField("@updateStuff", "string", "6", "input");

               //add by jiangbb 新增收款人账户类型
               AddField("@purposeType", "string", "1", "input");
               AddField("@bankChannel", "string", "1", "input");

               AddField("@RegionCode", "string", "1", "input");
               AddField("@DeliveryModeCode", "string", "1", "input");
               AddField("@AppCallingCode", "string", "1", "input");

               InitEnd();
          }

          //收款人账户类型
          public string purposeType
          {
              get { return Getstring("purposeType"); }
              set { Setstring("purposeType", value); }
          }

          //银行渠道
          public string bankChannel
          {
              get { return Getstring("bankChannel"); }
              set { Setstring("bankChannel", value); }
          }

          // 业务流水号
          public string tradeId
          {
              get { return  Getstring("tradeId"); }
              set { Setstring("tradeId",value); }
          }

          // 业务类型编码
          public string tradeTypeCode
          {
              get { return  Getstring("tradeTypeCode"); }
              set { Setstring("tradeTypeCode",value); }
          }

          // 结算单元编码
          public string balUnitNo
          {
              get { return  Getstring("balUnitNo"); }
              set { Setstring("balUnitNo",value); }
          }

          // 结算单元名称
          public String balUnit
          {
              get { return  GetString("balUnit"); }
              set { SetString("balUnit",value); }
          }

          // 单元类型编码
          public string balUnitTypeCode
          {
              get { return  Getstring("balUnitTypeCode"); }
              set { Setstring("balUnitTypeCode",value); }
          }

          // 通道编码
          public string channelNo
          {
              get { return  Getstring("channelNo"); }
              set { Setstring("channelNo",value); }
          }

          // 来源识别类型编码
          public string sourceTypeCode
          {
              get { return  Getstring("sourceTypeCode"); }
              set { Setstring("sourceTypeCode",value); }
          }

          // 行业编码
          public string callingNo
          {
              get { return  Getstring("callingNo"); }
              set { Setstring("callingNo",value); }
          }

          // 单位编码
          public string corpNo
          {
              get { return  Getstring("corpNo"); }
              set { Setstring("corpNo",value); }
          }

          // 部门编码
          public string departNo
          {
              get { return  Getstring("departNo"); }
              set { Setstring("departNo",value); }
          }

          // 开户银行编码
          public string bankCode
          {
              get { return  Getstring("bankCode"); }
              set { Setstring("bankCode",value); }
          }

          // 银行帐号
          public String bankAccno
          {
              get { return  GetString("bankAccno"); }
              set { SetString("bankAccno",value); }
          }

          // 商户经理编码
          public string serManagerCode
          {
              get { return  Getstring("serManagerCode"); }
              set { Setstring("serManagerCode",value); }
          }

          // 结算级别编码
          public string balLevel
          {
              get { return  Getstring("balLevel"); }
              set { Setstring("balLevel",value); }
          }

          // 结算周期类型编码
          public string balCycleTypeCode
          {
              get { return  Getstring("balCycleTypeCode"); }
              set { Setstring("balCycleTypeCode",value); }
          }

          // 结算周期跨度
          public Int32 balInterval
          {
              get { return  GetInt32("balInterval"); }
              set { SetInt32("balInterval",value); }
          }

          // 划账周期类型编码
          public string finCycleTypeCode
          {
              get { return  Getstring("finCycleTypeCode"); }
              set { Setstring("finCycleTypeCode",value); }
          }

          // 划账周期跨度
          public Int32 finInterval
          {
              get { return  GetInt32("finInterval"); }
              set { SetInt32("finInterval",value); }
          }

          // 转账类型
          public string finTypeCode
          {
              get { return  Getstring("finTypeCode"); }
              set { Setstring("finTypeCode",value); }
          }

          // 佣金扣减方式编码
          public string comFeeTakeCode
          {
              get { return  Getstring("comFeeTakeCode"); }
              set { Setstring("comFeeTakeCode",value); }
          }

          // 转出银行编码
          public string finBankCode
          {
              get { return  Getstring("finBankCode"); }
              set { Setstring("finBankCode",value); }
          }

          // 联系人
          public String linkMan
          {
              get { return  GetString("linkMan"); }
              set { SetString("linkMan",value); }
          }

          // 联系电话
          public String unitPhone
          {
              get { return  GetString("unitPhone"); }
              set { SetString("unitPhone",value); }
          }

          // 联系地址
          public String unitAdd
          {
              get { return  GetString("unitAdd"); }
              set { SetString("unitAdd",value); }
          }

          // 电子邮件
          public String uintEmail
          {
              get { return  GetString("uintEmail"); }
              set { SetString("uintEmail",value); }
          }

          // 备注
          public String remark
          {
              get { return  GetString("remark"); }
              set { SetString("remark",value); }
          }

          // 更新员工编码(结算单元增删改，结算单元佣金方案增删改的操作员工编码)
          public string updateStuff
          {
              get { return  Getstring("updateStuff"); }
              set { Setstring("updateStuff",value); }
          }

          // 地区编码
          public string RegionCode
          {
              get { return Getstring("RegionCode"); }
              set { Setstring("RegionCode", value); }
          }

          // POS投放模式
          public string DeliveryModeCode
          {
              get { return Getstring("DeliveryModeCode"); }
              set { Setstring("DeliveryModeCode", value); }
          }

          // 应用行业
          public string AppCallingCode
          {
              get { return Getstring("AppCallingCode"); }
              set { Setstring("AppCallingCode", value); }
          }

     }
}


