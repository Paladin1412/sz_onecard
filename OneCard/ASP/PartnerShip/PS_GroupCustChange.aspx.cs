using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using TDO.CardManager;
using TDO.UserManager;
using TM;
using Common;
using TDO.PartnerShip;
using PDO.PartnerShip;

public partial class ASP_PartnerShip_PS_GroupCustChange : Master.Master
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

            TMTableModule tmTMTableModule = new TMTableModule();
            //从集团客户资料表(TD_GROUP_CUSTOMER)中读取数据，放入查询输入集团客户名称下拉列表中
            //TD_GROUP_CUSTOMERTDO tdoTD_GROUP_CUSTOMERIn = new TD_GROUP_CUSTOMERTDO();
            //TD_GROUP_CUSTOMERTDO[] tdoTD_GROUP_CUSTOMEROutArr = (TD_GROUP_CUSTOMERTDO[])tmTMTableModule.selByPKArr(context, tdoTD_GROUP_CUSTOMERIn, typeof(TD_GROUP_CUSTOMERTDO), "S008111110", "", null);

            //ControlDeal.SelectBoxFillWithCode(selGroupCust.Items, tdoTD_GROUP_CUSTOMEROutArr, "CORPNAME", "CORPCODE", true);

            //设置集团客户信息列表表头字段名
            lvwGroupCustQuery.DataSource = new DataTable();
            lvwGroupCustQuery.DataBind();
            lvwGroupCustQuery.SelectedIndex = -1;

            //设置有效标志下拉列表值
            TSHelper.initUseTag(selUseTag, false);

            //设置客户经理编码
            //从内部员工编码表(TD_M_INSIDESTAFF)中读取数据，放入选定集团客户信息的客户经理下拉列表中
            TD_M_INSIDESTAFFTDO tdoTD_M_INSIDESTAFFIn = new TD_M_INSIDESTAFFTDO();
            TD_M_INSIDESTAFFTDO[] tdoTD_M_INSIDESTAFFOutArr = (TD_M_INSIDESTAFFTDO[])tmTMTableModule.selByPKArr(context, tdoTD_M_INSIDESTAFFIn, typeof(TD_M_INSIDESTAFFTDO), "S008111111", "TD_M_INSIDESTAFF_SVR", null);

            ControlDeal.SelectBoxFill(selCustSerMgr.Items, tdoTD_M_INSIDESTAFFOutArr, "STAFFNAME", "STAFFNO", true);

            //指定GridView DataKeyNames
            lvwGroupCustQuery.DataKeyNames = new string[] { "CORPCODE", "CORPNAME", "SERMANAGERCODE", "LINKMAN", "CORPPHONE", "CORPADD", "CORPEMAIL", "STAFFNAME", "REMARK", "USETAG" };

        }
    }

    protected void btnQuery_Click(object sender, EventArgs e)
    {
        if (!ValidInput()) return;//查询条件判断
        //查询集团客户信息
        lvwGroupCustQuery.DataSource = CreateGroupCustQueryDataSource();
        lvwGroupCustQuery.DataBind();
        

        ClearCorp();
    }
    //判定操作权限
    private bool HasOperPower(string powerCode)
    {
        TMTableModule tmTMTableModule = new TMTableModule();
        TD_M_ROLEPOWERTDO ddoTD_M_ROLEPOWERIn = new TD_M_ROLEPOWERTDO();
        string strSupply = " Select POWERCODE From TD_M_ROLEPOWER Where POWERCODE = '" + powerCode +
            "' And ROLENO IN ( SELECT ROLENO From TD_M_INSIDESTAFFROLE Where STAFFNO ='" + context.s_UserID + "')";
        DataTable dataSupply = tmTMTableModule.selByPKDataTable(context, ddoTD_M_ROLEPOWERIn, null, strSupply, 0);
        if (dataSupply.Rows.Count > 0)
            return true;
        else
            return false;
    }
    //查询条件
    private bool ValidInput()
    {
        string strGroupCust = txtGroupName.Text.Trim();
        if (!HasOperPower("201012") && !HasOperPower("201013"))//非主管权限（部门主管、公司主管）
        {
            if (strGroupCust.Equals(""))
            {
                context.AddError("A008111006", txtGroupName);//非主管操作权限禁止空查询
            }
            else if (strGroupCust.Length<2)
            {
                context.AddError("A008111008", txtGroupName);//非主管权限至少输入2个关键字
            }
            else if (Validation.strLen(strGroupCust) > 50)
            {
                context.AddError("A008111007", txtGroupName);
            }
            else if (isPopPhrase(strGroupCust))//检查常用词查询
            {
                context.AddError("A008111009", txtGroupName);
            }
          
        }
  
        return !(context.hasError());
       
    }
    private Boolean isPopPhrase(string custName)
    {
        foreach (string cust in popPhrase)
        {
            if (cust.Equals(custName))
            {
                return true;
            }
        }

        return false;
    }

    public void lvwGroupCustQuery_Page(Object sender, GridViewPageEventArgs e)
    {
        lvwGroupCustQuery.PageIndex = e.NewPageIndex;
        btnQuery_Click(sender, e);
        lvwGroupCustQuery.SelectedIndex = -1;
    }



    public ICollection CreateGroupCustQueryDataSource()
    {
        //从集团客户资料表(TD_GROUP_CUSTOMER)中读取数据

        DataTable data = SPHelper.callPSQuery(context, "QueryGroupCustomer", txtGroupName.Text.Trim());
                
        DataView dataView = new DataView(data);
        return dataView;

    }


    //public void lvwGroupCustQuery_Page(Object sender, GridViewPageEventArgs e)
    //{
    //    lvwGroupCustQuery.PageIndex = e.NewPageIndex;
    //    lvwGroupCustQuery.DataSource = CreateGroupCustQueryDataSource();
    //    lvwGroupCustQuery.DataBind();
    //}


    protected void lvwGroupCustQuery_SelectedIndexChanged(object sender, EventArgs e)
    {
  
        //选择列表框一行记录后,设置集团客户信息修改区域中数据
        txtGroupCust.Text   = getDataKeys("CORPNAME");
        txtLinkMan.Text     = getDataKeys("LINKMAN");
        txtPhone.Text       = getDataKeys("CORPPHONE");
        txtAddr.Text        = getDataKeys("CORPADD");
        txtRemark.Text      = getDataKeys("REMARK");
        txtEmail.Text       = getDataKeys("CORPEMAIL");
        try {
           selUseTag.SelectedValue = getDataKeys("USETAG");
        }
        catch (Exception)
        {  selUseTag.SelectedValue = "0"; }

        try {
            selCustSerMgr.SelectedValue = getDataKeys("SERMANAGERCODE").Trim();
        }catch(Exception)
        {   selCustSerMgr.SelectedValue = ""; }

    }

    public String getDataKeys(string keysname)
    {
        return lvwGroupCustQuery.DataKeys[lvwGroupCustQuery.SelectedIndex][keysname].ToString();
    }

    //AutoGenerateSelectButton="true" 可以替代该功能
    protected void lvwGroupCustQuery_RowCreated(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //注册行单击事件
            e.Row.Attributes.Add("onclick", "javascirpt:__doPostBack('lvwGroupCustQuery','Select$" + e.Row.RowIndex + "')");
        }
    }


    private void GruopCustInputValidation()
    {
        //对集团客户名称名称进行非空,长度校验
        string strGroupCust = txtGroupCust.Text.Trim();
        if (strGroupCust == "")
            context.AddError("A008111005", txtGroupCust);
        else if (Validation.strLen(strGroupCust) > 50)
            context.AddError("A008111007", txtGroupCust);

        //对客户经理非空检验
        //string strSerMgr = selCustSerMgr.SelectedValue;
        //if (strSerMgr == "")
        //    context.AddError("A008111023", selCustSerMgr);


        //对联系人进行非空,长度校验
        string strLinkMan = txtLinkMan.Text.Trim();
        //if (strLinkMan == "")
        //    context.AddError("A008100004", txtLinkMan);
        if (strLinkMan != "" && Validation.strLen(strLinkMan) > 10)
            context.AddError("A008100005", txtLinkMan);

        //对联系电话进行非空,长度校验
        string strPhone = txtPhone.Text.Trim();
        //if (strPhone == "")
        //    context.AddError("A008100006", txtPhone);
        if (strPhone != "" && Validation.strLen(strPhone) > 40)
            context.AddError("A008100007", txtPhone);

        //对有效标志进行非空检验
        //string strUseTag = selUseTag.SelectedValue;
        //if (strUseTag == "")
        //    context.AddError("A008100014", selUseTag);

        //对联系地址进行非空,长度校验
        string strAddr = txtAddr.Text.Trim();
        //if (strAddr == "")
        //    context.AddError("A008111012", txtAddr);
        if (strAddr != "" && Validation.strLen(strAddr) > 100)
            context.AddError("A008111014", txtAddr);

        //对电子邮件非空的判断

        if (txtEmail.Text.Trim() != "")
        {
            new Validation(context).isEMail(txtEmail);
        }
  
        //对备注进行长度校验
        string strRemrk = txtRemark.Text.Trim();
        if (strRemrk != "")
        {
            if (Validation.strLen(strRemrk) > 100)
                context.AddError("A008100011", txtRemark);
        }
    }


    private Boolean GroupCustModifyValidation()
    {

        //检查是否选择了要修改的集团客户信息
        if (lvwGroupCustQuery.SelectedIndex == -1)
        {
            context.AddError("A008111004");
            return false;
        }

         //当选择的的集团客户信息都没有修改时,不能执行修改
        if (!isModifyAll())
        {
            context.AddError("A008111022");
            return false;
        }

        //对输入的集团客户信息检验
        GruopCustInputValidation();
   
        //当集团客户名称修改后,检测库中是否已存在该集团客户
        if (txtGroupCust.Text.Trim() != getDataKeys("CORPNAME"))
        {
  
            TMTableModule tmTMTableModule = new TMTableModule();
            //从集团客户资料表(TD_GROUP_CUSTOMER)中读取数据
            TD_GROUP_CUSTOMERTDO tdoTD_GROUP_CUSTOMERIn = new TD_GROUP_CUSTOMERTDO();
            tdoTD_GROUP_CUSTOMERIn.CORPNAME = txtGroupCust.Text.Trim();
            TD_GROUP_CUSTOMERTDO[] tdoTD_GROUP_CUSTOMEROutArr = (TD_GROUP_CUSTOMERTDO[])tmTMTableModule.selByPKArr(context, tdoTD_GROUP_CUSTOMERIn, typeof(TD_GROUP_CUSTOMERTDO), null, "TD_GROUP_CUSTOMERNAME", null);

            //从集团客户台帐中读取数据
            TF_B_GROUP_CUSTOMERCHANGETDO tdo_TF_B_GROUPIn = new TF_B_GROUP_CUSTOMERCHANGETDO();
            tdo_TF_B_GROUPIn.CORPNAME = txtGroupCust.Text.Trim();
            TF_B_GROUP_CUSTOMERCHANGETDO[] tdo_TF_B_GROUPOutArr = (TF_B_GROUP_CUSTOMERCHANGETDO[])tmTMTableModule.selByPKArr(context, tdo_TF_B_GROUPIn, typeof(TF_B_GROUP_CUSTOMERCHANGETDO), null, "TD_GROUP_CUSTOMERASS_CORPNAME", null);

            if (tdoTD_GROUP_CUSTOMEROutArr.Length != 0 || tdo_TF_B_GROUPOutArr.Length != 0)
            {
                context.AddError("A008111024", txtGroupCust);
            }

        }

        if (context.hasError())
            return false;
        else
            return true;

    }




    protected void btnModify_Click(object sender, EventArgs e)
    {

        if (!GroupCustModifyValidation()) return;
        
        //执行修改集团客户信息的存储过程
        SP_PS_GroupCustChangePDO ddoSP_PS_GroupIn = new SP_PS_GroupCustChangePDO();

        ddoSP_PS_GroupIn.corpCode       = getDataKeys("CORPCODE"); ;
        ddoSP_PS_GroupIn.corpName       = txtGroupCust.Text.Trim();
        ddoSP_PS_GroupIn.linkMan        = txtLinkMan.Text.Trim();
        ddoSP_PS_GroupIn.remark         = txtRemark.Text.Trim();
        ddoSP_PS_GroupIn.serManagerCode = selCustSerMgr.SelectedValue;
        ddoSP_PS_GroupIn.useTag         = selUseTag.SelectedValue ;
        ddoSP_PS_GroupIn.corpAdd        = txtAddr.Text.Trim();
        ddoSP_PS_GroupIn.corpPhone      = txtPhone.Text.Trim();
        ddoSP_PS_GroupIn.corpEmail      = txtEmail.Text.Trim();

        bool ok = TMStorePModule.Excute(context, ddoSP_PS_GroupIn);
        if (ok)
        {
            AddMessage("M008111112");
            //btnQuery_Click(sender, e);

            lvwGroupCustQuery.SelectedIndex = -1;
            //清除输入的单位信息
            ClearCorp();
        }
    }

    private void ClearCorp()
    {
        txtGroupCust.Text="";
        txtLinkMan.Text="";
        txtRemark.Text="";
        selCustSerMgr.SelectedValue="";

        txtAddr.Text="";
        txtPhone.Text = "";
        txtEmail.Text = "";
   
    }


   private Boolean isModifyAll()
   {
       if (
        txtGroupCust.Text   == getDataKeys("CORPNAME") &&
        txtLinkMan.Text     == getDataKeys("LINKMAN")  &&
        txtPhone.Text       == getDataKeys("CORPPHONE") &&
        txtAddr.Text        == getDataKeys("CORPADD") &&
        txtEmail.Text       == getDataKeys("CORPEMAIL") &&
        txtRemark.Text      == getDataKeys("REMARK") &&
        selUseTag.SelectedValue == getDataKeys("USETAG") &&
        selCustSerMgr.SelectedValue == getDataKeys("SERMANAGERCODE").Trim()
       )
       {
           return false;
       }

       return true;

   }
   string[] popPhrase = {"公司", "苏州", "中国" ,"中心" ,"银行" };

}
