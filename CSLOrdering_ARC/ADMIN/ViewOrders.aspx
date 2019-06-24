<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ViewOrders.aspx.cs" Inherits="ADMIN_ViewOrders" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">

    <script type="text/javascript">
        //added by priya
        $(function () {
            
            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
    </script>
    <div style="width: 824px!important;">
        <div>
            <table width="100%" cellpadding="0" cellspacing="0">

                <tr>
                    <td>
                        <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                                <ul style="line-height: 20px">
                                    <li>Allows the user to view the orders placed
                                        <br />
                                        1. By date<br />
                                        2. By order no<br />
                                        3. By chip no<br />
                                    </li>
                                    <li>Allows the user to look for orders placed by particular<br />
                                        1. ARC<br />
                                        2.	Categories<br />
                                        3.	Products<br />
                                    </li>
                                    <li>By clicking on the specific Order in the grid will give the complete order details like Delivery Details, Product details, Chip no, ICCID No. etc.,
                                    </li>
                                    <li>The order email can be resent with or without price.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <fieldset>
                            <legend><b style="color: red; font-size: 14px;">View Orders</b></legend>
                            <table>
                                <tr>
                                    <td>
                                        <b>FROM:</b>
                                        <asp:TextBox ID="txtfromDate" runat="server" Text='<%#Convert.ToString(Eval("Datetime.Now.Date")) %>'
                                            Width="80px" ValidationGroup="e"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*"
                                            ControlToValidate="txtfromDate" ValidationExpression="(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])"
                                            ValidationGroup="e" Display="Dynamic" SetFocusOnError="true" ForeColor="Red"></asp:RegularExpressionValidator>
                                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtfromDate"
                                            Enabled="true" Format="yyyy-MM-dd">
                                        </asp:CalendarExtender>
                                    </td>
                                    <td>
                                        <b>TO:</b>
                                        <asp:TextBox ID="txttoDate" runat="server" Text='<%#Convert.ToString(Eval("ExpDate")) %>'
                                            Width="80px" ValidationGroup="e"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="*"
                                            ControlToValidate="txttoDate" ValidationExpression="^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])"
                                            ValidationGroup="e" Display="Dynamic" SetFocusOnError="true" ForeColor="Red"></asp:RegularExpressionValidator>
                                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txttoDate"
                                            Enabled="true" Format="yyyy-MM-dd">
                                        </asp:CalendarExtender>
                                    </td>
                                    <td>
                                        <b>Order No:</b>
                                        <asp:TextBox ID="txtOrderNO" runat="server" Width="80px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <b>Chip No:</b>
                                        <asp:TextBox ID="txtChipNo" runat="server" Width="80px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="font-weight: bold">Select ARC</span>
                                    </td>
                                    <td>
                                        <span style="font-weight: bold">Select Categories</span>
                                    </td>
                                    <td>
                                        <span style="font-weight: bold">Select Products</span>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList Width="195px" ID="ddlarc" runat="server">
                                        </asp:DropDownList>
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:DropDownList Width="195px" ID="ddlctg" runat="server">
                                        </asp:DropDownList>
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:DropDownList Width="195px" ID="ddlpro" runat="server">
                                        </asp:DropDownList>
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:Button ID="btnShow" runat="server" Width="100px" Text="Show" OnClick="btnShow_Click"
                                            CssClass="css_btn_class" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3"></td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <br />
            <b>Click on the below orders to view in detail. </b>
        </div>
        <br />
        <div>
            <asp:GridView ID="gvOrders" runat="server" AllowPaging="True" PageSize="15" AutoGenerateColumns="false"
                CellPadding="4" Width="100%" ForeColor="#333333" GridLines="Horizontal" DataKeyNames="OrderId"
                OnPageIndexChanging="gvOrders_PageIndexChanging" OnRowDataBound="gvOrders_RowDataBound"
                OnRowCommand="gvOrders_RowCommand">
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <EmptyDataTemplate>
                    <span style="text-align: center; font-weight: bold; color: #FF0000;">No Orders Found</span>
                </EmptyDataTemplate>
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ARCDisp" HeaderText="ARC" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="CSLOrderNo" HeaderText="Order #" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="ARCOrderRefNo" HeaderText="Order Ref #" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="OrderStatus" HeaderText="Order Status" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="OrderDate" HeaderText="Order Date" HeaderStyle-HorizontalAlign="Left"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="OrderQty" HeaderText="Order Qty" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="TotalAmountToPay" HeaderText="Total Amount" HeaderStyle-HorizontalAlign="Left" />
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            gvOrders
                            <asp:Label ID="UserEmail" runat="server" Text='<%# Eval("UserEmail") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="UserId" runat="server" Text='<%# Eval("UserId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#5D7B9D" ForeColor="White" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            </asp:GridView>
            <br />
        </div>
        <div id="divDetails" runat="server" style="float: left; vertical-align: top; position: relative;">
            <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
                <div class="heading">
                    Installer Details
                </div>
                <br />
                <div>
                    <div>
                        <table border="0" width="760" cellspacing="5">
                            <tr>
                                <td width="132px">
                                    <asp:Label ID="Label9" runat="server" Font-Bold="true" Text="Delivery Address"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblDelAddress" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <hr />
                    <div>
                        <table border="0" width="760" cellspacing="5">
                            <tr>
                                <td width="132px">
                                    <asp:Label ID="Label7" runat="server" Font-Bold="true" Text="Installation Address"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInstAddress" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <hr />
                    <div>
                        <table border="0" width="760" cellspacing="5">
                            <tr>
                                <td width="132px">
                                    <asp:Label ID="Label2" runat="server" Font-Bold="true" Text="Special Instructions"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblSpecialInst" runat="server" />
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
                <asp:Label ID="Label14" Text="ARC Order ref#" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblARCOrderRefNo" runat="server" />
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
                                            <asp:Label ID="Label3" Width="350px" Text="Product Name" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label6" Text="Type" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label25" Text="IsCSD" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>IsReplenishment </b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label1" Text="Quantity" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label2" Text="Unit Price" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label5" Text="Amount" runat="server"></asp:Label></b>
                                    </td>
                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr bgcolor="#cccccc">
                                    <td>
                                        <asp:HiddenField ID="hdnOrderItemId" runat="server" Value='<%# Eval("OrderItemId") %>' />
                                        <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("ProductCode")%>'></asp:Label>
                                        <asp:CheckBox ID="chkCSD" runat="server" Text='<%# Eval("IsCSDProd")%>' Visible="false" />
                                    </td>
                                    <td>
                                        <asp:Literal ID="Literal1" runat="server" Mode="Encode" Text='<%# Eval("ProductName") %>'></asp:Literal>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblProductType" runat="server" Text='<%# Eval("ProductType")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCSD" runat="server" Text='<%# Eval("IsCSDProd")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("IsReplenishment")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblProductQty" runat="server" Text='<%# Eval("ProductQty")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblProductPrice" runat="server">£<%# Eval("Price")%></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblProductPriceTotal" runat="server">£<%# Eval("ProductPriceTotal")%></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <asp:Repeater runat="server" ID="rptrDependentProducts" OnItemDataBound="rptrDependentProducts_ItemBound">
                                            <ItemTemplate>
                                                <tr bgcolor="#cccccc">
                                                    <td>
                                                        <asp:Label ID="lblProductCode" runat="server"><%# Eval("ProductCode")%></asp:Label>
                                                    </td>
                                                    <td colspan="3">
                                                        <asp:Literal ID="Literal1" runat="server" Mode="Encode" Text='<%# Eval("ProductName") %>'></asp:Literal>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblProductQty" runat="server" Width="50px"><%# Eval("ProductQty")%></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblProductPrice" runat="server" Width="60px">£<%# Eval("Price")%></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblProductPriceTotal" runat="server" Width="70px">£<%# Eval("DependentProductPriceTotal")%></asp:Label>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <asp:Repeater runat="server" ID="rptrItemDetails">
                                            <HeaderTemplate>
                                                <table cellpadding="5" cellspacing="1" border="0" width="100%">
                                                    <tr bgcolor="#fbcaca" id="trlblIdent" runat="server">
                                                        <td align="center">
                                                            <b><span>ICCID<span></b>
                                                        </td>
                                                        <td align="center">
                                                            <b><span>Chip Number<span></b>
                                                        </td>
                                                        <td align="center">
                                                            <b><span>IDENT<span></b>
                                                        </td>
                                                        <td align="center">
                                                            <b><span>Post Code</span></b>
                                                        </td>
                                                        <td align="center">
                                                            <b><span>Option</span></b>
                                                        </td>
                                                        <td align="center">
                                                            <b><span>SiteName</span></b>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr id="Tr1" bgcolor="#cccccc" runat="server">
                                                    <td align="left">
                                                        <%# Eval("ICCID")%>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ICCID") %>' Visible="false"></asp:Label>
                                                    </td>
                                                    <td align="left">
                                                        <%# Eval("GPRSNo")%>
                                                    </td>
                                                    <td align="left">
                                                        <%# Eval("PSTNNo")%>
                                                    </td>
                                                    <td align="left">
                                                        <%# Eval("GPRSNoPostCode")%>
                                                    </td>
                                                    <td align="left">
                                                        <%# Eval("OptionName")%>
                                                    </td>
                                                    <td align="left">
                                                        <%# Eval("SiteName")%>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                <tr bgcolor="#cccccc">
                                    <td colspan="4" align="right">
                                        <b>
                                            <asp:Label ID="Label4" Text="Grand Total" runat="server"></asp:Label></b>
                                    </td>
                                    <td style="border-right: 0;">
                                        <b>
                                            <asp:Label ID="lblTotalQty" Text="" runat="server" Width="50px"></asp:Label></b>
                                    </td>
                                    <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                                       { %>
                                    <td style="border-left: 0;">
                                        <b>
                                            <asp:Label ID="Label8" Text="" runat="server" Width="55px"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="lblTotalPrice" Text="" runat="server" Width="70px"></asp:Label></b>
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
                            <asp:Label ID="lblDelType" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="top" width="100">
                            <asp:Label ID="Label12" runat="server" Font-Bold="true" Text="Delivery Total"></asp:Label>
                        </td>
                        <td align="left" style="text-align: left">
                            <asp:Label ID="lblDeliveryTotal" runat="server" Font-Bold="true" Text="0.00"></asp:Label>
                            <asp:Label ID="lblOrderQty" runat="server" Font-Bold="true" Text="0.00" Visible="false"></asp:Label>
                        </td>
                    </tr>
                </table>
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
                            <asp:Label ID="lblDtlsOrderTotal" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                            <asp:Label ID="Label13" runat="server" Font-Bold="true" Text="Delivery Total : "></asp:Label>
                        </td>
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">
                            <asp:Label ID="lblDtlsDeliveryTotal" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                            <asp:Label ID="Label15" runat="server" Font-Bold="true" Text="VAT : "></asp:Label>
                        </td>
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">
                            <asp:Label ID="lblDtlsVAT" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                            <asp:Label ID="Label17" runat="server" Font-Bold="true" Text="Total: "></asp:Label>
                        </td>
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">
                            <asp:Label ID="lblDtlsTotalToPay" Font-Bold="true" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right" style="text-align: right; padding-right: 20px;" valign="top">
                            <asp:RadioButton ID="rbtnwithprice" Text="EmailWithPrice" runat="server" GroupName="a"
                                Checked="true" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right" style="text-align: right; padding-right: 10px;" valign="top">
                            <asp:RadioButton ID="rbtnwithoutprice" runat="server" Text="EmailWithoutPrice" GroupName="a" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right" style="padding-right: 35px;">
                            <asp:Literal ID="LitMailbody" runat="server" Mode="Transform"></asp:Literal>
                            <%-- <asp:Button ID="Btnemail" runat="server" Text="Send Email" 
                             onclick="Btnemail_Click" />--%>
                            <asp:TextBox ID="txtNewMail" runat="server" Width="250px"></asp:TextBox>
                            <asp:LinkButton ID="Btnemail" runat="server" ValidationGroup="a" OnClick="Btnemail_Click">Resend Email</asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:HiddenField ID="hidProductCode" runat="server" />
            <asp:HiddenField ID="hidUserID" runat="server" />
            <asp:HiddenField ID="hidUserName" runat="server" />
            <asp:HiddenField ID="hidUserEmail" runat="server" />
        </div>
    </div>
</asp:Content>
