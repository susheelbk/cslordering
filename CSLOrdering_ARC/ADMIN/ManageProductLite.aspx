<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    CodeFile="ManageProductLite.aspx.cs" Inherits="ADMIN_ManageProductLite" ValidateRequest="false" %>

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

        function isValidPrice(evt) {

            var key = (evt.which) ? evt.which : event.keyCode

            var parts = evt.srcElement.value.split('.');
            if (parts.length > 1 && key == 46)
                return false;

            if (!((key > 47 && key <= 57) || (key == 46) || (key == 8) || (key == 13) || (key == 9) || (key == 0) || (key == 127))) {
                return false;
            }
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
    <%--checkboxlist in drowdown  --%>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />
    <div>
        <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: separate !important;">
            <tr>
                <td>
                    <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
                            ARCs and Installers associated with the products can be edited.<br />
                        </li>                        
                    </ul>
                    </div>
                        </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Products</b></legend>
                        <br />
                        <asp:HiddenField runat="server" ID="hdnProductCode" />
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="100%">
                                    <asp:Panel ID="pnlproductlist" runat="server">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Product Name"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtpronamesrch" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Product Code"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtprocodesrch" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" ID="chkM2MSearch" Text="(M2M)" />
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" CssClass="css_btn_class"
                                                        OnClick="btnSearch_Click" />
                                                </td>
                                                <td>
                                                    <asp:Button ID="brnShowAll" runat="server" Text="Show All" Width="80px" CssClass="css_btn_class"
                                                        OnClick="btnShowAll_Click" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Button ID="btnCSLConnect" runat="server" Text="Listed on CSL Connect" Width="165px" CssClass="css_btn_class"
                                                        OnClick="btnCSLConnect_Click" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">
                                                    <div>
                                                        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductId"
                                                            CellPadding="4" Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True"
                                                            PageSize="15" OnPageIndexChanging="gvProducts_PageIndexChanging" EmptyDataText="No Data Found">
                                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ProductCode" HeaderText="Code" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:BoundField DataField="ProductName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:TemplateField HeaderText="Price">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblPrice" runat="server" Text='<%# "£" +Eval("Price") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField Visible="false">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="ProductId" runat="server" Text='<%# Eval("ProductId") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ListOrder" HeaderText="List Order" HeaderStyle-HorizontalAlign="Left" />
                                                                <asp:TemplateField HeaderText="Is Dependent">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lbisdep" runat="server" Text='<%# Eval("IsDependentProduct") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Product Type">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lbisprod" runat="server" Text='<%# Eval("ProductType") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
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
                            <asp:Panel ID="pnlproductdetails" runat="server" Visible="false">
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                            <ContentTemplate>
                                                <div id="divnotdependent" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="lblSelectedProduct" style="font-size:10pt"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlOverallArcHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="lblARC" Text="ARCs" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnARC" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show
                                                            Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlARC" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px;" align="center" cellspacing="3">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:ListBox ID="lstboxARC" runat="server" Height="350px" Width="300px" SelectionMode="Multiple"></asp:ListBox>
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100px">
                                                                                        <tr style="height: 175px;">
                                                                                            <td>
                                                                                                <asp:Button ID="btnAdd" runat="server" Text="Add >>" CssClass="css_btn_class" OnClick="btnAdd_Click" />
                                                                                                <asp:Button ID="btnRemove" runat="server" Text="<< Remove" CssClass="css_btn_class"
                                                                                                    OnClick="btnRemove_Click" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr style="height: 175px;">
                                                                                            <td></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td>
                                                                                    <span><b>Selected ARCs</b></span>
                                                                                    <br />
                                                                                    <asp:ListBox ID="lstSelectedARC" runat="server" Height="150px" Width="300px" SelectionMode="Multiple"></asp:ListBox>
                                                                                    <table width="100">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Button ID="btnAddCSD" runat="server" Text="Add vv" CssClass="css_btn_class" OnClick="btnAddCSD_Click" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Button ID="btnRemoveCSD" runat="server" Text="^^ Remove" CssClass="css_btn_class"
                                                                                                    OnClick="btnRemoveCSD_Click" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <span><b>CSD only ARCs</b></span>
                                                                                    <br />
                                                                                    <asp:ListBox ID="lstCSDRestrictedARC" runat="server" Height="150px" Width="300px" SelectionMode="Multiple"></asp:ListBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender3" runat="server" TargetControlID="pnlARC"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallArcHeader"
                                                                        ImageControlID="imgBtnARC" CollapseControlID="pnlOverallArcHeader">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlOverallInstallerHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="lblInstaller" Text="Installers (Only for M2M Connect)" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnInstaller" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show
                                                            Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlInstaller" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px;" align="center" cellspacing="3">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:ListBox ID="lstboxInstaller" runat="server" Height="350px" Width="300px" SelectionMode="Multiple"></asp:ListBox>
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100px">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Button ID="btnAddInst" runat="server" Text="Add >>" CssClass="css_btn_class" OnClick="btnAddInst_Click" />
                                                                                                <asp:Button ID="btnRemoveInst" runat="server" Text="<< Remove" CssClass="css_btn_class"
                                                                                                    OnClick="btnRemoveInst_Click" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td>
                                                                                    <span><b>Selected Installers</b></span>
                                                                                    <br />
                                                                                    <asp:ListBox ID="lstSelectedInstaller" runat="server" Height="350px" Width="300px" SelectionMode="Multiple"></asp:ListBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender10" runat="server" TargetControlID="pnlInstaller"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallInstallerHeader"
                                                                        ImageControlID="imgBtnInstaller" CollapseControlID="pnlOverallInstallerHeader">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel6">
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
                                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                                            CssClass="css_btn_class" Style="width: 118px; margin-right: 20px" />
                                    </td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No Matching Results Found."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDupProd" Visible="false" Text="Duplicate Product code. Please enter again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillProdCode" Visible="false" Text="Please fill required details correctly : Product Code "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillProdName" Visible="false" Text="Please fill required details correctly : Product Name "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillLstOrdr" Visible="false" Text="Please fill required details correctly : List Order "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillPrice" Visible="false" Text="Please fill required details correctly : Price "></asp:Literal>
    <asp:Literal runat="server" ID="ltrProdDel" Visible="false" Text="Product Deleted."></asp:Literal>
</asp:Content>
