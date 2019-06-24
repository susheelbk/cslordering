<%@ Page Title="" Language="C#" MasterPageFile="~/site.master" AutoEventWireup="true"
    CodeFile="Products.aspx.cs" Inherits="Products" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="UserControls/ProductBadge.ascx" TagName="ProductBadge" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentWrapper" runat="Server">
    <asp:Literal ID="ltrScript" runat="server">
    </asp:Literal>
    <%--<h2 class="categoryHeader">--%>
    <asp:Literal ID="lblCategoryName" runat="server" Visible="false"></asp:Literal>
    <%--</h2>--%>
    <div class="catalogtable">
        <asp:Repeater runat="server" ID="dlProducts" OnItemDataBound="ProductsRepeater_ItemBound">
            <ItemTemplate>
                <table>
                    <tr>
                        <td>
                            <uc1:ProductBadge ID="ProductBadge1" runat="server" ProductID='<%#Eval("ProductId") %>'
                                ProductCode='<%# Eval("ProductCode")%>' ProductTitle='<%# Eval("ProductName") %>'
                                ProductPrice='<%# Eval("Price") %>' ThumbImageUrl='<%# Eval("DefaultImage") %>'
                                CategoryId='<%# this.CategoryID %>' />
                        </td>
                        <td valign="top" style="padding-left: 20px;">
                            <b>
                                <br />
                                <asp:Label ID="Label1" runat="server" Width="100">Related Products</asp:Label>
                                <br />
                            </b>
                            <asp:Repeater runat="server" ID="rptrRelatedProducts">
                                <ItemTemplate>
                                    <ul>
                                        <li>
                                            <asp:Label ID="lbl1" runat="server">
            <%# Eval("ProductName") %>
                                            </asp:Label>
                                        </li>
                                    </ul>
                                </ItemTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
