<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Checkout
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    
    <script type="text/javascript">
        function isvalid() {
            if (document.getElementById("chkterms").checked == true) {
                return true;
            }
            else {
                alert('Please accept all the terms and conditions to proceed!')
                return false;
            }

        }
        function EnterEvent(e) {
            if (e.keyCode == 13) {
                return false;
            }
        }
    </script>

    <style type="text/css">
        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 430px;
            height: 200px;
            overflow: auto;
        }
    </style>
    <br />
        
    <div>
        <asp:Label ID="ltrMessage" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
        <asp:Button ID="btnShow" runat="server" Text="" Style="display: none;" OnClientClick="return false;" />
        <!-- THE BELOW FIELD IS USED TO AUDIT THE SMTP SETTINGS -->
        <asp:HiddenField ID="hdnInsertSMTPData" runat="server" Value="1" />
        <!-- ModalPopupExtender -->
        <cc1:ModalPopupExtender ID="mp1" runat="server" PopupControlID="Panel1" TargetControlID="btnShow"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Style="display: none;">
            <asp:Literal ID="ltrMessage1" runat="server" Text="Your Order has been confirmed and we are processing your order.<br />Please store your order number."></asp:Literal>
            <div style="margin-left: auto; margin-right: auto">
                CSL Order Number :&nbsp; <b>
                    <asp:Label ID="lblOrderNumber" runat="server" ForeColor="Gray"></asp:Label></b>
                <br />
            </div>
            <br />
            <center>
                <asp:Button ID="btnAlertOrderConfirmation" runat="server" Text="Done" OnClick="btnAlertOrderConfirmation_Click" /></center>
        </asp:Panel>
        <!-- ModalPopupExtender -->
    </div>
    <div style="float: left; vertical-align: top; position: relative;">
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <div class="heading">
                Installer Details
            </div>
            <div>
                <div style="width: 100%; border: dotted 1px gray; padding: 0px; margin: 2px; min-height: 280px;">
                    <br />
                    <p style="width: 400px; background-color: gray; color: #fff; padding: 0px; font-weight: bold; margin-left: auto; margin-right: auto; height: 40px; font-size: 1.2em; line-height: 40px; text-align: center;">
                        Delivery Address / Installer Company Address
                    </p>
                    &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="Label1" Text="Installer Contact Name:" runat="server"
                        Font-Bold="true" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:TextBox ID="txtInstContactName1" runat="server" onkeypress="return EnterEvent(event)" />
                    <br />
                    <div style="width: 90%; padding-left: 20px;">
                        <asp:RadioButton ID="rdoInstallerAddress" runat="server" GroupName="grpInstallerAddress"
                            AutoPostBack="true" Checked="true" OnCheckedChanged="rdoInstallerAddress_CheckedChanged" />
                        <asp:Button ID="btnChangeInstaller" runat="server" Text="Change Installer Company"
                            PostBackUrl="~/SelectInstaller.aspx" CssClass="css_btn_class"></asp:Button>
                    </div>
                    <br />
                    <div style="width: 90%; padding-left: 20px;">
                        <asp:RadioButton ID="rdoNewAddress" runat="server" GroupName="grpInstallerAddress"
                            AutoPostBack="true" Font-Bold="true" Text="If Delivery address is different from the above address, then please select here."
                            OnCheckedChanged="rdoNewAddress_CheckedChanged" />
                    </div>
                    <div id="divNewAddress" runat="server" visible="false" style="padding-left: 20px;">
                        <table border="0" width="760" cellspacing="5">
                            <tr>
                                <td colspan="2">&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label28" runat="server" Text="Postcode of previous address"></asp:Label>
                                </td>
                                <td>
                                    <asp:Panel ID="pnlsearchprevaddress" DefaultButton="btnGo" runat="server">
                                        <asp:TextBox ID="txtPreviousPostcode" runat="server" Height="22px"></asp:TextBox>&nbsp;&nbsp;
                                        <asp:Button ID="btnGo" runat="server" Text="Go" CssClass="css_btn_class" OnClick="btnGo_Click" />
                                    </asp:Panel>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lbldlv" runat="server" Text="Recent / Filtered previous addresses"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList AutoPostBack="true" ID="ddlarcdeliveryaddresses" Width="80%" Height="23px" runat="server"
                                        OnSelectedIndexChanged="ddlarcdeliveryaddresses_SelectedIndexChanged">
                                    </asp:DropDownList>


                                    <asp:CheckBox ID="chkEditAddress"  Visible="false" AutoPostBack="true" runat="server"
                                        Text="Edit Address" OnCheckedChanged="chkEditAddress_CheckedChanged"  />

                                </td>

                            </tr>
                            <tr>
                                <td colspan="2"></td>
                            </tr>
                            <asp:Panel ID="pnlPrevAddress" runat="server">
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Text="Contact Name"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliContactName" TabIndex="0" runat="server" MaxLength="255"
                                            Height="22px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ForeColor="Red" runat="server"
                                            ValidationGroup="grpDeliveryAddress" Display="Dynamic" ControlToValidate="txtDeliContactName"
                                            ErrorMessage="Delivery ContactName Required">* Delivery ContactName Required
                                        </asp:RequiredFieldValidator>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text="Contact Number"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliContactNo" runat="server" MaxLength="50" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text="Address"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliAddressOne" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="grpDeliveryAddress"
                                            ControlToValidate="txtDeliAddressOne" ForeColor="Red" ErrorMessage="Address Required"
                                            Display="Dynamic">* Address Required
                                        </asp:RequiredFieldValidator>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Text="Address 2"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliAddressTwo" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Town"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliTown" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Text="County"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliCounty" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Text="Postcode"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDeliPostcode" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                            Height="22px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Text="Country"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCountry" runat="server" Height="22px" Width="155px" />
                                        <%--<asp:TextBox ID="txtDeliCountry" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>--%>
                                    </td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </div>
                    <br />
                </div>
                <br />
                <br />
                <asp:CheckBox ID="chkInstallationAddress" runat="server" AutoPostBack="true" Font-Bold="true"
                    Text="If Installation address is different from the delivery address, then please select here."
                    OnCheckedChanged="chkInstallationAddress_CheckedChanged" />
                <br />
                <br />
                <div id="divInstallationAddress" runat="server" visible="false">
                    <table border="0" width="760" cellspacing="5">
                        <tr>
                            <td>
                                <asp:Label ID="Label19" runat="server" Text="Contact Name"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstContactName" TabIndex="0" runat="server" MaxLength="255"
                                    Height="22px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ForeColor="Red" runat="server"
                                    ValidationGroup="grpInstallationAddress" Display="Dynamic" ControlToValidate="txtInstContactName"
                                    ErrorMessage="Installation ContactName Required">*
                                </asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:Label ID="Label20" runat="server" Text="Contact Number"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstContactNumber" runat="server" MaxLength="255" TabIndex="0"
                                    TextMode="SingleLine" Height="22px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label21" runat="server" Text="Address"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstAddressOne" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ForeColor="Red" runat="server"
                                    ValidationGroup="grpInstallationAddress" ControlToValidate="txtInstAddressOne"
                                    ErrorMessage="Address Required" Display="Dynamic">*
                                </asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:Label ID="Label22" runat="server" Text="Address 2"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstAddressTwo" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label23" runat="server" Text="Town"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstTown" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Label ID="Label24" runat="server" Text="County"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstCounty" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label25" runat="server" Text="Postcode"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstPostCode" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Label ID="Label26" runat="server" Text="Country"></asp:Label>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlInstCountry" runat="server" Height="22px" Width="155px" />
                                <%--<asp:TextBox ID="txtDeliCountry" runat="server" MaxLength="255" TabIndex="0" TextMode="SingleLine"
                                    Height="22px"></asp:TextBox>--%>
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
                <hr />
                <div>
                    <table border="0" width="760" cellspacing="5">
                        <tr>
                            <td width="132px;">
                                <asp:Label ID="Labelins" runat="server" Text="Special Instructions"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtInstructions" runat="server" Height="100px" MaxLength="1000"
                                    Rows="4" Width="85%" TabIndex="0" TextMode="MultiLine"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <br />
        <br />
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <asp:Label ID="Label16" Text="CSL Order#" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="lblCSLOrderNo" runat="server" Text="" />
            <br />
            <br />
            <asp:Label ID="Label18" Text="Order Date" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="lblOrderDate" runat="server" Text="" />
        </div>
        <br />
        <br />
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <asp:Label ID="Label14" Text="Customer Order No" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtOrderRefNo" runat="server" MaxLength="50" onkeypress="return EnterEvent(event)" />

        </div>
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;" runat="server" id="divARCBranches" >
                     <asp:Label ID="lblARCBrcanches" Text="ARC Branches" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     <asp:DropDownList ID="ddlArcBranches" runat="server">
                    </asp:DropDownList>
                </div>
        <br />
        <br />
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <div class="heading">
                Product Details
            </div>
            <div>
                <table width="100%" cellpadding="5" cellspacing="2" border="0">
                    <asp:Repeater runat="server" ID="dlProducts" OnItemDataBound="ProductsRepeater_ItemBound">
                        <HeaderTemplate>
                            <tr bgcolor="#fbcaca">
                                <td>
                                    <b>
                                        <asp:Label ID="Label4" Text="Code" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label3" Text="Product Name" runat="server"></asp:Label></b>
                                </td>
                                 <td>
                                    <b>
                                        <asp:Label ID="Label31" Text="Manufacturer" runat="server" Visible="false"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label27" Text="Options" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label6" Text="Type" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label29" Text="CSD? [Activation]" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label30" Text="Replenishment?" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label1" Text="Quantity" runat="server"></asp:Label></b>
                                </td>
                                <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                                   { %>
                                <td>
                                    <b>
                                        <asp:Label ID="Label2" Text="Unit Price" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="Label5" Text="Amount" runat="server"></asp:Label></b>
                                </td>
                                <%} %>
                            </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr bgcolor="#cccccc">
                                <td>

                                    <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("ProductCode")%>'></asp:Label>

                                   <%-- <asp:Label ID="lblProductCode" runat="server" Text='<%# getProductCode(Eval("ProductCode").ToString())%>'></asp:Label>--%>
                                    <asp:CheckBox ID="chkCSD" runat="server" Text='<%# Eval("IsCSDProd")%>' Visible="false" />
                                </td>
                                <td>
                                    <asp:Label ID="lblProductTitle" runat="server"><%# Eval("ProductName") %></asp:Label>
                                    
                                </td>
                                 <td id="tdManufacturer" runat="server" Visible="false">
                                    <asp:Label ID="lblManufacturer" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblOption" runat="server"><%# Eval("OptionName")%></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="lblProductType" runat="server" CssClass="NoStyleTextBox"
                                        Text='<%# Eval("ProductType")%>' BackColor="#cccccc"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblCSD" runat="server"><%# Eval("IsCSDUser")%></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblReplenishment" runat="server"><%# Eval("IsReplenishment")%></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblProductQty" runat="server" Text='<%# Eval("ProductQty")%>'></asp:Label>
                                </td>
                                <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                                   { %>
                                <td>
                                    <asp:Label ID="lblProductPrice" runat="server">£<%# Eval("Price")%></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblProductPriceTotal" runat="server">£<%# Eval("ProductPriceTotal")%></asp:Label>
                                </td>
                                <%} %>
                            </tr>
                            <asp:Repeater runat="server" ID="rptrDependentProducts" OnItemDataBound="rptrDependentProducts_ItemBound">
                                <ItemTemplate>
                                    <tr bgcolor="#cccccc">
                                        <td>
                                            <asp:Label ID="lblProductCode" runat="server"><%# Eval("ProductCode")%></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblProductTitle" runat="server"><%# Eval("ProductName") %></asp:Label>
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <asp:Label ID="lblProductQty" runat="server"><%# Eval("ProductQty")%></asp:Label>
                                        </td>
                                        <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                                           { %>
                                        <td>
                                            <asp:Label ID="lblProductPrice" runat="server">£<%# Eval("Price")%></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblProductPriceTotal" runat="server">£<%# Eval("DependentProductPriceTotal")%></asp:Label>
                                        </td>
                                        <%} %>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <tr>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            <tr bgcolor="#cccccc">
                                <td colspan="7" align="right">
                                    <b>
                                        <asp:Label ID="Label4" Text="Grand Total" runat="server"></asp:Label></b>
                                </td>
                                <td style="border-right: 0;">
                                    <b>
                                        <asp:Label ID="lblTotalQty" Text="" runat="server"></asp:Label></b>
                                </td>
                                <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                                   { %>
                                <td style="border-left: 0;">
                                    <b>
                                        <asp:Label ID="Label8" Text="" runat="server"></asp:Label></b>
                                </td>
                                <td>
                                    <b>
                                        <asp:Label ID="lblTotalPrice" Text="" runat="server"></asp:Label></b>
                                </td>
                                <%} %>
                            </tr>
                        </FooterTemplate>
                    </asp:Repeater>
                </table>
            </div>
        </div>
        <br />
        <br />
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <div class="heading">
                Delivery Details
            </div>
            <table border="0">
                <tr>
                    <td colspan="2">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top" width="100">
                        <asp:Label ID="Label10" runat="server" Font-Bold="true" Text="Delivery Types"></asp:Label>
                    </td>
                    <td align="left" style="text-align: left">
                        <asp:DropDownList AutoPostBack="true" Width="400px" ID="ddlDeliveryTypes" runat="server"
                            OnSelectedIndexChanged="ddlDeliveryTypes_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top" width="100">
                        <asp:Label ID="Label12" runat="server" Font-Bold="true" Text="Delivery Total"></asp:Label>
                    </td>
                    <td align="left" style="text-align: left; font-weight: bold;">£<asp:Label ID="lblDeliveryTotal" runat="server" Font-Bold="true" Text="0.00"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="left" style="color: red" colspan="5" valign="top" width="100">
                       
                    </td>
                    
                </tr>
            </table>
             <asp:Label ID="lblIsAncillary" runat="server"  style="color: red"  visible="false"  Text="* Please note only orders containing signalling devices are delivered free of charge. Standard delivery costs are applicable for orders containing ancillaries only."></asp:Label>
        </div>
        <br />
        <br />
        <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
            <%--<div class="heading">Order Total Details</div>--%>
            <table border="0" width="100%" cellpadding="2" cellspacing="2">
                <tr>
                    <td colspan="2">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                        <asp:Label ID="Label11" runat="server" Font-Bold="true" Text="Order Total (ex VAT) : "></asp:Label>
                    </td>
                    <td align="right" style="text-align: right; padding-right: 10px;" width="70">
                        <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                           { %>
                        £<asp:Label ID="lblDtlsOrderTotal" runat="server" Text="0.00"></asp:Label>
                        <%}
                           else
                           { %>
                        ---
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                        <asp:Label ID="Label13" runat="server" Font-Bold="true" Text="Delivery Total : "></asp:Label>
                    </td>
                    <td align="right" style="text-align: right; padding-right: 10px;" width="70">£<asp:Label ID="lblDtlsDeliveryTotal" runat="server" Text="0.00"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                        <asp:Label ID="Label15" runat="server" Font-Bold="true" Text="VAT : "></asp:Label>
                    </td>
                    <td align="right" style="text-align: right; padding-right: 10px;" width="70">
                        <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                           { %>
                        £<asp:Label ID="lblDtlsVAT" runat="server" Text="0.00"></asp:Label>
                        <%}
                           else
                           { %>
                        ---
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                        <asp:Label ID="Label17" runat="server" Font-Bold="true" Text="Total: "></asp:Label>
                    </td>
                    <td align="right" style="text-align: right; padding-right: 10px; font-weight: bold;" width="70">
                        <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                           { %>
                        £<asp:Label ID="lblDtlsTotalToPay" Font-Bold="true" runat="server" Text="0.00"></asp:Label>
                        <%}
                           else
                           { %>
                        ---
                        <%} %>
                    </td>
                </tr>
            </table>
        </div>
        <asp:HiddenField ID="hidProductCode" runat="server" />

        <asp:Panel ID="pnlAccepted" runat="server" Visible="false">

            <br />
            <input type="checkbox" id="chkterms" name="chkterms" />
            I agree to have read and accepted the 
            <asp:HyperLink runat="server" ID="lnkTerms"
                 NavigateUrl="TermsAndConditions/Default.aspx"
                 Target="_blank">Terms and Conditions.</asp:HyperLink>
        </asp:Panel>

        <div style="padding: 5px; float: right;">
            <br />
            <asp:Button ID="btnConfirmOrder" CssClass="css_btn_class" Text="Confirm Order" runat="server"
                OnClick="btnConfirmOrder_Click" />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <asp:Literal ID="LitMailbody" runat="server" Mode="Transform"></asp:Literal>
    
</asp:Content>
<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
