<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    CodeFile="ManageARC.aspx.cs" Inherits="ADMIN_ManageARC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">

    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if ((charCode < 48 || charCode > 57) && charCode != 43)
                    return false;
            return true;
        }
        function EnterEvent(e) {
            if (e.keyCode == 13) {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        //added by priya
        $(function () {

            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
    </script>
    <style type="text/css">
        .style1 {
            width: 278px;
        }

        .style2 {
            /*width: 25%;*/
        }

        .chkListStyle td {
            padding-left: 35px;
        }

        .chkListStyle label {
            padding-left: 5px;
        }
    </style>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />

    <div>
        <table width="102%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div id="accordion">
                        <h3><b>Page Description</b></h3>
                        <div>
                            <ul style="line-height: 20px">
                                <li>Specific ARC can be searched by
                                    <br />
                                    1.	ARC Name<br />
                                    2.  ARC Code<br />
                                    3.	Unique code<br />
                                </li>

                                   <li>Emizon InstallID  IDStrategy (0,1,2,3)
                                       <ul>
                                           <li>0 Emizon managed</li>
                                           <li>"1" integers only</li>
                                           <li>"2" numbers with leading zero's</li>
                                           <li>"3" - alphanumerics</li>
                                       </ul>
                                   </li>
                                <li>
                                    InstallID Length - specifies the min and max length allowed for InstallID (ex: 1,6 --> Min:1 , Max: 6)
                                </li>


                                <li>A new ARC can be created and categories and products can be assigned to the ARC.<br />
                                </li>
                                <li>The ARC Details can be edited and saved.<br />
                                </li>
                            </ul>
                        </div>
                    </div>

                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage ARC</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="100%">
                                    <asp:Panel ID="pnlARClist" runat="server">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="ARC Name"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtarcnamesrch" runat="server" onkeypress="return EnterEvent(event)"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="ARC Code"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtarccodesrch" runat="server" onkeypress="return EnterEvent(event)"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Unique Code"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtuniquecodesrch" runat="server" onkeypress="return EnterEvent(event)"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                        <table>
                                            <tr>
                                                <td colspan="6">Choose an ARC from below to edit OR
                                                    <asp:Button ID="lbnewarc" runat="server" OnClick="lbnewarc_Click" Text="Create new ARC"
                                                        CssClass="css_btn_class"></asp:Button>
                                                </td>
                                                <td colspan="1" style="text-align: right;">
                                                    <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" OnClick="btnSearch_Click"
                                                        CssClass="css_btn_class" />
                                                    <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" OnClick="btnShowAll_Click"
                                                        CssClass="css_btn_class" />
                                                </td>
                                            </tr>
                                            <%--  <tr>
                                                <td colspan="7">
                                                    <div visible="false" id="divrepeatorders" runat="server" class="divrepeatorders">
                                                        <span>There are other ARC for same ARC Code. </span>
                                                        <br />
                                                        <%=strArcCode%>
                                                    </div>
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td colspan="7">
                                                    <div id="ScrollList">
                                                        <asp:HiddenField ID="Csdrestricted_productcodes" runat="server" />
                                                        <asp:GridView ID="gvARC" runat="server" AutoGenerateColumns="false" CellPadding="4"
                                                            Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                            OnPageIndexChanging="gvARC_PageIndexChanging" EmptyDataText="No Data Found">
                                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                            <EmptyDataTemplate>
                                                                <asp:Label ID="lblNoRow" runat="server" Text="No Records Found!" ForeColor="Red"
                                                                    Font-Bold="true"></asp:Label>
                                                            </EmptyDataTemplate>
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex +1%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ARC_Code" HeaderText="ARC Code" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="UNiqueCode" HeaderText="Unique Code" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="CompanyName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="ARC_Email" HeaderText="Email" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:TemplateField Visible="true">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="ARCId" runat="server" Text='<%# Eval("ARCId") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="PrimaryContact" HeaderText="Primary Contact" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="BillingAccountNo" HeaderText="Billing Account No." HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="AllowReturns" HeaderText="Allow Returns" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="IsBulkUploadAllowed" HeaderText="Allow Bulk Upload" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="IsDeleted" HeaderText="Deleted?" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LinkButtonupdate_click">Edit</asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                            <PagerStyle BackColor="#284775" CssClass="gridPage" ForeColor="White" HorizontalAlign="Center" />
                                                            <PagerSettings Mode="NumericFirstLast" />
                                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                            <EditRowStyle BackColor="#999999" />
                                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                        </asp:GridView>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="pnlArcDetail" runat="server" Visible="false">
                            <table>
                                <tr>
                                    <td>
                                        <table width="95%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:Literal runat="server" ID="litAction" Text=""></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2"><asp:TextBox ID="txtARCID" runat="server" Visible="false"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Company Name *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtarcName" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtarcName"
                                                        ErrorMessage="*" ForeColor="#FF3300" SetFocusOnError="True" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Unique Code
                                                    </label>
                                                    <asp:Button Style="background: transparent!important; border: none!important;" runat="server" OnClick="btnUnique_Click" Text="Click If Available"></asp:Button>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblUniqCode" runat="server"></asp:Label>
                                                    <asp:TextBox ID="txtUniqCode" runat="server" Visible="false"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <asp:Button ID="btnSaveUniqueCode" runat="server" OnClick="btnSaveUniqueCode_Click" Text="Save" CssClass="css_btn_class" Visible="false" /></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        ARC Code *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtarcCode" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtarcCode"
                                                        ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Primary Contact</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textprimcontact" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Email *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textemail" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="Textemail"
                                                        ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                        ControlToValidate="Textemail" ValidationGroup="a" runat="server" ForeColor="#FF5050"
                                                        ErrorMessage="Invalid Email address"></asp:RegularExpressionValidator>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Telephone No.</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Texttelphn" runat="server" MaxLength="12" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Fax</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textfax" runat="server" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Address One</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textadd1" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Address Two</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textadd2" runat="server"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Post Code</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textpostcode" runat="server" MaxLength="10"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Town</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Texttown" runat="server"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        County</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textcounty" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Country</label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="Ddcountry" runat="server" Height="20px" Width="145px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Country Code</label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="DdcountryCode" runat="server" Height="20px" Width="145px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Billing Account No</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textbillaccno" runat="server"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        SalesLedger No
                                                    </label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Textsalesno" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Email address for Orders</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtARCEmailCC" runat="server"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        ARC Types</label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlArcTypes" runat="server" Height="20px" Width="145px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Description</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Height="45px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        Logistics Description</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtLogisticDescription" runat="server" TextMode="MultiLine" Height="45px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Replenishment Limit</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtReplenishmentLimit" runat="server" Text="0" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>
                                                        SF_ObjectID</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txt_SFObjectID" runat="server" Text="0"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <label>
                                                        Emizon Platform</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEmizonPlatform" runat="server" Text="UK01"></asp:TextBox>
                                                </td>
                                                <td class="style2">
                                                    <label>Emizon ARC No</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEmizonARCNo" runat="server" Text=""></asp:TextBox>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td class="style2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2" colspan="4">
                                                    <table width="100%">
                                                        <tr>
                                                            <td style="width: 20%">
                                                                <asp:CheckBox ID="Chkannualbilling" Text="Annual Billing" runat="server" />
                                                            </td>
                                                            <td style="width: 20%">
                                                                <asp:CheckBox ID="ChkAllowReturns" Text="Allow Returns" runat="server" />
                                                            </td>
                                                            <td style="width: 20%">
                                                                <asp:CheckBox ID="Chkpostingopt" Text="Posting Options" runat="server" />
                                                            </td>
                                                            <td style="width: 20%">
                                                                <asp:CheckBox ID="Chkisbulkallow" Text="Allow Bulk Upload" runat="server" />
                                                            </td>
                                                            <td style="width: 20%">
                                                                <asp:CheckBox ID="Chkisapi" Text="Allow API Access" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsDeleted" Text="Is Deleted" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkPolltoEIRE" Text="PolltoEIRE" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkExcludeTerms" Text="Exclude Terms" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsAllowedCSD" Text="Allow CSD" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkEnablePostCodeSearch" Text="Enable Postcode Search" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:CheckBox ID="chkIsARCAllowedForBranch" Text="Is ARC Allowed For Branch" runat="server" />
                                                            </td>
                                                            <td colspan="2">
                                                                <asp:CheckBox ID="chkVoiceSMS" Text="Is Voice SMS enabled" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkSafelinkOnIPSEC" Text="Safelink with IPSEC" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkisListedinRouterMonitor" Text="Listed for Router Monitoring" runat="server" />
                                                            </td>
                                                            isListedinRouterMonitor
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkInstallID_Flag" Text="InstallID Flag" runat="server" />
                                                            </td>
                                                            <td colspan="2">InstallID Strategy:
                                                                <asp:TextBox ID="txtInstallIDStrategy" runat="server" MaxLength="1" Text=""></asp:TextBox>
                                                            </td>
                                                            <td colspan="2">InstallID Lengths:
                                                                <asp:TextBox ID="txtInstallIDLength" runat="server" MaxLength="3" Text="1,6"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2" colspan="2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span style="font-style: italic">* Required Fields</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 300px;">
                                        <asp:UpdatePanel ID="upOption" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnloptionHeader" runat="server" Height="40px" SkinID="NoSkin" Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblOption" Text="OPTIONS" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlSearchOptions" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButtonList ID="rdbtnloptions" RepeatDirection="Horizontal" runat="server"
                                                                        CssClass="CheckBoxList3" Width="100%" AutoPostBack="true">
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender3" runat="server" TargetControlID="pnlSearchOptions"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnloptionHeader" ImageControlID="ImageButtonProductsOverallSummary"
                                                        CollapseControlID="pnloptionHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgressopt" runat="server" AssociatedUpdatePanelID="upOption">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 200px;">
                                        <asp:UpdatePanel ID="upCategory" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlCategorylHeader" runat="server" Height="40px" SkinID="NoSkin" Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblCategory" Text="CATEGORY" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="imgBtnCategoryOverallSummary" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlCategoryList" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:CheckBoxList ID="CheckBoxCtg" RepeatDirection="Vertical" runat="Server" CssClass="CheckBoxList2"
                                                                        Width="100%" OnSelectedIndexChanged="CheckBoxCtg_OnSelectedIndexChanged" AutoPostBack="true">
                                                                    </asp:CheckBoxList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="server" TargetControlID="pnlCategoryList"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlCategorylHeader"
                                                        ImageControlID="imgBtnCategoryOverallSummary" CollapseControlID="pnlCategorylHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="upCategory">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 300px;">
                                        <asp:UpdatePanel ID="upProduct" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlOverallHeader" runat="server" Height="40px" SkinID="NoSkin" Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblProducts" Text="PRODUCTS" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="ImageButtonProductsOverallSummary" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlSearchProduct" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="5">
                                                            <tr>
                                                                <td>
                                                                    <asp:GridView ID="gvctg" runat="server" AutoGenerateColumns="False" RowStyle-BackColor="#F6CECE"
                                                                        BorderColor="#336699" BorderStyle="Solid" BorderWidth="1px" CellPadding="0" CellSpacing="0"
                                                                        DataKeyNames="CategoryID" Font-Size="10" Font-Names="Arial" GridLines="Vertical"
                                                                        Width="100%" OnRowDataBound="gvctg_RowDataBound">
                                                                        <Columns>
                                                                            <asp:TemplateField>
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="chkctg" runat="server" AutoPostBack="true" Text='<%# Eval("CategoryDisp") %>'
                                                                                        OnCheckedChanged="chkctg_CheckedChanged" />
                                                                                    <asp:GridView ID="gvinner" RowStyle-BackColor="White" AutoGenerateColumns="False"
                                                                                        BorderColor="#336699" BorderStyle="Solid" BorderWidth="1px" CellPadding="0" CellSpacing="0"
                                                                                        DataKeyNames="ProductId" Font-Size="10" Width="100%" Font-Names="Arial" GridLines="none"
                                                                                        runat="server" ShowHeader="false">
                                                                                        <Columns>
                                                                                            <asp:TemplateField HeaderStyle-BackColor="white">
                                                                                                <ItemTemplate>
                                                                                                    <asp:CheckBox ID="chkprod" Width="4%" runat="server" OnCheckedChanged="chkprod_CheckedChanged"
                                                                                                        AutoPostBack="true" />
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateField>
                                                                                            <asp:BoundField HeaderStyle-BackColor="White" ItemStyle-Width="96%" DataField="ProductDisp" />
                                                                                        </Columns>
                                                                                    </asp:GridView>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                        <RowStyle BackColor="#F6CECE"></RowStyle>
                                                                    </asp:GridView>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" TargetControlID="pnlSearchProduct"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallHeader"
                                                        ImageControlID="ImageButtonProductsOverallSummary" CollapseControlID="pnlOverallHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upProduct">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="padding-left: 200px;">
                                        <asp:Button ID="btnCancel" ValidationGroup="" runat="server" Text="Cancel" OnClientClick=""
                                            OnClick="btnCancel_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClientClick="" CssClass="css_btn_class"
                                            Style="width: 118px;" OnClick="btnReset_Click" />
                                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                                            Style="width: 118px; margin-right: 20px" ValidationGroup="a" CssClass="css_btn_class" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No matching results found."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDeleted" Visible="false" Text="ARC Deleted."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDuplicate" Visible="false" Text="Duplicate ARC-Code or SalesledgerNo. Please Enter again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDetails" Visible="false" Text="Please fill required details correctly."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUniqueCode" Visible="false" Text="UniqueCode updated."></asp:Literal>


</asp:Content>
