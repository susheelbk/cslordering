<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="UploadMultipleOrdersCheckout.aspx.cs" Inherits="UploadMultipleOrdersCheckout" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/UserControls/Installers.ascx" TagName="Installers" TagPrefix="ucInstallers" %>
<%@ Register Src="~/UserControls/InstallersPC.ascx" TagName="InstallersPC" TagPrefix="ucInstallersPC" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript">
        $("[src*=plus]").live("click", function () {
            $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            $(this).attr("src", "Images/minus.png");
        });
        $("[src*=minus]").live("click", function () {
            $(this).attr("src", "Images/plus.png");
            $(this).closest("tr").next().remove();
        });


        //$(document).on("click", "[id*=btnInstaller]", function () {           
        //    $("#ctl00_contentWrapper_divLoader").dialog({
        //        modal: true

        //    });
        //    return false;
        //});

    </script>
    <script type="text/javascript">

        function showProgressBar() {
            var objInputFile = document.getElementById('ctl00_contentWrapper_fileUploadCon');
            var objLoader = document.getElementById('ctl00_contentWrapper_divLoader');
            var objbtnUpload = document.getElementById('ctl00_contentWrapper_btnUpload');
            if (objInputFile.value != '') {

                objLoader.style.display = "block";
                objbtnUpload.style.display = 'none';
            }
            else {
                objLoader.style.display = "none";
                objbtnUpload.style.display = 'block';

            }
        }

        function ConfirmToSetDeliveryTypes(selectedDeliveryTypes) {
            var isConfirmed = confirm("Do you want to set same delivery type for all orders");
            if (isConfirmed) {
                var gvOrders = document.getElementById('ctl00_contentWrapper_gvOrders');
                var rowCount = gvOrders.rows.length;
                for (var rowIdx = 1; rowIdx <= rowCount - 1; rowIdx++) {
                    gvOrders.rows[rowIdx].cells[5].getElementsByTagName("*")[0].value = selectedDeliveryTypes.value;

                }
                return true;

            }
            else {
                return false;
            }
        }
        function ConfirmToSetCustOrderNo(custOrderNo) {
            var isConfirmed = confirm("Do you want to set same customer order no for all orders");
            if (isConfirmed) {
                var gvOrders = document.getElementById('ctl00_contentWrapper_gvOrders');
                var rowCount = gvOrders.rows.length;
                for (var rowIdx = 1; rowIdx <= rowCount - 1; rowIdx++) {
                    gvOrders.rows[rowIdx].cells[5].getElementsByTagName("*")[0].value = custOrderNo.value;
                }
                return false;

            }
            else {
                return false;
            }
        }

        function SetSameDeliveryAddressForAllOrders() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            var isConfirmed = confirm("Do you want to set same delivery address for all orders");
            if (isConfirmed) {
                confirm_value.value = "Ok";
            }
            else {
                confirm_value.value = "Cancel";
            }
            document.forms[0].appendChild(confirm_value);
        }

        function HidePopup() {

            $find('ctl00_contentWrapper_divpoup').hide();
            //$get('btnCancel').click();
        }
        function ToggleListVisibility(id) {
            //$(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
            var wrapper = document.getElementById(id);
            if (wrapper.style.display == "none") {
                $(this).closest("tr").after("<tr><td></td><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
                wrapper.style.display = "block";
            } else {
                wrapper.style.display = "none";
            }
        }
        function ShowModalPopup() {

            alert('test');
            $find("InstallerPopup").show();
            return false;
        }
    </script>
    <style type="text/css">
        .Background {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .Popup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 10px;
            width: 800px;
            height: 500px;
        }

        .lbl {
            font-size: 16px;
            font-style: italic;
            font-weight: bold;
        }

        .buttonClose {
            font-size: 1em;
            padding: 1px;
            color: #fff;
            text-decoration: none;
            cursor: pointer;
            height: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        <%--Upload Multiple Orders--%>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <cc1:ModalPopupExtender ID="mpInstaller" BehaviorID="InstallerPopup" runat="server" PopupControlID="divpoup" TargetControlID="Button1"
        CancelControlID="btnCloseModalPopUp" BackgroundCssClass="Background">
    </cc1:ModalPopupExtender>
    <div class="Popup" id="divpoup" runat="server" style="width: 800px; display: none; height: 550px;">
        <div style="text-align: center;">
            <asp:Button ID="btnCloseModalPopUp" runat="server" CssClass="buttonClose" Text="X" />
        </div>
        <div style="height: 500px; overflow-y: scroll; overflow-x: hidden;">
            <ucInstallers:Installers ID="InstallersUC" runat="server" Visible="true " />
            <ucInstallersPC:InstallersPC ID="InstallersPC" runat="server" Visible="true" />
            <asp:Button ID="Button1" runat="server" Visible="true" Style="display: none" />
        </div>
    </div>

    <cc1:ModalPopupExtender ID="mpDeliveryAddress" runat="server" PopupControlID="divNewAddress" TargetControlID="Button4"
        CancelControlID="btnCloseNewAddress" BackgroundCssClass="Background">
    </cc1:ModalPopupExtender>

    <div id="divNewAddress" class="Popup" runat="server" style="width: 600px; height: 380px; display: block;">
        <div style="text-align: center;">
            <asp:Button ID="btnCloseNewAddress" runat="server" CssClass="buttonClose" Text="X" />
        </div>
        <table border="0" cellspacing="0">
            <tr>
                <td colspan="2" width="100%">&nbsp;
                </td>
            </tr>
            <tr>
                <td width="50%">
                    <asp:Label ID="Label1" runat="server" Text="Postcode of previous address"></asp:Label>
                </td>
                <td width="50%">
                    <asp:Panel ID="pnlsearchprevaddress" DefaultButton="btnGo" runat="server">
                        <asp:TextBox ID="txtPreviousPostcode" runat="server" Height="22px" Width="79%"></asp:TextBox>&nbsp;&nbsp;
                                        <asp:Button ID="btnGo" runat="server" Text="Go" CssClass="css_btn_class" OnClick="btnGo_Click" />
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td width="30%">
                    <asp:Label ID="lbldlv" runat="server" Text="Recent / Filtered previous addresses"></asp:Label>
                </td>
                <td width="70%">
                    <asp:DropDownList AutoPostBack="true" ID="ddlarcdeliveryaddresses" Width="80%" Height="23px" runat="server"
                        OnSelectedIndexChanged="ddlarcdeliveryaddresses_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr><td colspan="2"></td></tr>
            <tr id="trEditAddress" runat="server" visible="false">
                <td colspan="2">
                    <asp:CheckBox ID="chkEditAddress"  AutoPostBack="true" runat="server"
                        Text="Edit(Editing this address will create new address for this order)" OnCheckedChanged="chkEditAddress_CheckedChanged" /></td>
            </tr>
            <tr>
                <td colspan="2" style="height: 20px;"></td>
            </tr>
            <tr>
                <td colspan="2" width="100%">
                    <asp:Panel ID="pnlPrevAddress" runat="server" DefaultButton="btnSave">
                        <table border="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="Contact Name"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDeliContactName" TabIndex="0" runat="server" MaxLength="255"
                                        Height="22px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ForeColor="Red" runat="server"
                                        ValidationGroup="grpDeliveryAddress" Display="Dynamic" ControlToValidate="txtDeliContactName"
                                        ErrorMessage="Delivery ContactName Required">Delivery ContactName Required
                                    </asp:RequiredFieldValidator><span style="color: red">*</span>
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
                                        Display="Dynamic">Address Required
                                    </asp:RequiredFieldValidator>
                                    <span style="color: red">*</span>
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
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 30px;"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Button ID="Button4" runat="server" Visible="true" Style="display: none" />
                    <asp:Button ID="btnSave" CssClass="css_btn_class" Text="Save" runat="server" Visible="true" OnClick="btnSave_Click" />
                    <asp:Button ID="btnSaveforAllOrders" CssClass="css_btn_class" Text="Save Address For All Orders" runat="server" Visible="true" OnClick="btnSaveforAllOrders_Click" OnClientClick="SetSameDeliveryAddressForAllOrders();" />
                </td>
            </tr>
        </table>
    </div>
    <div class="modal" id="divLoader" runat="server" style="display: none; width: 93%; height: 100%">
        <div style="text-align: center">
            <img alt="" src="Images/ajax-loading.gif" />
        </div>
    </div>

    <div style="float: initial; vertical-align: top; position: relative; width: 1000px;">
        <div>
            <table width="100%" cellpadding="5" cellspacing="2" border="0">
                <tr>
                    <td colspan="2" bgcolor="gray">
                        <span style="color: #fff"><b>CHECKOUT UPLOADED ORDER ITEMS</b></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <span>
                            <asp:Literal ID="ltrOrderConfirmMessage" Visible="false" runat="server">Your Order has been confirmed and we are processing your orders.<br/><br/>Order Summary</asp:Literal></span>

                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="left">
                        <asp:Label runat="server" ForeColor="Red" ID="lblClearItems" Visible="false" Text="Your uploaded items has been removed,please upload the items again."></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <asp:LinkButton ID="lbClearBasket" Visible="false" CssClass="lbClearBasket css_btn_class" runat="server"
                            OnClick="lbClearBasket_Click"><i class="thrash"></i>Clear Basket</asp:LinkButton>
                        <br />
                    </td>

                </tr>
                <tr>
                    <td style="border: groove;" width="100%" runat="server" id="tdOrderSummary" visible="false">
                        <asp:Repeater runat="server" ID="rptUploadedProducts" Visible="false">
                            <HeaderTemplate>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td align="left" width="20%" style="font: bold">
                                            <asp:Label ID="Label2" Text="Order No" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="left" width="70%" style="font: bold">
                                            <asp:Label ID="Label10" Text="Product Codes" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="center" width="10%" style="font: bold">
                                            <asp:Label ID="Label12" Text="Quantity" runat="server"></asp:Label></b>
                                        </td>
                                    </tr>
                                </table>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td align="left" width="20%">
                                            <asp:Label ID="Label4" runat="server"><%# Eval("OrderNo")%></asp:Label>
                                        </td>
                                        <td align="left" width="70%">
                                            <asp:Label ID="Label3" runat="server"><%# Eval("ProductCodes")%></asp:Label>
                                        </td>
                                        <td align="center" width="10%">
                                            <asp:Label ID="Label1" runat="server"><%# Eval("Qty")%></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:Repeater>

                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div style="max-height: 450px; max-width: 100%; overflow: auto; width: 1200px;">
            <table width="100%" cellpadding="1" cellspacing="0" border="0" style="min-width: 1000px;">
                <tr>
                    <td style="font-size: smaller; font-weight: bold; font-family: Arial;"><span>Note:</span><span style="font-style: italic;">Installer address will be used for delivery.</span></td>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="false"
                            DataKeyNames="OrderId" Width="100%" OnRowDataBound="gvOrders_RowDataBound">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <img alt="" style="cursor: pointer;" src="images/plus.png" />
                                        <asp:Panel ID="pnlOrders" runat="server" Style="display: none;">
                                            <asp:GridView ID="gvOrderProducts" HeaderStyle-BackColor="#CCCCCC" Width="100%" runat="server" AutoGenerateColumns="false" CssClass="ChildGrid">
                                                <Columns>
                                                    <asp:BoundField ItemStyle-Width="150px" DataField="ProductCode" HeaderText="Product Code" />
                                                    <asp:BoundField ItemStyle-Width="150px" DataField="ProductQty" HeaderText="Product Qty" />
                                                </Columns>
                                            </asp:GridView>
                                        </asp:Panel>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10px" BackColor="#CCCCCC"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:BoundField ItemStyle-Width="50px" DataField="OrderNo" HeaderText="Order No">
                                    <ItemStyle Width="50px" Font-Size="Small"></ItemStyle>
                                    <HeaderStyle Font-Size="Small" />
                                </asp:BoundField>
                                <asp:BoundField ItemStyle-Width="60px" DataField="OrderRefNo" HeaderText="Order Ref No">
                                    <ItemStyle Width="60px" Font-Size="Small"></ItemStyle>
                                    <HeaderStyle Font-Size="Small" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderStyle-Width="400px" HeaderText="Installer Company Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblInstallerAddress" Font-Size="Small" runat="server" Visible="true" Text='<%#Eval("CompanyName") %>'></asp:Label>
                                        <asp:LinkButton ID="lnkInstaller" Font-Size="Small" ForeColor="#ff0000" runat="server" Text="Select Installer" OnClick="lnkInstaller_Click" />
                                        <asp:LinkButton ID="lnkSameAddress" Font-Size="Small" ForeColor="#ff0000" runat="server" Visible="false" Text="Use this Installer on all orders" OnClick="lnkSameAddress_Click" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="400px" Font-Size="Small"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="300px" HeaderText="Delivery Address">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDeliveryAddress" Font-Size="Small" runat="server" Visible="true" Text='<%#Eval("CompanyName") %>'></asp:Label>
                                        <asp:LinkButton ID="lnkNewAddress" ForeColor="#ff0000" Font-Size="Small" runat="server" GroupName="grpInstallerAddress"
                                            Font-Bold="true" Text="Click here to set a different delivery address" OnClick="lnkNewAddress_Click" />
                                   </ItemTemplate>
                                    <HeaderStyle Width="300px" Font-Size="Small"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="250px" HeaderText="Delivery Type">
                                    <HeaderTemplate>
                                        <asp:CheckBox ID="chkSelectAll" Font-Size="Small" Text="Set Default Delivery Type" AutoPostBack="true" OnCheckedChanged="chkSelectAll_CheckedChanged" runat="server" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlDeliveryTypes" Font-Size="Small" runat="server" OnSelectedIndexChanged="ddlDeliveryTypes_SelectedIndexChanged" Width="248px" AutoPostBack="true"></asp:DropDownList>
                                        <asp:Label ID="lblDeliveryCostTotal" runat="server" Visible="false" Text="0"></asp:Label>
                                        <asp:Label ID="lblCompanyId" runat="server" Visible="false" Text='<%#Eval("InstallerCompanyId") %>'></asp:Label>
                                        <asp:Label ID="lblDeliveryAddressId" runat="server" Visible="false" Text='<%#Eval("DeliveryAddressId") %>'></asp:Label>
                                        <asp:Label ID="lblOrderRefNo" runat="server" Visible="false" Text='<%#Eval("OrderRefNo") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="250px"></HeaderStyle>
                                </asp:TemplateField>
                            </Columns>

                            <HeaderStyle BackColor="#CCCCCC"></HeaderStyle>
                        </asp:GridView>
                    </td>
                </tr>

            </table>
        </div>
        <asp:Panel ID="pnlAccepted" runat="server" Visible="false">
            <br />
            <asp:Label ID="ltrConfirmTermsAndConds" ForeColor="Red" Visible="false" runat="server" Text="Please select terms and conditions to confirm the order."></asp:Label>
            <br />
            <asp:CheckBox ID="chkTermsAndConds" runat="server" />I agree to have read and accepted the <a href="TermsAndConditions/Default.aspx" target="_blank">Terms and Conditions.</a>
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
    <asp:Literal runat="server" ID="ltrDeliverTypeNoItems" Visible="false" Text="Delivery types can not be blank for any orders."></asp:Literal>
  </asp:Content>
