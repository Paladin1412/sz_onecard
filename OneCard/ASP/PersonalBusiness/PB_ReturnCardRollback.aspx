﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PB_ReturnCardRollback.aspx.cs"
    Inherits="ASP_PersonalBusiness_PB_ReturnCardRollback" %>

<%@ Register Src="../../CardReader.ascx" TagName="CardReader" TagPrefix="cr" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>退卡返销</title>
    <link rel="stylesheet" type="text/css" href="../../css/frame.css" />
    <script type="text/javascript" src="../../js/print.js"></script>
    <link href="../../css/card.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <cr:CardReader ID="cardReader" runat="server" />
    <form id="form1" runat="server">
    <div class="tb">
        个人业务->退卡返销
    </div>
    <ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true" ID="ScriptManager2" />
    <script type="text/javascript" language="javascript">
        var swpmIntance = Sys.WebForms.PageRequestManager.getInstance();
        swpmIntance.add_initializeRequest(BeginRequestHandler);
        swpmIntance.add_pageLoading(EndRequestHandler);
        function BeginRequestHandler(sender, args) {
            try { MyExtShow('请等待', '正在提交后台处理中...'); } catch (ex) { }
        }
        function EndRequestHandler(sender, args) {
            try { MyExtHide(); } catch (ex) { }
        }
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <contenttemplate>
            <aspControls:PrintPingZheng ID="ptnPingZheng" runat="server" PrintArea="ptnPingZheng1" />
<asp:BulletedList ID="bulMsgShow" runat="server">
</asp:BulletedList>
<script runat="server" >public override void ErrorMsgShow() { ErrorMsgHelper(bulMsgShow); }</script>  
  <div class="con">
  <div class="card">卡片信息</div>
  <div class="kuang5">
 <table width="95%" border="0" cellpadding="0" cellspacing="0" class="text20">
  <tr>
    <td width="10%"><div align="right">用户卡号:</div></td>
    <td width="13%"><asp:TextBox ID="txtCardno" CssClass="input" maxlength="16" runat="server"></asp:TextBox></td>
    <td width="10%"><div align="right">卡片类型:</div></td>
    <td width="13%"><asp:TextBox ID="LabCardtype" CssClass="labeltext" runat="server"></asp:TextBox></td>
    <td width="10%"><div align="right">退卡类型:</div></td>
    <td width="13%"><asp:Label ID="Reasontype" runat="server" Text=""></asp:Label></td>
    <td width="10%"><div align="right"></div></td>
    <td width="21%"><asp:Button ID="btnReadCard" CssClass="button1" runat="server" Text="读卡" 
        OnClientClick="return ReadCardInfoEx()" OnClick="btnReadCard_Click" /></td>
  </tr>
  <tr>
    <td><div align="right">售卡时间:</div></td>
    <td><asp:Label ID="SaleDate" runat="server" Text=""></asp:Label></td>
    <td><div align="right">退卡时间:</div></td>
    <td><asp:Label ID="ReturnDate" runat="server" Text=""></asp:Label></td>
    <td><div align="right">已退充值:</div></td>
    <td><asp:Label ID="ReturnMoney" runat="server" Text=""></asp:Label></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><div align="right">卡片押金:</div></td>
    <td><asp:Label ID="Deposit" runat="server" Text=""></asp:Label></td>
    <td><div align="right">已退押金:</div></td>
    <td><asp:Label ID="ReturnDeposit" runat="server" Text=""></asp:Label></td>
    <td><div align="right">退卡员工:</div></td>
    <td><asp:Label ID="ReturnStaff" runat="server" Text=""></asp:Label></td>
    <td>&nbsp;</td>
    <td><asp:Button ID="btnDBread" CssClass="button1" runat="server" Text="读数据库" OnClick="btnDBread_Click" /></td>
  </tr>
</table>

 </div>
  <div class="pip" style="display: none">用户信息</div>
  <div class="kuang5" style="display: none">
 <table width="95%" border="0" cellpadding="0" cellspacing="0" class="text20">
  <tr>
    <td width="10%"><div align="right">用户姓名:</div></td>
    <td width="13%"><asp:Label ID="CustName" runat="server" Text=""></asp:Label></td>
    <td width="10%"><div align="right">出生日期:</div></td>
    <td width="13%"><asp:Label ID="CustBirthday" runat="server" Text=""></asp:Label></td>
    <td width="10%"><div align="right">证件类型:</div></td>
    <td width="13%"><asp:Label ID="Papertype" runat="server" Text=""></asp:Label></td>
    <td width="10%"><div align="right">证件号码:</div></td>
    <td width="21%" colspan="3"><asp:Label ID="Paperno" runat="server" Text=""></asp:Label></td>
    </tr>
  <tr>
    <td><div align="right">用户性别:</div></td>
    <td><asp:Label ID="Custsex" runat="server" Text=""></asp:Label></td>
    <td><div align="right">联系电话:</div></td>
    <td><asp:Label ID="Custphone" runat="server" Text=""></asp:Label></td>
    <td><div align="right">邮政编码:</div></td>
    <td><asp:Label ID="Custpost" runat="server" Text=""></asp:Label></td>
    <td><div align="right">联系地址:</div></td>
    <td colspan="3"><asp:Label ID="Custaddr" runat="server" Text=""></asp:Label></td>
    </tr>
  
  
  <tr>
    <td><div align="right">电子邮件:</td>
    <td><asp:Label ID="txtEmail" runat="server" Text=""></asp:Label></td> 
    <td valign="top"><div align="right">备注　　:</div></td>
    <td colspan="5"><asp:Label ID="Remark" runat="server" Text=""></asp:Label></td>
    </tr>
