using System;
using System.Data;
using System.Configuration;
using System.Collections;
using Master;

namespace PDO.SpecialDeal
{
     // 异常消费信息作废
     public class SP_SD_ConsumeErrCancelPDO : PDOBase
     {
          public SP_SD_ConsumeErrCancelPDO()
          {
          }

          protected override void Init()
          {
                InitBegin("SP_SD_ConsumeErrCancel",7);

               AddField("@renewRemark", "String", "150", "input");
               AddField("@billMonth", "string", "2", "input");

               InitEnd();
          }

          // 回收说明
          public String renewRemark
          {
              get { return  GetString("renewRemark"); }
              set { SetString("renewRemark",value); }
          }

          // 回收清单月份
          public string billMonth
          {
              get { return  Getstring("billMonth"); }
              set { Setstring("billMonth",value); }
          }

     }
}


