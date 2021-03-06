using System;
using System.Data;
using System.Configuration;
using System.Collections;
using Master;

namespace PDO.GroupCard
{
     // 批量开卡审批
     public class SP_GC_OpenApprovalPDO : PDOBase
     {
          public SP_GC_OpenApprovalPDO()
          {
          }

          protected override void Init()
          {
                InitBegin("SP_GC_OpenApproval",7);

               AddField("@batchNo", "string", "16", "input");
               AddField("@stateCode", "string", "1", "input");

               InitEnd();
          }

          // 批次号
          public string batchNo
          {
              get { return  Getstring("batchNo"); }
              set { Setstring("batchNo",value); }
          }

          // 状态编码
          public string stateCode
          {
              get { return  Getstring("stateCode"); }
              set { Setstring("stateCode",value); }
          }

     }
}


