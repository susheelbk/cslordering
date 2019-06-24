<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    CodeFile="Managecategory.aspx.cs" Inherits="ADMIN_Managecategory" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if (charCode < 48 || charCode > 57)
                    return false;
            return true;
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

        .chkListStyle td {
            padding-left: 35px;
        }

        .chkListStyle label {
            padding-left: 5px;
        }
    </style>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
                            A category can be searched by the category name or category code.<br />
                        </li>
                        <li>
                            A new category can be added with the specific products associated with it.<br />
                        </li>
                        <li>
                           The categories can add ARCs to it.<br />
                        </li>
                        <li>
                            A category can be edited and saved.<br />
                        </li>
                    </ul>
                </div>
                        </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Category</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="100%">
                                    <asp:Panel ID="pnlcategorylist" runat="server">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Name" Width="112px"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtctgnamesrch" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Code" Width="114px"
                                                        MaxLength="35"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtctgcodesrch" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" CssClass="css_btn_class" OnClick="btnSearch_Click" />
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" CssClass="css_btn_class" OnClick="btnShowAll_Click" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">Choose a category from below to edit    OR  
                                                <asp:Button ID="btnnewctg" runat="server" Text="Create new CATEGORY"
                                                    CssClass="css_btn_class" OnClick="btnnewctg_Click"></asp:Button>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">
                                                    <div id="ScrollList" style="max-height: 300px; overflow: auto">
                                                        <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" DataKeyNames="CategoryID"
                                                            CellPadding="4" Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True"
                                                            PageSize="15" OnPageIndexChanging="gvCategories_PageIndexChanging" EmptyDataText="No Data Found">
                                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="CategoryName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="CategoryCode" HeaderText="Code" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:TemplateField Visible="false">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="CatID" runat="server" Text='<%# Eval("CategoryId") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ListOrder" HeaderText="List Order" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="IsGPRSChipEmpty" HeaderText="Allow GPRS Chip Empty" HeaderStyle-HorizontalAlign="Left" />
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
                            <asp:Panel ID="pnlcategorydetail" runat="server" Visible="false">
                                <tr>
                                    <td width="100%">
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Literal runat="server" ID="litAction" Text=""></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%; text-align: center; padding-bottom: 8px;">
                                                    <label>
                                                        Category Name *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtctgName" runat="server" Width="295px" TextMode="MultiLine" Height="45px"
                                                        MaxLength="250"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtctgName"
                                                        ErrorMessage="*" ForeColor="#FF3300" SetFocusOnError="True" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                </td>
                                                <td style="text-align: center; padding-bottom: 10px;">&nbsp;<label>
                                                    Description</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtctgdesc" runat="server" Height="45px" MaxLength="500" TextMode="MultiLine" Width="295px"></asp:TextBox>
                                                    &nbsp;
                                                </td>

                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; padding-bottom: 12px;">
                                                    <label>
                                                        Category Code *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtctgCode" runat="server" MaxLength="250" Width="295px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtctgCode"
                                                        ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                </td>

                                                <td style="width: 20%; text-align: center; padding-bottom: 12px;">&nbsp;<label>
                                                    List Order *</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Txtlistorder" runat="server" MaxLength="4" onKeyPress="return isNumberKey(event);"
                                                        Width="295px" onpaste="return false"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Txtlistorder"
                                                        EnableTheming="True" ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; padding-bottom: 12px;">
                                                    <label>
                                                        Sales Type</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSalesType" runat="server" MaxLength="250" Width="295px"></asp:TextBox>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="CheckBoxgprschip" runat="server" Text="Allow GPRS Chip Empty" />
                                                    <asp:CheckBox ID="chkIsDeleted" runat="server" Text="isDeleted" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
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
                                        <asp:UpdatePanel ID="UpProducts" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlOverallHeader" runat="server" Height="40px" SkinID="NoSkin" Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblProduct" Text="Products" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="imgBtnProduct" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlSearchProduct" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="5">
                                                            <tr>
                                                                <td>
                                                                    <%--<asp:Panel ID="pnlProduct" runat="server" Height="300" ScrollBars="Auto" HorizontalAlign="Left"
                                                                    BackColor="White" BorderStyle="Solid" BorderWidth="3" BorderColor="#CFCFCF">--%>
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
                                                                                                    <asp:CheckBox ID="chkprod" Width="4%" runat="server" OnCheckedChanged="chkprod_CheckedChanged" AutoPostBack="true" />
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
                                                                    <%-- </asp:Panel>--%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" TargetControlID="pnlSearchProduct"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallHeader"
                                                        ImageControlID="imgBtnProduct" CollapseControlID="pnlOverallHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpProducts">
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
                                        <asp:UpdatePanel ID="upARC" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlOverallARCHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                        Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblARC" Text="ARC" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="imgBtnARCOverallSummary" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlSearchARC" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="5">
                                                            <tr>
                                                                <td>

                                                                    <asp:CheckBoxList ID="CheckBoxARC" RepeatColumns="3" runat="server" Width="100%"
                                                                        CssClass="CheckBoxList" OnSelectedIndexChanged="CheckBoxARC_OnSelectedIndexChanged"
                                                                        AutoPostBack="true">
                                                                    </asp:CheckBoxList>

                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="server" TargetControlID="pnlSearchARC"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallARCHeader"
                                                        ImageControlID="imgBtnARCOverallSummary" CollapseControlID="pnlOverallARCHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="upARC">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="upnlImages" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="Panel1" runat="server" Height="40px" SkinID="NoSkin"
                                                        Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="Label6" Text="Product Images" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlImages" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="3">
                                                            <tr>
                                                                <td>
                                                                    <table>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Image ID="Imagectg" runat="server" Width="120px" Height="150px" />
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <label>
                                                                                    Default Image</label>
                                                                            </td>
                                                                            <td>
                                                                                <asp:FileUpload ID="FileUpload1" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Image ID="LImagectg" runat="server" Width="120px" Height="150px" />
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <label>
                                                                                    Large Image</label>
                                                                            </td>
                                                                            <td>
                                                                                <asp:FileUpload ID="FileUpload2" runat="server" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender7" runat="server" TargetControlID="pnlImages"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="upnlImages"
                                                        ImageControlID="imgBtnProductOptions" CollapseControlID="upnlImages">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress5" runat="server" AssociatedUpdatePanelID="upnlImages">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="" OnClick="btnCancel_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClientClick="" CssClass="css_btn_class" Style="Width: 118px;" OnClick="btnReset_Click" />
                                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="css_btn_class"
                                            Width="118px" ValidationGroup="a" />
                                    </td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <table width="100%" cellpadding="0" cellspacing="0">
    </table>
    <asp:Literal runat="server" ID="ltrDuplCat" Visible="false" Text="Duplicate CategoryCode. Please Enter again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrRequired" Visible="false" Text="Please fill required details correctly."></asp:Literal>
    <asp:Literal runat="server" ID="ltrCatDeleted" Visible="false" Text="Category Deleted."></asp:Literal>
</asp:Content>
