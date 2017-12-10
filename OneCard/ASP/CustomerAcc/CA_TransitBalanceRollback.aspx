﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CA_TransitBalanceRollback.aspx.cs" 
Inherits="ASP_CustomerAcc_CA_TransitBalanceRollback" EnableEventValidation="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../../CardReader.ascx" TagName="CardReader" TagPrefix="cr" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>转账返销</title>
    <link rel="stylesheet" type="text/css" href="../../css/frame.css" />
    <link href="../../css/card.css" rel="stylesheet" type="text/css" />
    <link  href="../../css/Cust_AS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../js/jquery-1.5.min.js"></script>
    <script type="text/javascript" src="../../js/print.js"></script>
    <script language="javascript">
  <!--
        function OpenPort() {
            if (!MSComm1.PortOpen) {
                var WshShell;
                var keyValue;

                try {
                    WshShell = new ActiveXObject("WScript.Shell");
                } catch (ex) {
                    alert("请调整IE的ActiveX安全级别");
                    return false;
                }

                try {

                    keyValue = WshShell.RegRead("HKEY_LOCAL_MACHINE\\SOFTWARE\\OneCard\\ComPort");

                    if (keyValue == '' || keyValue.charCodeAt(0) < 49 || keyValue.charCodeAt(0) > 57) {
                        alert("请在【系统管理->本地参数管理】页面里，配置ComPort端口！");
                        return false;
                    }

                }
                catch (ex) {
                    alert("请在【系统管理->本地参数管理】页面里，配置ComPort端口！");
                    return false;
                }


                try {
                    MSComm1.CommPort = keyValue;
                    MSComm1.PortOpen = true;
                } catch (ex) {
                    alert("小键盘端口无法打开，请在【系统管理->本地参数管理】页面里，配置ComPort端口！");
                    return false;
                }

            }
        }

        function ClosePort() {
            if (MSComm1.PortOpen) {
                MSComm1.PortOpen = false;
            }
        }
  
  -->
    </script>

    <script id="clientEventHandlersJS" language="javascript">   
  <!--
        function MSComm1_OnComm() {
            var fldWeight = $get("PassWD");
            var strInput;
            strInput = MSComm1.Input;
            if (strInput.charCodeAt(0) == 13) {
                ClosePort();
                alert("密码输入完毕");
            } else if (strInput.charCodeAt(0) == 8) {
                fldWeight.value = "";
            } else {
                fldWeight.value = fldWeight.value + strInput;
            }
            fldWeight.focus();
            return false;
        }
  -->
    </script>

    <script type="text/javascript" for="MSComm1" event="OnComm">
  MSComm1_OnComm();
    </script>
