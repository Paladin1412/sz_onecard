﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RM_ResourceStockReturn.aspx.cs"
    Inherits="ASP_ResourceManage_RM_ResourceStockReturn" EnableEventValidation="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>资源退库</title>
    <link rel="stylesheet" type="text/css" href="../../css/frame.css" />
    <link href="../../css/card.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../js/myext.js"></script>
    <script src="../../js/jquery-1.5.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function changeType(index) {
            if ($('#hideInputType' + index.toString()).val() == "0") {
                $('#linkAttribute' + index.toString() + 'Type').text('字符串');
                $('#hideInputType' + index.toString()).val('1');
                $('#txtAttribute' + index.toString() + 'ValueStr').hide();
                $('#spanAttribute' + index.toString() + 'No').show();
            }
            else {
                $('#linkAttribute' + index.toString() + 'Type').text('号段');
                $('#hideInputType' + index.toString()).val('0');
                $('#txtAttribute' + index.toString() + 'ValueStr').show();
                $('#spanAttribute' + index.toString() + 'No').hide();
            }
        }
    </script>
    <style type="text/css">
        table.data
        {
            font-size: 90%;
            border-collapse: collapse;
            border: 0px solid black;
        }

            table.data th
            {
                background: #bddeff;
                width: 25em;
                text-align: left;
                padding-right: 8px;
                font-weight: normal;
                border: 1px solid black;
            }

            table.data td
            {
                background: #ffffff;
                vertical-align: middle;
                padding: 0px 2px 0px 2px;
                border: 1px solid black;
            }

        .attributeDIV
        {
            width: 24%;
            float: left;
            text-align: center;
        }

        .inputlabel
        {
            width: 75px;
            border: 0;
            color: #000000;
            font-size: 12px;
            padding-top: 4px;
        }

        .inputtext
        {
            width: 85px;
            padding-top: 4px;
        }

        .divright
        {
            width: 50%;
            float: left;
            text-align: right;
        }

        .divleft
        {
            width: 50%;
            float: left;
            text-align: left;
            height: 25px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="tb">
            其他资源管理->资源退库
        </div>
        <ajaxToolkit:ToolkitScriptManager EnableScriptGlobalization="true" EnableScriptLocalization="true"
            ID="ScriptManager1" runat="server" />
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
        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <asp:BulletedList ID="bulMsgShow" runat="server" />
                <script runat="server">public override void ErrorMsgShow() { ErrorMsgHelper(bulMsgShow); }</script>
                <div class="con">
                    <div class="card">
                        查询
                    </div>
                    <div class="kuang5">
                        <table width="95%" border="0" cellpadding="0" cellspacing="0" class="text25">
                            <tr>
                                <td width="15%">
                                    <div align="right">
                                        资源类型:
                                    </div>
                                </td>
                                <td width="15%">
                                    <asp:DropDownList ID="ddlResourceType" runat="server" OnSelectedIndexChanged="ddlResourceType_SelectIndexChange"
                                        AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                                <td width="15%">
                                    <div align="right">
                                        资源名称:
                                    </div>
                                </td>
                                <td width="15%">
                                    <asp:DropDownList ID="ddlResource" runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td width="15%">
                                    <div align="right">
                                        领用员工:
                                    </div>
                                </td>
                                <td width="15%">
                                    <asp:DropDownList ID="selStaff" CssClass="inputmid" runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td align="right">
                                    <asp:Button ID="Button1" CssClass="button1" runat="server" Text="查询" OnClick="btnQuery_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="jieguo">
                        领用单信息
                    </div>
                    <div class="kuang5">
                        <div id="gvUseCard" style="height: 130px; overflow: auto; display: block">
                            <asp:GridView ID="gvResult" runat="server" Width="150%" CssClass="tab1" HeaderStyle-CssClass="tabbt"
                                FooterStyle-CssClass="tabcon" AlternatingRowStyle-CssClass="tabjg" SelectedRowStyle-CssClass="tabsel"
                                PagerSettings-Mode="NumericFirstLast" PagerStyle-HorizontalAlign="left" PagerStyle-VerticalAlign="Top"
                                AutoGenerateColumns="false" OnSelectedIndexChanged="gvResult_SelectedIndexChanged"
                                OnRowDataBound="gvResult_RowDataBound" OnRowCreated="gvResult_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="GETORDERID" HeaderText="领用单号" />
                                    <asp:BoundField DataField="RESUOURCETYPE" HeaderText="资源类型" />
                                    <asp:BoundField DataField="RESOURCENAME" HeaderText="资源名称" />
                                    <asp:BoundField DataField="STATE" HeaderText="领用状态" />
                                    <asp:BoundField DataField="APPLYGETNUM" HeaderText="申请领用数量" />
                                    <asp:BoundField DataField="AGREEGETNUM" HeaderText="同意领用数量" />
                                    <asp:BoundField DataField="ALREADYGETNUM" HeaderText="已领用数量" />
                                    <asp:BoundField DataField="LATELYGETDATE" HeaderText="最近领用时间" />
                                    <asp:BoundField DataField="GETSTAFFNAME" HeaderText="领用员工" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tab1">
                                        <tr class="tabbt">
                                            <td>领用单号
                                            </td>
                                            <td>资源类型
                                            </td>
                                            <td>资源名称
                                            </td>
                                            <td>领用状态
                                            </td>
                                            <td>申请领用数量
                                            </td>
                                            <td>同意领用数量
                                            </td>
                                            <td>已领用数量
                                            </td>
                                            <td>最近领用时间
                                            </td>
                                            <td>领用员工
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                    <div class="card">
                        资源退库
                    </div>
                    <div class="kuang5">
                        <table id="supplyUseCard" width="95%" border="0" cellpadding="0" cellspacing="0"
                            class="text25" style="display: block">
                            <tr>
                                <td width="12%">
                                    <div align="right">
                                        领用单号:
                                    </div>
                                </td>
                                <td width="12%">
                                    <asp:Label ID="txtResourceGetOrderID" runat="server">
                                    </asp:Label>
                                </td>
                                <td width="12%">
                                    <div align="right">
                                        领用状态:
                                    </div>
                                </td>
                                <td width="12%">
                                    <asp:Label ID="txtSTATE" runat="server">
                                    </asp:Label>
                                </td>
                                <td>
                                    <div align="right" width="12%">
                                        资源类型:
                                    </div>
                                </td>
                                <td width="12%">
                                    <asp:Label ID="txtResourceType" runat="server">
                                    </asp:Label>
                                </td>
                                <td width="12%">
                                    <div align="right">
                                        资源名称:
                                    </div>
                                </td>
                                <td width="12%">
                                    <asp:Label ID="txtResourceName" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="right">
                                        申请领用数量:
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="txtAPPLYGETNUM" runat="server">
                                    </asp:Label>
                                </td>
                                <td>
                                    <div align="right">
                                        同意领用数量:
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="txtAGREEGETNUM" runat="server">
                                    </asp:Label>
                                </td>
                                <td>
                                    <div align="right">
                                        已领用数量:
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="txtALREADYGETNUM" runat="server"></asp:Label>
                                </td>
                                <td>
                                    <div align="right">
                                        退库数量:
                                    </div>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtReturnNum" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <!--资源属性-->
                            <tr runat="server" id="trAttribute">
                                <td colspan="8">
                                    <div runat="server" id="divAttribute1" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute1Name" Text="" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute1Str">
                                                <asp:TextBox runat="server" ID="txtAttribute1ValueStr" Width="78" /></span> <span runat="server"
                                                    id="spanAttribute1No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute1ValueNoFrom" Width="23" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute1ValueNoTo" Width="23" /></span>
                                            <span runat="server"
                                                id="spanAttribute1Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute1Type" href="javascript:void(0)" onclick="changeType(1)">号段</a>
                                            <asp:HiddenField ID="hideAttribute1Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute1ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType1" runat="server" Value="0" />
                                        </div>
                                    </div>
                                    <div runat="server" id="divAttribute2" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute2Name" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute2Str">
                                                <asp:TextBox runat="server" ID="txtAttribute2ValueStr" Width="75" /></span> <span runat="server"
                                                    id="spanAttribute2No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute2ValueNoFrom" Width="23" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute2ValueNoTo" Width="23" /></span>
                                            <span runat="server"
                                                id="spanAttribute2Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute2Type" href="javascript:void(0)" onclick="changeType(2)">号段</a>
                                            <asp:HiddenField ID="hideAttribute2Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute2ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType2" runat="server" Value="0" />
                                        </div>
                                    </div>
                                    <div runat="server" id="divAttribute3" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute3Name" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute3Str">
                                                <asp:TextBox runat="server" ID="txtAttribute3ValueStr" Width="75" /></span> <span runat="server"
                                                    id="spanAttribute3No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute3ValueNoFrom" Width="23" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute3ValueNoTo" Width="23" /></span>
                                            <span runat="server"
                                                id="spanAttribute3Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute3Type" href="javascript:void(0)" onclick="changeType(3)">号段</a>
                                            <asp:HiddenField ID="hideAttribute3Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute3ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType3" runat="server" Value="0" />
                                        </div>
                                    </div>
                                    <div runat="server" id="divAttribute4" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute4Name" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute4Str">
                                                <asp:TextBox runat="server" ID="txtAttribute4ValueStr" Width="75" /></span> <span runat="server"
                                                    id="spanAttribute4No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute4ValueNoFrom" Width="23" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute4ValueNoTo" Width="23" /></span>
                                            <span runat="server"
                                                id="spanAttribute4Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute4Type" href="javascript:void(0)" onclick="changeType(4)">号段</a>
                                            <asp:HiddenField ID="hideAttribute4Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute4ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType4" runat="server" Value="0" />
                                        </div>
                                    </div>
                                    <div runat="server" id="divAttribute5" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute5Name" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute5Str">
                                                <asp:TextBox runat="server" ID="txtAttribute5ValueStr" Width="75" /></span> <span runat="server"
                                                    id="spanAttribute5No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute5ValueNoFrom" Width="28" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute5ValueNoTo" Width="28" /></span>
                                            <span runat="server"
                                                id="spanAttribute5Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute5Type" href="javascript:void(0)" onclick="changeType(5)">号段</a>
                                            <asp:HiddenField ID="hideAttribute5Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute5ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType5" runat="server" Value="0" />
                                        </div>
                                    </div>
                                    <div runat="server" id="divAttribute6" class="attributeDIV">
                                        <div class="divright">
                                            <asp:Label runat="server" ID="lblAttribute6Name" />
                                        </div>
                                        <div class="divleft">
                                            <span runat="server" id="spanAttribute6Str">
                                                <asp:TextBox runat="server" ID="txtAttribute6ValueStr" Width="75" /></span> <span runat="server"
                                                    id="spanAttribute6No" style="display: none">
                                                    <asp:TextBox runat="server" ID="txtAttribute6ValueNoFrom" Width="28" />
                                                    -
                                                <asp:TextBox runat="server" ID="txtAttribute6ValueNoTo" Width="28" /></span>
                                            <span runat="server"
                                                id="spanAttribute6Null" style="display: none; color: red; font-weight: bold;">*</span>
                                            <a runat="server" id="linkAttribute6Type" href="javascript:void(0)" onclick="changeType(6)">号段</a>
                                            <asp:HiddenField ID="hideAttribute6Type" runat="server" />
                                            <asp:HiddenField ID="hideAttribute6ISNULL" runat="server" />
                                            <asp:HiddenField ID="hideInputType6" runat="server" Value="0" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="right">
                                        退库原因:
                                    </div>
                                </td>
                                <td colspan="7">
                                    <asp:TextBox ID="txtReMark" CssClass="inputlong"
                                        Width="313px" Height="60px" MaxLength="255" Rows="4" runat="server" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="footall">
                </div>
                <div class="btns">
                    <table width="200" border="0" align="right" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <asp:Button ID="btnSubmit" runat="server" Text="资源退库" CssClass="button1" Enabled="true"
                                    OnClick="btnSubmit_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="display: none" runat="server" id="printarea">
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
