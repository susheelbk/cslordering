<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    EnableEventValidation="false" CodeFile="ManageDelivery.aspx.cs" Inherits="ADMIN_ManageDelivery" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if ((charCode < 48 || charCode > 57) && charCode != 46)
                    return false;
            return true;
        }

        function ConfirmDelete() {
            return confirm('Are you sure you want to delete?');
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

        .modalBackground {
            background-color: #666699;
            filter: alpha(opacity=50);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: Red;
            width: 580px;
            padding: 2px;
            height: 400px;
            overflow: auto;
        }
    </style>
    <asp:Button ID="Btndummy" runat="server" Style="display: none;" />
    <cc1:ModalPopupExtender ID="PopupControlExtender2" runat="server" Enabled="true" TargetControlID="Btndummy"
        PopupControlID="Panel1" BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" align="center" Style="display: none; vertical-align: middle;">
        <asp:Button ID="btnSaveSibblings" runat="server" Text="OK" OnClick="btnSaveSibblings_Click" />
        <asp:Button ID="btncancel" runat="server" Text="Cancel" />
        <asp:CheckBoxList ID="Chklistproducts" runat="server" AutoPostBack="False" RepeatColumns="2"
            RepeatLayout="Table" TextAlign="Right">
        </asp:CheckBoxList>
    </asp:Panel>
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                   <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
	                        Delivery Type can be searched for a particular delivery company or by using delivery code.<br />
                        </li>
                        <li>
                            A new Delivery type can be added.<br />
                        </li>
                        <li>
                            A delivery type can be edited/deleted.<br />
                        </li>
                        <li>
                            Delivery Offer can be created for a particular product /product under an Installer/ARC with an expiry date. Offer is valid only if product quantity is between max quantity and min quantity/ price greater than the order value set.<br />
                        </li>
                        <li>
                            Delivery price can be added/deleted  for different currencies.<br />
                        </li>               
                    </ul>
                       </div>
                       </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Delivery</b></legend>
                        <br />
                        <fieldset>
                            <legend>Delivery Type</legend>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="100%">
                                        <asp:Panel ID="pnlDeliverylist" runat="server">
                                            <table width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Company Name" Width="112px"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtdlvnamesrch" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Delivery Code" Width="114px"
                                                            MaxLength="35"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtdlvcodesrch" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" CssClass="css_btn_class"
                                                            OnClick="btnSearch_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" CssClass="css_btn_class"
                                                            OnClick="btnShowAll_Click" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="7">Choose a Delivery Company from below to edit OR
                                                        <asp:Button ID="btnNewDeliveryType" runat="server" Text="Create new DELIVERY TYPE"
                                                            CssClass="css_btn_class" OnClick="btnNewDeliveryType_Click"></asp:Button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="7">
                                                        <div>
                                                            <asp:GridView ID="gvDelivery" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                                OnPageIndexChanging="gvDelivery_PageIndexChanging" EmptyDataText="No Data Found">
                                                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                        <ItemTemplate>
                                                                            <%# Container.DataItemIndex + 1 %>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Code">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeliveryCode" runat="server" Text='<%# Eval("DeliveryCode") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Company Name">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeliveryCompanyName" runat="server" Text='<%# Eval("DeliveryCompanyName") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Description">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeliveryDesc" runat="server" Text='<%# Eval("DeliveryShortDesc") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField Visible="false">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="DeliveryTypeId" runat="server" Text='<%# Eval("DeliveryTypeId") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Price">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDeliveryPrice" runat="server" Text='<%# Eval("DeliveryPrice") %>' />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LnkBtnupdateDeliverytype_click">Edit</asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="LinkButtondelete" runat="server" OnClientClick="return ConfirmDelete();"
                                                                                OnClick="LinkButtondelete_click">Delete</asp:LinkButton>
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
                                <asp:Panel ID="pnlDeliveryDetails" runat="server" Visible="false">
                                    <tr>
                                        <td width="100%">
                                            <table width="100%" cellpadding="0" cellspacing="0">
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
                                                    <td style="width: 20%">Company<label>
                                                        Name *</label>
                                                    </td>
                                                    <td class="style1">
                                                        <asp:TextBox ID="txtdlvName" runat="server" MaxLength="35" Width="150px"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtdlvName"
                                                            ErrorMessage="*" ForeColor="#FF3300" SetFocusOnError="True" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="style4">
                                                        <label>
                                                            Delivery Code *</label>
                                                    </td>
                                                    <td class="style1">
                                                        <asp:TextBox ID="txtdlvCode" runat="server" MaxLength="35" Width="150px"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtdlvCode"
                                                            ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>
                                                            Description</label>
                                                    </td>
                                                    <td class="style1">
                                                        <asp:TextBox ID="txtdlvdesc" runat="server" TextMode="MultiLine" MaxLength="35" Height="53px"
                                                            Width="295px"></asp:TextBox>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 20%">
                                                        <label>
                                                            Price *</label>
                                                    </td>
                                                    <td class="style1">
                                                        <asp:TextBox ID="Txtprice" runat="server" onKeyPress="return isValidPrice(event);"
                                                            onpaste="return false" Width="150px"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Txtprice"
                                                            EnableTheming="True" ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"
                                                            SetFocusOnError="true"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
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
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="padding-left: 100px;">
                                            <asp:Button ID="btnCancell" runat="server" Text="Cancel" OnClientClick="" OnClick="btnCancel_Click" />
                                            <asp:Button ID="btnReset" runat="server" Text="Reset" OnClientClick="" CssClass="css_btn_class"
                                                Style="width: 118px;" OnClick="btnReset_Click" />
                                            <asp:Button ID="btnSave" runat="server" Text=" Save Delivery" OnClick="btnSave_Click"
                                                CssClass="css_btn_class" Width="118px" ValidationGroup="a" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </fieldset>
                        <table>
                            <tr>
                                <td>&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>
                        </table>
                        <div id="divdlvoffer" runat="server">
                            <fieldset>
                                <legend>Delivery Offer</legend>
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnNewOffer" runat="server" Text="Create New Offer" CssClass="css_btn_class"
                                                Width="189px" OnClick="btnNewOffer_Click" />
                                        </td>
                                    </tr>
                                    <asp:Panel runat="server" ID="pnlOfferList">
                                        <tr>
                                            <td colspan="7">
                                                <div id="Div1" style="max-height: 300px; overflow: auto">
                                                    <asp:GridView ID="Gvoffer" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                        OnRowDataBound="Gvoffer_RowDataBound" Width="100%" ForeColor="#333333" GridLines="Horizontal"
                                                        DataKeyNames="DeliveryOfferId">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <Columns>
                                                            <%--<asp:BoundField DataField="OrderValue" HeaderText="Order Value " HeaderStyle-HorizontalAlign="Left" />--%>
                                                            <asp:TemplateField HeaderStyle-Width="5%" HeaderText="Order Value" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblorderval" runat="server" Text='<%# Eval("OrderValue") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField HeaderStyle-Width="20%" DataField="ARCDisp" HeaderText="ARC" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="ProductDisp" HeaderStyle-Width="35%" HeaderText="Product"
                                                                HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="InstallerCompany" HeaderStyle-Width="35%" HeaderText="InstallerCompany"
                                                                HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="DeliveryTypeId" runat="server" Text='<%# Eval("DeliveryTypeId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="DeliveryOfferId" runat="server" Text='<%# Eval("DeliveryOfferId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="ArcId" runat="server" Text='<%# Eval("ARCId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="ProductId" runat="server" Text='<%# Eval("ProductId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblMaxQty" runat="server" Text='<%# Eval("MaxQty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblMinQty" runat="server" Text='<%# Eval("MinQty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LnkBtnupdateOffer_click">Edit</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-Width="5%" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtondelete" runat="server" OnClientClick="return ConfirmDelete();"
                                                                        OnClick="LnkBtndeleteoffer_click">Delete</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Sibblings" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="25%">
                                                                <ItemTemplate>
                                                                    <asp:GridView ID="gvSibblings" Width="100%" HeaderStyle-BackColor="Red" DataKeyNames="Delivery_Prod_SibblingId"
                                                                        AutoGenerateColumns="false" runat="server">
                                                                        <Columns>
                                                                            <asp:BoundField ItemStyle-HorizontalAlign="Center" DataField="ProductCodeSib" HeaderText="SibblingProduct"
                                                                                HeaderStyle-HorizontalAlign="Left" />
                                                                            <asp:BoundField ItemStyle-HorizontalAlign="Center" DataField="ProductCodeDlvOfferProd"
                                                                                HeaderText="DeliveryOfferProduct" HeaderStyle-HorizontalAlign="Left" />
                                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Center">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="lbDeleteSibb" ForeColor="Blue" runat="server" OnClientClick="return ConfirmDelete();"
                                                                                        OnClick="lbDeleteSibb_click">Delete</asp:LinkButton>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </asp:GridView>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderStyle-Width="5%" HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtoncreatesibll" Visible='<%# Convert.ToBoolean(Eval("CanCreateSibblings")) %>'
                                                                        CommandArgument='<%# Eval("DeliveryOfferId")%>' OnClick="OfferSiblingPopup" runat="server">Create Sibling</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <EditRowStyle BackColor="#999999" />
                                                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                    </asp:GridView>
                                                </div>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                                <asp:Panel ID="pnlOfferDetails" runat="server" Visible="false">
                                    <table width="100%">
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4">
                                                <label>
                                                    ARC
                                                </label>
                                            </td>
                                            <td class="style1">
                                                <asp:DropDownList Width="320px" ID="ddarc" runat="server" OnSelectedIndexChanged="ddarc_SelectedIndexChanged"
                                                    AutoPostBack="true">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4"></td>
                                            <td class="style1">
                                                <asp:TextBox ID="txtSearchInstaller" MaxLength="256" runat="server">
                                                </asp:TextBox>
                                                <asp:Button ID="buttonSearch" Text="Search Installer" CssClass="css_btn_class" runat="server"
                                                    OnClick="SelectHeadOffice_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4">
                                                <label>
                                                    Installers
                                                </label>
                                            </td>
                                            <td class="style1">
                                                <asp:DropDownList Width="320px" ID="ddlInstallers" runat="server">
                                                </asp:DropDownList>
                                                &nbsp;<asp:Button ID="buttonClear" Text="Clear Search" CssClass="css_btn_class" runat="server"
                                                    OnClick="Clear_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4">
                                                <label>
                                                    Product</label>
                                            </td>
                                            <td class="style1">
                                                <asp:DropDownList Width="320px" ID="ddpro" runat="server">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Max Qty</label>
                                            </td>
                                            <td class="style1">
                                                <asp:TextBox ID="Textmax" runat="server" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    Min Qty</label>
                                            </td>
                                            <td class="style1">
                                                <asp:TextBox ID="TextMin" runat="server" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    Order Value</label>
                                            </td>
                                            <td class="style1">
                                                <asp:TextBox ID="Textordervalue" runat="server" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    Expiry Date*</label>
                                            </td>
                                            <td class="style1">
                                                <asp:TextBox ID="txtExpiryDate" runat="server"></asp:TextBox>
                                                <cc1:CalendarExtender ID="calExpiryDate" runat="server" PopupButtonID="txtExpiryDate"
                                                    TargetControlID="txtExpiryDate" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                    ForeColor="Red" ControlToValidate="txtExpiryDate" SetFocusOnError="true" ValidationGroup="b"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" colspan="2">
                                                <asp:Button ID="btnCancelOffer" runat="server" Text="Cancel" OnClick="btnCancelOffer_Click" />
                                                <asp:Button ID="btnResetOffer" runat="server" Text="Reset" CssClass="css_btn_class"
                                                    Style="width: 118px;" OnClick="btnResetOffer_Click" />
                                                <asp:Button ID="SaveOfferbtn" runat="server" Text=" Save Offer" OnClick="SaveOfferbtn_Click"
                                                    Style="width: 118px; margin-right: 20px" ValidationGroup="b" CssClass="css_btn_class" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </fieldset>
                        </div>
                        <table>
                            <tr>
                                <td>&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>
                        </table>
                        <div id="divDlvPrice" runat="server">
                            <fieldset>
                                <legend>Delivery Price</legend>

                                <asp:GridView runat="server" ID="gvDlvPrices" DataSourceID="sdsDlvPrices" AutoGenerateColumns="true" CellPadding="4" DataKeyNames="ID"
                                    Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15">
                                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#284775" CssClass="gridPage" ForeColor="White" HorizontalAlign="Center" />
                                    <PagerSettings Mode="NumericFirstLast" />
                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                    <EditRowStyle BackColor="#999999" />
                                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                    <Columns>
                                        <asp:CommandField ShowDeleteButton="true" />
                                    </Columns>
                                </asp:GridView>
                                <asp:SqlDataSource runat="server" ID="sdsDlvPrices" ConnectionString='<%$ connectionStrings:CSLOrderingARCBAL.Properties.Settings.ARC_OrderingConnectionString %>'
                                    SelectCommand="select ID, CurrencyCode, DeliveryPrice from vw_DeliveryPrices where DeliveryTypeId = @DeliveryTypeId"
                                    DeleteCommand="delete from DeliveryPrices where ID = @ID" >
                                    <SelectParameters>
                                        <asp:SessionParameter Name="DeliveryTypeId" Type="String" SessionField="DeliveryTypeId" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <table width="100%">
                                    <tr>
                                        <td class="style2">
                                            <label>
                                                Currency *</label>
                                        </td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="ddlCurrency"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 20%">
                                            <label>Price *</label>
                                        </td>
                                        <td class="style1">
                                            <asp:TextBox ID="txtDlvPrice" runat="server" onKeyPress="return isValidPrice(event);"
                                                onpaste="return false" Width="150px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="Txtprice"
                                                EnableTheming="True" ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="a"
                                                SetFocusOnError="true"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="padding-left: 100px;">
                                            <asp:Button ID="btnSaveDlvPrice" runat="server" Text="Save Price" OnClick="btnSaveDlvPrice_Click"
                                                CssClass="css_btn_class" Width="118px" ValidationGroup="a" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No Matching Results Found."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDelUpdated" Visible="false" Text="Delivery Successfully Updated."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDelCreated" Visible="false" Text="Delivery Successfully Created."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFill" Visible="false" Text="Please fill the marked places."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDelDeleted" Visible="false" Text="Delivery and its offers are Deleted."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOfferDeleted" Visible="false" Text="Offer is Deleted."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSibbDeleted" Visible="false" Text="Sibbling is Deleted."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOfferUpdated" Visible="false" Text="Offer Successfully Updated."></asp:Literal>
    <asp:Literal runat="server" ID="ltrMaxGreater" Visible="false" Text="Max Values must be greater than the min values."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEnterMaxMin" Visible="false" Text="Please enter Max and Min values."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOfferCreated" Visible="false" Text="Offer Successfully Created."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOrderVal" Visible="false" Text="Please enter the order value."></asp:Literal>
    <asp:Literal runat="server" ID="ltrRecordExists" Visible="false" Text="A record already exist with the same currency. To change the price, please delete and recreate."></asp:Literal>
</asp:Content>