</head>
<body>
    <cr:CardReader ID="cardReader" runat="server" />
    <form id="form1" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="cust_left"></td>
                <td class="cust_mid">专有账户->账户互转返销</td>
                <td class="cust_right"></td>
             </tr>
    </table>
    <object classid="clsid:648A5600-2C6E-101B-82B6-000000000014" id="MSComm1" codebase="MSCOMM32.OCX"
        type="application/x-oleobject" width='0' height='0'>
        <param name="InputLen" value="0" />
        <param name="Rthreshold" value="1" />
        <param name="Settings" value="1200,N,8,1" />
    </object>
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
            <ContentTemplate>
                <aspControls:PrintPingZheng ID="ptnPingZheng" runat="server" PrintArea="ptnPingZheng1" />
                <asp:BulletedList ID="bulMsgShow" runat="server">
                </asp:BulletedList>

                <script runat="server">public override void ErrorMsgShow() { ErrorMsgHelper(bulMsgShow); }</script>
                <div class="cust_tabbox">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
    	                <td class="cust_top1_l"><div class="cust_p1"></div></td>
                        <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">转出卡信息</span></td>
                        <td class="cust_top1_r"></td>
                    </tr>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cust_form">
                            <tr>
                                <th style="width: 10%">
                                        用户卡号：
                                </th>
                                <td style="width: 15%">
                                    <asp:TextBox ID="OtxtCardno" CssClass="labeltext" MaxLength="16" runat="server"></asp:TextBox>
                                </td>
                                <th style="width: 10%">
                                        账户余额：
                                </th>
                                <td style="width: 15%">
                                    <asp:HiddenField ID="OhidAccID" runat="server"  />
                                    <asp:Label ID="OlblRelBalance" runat="server" Text=""></asp:Label>
                                </td>
                                <th style="width: 10%">
                                        用户姓名：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="OlblCusname" runat="server" Text=""></asp:Label>
                                </td>
                                <th style="width: 10%">
                                        手机号码：
                                </th>
                                 <td style="width: 15%">
                                    <asp:Label ID="OlblCustphone" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                
                               
                                <th style="width: 10%">
                                        证件类型：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="OlblPapertype" runat="server" Text=""></asp:Label>
                                </td>
                               <th style="width: 10%">
                                        证件号码：
                                </th>
                                <td colspan=5>
                                    <asp:Label ID="OlblCustpaperno" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=8>
                                     <div class="cust_bton1">
                                    <asp:LinkButton ID="btnReadCard" runat="server" Text="读卡" OnClientClick="return ReadCardInfo('OtxtCardno')"
                                        OnClick="btnReadCard_Click" />
                                        </div>
                                </td>
                            </tr>
                        </table>
                </div>
                <div class="cust_tabbox">
    	            <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	            <td class="cust_top1_l"><div class="cust_p3"></div></td>
                    <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">转出卡账户信息</span></td>
                    <td class="cust_top1_r"></td>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	                <tr>
    	                    <td>
    	                        <div style="height: 100px" class="gdtb">
                                <asp:GridView ID="gvOutAccount" runat="server" Width="100%" CssClass="tab1" HeaderStyle-CssClass="tabbt"
                                    AlternatingRowStyle-CssClass="tabjg" SelectedRowStyle-CssClass="tabsel" PagerSettings-Mode="NumericFirstLast"
                                    PageSize="200" AllowPaging="True"  PagerStyle-HorizontalAlign="left"
                                    PagerStyle-VerticalAlign="Top" AutoGenerateColumns="false" onrowcreated="gvOutAccount_RowCreated"
                                    onselectedindexchanged="gvOutAccount_SelectedIndexChanged" OnRowDataBound="gvOutAccount_RowDataBound"
                                    EmptyDataText="没有数据记录!">
                                    <Columns>
                                        <asp:BoundField DataField="ACCT_TYPE_NAME" HeaderText="账户类型" />
                                        <asp:BoundField DataField="LIMIT_DAYAMOUNT" HeaderText="每日消费限额" />
                                        <asp:BoundField DataField="LIMIT_EACHTIME" HeaderText="每笔消费限额" />
                                        <asp:BoundField DataField="EFF_DATE" HeaderText="生效日期" />
                                        <asp:BoundField DataField="STATENAME" HeaderText="状态" />
                                        <asp:BoundField DataField="Create_Date" HeaderText="创建日期" />
                                        <asp:BoundField DataField="REL_BALANCE" HeaderText="专有账户余额" />
                                        <asp:BoundField DataField="Total_Consume_Money" HeaderText="总消费金额" />
                                        <asp:BoundField DataField="Total_Consume_Times" HeaderText="总消费次数" />
                                        <asp:BoundField DataField="LAST_CONSUME_TIME" HeaderText="最后消费时间" />
                                        <asp:BoundField DataField="Total_Supply_Money" HeaderText="总充值金额" />
                                        <asp:BoundField DataField="Total_Supply_Times" HeaderText="总充值次数" />
                                        <asp:BoundField DataField="LAST_SUPPLY_TIME" HeaderText="最后充值时间" />
                                    </Columns>
                                </asp:GridView>
                                </div>
    	                    </td>
    	                </tr>
    	            </table>
                </div>
                <div class="cust_tabbox">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
    	                <td class="cust_top1_l"><div class="cust_p1"></div></td>
                        <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">转入卡信息</span></td>
                        <td class="cust_top1_r"></td>
                    </tr>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="cust_form">
                            <tr>
                                <th style="width: 10%">
                                        用户卡号：
                                </th>
                                <td style="width: 15%">
                                    <asp:TextBox ID="ItxtCardno" CssClass="labeltext" MaxLength="16" runat="server"></asp:TextBox>
                                </td>
                                <th style="width: 10%">
                                        账户余额：
                                </th>
                                <td style="width: 15%">
                                    <asp:HiddenField ID="IhidAccID" runat="server"  />
                                    <asp:Label ID="IlblRelBalance" runat="server" Text=""></asp:Label>
                                </td>
                                <th>
                                        帐期扣费类型：
                                </th>
                                <td>
                                    <asp:Label ID="IlblUpperType" runat="server" Text=""></asp:Label>
                                </td>
                                <th>
                                        扣费最高额：
                                </th>
                                <td>
                                   <asp:Label ID="IlblUpper" runat="server" Text=""></asp:Label>
                                </td>
                               
                            </tr>
                            <tr>
                                <th style="width: 10%">
                                        用户姓名：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="IlblCusname" runat="server" Text=""></asp:Label>
                                </td>
                                <th style="width: 10%">
                                        手机号码：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="IlblCustphone" runat="server" Text=""></asp:Label>
                                </td>
                                <th style="width: 10%">
                                        证件类型：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="IlblPapertype" runat="server" Text=""></asp:Label>
                                </td>
                               <th style="width: 10%">
                                        证件号码：
                                </th>
                                <td style="width: 15%">
                                    <asp:Label ID="IlblCustpaperno" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                        账户状态：
                                </th>
                                <td>
                                    <asp:Label ID="IlblAccState" runat="server" Text=""></asp:Label>
                                </td>
                                <th>
                                        开户日期：
                                </th>
                                <td>
                                    <asp:Label ID="IlblCreateDate" runat="server" Text=""></asp:Label>
                                </td>
                                <th>
                                        当日消费限额：
                                </th>
                                <td>
                                   <asp:Label ID="IlblUpperDay" runat="server" Text=""></asp:Label>
                                </td>
                               <th>
                                        每笔消费限额：
                                </th>
                                <td>
                                   <asp:Label ID="IlblUpperOnce" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            
                        </table>
                </div>
                <div class="cust_tabbox">
    	            <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	            <td class="cust_top1_l"><div class="cust_p3"></div></td>
                    <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">转入卡账户信息</span></td>
                    <td class="cust_top1_r"></td>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	                <tr>
    	                    <td>
    	                        <div style="height: 100px">
                                    <asp:GridView ID="gvInAccount" runat="server" Width="100%" CssClass="tab1" HeaderStyle-CssClass="tabbt"
                                        AlternatingRowStyle-CssClass="tabjg" SelectedRowStyle-CssClass="tabsel" PagerSettings-Mode="NumericFirstLast"
                                        PageSize="200" AllowPaging="True"  PagerStyle-HorizontalAlign="left"
                                        PagerStyle-VerticalAlign="Top" AutoGenerateColumns="false" onrowcreated="gvInAccount_RowCreated"
                                        onselectedindexchanged="gvInAccount_SelectedIndexChanged" OnRowDataBound="gvInAccount_RowDataBound"
                                        EmptyDataText="没有数据记录!">
                                        <Columns>
                                            <asp:BoundField DataField="ACCT_TYPE_NAME" HeaderText="账户类型" />
                                            <asp:BoundField DataField="LIMIT_DAYAMOUNT" HeaderText="每日消费限额" />
                                            <asp:BoundField DataField="LIMIT_EACHTIME" HeaderText="每笔消费限额" />
                                            <asp:BoundField DataField="EFF_DATE" HeaderText="生效日期" />
                                            <asp:BoundField DataField="STATENAME" HeaderText="状态" />
                                            <asp:BoundField DataField="Create_Date" HeaderText="创建日期" />
                                            <asp:BoundField DataField="REL_BALANCE" HeaderText="专有账户余额" />
                                            <asp:BoundField DataField="Total_Consume_Money" HeaderText="总消费金额" />
                                            <asp:BoundField DataField="Total_Consume_Times" HeaderText="总消费次数" />
                                            <asp:BoundField DataField="LAST_CONSUME_TIME" HeaderText="最后消费时间" />
                                            <asp:BoundField DataField="Total_Supply_Money" HeaderText="总充值金额" />
                                            <asp:BoundField DataField="Total_Supply_Times" HeaderText="总充值次数" />
                                            <asp:BoundField DataField="LAST_SUPPLY_TIME" HeaderText="最后充值时间" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
    	                    </td>
    	                </tr>
    	            </table>
                </div>
                 <div class="cust_tabbox">
	                <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	                <td class="cust_top1_l"><div class="cust_p7"></div></td>
                        <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">输入转出卡密码</span></td>
                        <td class="cust_top1_r"></td>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="cust_form">
    	                <tr>
        	                <th width="10%">密码：</th>
        	                <td width="20%"><asp:TextBox ID="PassWD" CssClass="inputmid" TextMode="password" MaxLength="6" runat="server"></asp:TextBox>
        	                </td>
        	                <td>
        	                <div class="cust_bton2"><asp:LinkButton ID="btnPassInput" runat="server" Text="小键盘输入密码" Width="100px" OnClientClick="return OpenPort()"/>
        	                </div>
        	                </td>
        	            </tr>
        	        </table>
                </div>
                <div class="cust_tabbox">
	                <table border="0" cellpadding="0" cellspacing="0" width="100%">
    	                <td class="cust_top1_l"><div class="cust_p7"></div></td>
                        <td class="cust_top1_m"><span style="line-height:22px; margin-left:5px; color:#333;">转账信息</span></td>
                        <td class="cust_top1_r"></td>
                    </table>
                    <div class="cust_line1"></div>
                    <div class="cust_line2"></div>
                  
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" class="cust_form">
                            <tr>
                                <th width="10%">转账金额：</th>
                                <td><asp:Label ID="labTranBalance" runat="server" Text=""></asp:Label></td>
                                <th width="10%">转账员工：</th>
                                <td><asp:Label ID="labTranPer" runat="server" Text=""></asp:Label></td>
                                <th width="10%">转账时间：</th>
                                <td><asp:Label ID="labTranDate" runat="server" Text=""></asp:Label><asp:HiddenField ID="hidTradeID" runat="server" /></td>
                            </tr>
    	                 </table>
                
                </div>
                <div class="cust_tabbox">
	                <div class="cust_bottom_bton"><asp:LinkButton ID="btnTransAcc" OnClick="btnSubmit_Click" runat="server"
                                        Text="转账返销" Enabled="false" OnClientClick="return submitConfirm()" /></div>
                    <div class="cust_bottom_bton"><asp:LinkButton ID="btnPrintPZ" runat="server" Text="打印凭证"  Enabled="false"
                                        OnClientClick="printdiv('ptnPingZheng1')" /></div>
                    <div class="cust_bottom_txt"><span style="margin-right:5px;"><asp:CheckBox ID="chkPingzheng" runat="server" Checked="true" Text="自动打印凭证" /></span></div>
                    <div class="c"></div>
                </div>
               <div class="btns">
                        <table width="200" border="0" align="right" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    </td>
                                <td>
                                    <asp:LinkButton runat="server" ID="btnConfirm" OnClick="btnSubmit_Click" />
                                    </td>
                            </tr>
                        </table>
                        
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>

    </form>
</body>
</html>
