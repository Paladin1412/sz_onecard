﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FI_GroupBusinessQuery.aspx.cs"
    Inherits="ASP_Financial_FI_GroupBusinessQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>团购业务报表</title>
    <link rel="stylesheet" type="text/css" href="../../css/frame.css" />
    <script type="text/javascript" src="../../js/print.js"></script>
    <script type="text/javascript" src="../../js/myext.js"></script>
    <link href="../../css/card.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="tb">
        管理报表->团购业务报表
    </div>
    <ajaxToolkit:ToolkitScriptManager runat="Server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true" ID="ToolkitScriptManager1" />
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
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <!-- #include file="../../ErrorMsg.inc" -->
            <div class="con">
                <div class="card">
                    查询</div>
                <div class="kuang5">
                    <table width="95%" border="0" cellpadding="0" cellspacing="0" class="text25">
                        <tr>
                            <td>
                                <div align="right">
                                    开始日期:</div>
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtFromDate" MaxLength="8" CssClass="input"></asp:TextBox>
                                <ajaxToolkit:CalendarExtender ID="FCalendar1" runat="server" TargetControlID="txtFromDate"
                                    Format="yyyyMMdd" />
                            </td>
                            <td>
                                <div align="right">
                                    结束日期:</div>
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtToDate" MaxLength="8" CssClass="input"></asp:TextBox>
                                <ajaxToolkit:CalendarExtender ID="FCalendar2" runat="server" TargetControlID="txtToDate"
                                    Format="yyyyMMdd" />
                            </td>
                            <td>
                                <div align="right">
                                    部门:</div>
                            </td>
                            <td>
                                <asp:DropDownList ID="selDept" CssClass="inputmid" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="selDept_Changed">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div align="right">
                                    查询方式:</div>
                            </td>
                            <td>
                                <asp:DropDownList ID="selWay" CssClass="input" runat="server">
                                    <asp:ListItem Text="0:汇总" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="1:明细" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <div align="right">
                                    团购商家:</div>
                            </td>
                            <td>
                                <asp:DropDownList ID="selShop" CssClass="input" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <div align="right">
                                    员工:</div>
                            </td>
                            <td>
                                <asp:DropDownList ID="selStaff" CssClass="inputmid" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td align="right" colspan='5'>
                                <asp:Button ID="btnQuery" CssClass="button1" runat="server" Text="查询" OnClick="btnQuery_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
                <table border="0" width="95%">
                    <tr>
                        <td align="left">
                            <div class="jieguo">
                                查询结果</div>
                        </td>
                        <td align="right">
                            <asp:Button ID="btnExport" CssClass="button1" runat="server" Text="导出Excel" OnClick="btnExport_Click" />
                            <asp:Button ID="btnPrint" CssClass="button1" runat="server" Text="打印" OnClientClick="return printGridView('printarea');" />
                        </td>
                    </tr>
                </table>
                <div id="printarea" class="kuang5">
                    <div style="height: 380px; overflow: auto;">
                     <table id="printReport" width ="95%">
                        <tr align="center">
                            <td style ="font-size:16px;font-weight:bold">团购业务报表</td>
                        </tr>
                        <tr>
                            <td>
                                <table width="300px" align="right">
                                    <tr align="right">
                                        <td>开始日期：<%=txtFromDate.Text%></td>
                                        <td>结束日期：<%=txtToDate.Text%></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                        <asp:GridView ID="gvResult" runat="server" Width="95%" 
                            CssClass="tab2" 
                            HeaderStyle-CssClass="tabbt"
                            FooterStyle-CssClass="tabcon" 
                            AlternatingRowStyle-CssClass="tabjg" 
                            SelectedRowStyle-CssClass="tabsel"
                            PagerSettings-Mode="NumericFirstLast" 
                            PagerStyle-HorizontalAlign="left" 
                            PagerStyle-VerticalAlign="Top"
                            AutoGenerateColumns="true" 
                            AllowPaging="True"
                            PageSize="20" 
                            OnPageIndexChanging="gvResult_PageIndexChanging"
                            OnRowDataBound="gvResult_RowDataBound"
                            ShowFooter="true">
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
    </asp:UpdatePanel>
    </form>
</body>
</html>
