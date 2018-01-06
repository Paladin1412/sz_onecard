﻿using Common;
using Master;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NPOI.HSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using TDO.BalanceParameter;
using TM;
public partial class ASP_Financial_FI_ZZTradeReport : Master.ExportMaster
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //初始化日期

            TMTableModule tmTMTableModule = new TMTableModule();
            txtFromDate.Text = DateTime.Today.AddDays(-1).ToString("yyyyMMdd");
            txtToDate.Text = DateTime.Today.AddDays(-1).ToString("yyyyMMdd");

            gvResult.DataSource = new DataTable();
            gvResult.DataBind();
        }
    }


    #region Private


    #region validate
    // 查询输入校验处理
    private void validate()
    {
        Validation valid = new Validation(context);

        bool b = Validation.isEmpty(txtFromDate);
        DateTime? fromDate = null, toDate = null;
        if (!b)
        {
            fromDate = valid.beDate(txtFromDate, "开始日期范围起始值格式必须为yyyyMMdd");
        }
        b = Validation.isEmpty(txtToDate);
        if (!b)
        {
            toDate = valid.beDate(txtToDate, "结束日期范围终止值格式必须为yyyyMMdd");
        }

        if (fromDate != null && toDate != null)
        {
            valid.check(fromDate.Value.CompareTo(toDate.Value) <= 0, "开始日期不能大于结束日期");
        }

    }
    #endregion

    #region queryData

    private Dictionary<string, string> DeclarePost()
    {
        Dictionary<string, string> postData = new Dictionary<string, string>();
        postData.Add("channelCode", "ONECARD");
        postData.Add("tradeType", selTradeType.SelectedValue);
        postData.Add("fromDate", txtFromDate.Text);
        postData.Add("toDate", txtToDate.Text);

        return postData;
    }

    private DataTable initEmptyDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("TRADETYPE", typeof(string));//业务类型
        dt.Columns.Add("CARDNO", typeof(string));//卡号
        dt.Columns.Add("OPERATETIME", typeof(string));//操作时间
        dt.Columns.Add("OPERATEDEPARTID", typeof(string));//操作部门号
        dt.Columns.Add("STAFFNO", typeof(string));//操作员工号
        dt.Columns.Add("POSNO", typeof(string));//POS编号
        dt.Columns.Add("PSAMNO", typeof(string));//PSAM编号

        dt.Columns["TRADETYPE"].MaxLength = 100;
        dt.Columns["CARDNO"].MaxLength = 100;
        dt.Columns["OPERATETIME"].MaxLength = 100;
        dt.Columns["OPERATEDEPARTID"].MaxLength = 100;
        dt.Columns["STAFFNO"].MaxLength = 100;
        dt.Columns["POSNO"].MaxLength = 100;
        dt.Columns["PSAMNO"].MaxLength = 100;

        return dt;
    }

    private DataTable fillDataTable(HttpHelper.TradeType tradetype, Dictionary<string, string> postData)
    {
        string jsonResponse = HttpHelper.ZZPostRequest(tradetype, postData);
        //解析json
        DataTable dt = initEmptyDataTable();
        JObject deserObject = (JObject)JsonConvert.DeserializeObject(jsonResponse);
        string code = "";
        string message = "";
        foreach (JProperty itemProperty in deserObject.Properties())
        {
            string propertyName = itemProperty.Name;
            if (propertyName == "respCode")
            {
                code = itemProperty.Value.ToString();
            }
            else if (propertyName == "respDesc")
            {
                message = itemProperty.Value.ToString();
            }
            else if (propertyName == "tradeColl")
            {
                if (itemProperty.Value == null)
                {
                    context.AddMessage("查询结果为空");
                    return null;
                }
            }
        }

        if (code == "0000") //表示成功
        {
            foreach (JProperty itemProperty in deserObject.Properties())
            {
                string propertyName = itemProperty.Name;
                if (propertyName == "tradeColl")
                {
                    //DataTable赋值
                    JArray detailArray = new JArray();
                    try
                    {
                        detailArray = (JArray)itemProperty.Value;
                    }
                    catch (Exception)
                    {
                        context.AddMessage("查询结果为空");
                        return new DataTable();
                    }
                    foreach (JObject subItem in detailArray)
                    {
                        DataRow newRow = dt.NewRow();
                        foreach (JProperty subItemJProperty in subItem.Properties())
                        {
                            newRow[subItemJProperty.Name] = subItemJProperty.Value.ToString();
                        }
                        dt.Rows.Add(newRow);
                    }
                }
            }
        }
        else
        {
            context.AddError(message);
        }
        return dt;
    }
    #endregion

    #endregion


    #region protect Event
    protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //
    }

    // 查询处理
    protected void btnQuery_Click(object sender, EventArgs e)
    {
        validate();
        if (context.hasError()) return;

        DataTable data = fillDataTable(HttpHelper.TradeType.ZZOrderCardQuery, DeclarePost());
        if (data == null || data.Rows.Count == 0)
        {
            AddMessage("N005030001: 查询结果为空");
        }

        UserCardHelper.resetData(gvResult, data);
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (gvResult.Rows.Count > 0)
        {
            ExportGridView(gvResult);
        }
        else
        {
            context.AddMessage("查询结果为空，不能导出");
        }
    }
    #endregion

}