</table>
                    <asp:HiddenField ID="hiddenread" runat="server" />
                    <asp:HiddenField ID="hiddentxtCardno" runat="server" />
                    <asp:HiddenField ID="hiddenAsn" runat="server" />
                    <asp:HiddenField ID="hiddenLabCardtype" runat="server" />
                    <asp:HiddenField ID="hiddensDate" runat="server" />
                    <asp:HiddenField ID="hiddeneDate" runat="server" />
                    <asp:HiddenField ID="hiddencMoney" runat="server" />
                    <asp:HiddenField ID="hiddentradeno" runat="server" />
                    <asp:HiddenField ID="hidWarning" runat="server" />
<asp:LinkButton runat="server" ID="btnConfirm" OnClick="btnConfirm_Click"/>
                    <asp:HiddenField ID="hiddenDepositFee" runat="server" />
                    <asp:HiddenField ID="hiddenSupplyFee" runat="server" />
                    <asp:HiddenField ID="hidProcedureFee" runat="server" />
                    <asp:HiddenField ID="hidOtherFee" runat="server" />
                    <asp:HiddenField ID="hiddenTradeid" runat="server" />
                    <asp:HiddenField ID="hiddenREASONCODE" runat="server" />
                    <asp:HiddenField ID="hiddenCardstate" runat="server" />
                    <asp:HiddenField ID="hiddenSerstaketag" runat="server" />
<asp:HiddenField runat="server" ID="hidCardReaderToken" />
<asp:HiddenField ID="hiddenreadtype" runat="server" />
      <asp:HiddenField ID="hidChargeMoney" runat="server" />
 </div>
</div>
 <div class="basicinfo">
 <div class="money">费用信息</div>
 <div class="kuang5">
     <table width="180" border="0" cellpadding="0" cellspacing="0" class="tab1">
  <tr class="tabbt">
    <td width="66">费用项目</td>
    <td width="94">费用金额(元)</td>
    </tr>
  <tr>
    <td>押金</td>
    <td><asp:Label ID="DepositFee" runat="server" Text=""></asp:Label></td>
    </tr>
  <tr class="tabjg">
    <td>充值</td>
    <td><asp:Label ID="SupplyFee" runat="server" Text=""></asp:Label></td>
    </tr>
  <tr>
    <td>手续费</td>
    <td><asp:Label ID="ProcedureFee" runat="server" Text=""></asp:Label></td>
  </tr>
  <tr class="tabjg">
    <td>其他费用</td>
    <td><asp:Label ID="OtherFee" runat="server" Text=""></asp:Label></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="tabjg">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="tabjg">
    <td>合计应收(退)</td>
    <td><asp:Label ID="Total" runat="server" Text=""></asp:Label></td>
  </tr>
</table>
 </div>
 </div>
 <div class="pipinfo">
 <div class="info">退卡信息</div>
 <div class="kuang5">
 <div class="bigkuang">
 <div class="left">
 <img src="../../Images/show-re.JPG" /></div>
  <div class="big">
  <table width="200" border="0" cellspacing="0" cellpadding="0">
     <tr>
       <td width="160" colspan="2">&nbsp;</td>
       </tr>
     
     <tr>
       <td colspan="2">
         <label></label></td>
      </tr>
     <tr>
       <td colspan="2" class="red"><div align="center">应收/退客户的金额</div></td>
      </tr>
     <tr>
       <td colspan="2"><div align="center"><asp:Label ID="ReturnSupply" runat="server" Text=""></asp:Label></div></td>
      </tr>
     <tr>
       <td colspan="2">&nbsp;</td>
     </tr>
     <tr>
       <td colspan="2">&nbsp;</td>
     </tr>
   </table>
  </div>
  </div>
 </div>
</div>
 <div class="footall"></div>
<div class="btns">
     <table width="200" border="0" align="right" cellpadding="0" cellspacing="0">
  <tr>
                        <td style="height: 24px">
                            <asp:Button ID="btnPrintPZ" runat="server" Text="打印凭证" CssClass="button1" Enabled="false"
                                OnClientClick="printdiv('ptnPingZheng1')" />
                        </td>
                        <td style="height: 24px">
                            <asp:Button ID="btnRollback" CssClass="button1" runat="server" Text="退卡返销" Enabled="false"
                                OnClick="btnRollback_Click" />
                        </td>
                        <asp:HiddenField ID="hidTradeIDZJG" runat="server" />
                        <asp:HiddenField ID="hidCardIDZJG" runat="server" />
  </tr>
</table>
<td><asp:CheckBox ID="chkPingzheng" runat="server" Checked="true" />自动打印凭证</td>
</div>
</contenttemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
