﻿using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PDO.Financial;
using Master;
using Common;
using TDO.BalanceParameter;
using TDO.BalanceChannel;
using TM;
public partial class ASP_Financial_FI_DeptBalAgentChargeReport : Master.ExportMaster
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //初始化日期

            TMTableModule tmTMTableModule = new TMTableModule();
            txtFromDate.Text = DateTime.Today.AddDays(-1).ToString("yyyyMMdd");
            txtToDate.Text = DateTime.Today.AddDays(-1).ToString("yyyyMMdd");

            context.DBOpen("Select");
            string sql = @"SELECT DBALUNIT, DBALUNITNO	FROM TF_DEPT_BALUNIT WHERE USETAG = '1' AND DEPTTYPE = '2' ORDER BY DBALUNITNO";
            System.Data.DataTable table = context.ExecuteReader(sql);
            GroupCardHelper.fill(selBalUnit, table, true);
            selBalUnit.Items[0].Value = "00000000";
        }
    }

    private double totalSupplys = 0;    //充值

    private double totalCharges = 0;    //冲正
    private double totalReturns = 0;    //回收
    private double totalGet = 0;        //转帐
    private int totalCount = 0;         //笔数
    private int totaRefundlCount = 0;   //退款笔数  add by youyue 20160303
    private double totalRefund = 0;     //退款
    private double totalGet2 = 0;        //转帐扣退款
    protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (gvResult.ShowFooter && e.Row.RowType == DataControlRowType.DataRow)
        {
            totalSupplys += Convert.ToDouble(GetTableCellValue(e.Row.Cells[2]));
            totalCharges += Convert.ToDouble(GetTableCellValue(e.Row.Cells[3]));
            totalReturns += Convert.ToDouble(GetTableCellValue(e.Row.Cells[4]));
            totalGet += Convert.ToDouble(GetTableCellValue(e.Row.Cells[7]));
            totalCount += Convert.ToInt32(GetTableCellValue(e.Row.Cells[8]));
            totalRefund += Convert.ToDouble(GetTableCellValue(e.Row.Cells[5]));
            totaRefundlCount += Convert.ToInt32(GetTableCellValue(e.Row.Cells[6]));
            totalGet2 += Convert.ToDouble(GetTableCellValue(e.Row.Cells[9]));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)  //页脚 
        {
            e.Row.Cells[0].Text = "总计";
            e.Row.Cells[2].Text = totalSupplys.ToString("n");
            e.Row.Cells[3].Text = totalCharges.ToString("n");
            e.Row.Cells[4].Text = totalReturns.ToString("n");
            e.Row.Cells[5].Text = totalRefund.ToString("n");
            e.Row.Cells[6].Text = totaRefundlCount.ToString();
            e.Row.Cells[7].Text = totalGet.ToString("n");
            e.Row.Cells[8].Text = totalCount.ToString();
            e.Row.Cells[9].Text = totalGet2.ToString("n");
        }
    }
    private string GetTableCellValue(TableCell cell)
    {
        string s = cell.Text.Trim();
        if (s == "&nbsp;" || s == "")
            return "0";
        return s;
    }
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

    private bool checkEndDate()
    {
        TP_DEALTIMETDO tdoTP_DEALTIMEIn = new TP_DEALTIMETDO();
        TP_DEALTIMETDO[] tdoTP_DEALTIMEOutArr = (TP_DEALTIMETDO[])tm.selByPKArr(context, tdoTP_DEALTIMEIn, typeof(TP_DEALTIMETDO), null, "DEALTIME", null);
        if (tdoTP_DEALTIMEOutArr.Length == 0)
        {
            context.AddError("没有找到有效的结算处理时间");
            return false;
        }
        else
        {
            DateTime dealDate = tdoTP_DEALTIMEOutArr[0].DEALDATE.Date;
            DateTime endDate = DateTime.ParseExact(txtToDate.Text.Trim(), "yyyyMMdd", null);
            if (endDate.CompareTo(dealDate) >= 0)
            {
                context.AddError("结束日期过大，未结算");
                return false;
            }
        }
        return true;
    }

    // 查询处理
    protected void btnQuery_Click(object sender, EventArgs e)
    {
        validate();
        if (context.hasError()) return;


        SP_FI_QueryPDO pdo = new SP_FI_QueryPDO();
        pdo.funcCode = "SUPPLY_DEPTBAL_REPORT";
        pdo.var1 = txtFromDate.Text;
        pdo.var2 = txtToDate.Text;
        pdo.var7 = selBalUnit.SelectedValue;

        StoreProScene storePro = new StoreProScene();
        DataTable data = storePro.Execute(context, pdo);
        hidNo.Value = pdo.var9;
        if (data == null || data.Rows.Count == 0)
        {
            AddMessage("N005030001: 查询结果为空");
        }

        totalSupplys = 0;
        totalCharges = 0;
        totalReturns = 0;
        totalGet = 0;
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

    #region 根据输入结算单元名称初始化下拉选项
    /// <summary>
    /// 根据输入结算单元名称初始化下拉选项
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtBalUnitName_Changed(object sender, EventArgs e)
    {
        selBalUnit.Items.Clear();

        context.DBOpen("Select");
        System.Text.StringBuilder sql = new System.Text.StringBuilder();

        sql.Append("SELECT DBALUNIT, DBALUNITNO	FROM TF_DEPT_BALUNIT WHERE USETAG = '1' AND DEPTTYPE = '2'");
        //模糊查询单位名称，并在列表中赋值
        string strBalname = txtBalUnitName.Text.Trim().Replace('\'', '\"');
        if (strBalname.Length != 0)
        {
            sql.Append("AND DBALUNIT LIKE '%" + strBalname + "%'");
        }
        sql.Append("ORDER BY DBALUNITNO");

        System.Data.DataTable table = context.ExecuteReader(sql.ToString());
        GroupCardHelper.fill(selBalUnit, table, true);
    }
    #endregion 
}
