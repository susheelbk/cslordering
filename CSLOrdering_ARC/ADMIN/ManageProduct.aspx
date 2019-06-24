<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    CodeFile="ManageProduct.aspx.cs" Inherits="ADMIN_ManageProduct" ValidateRequest="false" %>

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

        .chkCurrency input {
            margin-left: 10px;
        }

        .chkCurrency td {
            padding-right: 60px;
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
                            <ul style="line-height: 20px">
                                <li>Specific Product can be searched by
                                    <br />
                                    1.	Product  Name<br />
                                    2.	Product Code
                                    <br />
                                </li>
                                <li>All products specific to M2M can be searched by clicking Listed on CSL Connect.<br />
                                </li>
                                <li>A new product can be created and a category assigned.<br />
                                </li>
                                <li>A product can have ARCs added to it, enabling the ARC can buy that product. It can be enabled to only order CSD.<br />
                                </li>
                                <li>An M2M product can have an installer added to it, enabling the Installer to buy that product, provided the installer has a price band mapped to product.<br />
                                </li>
                                <li>The product details can be edited and saved.<br />
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
                                                <td colspan="5">Choose a product from below to edit OR
                                                    <asp:Button ID="btnnewproduct" runat="server" Text="Create new PRODUCT" CssClass="css_btn_class"
                                                        OnClick="btnnewproduct_Click"></asp:Button>
                                                </td>
                                                <td colspan="2">
                                                    <asp:Button ID="btnCSLConnect" runat="server" Text="Listed on CSL Connect" Width="165px" CssClass="css_btn_class"
                                                        OnClick="btnCSLConnect_Click" />
                                                </td>
                                            </tr>
                                            <%--     <tr>
                                                <td colspan="7">
                                                    <div visible="false" id="divrepeatorders" runat="server" class="divrepeatorders">
                                                        There are other Product for same Product Code.
                                                        <br />
                                                        <%=strProductCode%>
                                                    </div>
                                                </td>
                                            </tr>--%>
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
                                        <table width="95%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Literal ID="litAction" runat="server"></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        Product Name *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtproName" runat="server" Width="255px" TextMode="MultiLine" Height="45px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <label>
                                                        Description</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtprodesc" runat="server" Height="90px" TextMode="MultiLine" Width="255px"></asp:TextBox>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>CSL description
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCSLDescription" runat="server" Height="90px" TextMode="MultiLine"
                                                        Width="255px"></asp:TextBox>
                                                </td>
                                                 <td>
                                                    <label>Logistics Description</label>
                                                     <h6><i>use this field to show message on logistics screen</i></h6>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtlogisticsDesc" runat="server" Height="90px" 
                                                        TextMode="MultiLine" MaxLength="512" Width="255px"></asp:TextBox>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <label>
                                                        Product Code *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtproCode" runat="server" Width="255px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>CSL Grade *
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtprograde" runat="server" Width="255px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>

                                                <td style="width: 20%">
                                                    <label>
                                                        List Order *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="Txtlistorder" runat="server" MaxLength="4" onKeyPress="return isNumberKey(event);"
                                                        Width="255px"></asp:TextBox>
                                                </td>
                                                <td style="width: 20%">
                                                    <label>
                                                        Allowance (MB) *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtAllowance" runat="server" Width="255px" onKeyPress="return isValidPrice(event);"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>



                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        Price *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="Txtprice" runat="server" Width="255px" onKeyPress="return isValidPrice(event);"></asp:TextBox>
                                                </td>
                                                <td style="width: 20%">
                                                    <label>
                                                        Annual Price *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="TxtAnnualprice" runat="server" Width="255px" onKeyPress="return isValidPrice(event);"></asp:TextBox>
                                                </td>

                                            </tr>
                                             <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        UK Gemini Server *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtUKServer" runat="server" Width="255px" ></asp:TextBox>
                                                </td>
                                                <td style="width: 20%">
                                                    <label>
                                                        IRE Gemini Server</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtIREServer" runat="server" Width="255px" ></asp:TextBox>
                                                </td>

                                            </tr>


                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="5">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsCSD" Text="CSD" runat="server" AutoPostBack="true" OnCheckedChanged="chkIsCSD_CheckedChanged" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkSiteName" Text="SiteName" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkReplenishment" Text="Replenishment" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkisDeleted" Text="IsDeleted" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkListedonCSLConnect" Text="ListedonCSLConnect" runat="server" AutoPostBack="true" OnCheckedChanged="chkListedonCSLConnect_CheckedChanged" />
                                                            </td>
                                                            </tr><tr>
                                                            <td>
                                                                <asp:CheckBox ID="chkCSLConnectVoice" Text="CSLConnectVoice" runat="server" />
                                                            </td>
                                                        
                                                            <td>
                                                                <asp:CheckBox ID="chkCSLConnectSMS" Text="CSLConnectSMS" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsHardwareType" Text="IsHardwareType" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsVoiceSMSVisible" Text="IsVoiceSMSVisible" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsOEMProduct" Text="IsOEMProduct" runat="server" />
                                                            </td>
                                                            </tr><tr>
                                                            <td>

                                                                <asp:CheckBox ID="chkIsDCC" Text="IsDualComConnectedProduct" runat="server" />

                                                            </td>
                                                            <td>

                                                                <asp:CheckBox ID="chkIsRouter" Text="Router" runat="server" />

                                                            </td>
                                                            <td>

                                                                <asp:CheckBox ID="chkisArcMonitoredRouter" Text="Monitored by ARC" runat="server" />

                                                            </td>
                                                            <td>

                                                                <asp:CheckBox ID="chkUseCountryCodeonPrefix" Text="Use Country Code on prefix" runat="server" />

                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                                    <ContentTemplate>
                                                                        <asp:CheckBox ID="CheckBoxIsDep" Text="Is Dependent" runat="server" AutoPostBack="true"
                                                                            OnCheckedChanged="CheckBoxIsDep_CheckedChanged" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td colspan="5">
                                                                <asp:Label ID="Label2" Text="Checking this flag will delete all the mappings of this product"
                                                                    runat="server" ForeColor="Red" Width="100%"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                               AutoGenerateICCIDPrefix: 
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtAutoGenerateICCIDPrefix" runat="server" Width="50px"/>
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkAutoGenerateICCID" runat="server" Text="AutoGenerateICCID" />
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkAutoGenerateICCIDonOrderProcess" runat="server" Text="AutoGenerateICCIDonOrderProcess" />
                                                            </td>
                                                            
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left">
                                                                <label align="right">
                                                                    <b>Product Type </b>
                                                                </label>
                                                            </td>
                                                            <td colspan="4">
                                                                <asp:RadioButton ID="RadioBtnProd" runat="server" Text="Product" GroupName="a" />
                                                                <asp:RadioButton ID="RadioBtnAnc" runat="server" Text="Ancillary" GroupName="a" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                             <td colspan="2" align="right">
                                                                <label>
                                                                    <b>Emizon Billing Description</b>
                                                                </label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtEmProductCode" runat="server" ></asp:TextBox>
                                                            </td>
                                                            <td colspan="2" align="right">
                                                                <label>
                                                                    <b>Emizon Inst Type (this is used as EmizonProducctID for API)</b>
                                                                </label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtInstType_TypeID" runat="server" ></asp:TextBox>
                                                             </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                             <td colspan="2" align="right">
                                                                <label>
                                                                    <b>Flag if Emizon Product</b>
                                                                </label>
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkIsEmizonProduct" runat="server" Checked="false" />
                                                            </td>
                                                            <td colspan="2" align="right">
                                                                <label>
                                                                    <b>Is Emizon connection Only Product</b>
                                                                </label>
                                                            </td>
                                                            <td>
                                                                <asp:CheckBox ID="chkConnectionOnlyEM" runat="server" Checked="false" />
                                                             </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr id="trMessage" runat="server" visible="false">
                                                <td style="width: 20%">
                                                    <label>
                                                        Message</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtMsg" runat="server" Visible="false" TextMode="MultiLine" Width="295px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
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
                                    <td>
                                        <asp:UpdatePanel ID="upPriceband" runat="server" Visible="false">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlPriceBand" runat="server" Height="40px" SkinID="NoSkin"
                                                        Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblPriceBand" Text="Create PriceBands(Only for M2M Connect)" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="imgbtnCurrency" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlInsertPriceBand" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="3">
                                                            <tr id="trDisplayCurrency" runat="server">
                                                                <td>
                                                                    <label>Select Currency </label>
                                                                </td>
                                                                <td>

                                                                    <asp:CheckBoxList ID="cblCurrency" runat="server" CssClass="chkCurrency"
                                                                        RepeatDirection="horizontal" OnSelectedIndexChanged="cblCurrency_SelectedIndexChanged" AutoPostBack="true">
                                                                    </asp:CheckBoxList>

                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td>
                                                                    <asp:PlaceHolder ID="phPrice" runat="server"></asp:PlaceHolder>
                                                                    <asp:Table ID="CurrTable" runat="server" Width="100%">
                                                                        <asp:TableRow ID="trprice" runat="server" Width="30%">
                                                                        </asp:TableRow>
                                                                        <asp:TableRow ID="trAnnualprice" runat="server" Width="30%">
                                                                        </asp:TableRow>
                                                                    </asp:Table>

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5">
                                                                    <asp:Label ID="lblCreateProductNote" Text=" *Same Price will be inserted across all the Pricebands for this product.Please use Create Price Band tab for updating the prices in future"
                                                                        runat="server" ForeColor="Red" Width="100%" Visible="false" Font-Size="Small"></asp:Label>
                                                                    <asp:Label ID="lblEditNote" Text="Pricebands already exists for Disabled Currencies. Please use Create Price Band tab for updating the prices"
                                                                        runat="server" ForeColor="Red" Width="100%" Visible="false" Font-Size="Small"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender11" runat="server" TargetControlID="pnlInsertPriceBand"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlPriceBand"
                                                        ImageControlID="imgbtnCurrency" CollapseControlID="pnlPriceBand">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress6" runat="server" AssociatedUpdatePanelID="upPriceband">
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
                                        <asp:UpdatePanel ID="UpProductOptions" runat="server">
                                            <ContentTemplate>
                                                <div style="padding-left: 10px;">
                                                    <asp:Panel ID="pnlOverallProductOptionsHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                        Width="800px">
                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                            <asp:Label ID="lblProduct" Text="Product Options" runat="server" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                            <asp:ImageButton ID="imgBtnProductOptions" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                AlternateText="(Show Details...)" />
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlSearchProductOptions" runat="server">
                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                            cellspacing="3">
                                                            <tr>
                                                                <td>
                                                                    <asp:CheckBoxList ID="CheckBoxListOptions" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxOpt_OnSelectedIndexChanged"
                                                                        runat="Server" CssClass="CheckBoxList5" Width="100%">
                                                                    </asp:CheckBoxList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" TargetControlID="pnlSearchProductOptions"
                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallProductOptionsHeader"
                                                        ImageControlID="imgBtnProductOptions" CollapseControlID="pnlOverallProductOptionsHeader">
                                                    </cc1:CollapsiblePanelExtender>
                                                </div>
                                                <br />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress3" runat="server" AssociatedUpdatePanelID="UpProductOptions">
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
                                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                            <ContentTemplate>
                                                <div id="divdependent" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 300px;">
                                                                <asp:UpdatePanel ID="UpParentProduct" runat="server">
                                                                    <ContentTemplate>
                                                                        <div style="padding-left: 10px;">
                                                                            <asp:Panel ID="pnlOverallHeaderParentProduct" runat="server" Height="40px" SkinID="NoSkin"
                                                                                Width="800px">
                                                                                <div style="float: left; width: 750px" class="Trackerbutton">
                                                                                    <asp:Label ID="Label4" Text="<u>Parent-Products</u>" runat="server" Font-Bold="true"></asp:Label>
                                                                                </div>
                                                                                <div style="float: right; width: 30px; vertical-align: middle;">
                                                                                    <asp:ImageButton ID="imgBtnParentProduct" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                                        AlternateText="(Show Details...)" />
                                                                                </div>
                                                                            </asp:Panel>
                                                                            <asp:Panel ID="Panel6" runat="server">
                                                                                <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                                    cellspacing="5">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <%-- <asp:Panel ID="pnlSearchParentProducts" runat="server" Height="300" ScrollBars="Auto"
                                                                                            HorizontalAlign="Left" BackColor="White" BorderStyle="Solid" BorderWidth="3"
                                                                                            BorderColor="#CFCFCF">--%>
                                                                                            <%--<asp:CheckBoxList ID="Chkboxparentprod" runat="Server" CssClass="CheckBoxList4" Width="100%"
                                                                                                OnSelectedIndexChanged="Chkboxparentprod_OnSelectedIndexChanged" AutoPostBack="true"
                                                                                                RepeatColumns="3">
                                                                                            </asp:CheckBoxList>--%>
                                                                                            <asp:GridView ID="gvctgParent" runat="server" AutoGenerateColumns="False" RowStyle-BackColor="#F6CECE"
                                                                                                BorderColor="#336699" BorderStyle="Solid" BorderWidth="1px" CellPadding="0" CellSpacing="0"
                                                                                                DataKeyNames="CategoryID" Font-Size="10" Font-Names="Arial" GridLines="Vertical"
                                                                                                Width="100%" OnRowDataBound="gvctgParent_RowDataBound">
                                                                                                <Columns>
                                                                                                    <asp:TemplateField>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:CheckBox ID="chkctg" runat="server" AutoPostBack="true" Text='<%# Eval("CategoryDisp") %>'
                                                                                                                OnCheckedChanged="chkctgParent_CheckedChanged" />
                                                                                                            <asp:GridView ID="gvinnerParent" RowStyle-BackColor="White" AutoGenerateColumns="False"
                                                                                                                BorderColor="#336699" BorderStyle="Solid" BorderWidth="1px" CellPadding="0" CellSpacing="0"
                                                                                                                DataKeyNames="ProductId" Font-Size="10" Width="100%" Font-Names="Arial" GridLines="none"
                                                                                                                runat="server" ShowHeader="false">
                                                                                                                <Columns>
                                                                                                                    <asp:TemplateField HeaderStyle-BackColor="white">
                                                                                                                        <ItemTemplate>
                                                                                                                            <asp:CheckBox ID="chkprod" Width="4%" runat="server" OnCheckedChanged="chkprodParent_CheckedChanged"
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
                                                                                            <%-- </asp:Panel>--%>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </asp:Panel>
                                                                            <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender6" runat="server" TargetControlID="Panel6"
                                                                                ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                                SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallHeaderParentProduct"
                                                                                ImageControlID="imgBtnParentProduct" CollapseControlID="pnlOverallHeaderParentProduct">
                                                                            </cc1:CollapsiblePanelExtender>
                                                                        </div>
                                                                        <br />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                                <asp:UpdateProgress ID="UpdateProgress4" runat="server" AssociatedUpdatePanelID="UpParentProduct">
                                                                    <ProgressTemplate>
                                                                        <div style="text-align: center;">
                                                                            <span style="text-align: center"><b>Please wait...</b></span>
                                                                        </div>
                                                                    </ProgressTemplate>
                                                                </asp:UpdateProgress>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel2">
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
                                        <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                            <ContentTemplate>
                                                <div id="divnotdependent" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlOverallCategoriesHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="lblCategories" Text="Categories" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnCategories" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlCategories" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                            cellspacing="5">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:CheckBoxList ID="CheckBoxctg" AutoPostBack="true" OnSelectedIndexChanged="CheckBoxctg_OnSelectedIndexChanged"
                                                                                        runat="Server" CssClass="CheckBoxList2" Width="100%">
                                                                                    </asp:CheckBoxList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="server" TargetControlID="pnlCategories"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallCategoriesHeader"
                                                                        ImageControlID="imgBtnCategories" CollapseControlID="pnlOverallCategoriesHeader">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                                <br />
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
                                                        <tr>
                                                            <td style="width: 300px;">
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlOverallRelatedProductHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px" Style="display: NONE">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="Label3" Text="Related-Products" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnRelatedProduct" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlRelatedProduct" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                            cellspacing="5">
                                                                            <tr>
                                                                                <td>
                                                                                    <%--<asp:Panel ID="Panel3" runat="server" Height="300" ScrollBars="Auto" HorizontalAlign="Left"
                                                                                    BackColor="White" BorderStyle="Solid" BorderWidth="3" BorderColor="#CFCFCF">
                                                                                    <asp:CheckBoxList ID="ChkBoxRelprod" runat="Server" CssClass="CheckBoxList3" Width="100%"
                                                                                        OnSelectedIndexChanged="ChkBoxRelprod_OnSelectedIndexChanged" AutoPostBack="true"
                                                                                        RepeatColumns="3">
                                                                                    </asp:CheckBoxList>
                                                                                </asp:Panel>--%>
                                                                                    <asp:GridView ID="gvctgRelated" runat="server" AutoGenerateColumns="False" RowStyle-BackColor="#F6CECE"
                                                                                        BorderColor="#336699" BorderStyle="Solid" BorderWidth="1px" CellPadding="0" CellSpacing="0"
                                                                                        DataKeyNames="CategoryID" Font-Size="10" Font-Names="Arial" GridLines="Vertical"
                                                                                        Width="100%" OnRowDataBound="gvctgRelated_RowDataBound">
                                                                                        <Columns>
                                                                                            <asp:TemplateField>
                                                                                                <ItemTemplate>
                                                                                                    <asp:CheckBox ID="chkctg" runat="server" AutoPostBack="true" Text='<%# Eval("CategoryDisp") %>'
                                                                                                        OnCheckedChanged="chkctg_CheckedChanged" />
                                                                                                    <asp:GridView ID="gvinnerRelated" RowStyle-BackColor="White" AutoGenerateColumns="False"
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
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender4" runat="server" TargetControlID="pnlRelatedProduct"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallRelatedProductHeader"
                                                                        ImageControlID="imgBtnRelatedProduct" CollapseControlID="pnlOverallRelatedProductHeader">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                                <br />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 300px;">
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlOverallDependentProductHeader" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="Label5" Text="Dependent-Products" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnDependentProduct" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlSearchDependentProduct" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                            cellspacing="5">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:CheckBoxList ID="ChkboxDepprod" runat="Server" CssClass="CheckBoxList4" RepeatColumns="2"
                                                                                        Width="100%" OnSelectedIndexChanged="ChkboxDepprod_OnSelectedIndexChanged" AutoPostBack="true">
                                                                                    </asp:CheckBoxList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender5" runat="server" TargetControlID="pnlSearchDependentProduct"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlOverallDependentProductHeader"
                                                                        ImageControlID="imgBtnDependentProduct" CollapseControlID="pnlOverallDependentProductHeader">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr runat="server" id="trDefaultSMS" visible="false">
                                                            <td style="width: 300px;">
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlDefaultSMS" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="Label7" Text="Default SMS" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnDefaultSMS" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlSearchDefaultSMS" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                            cellspacing="5">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButtonList ID="rdbSMS" runat="Server" CssClass="CheckBoxList4" RepeatColumns="2"
                                                                                        Width="100%" AutoPostBack="true">
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender8" runat="server" TargetControlID="pnlSearchDefaultSMS"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlDefaultSMS"
                                                                        ImageControlID="imgBtnDefaultSMS" CollapseControlID="pnlDefaultSMS">
                                                                    </cc1:CollapsiblePanelExtender>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr runat="server" id="trDefaultVoice" visible="false">
                                                            <td style="width: 300px;">
                                                                <div style="padding-left: 10px;">
                                                                    <asp:Panel ID="pnlDefaultVoice" runat="server" Height="40px" SkinID="NoSkin"
                                                                        Width="800px">
                                                                        <div style="float: left; width: 750px" class="Trackerbutton">
                                                                            <asp:Label ID="Label8" Text="Default Voice" runat="server" Font-Bold="true"></asp:Label>
                                                                        </div>
                                                                        <div style="float: right; width: 30px; vertical-align: middle;">
                                                                            <asp:ImageButton ID="imgBtnDefaultVoice" runat="server" ImageUrl="../Images/coljlapse.jpg"
                                                                                AlternateText="(Show Details...)" />
                                                                        </div>
                                                                    </asp:Panel>
                                                                    <asp:Panel ID="pnlSearchDefaultVoice" runat="server">
                                                                        <table style="background-color: #fff; border: solid 0px; margin-left: 5px; width: 800px;"
                                                                            cellspacing="5">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButtonList ID="rdbVoice" runat="Server" CssClass="CheckBoxList4" RepeatColumns="2"
                                                                                        Width="100%" AutoPostBack="true">
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </asp:Panel>
                                                                    <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender9" runat="server" TargetControlID="pnlSearchDefaultVoice"
                                                                        ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                        SuppressPostBack="false" Collapsed="true" ExpandControlID="pnlDefaultVoice"
                                                                        ImageControlID="imgBtnDefaultVoice" CollapseControlID="pnlDefaultVoice">
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
                                    <td align="right">
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="" OnClick="btnCancel_Click" />
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClientClick="" CssClass="css_btn_class"
                                            Style="width: 118px;" OnClick="btnReset_Click" />
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
    <asp:SqlDataSource
        ID="sqlGetCurrency"
        runat="server"
        ConnectionString="<%$ ConnectionStrings: CSLOrderingARCBAL.Properties.Settings.ARC_OrderingConnectionString %>"
        ProviderName="<%$ ConnectionStrings: CSLOrderingARCBAL.Properties.Settings.ARC_OrderingConnectionString.ProviderName %>"
        SelectCommand="SELECT  CurrencyCode FROM Currency"></asp:SqlDataSource>

    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No Matching Results Found."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDupProd" Visible="false" Text="Duplicate Product code. Please enter again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillProdCode" Visible="false" Text="Please fill required details correctly : Product Code "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillProdName" Visible="false" Text="Please fill required details correctly : Product Name "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillLstOrdr" Visible="false" Text="Please fill required details correctly : List Order "></asp:Literal>
    <asp:Literal runat="server" ID="ltrFillPrice" Visible="false" Text="Please fill required details correctly : Price "></asp:Literal>
    <asp:Literal runat="server" ID="ltrProdDel" Visible="false" Text="Product Deleted."></asp:Literal>
</asp:Content>
