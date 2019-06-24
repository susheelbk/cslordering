<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="ViewPreviousOrders.aspx.cs" Inherits="ViewPreviousOrders" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="Ajax" %>
<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Previous Orders
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
   <!-- <div>
    <ul>
        <li>
      The previous orders can be viewed from date to date/ by Arc Ref/ by DIv Note No.
        </li>
    </ul>
</div>-->
    <br />
    <div>
        <fieldset>
            <legend><b style="color: red; font-size: 14px;">View Orders</b> </legend>
            <table>
                <tr>
                    <td colspan="3">
                        <div class="alert csl-info">
                            For orders placed before Jan 2017, please send an email to <a href="mailto:sales@csldual.com">sales@csldual.com</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>FROM:</b>
                        <asp:TextBox ID="txtfromDate" runat="server" Text='<%#Convert.ToString(Eval("Datetime.Now.Date")) %>'
                            Width="80px" ValidationGroup="e"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*"
                            ControlToValidate="txtfromDate" ValidationExpression="(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])"
                            ValidationGroup="e" Display="Dynamic" SetFocusOnError="true" ForeColor="Red"></asp:RegularExpressionValidator>
                        <Ajax:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtfromDate"
                            Enabled="true" Format="yyyy-MM-dd">
                        </Ajax:CalendarExtender>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;<b>TO:</b>
                        <asp:TextBox ID="txttoDate" runat="server" Text='<%#Convert.ToString(Eval("ExpDate")) %>'
                            Width="80px" ValidationGroup="e"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="*"
                            ControlToValidate="txttoDate" ValidationExpression="(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])"
                            ValidationGroup="e" Display="Dynamic" SetFocusOnError="true" ForeColor="Red"></asp:RegularExpressionValidator>
                        <Ajax:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txttoDate"
                            Format="yyyy-MM-dd" Enabled="true">
                        </Ajax:CalendarExtender>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnShow" runat="server" Width="100px" Text="Show" OnClick="btnShow_Click"
                            CssClass="css_btn_class" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <table width="80%">
                <tr>
                    <td align="left">
                        <b>ARC Ref :</b>
                        <asp:TextBox ID="txtarcref" runat="server"></asp:TextBox>
                    </td>
                    <td align="left">
                        <b>Dlv Note No :</b>
                        <asp:TextBox ID="txtdlvnoteno" runat="server"></asp:TextBox>
                    </td>
                    <td align="left">
                        <asp:Button ID="btnsearch" runat="server" Width="100px" Text="Search" CssClass="css_btn_class"
                            OnClick="btnsearch_Click" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3"></td>
                </tr>
            </table>
        </fieldset>
        <div>
            <b>Click on the below orders to view in detail. </b>
            <br />
        </div>
        <br />
        <div>
            <asp:GridView ID="gvOrders" runat="server" AllowPaging="True" PageSize="10" AutoGenerateColumns="false"
                CellPadding="4" Width="103%" ForeColor="#333333" GridLines="Horizontal" DataKeyNames="OrderId"
                EmptyDataText="No Data Found" OnPageIndexChanging="gvOrders_PageIndexChanging"
                OnRowDataBound="gvOrders_RowDataBound" OnRowCommand="gvOrders_RowCommand">
                <EmptyDataTemplate>
                    <asp:Label ID="lblNoRow" runat="server" Text="No Records Found For This Date!" ForeColor="Red"
                        Font-Bold="true"></asp:Label>
                </EmptyDataTemplate>
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <%# ((GridViewRow)Container).RowIndex + 1%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CSLOrderNo" HeaderText="Order #" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="ARCOrderRefNo" HeaderText="Order Ref #" HeaderStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="OrderDate" HeaderText="Order Date" HeaderStyle-HorizontalAlign="Left"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="OrderQty" HeaderText="Order Qty" HeaderStyle-HorizontalAlign="Left" />
                    <asp:TemplateField HeaderText="Total Amount" HeaderStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <asp:Label ID="lblTotalAmount" runat="server" Text='<%#"£" +Eval("TotalAmountToPay")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Company Name" HeaderStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <asp:Label ID="lblCompanyName" runat="server" Text='<%# Eval("CompanyName")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" ItemStyle-CssClass="HiddenColumn" HeaderStyle-CssClass="HiddenColumn"  />
                </Columns>
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#5D7B9D" ForeColor="White" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            </asp:GridView>
            <asp:HiddenField ID="hdnSelectedOrderID" runat="server" />
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
                <asp:Label ID="Label19" Text="Tracking No." Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
                <%=strURLTracking%>
            </div>
            <br />
            <br />
            <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
                <asp:Label ID="Label20" Text="Delivery Notes" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
                <%=strURLDeliveyNotes%>
            </div>
            <br />
            <br />
            <div style="border-width: 1px; border-style: dashed; border-color: #b0b5b2; padding: 5px;">
                <asp:Label ID="Label16" Text="CSL Order#" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblCSLOrderNo" runat="server" Text="" />
                <br />
                <br />
                <asp:Label ID="Label18" Text="Order Date" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblOrderDate" runat="server" Text="" />
                <br />
                <br />
                <asp:Label ID="Label31" Text="User" Font-Bold="true" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="lblUserName" runat="server" Text="" />
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
                    <table width="1024px" cellpadding="5" cellspacing="2" border="0">
                        <asp:Repeater runat="server" ID="dlProducts" OnItemDataBound="ProductsRepeater_ItemBound">
                            <HeaderTemplate>
                                <tr bgcolor="#fbcaca">
                                    <td>
                                        <b>
                                            <asp:Label ID="Label4" Text="Code" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b><asp:Label ID="Label3" Text="Product Name" runat="server" Width="100" ></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="lblGPRSNo" Text="ChipNo / InstallID" ToolTip="CSL ChipNo or Emizon InstallID" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label29" Text="SiteName" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label34" Text="EmNo" ToolTip="Emizon EMNO" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label35" Text="SerialNo" runat="server"></asp:Label></b>
                                    </td>
                                    <td >
                                        <b>
                                            <asp:Label ID="Label23" Text="REPL" ToolTip="Replenishment" runat="server"></asp:Label></b>
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="Label25" Text="CSD" ToolTip="Activation" runat="server"></asp:Label></b>
                                    </td>

                                    <td>
                                        <b>
                                            <asp:Label ID="Label1" Text="QTY" runat="server"></asp:Label></b>
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
                                        <asp:CheckBox ID="chkCSD" runat="server" Text='<%# Eval("IsCSDProd")%>' Visible="false" />
                                         <asp:Label ID="lblProductType" runat="server" Text='<%# Eval("ProductType")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="Label21" runat="server" Visible="false" Text='<%# Eval("ICCID")%>'></asp:Label>
                                        <asp:Label ID="Label22" runat="server" Visible="false" Text='<%# Eval("DataNo")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblProductTitle" runat="server"><%# Eval("ProductName") %></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label24" runat="server" Text='<%# Eval("GPRSNo")%>'></asp:Label>
                                        &nbsp;-&nbsp;
                                        <asp:Label ID="lblOption" runat="server"><%# Eval("OptionName")%></asp:Label>
                                    </td>
                                     <td>
                                        <asp:Label ID="Label32" runat="server" Text='<%# Eval("SiteName")%>'></asp:Label>
                                    </td>
                                     <td>
                                        <asp:Label ID="Label33" runat="server" Text='<%# Eval("EM_Number")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label30" runat="server" Text='<%# Eval("TCD_SerialNo")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label28" runat="server" Text='<%# Eval("IsReplenishment")%>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label26" runat="server" Text='<%# Eval("IsCSDProd")%>'></asp:Label>
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
                                    <td colspan="8" align="right">
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
                        <td align="left" style="text-align: left">£<asp:Label ID="lblDeliveryTotal" runat="server" Font-Bold="true" Text="0.00"></asp:Label>
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
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">£<asp:Label ID="lblDtlsOrderTotal" runat="server" Text="0.00"></asp:Label>
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
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">£<asp:Label ID="lblDtlsVAT" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="text-align: right; padding-right: 10px;" valign="top">
                            <asp:Label ID="Label17" runat="server" Font-Bold="true" Text="Total: "></asp:Label>
                        </td>
                        <td align="right" style="text-align: right; padding-right: 10px;" width="70">£<asp:Label ID="lblDtlsTotalToPay" Font-Bold="true" runat="server" Text="0.00"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:HiddenField ID="hidProductCode" runat="server" />
        </div>
    </div>
</asp:Content>
