<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductBadge1.ascx.cs"
    Inherits="UserControls_ProductBadge1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:UpdatePanel runat="server" ID="productBox1" UpdateMode="Always">
    <ContentTemplate>
        <table cellpadding="5" cellspacing="0" border="1" style="border-style: dashed">
            <tr>
                <td width="50px">
                    <asp:ImageButton ID="lnkProductView" runat="server" ImageAlign="Middle" Width="50"
                        Height="50" OnClick="lnkProductView_Click" />
                </td>
                <td width="30px">
                    <asp:Label ID="lblProductCode" runat="server"></asp:Label>
                </td>
                <td width="200px">
                    <asp:Label ID="lblProductTitle" runat="server"></asp:Label>
                </td>
                <td width="50px">
                    <asp:Label ID="lblProductPrice" runat="server"></asp:Label>
                </td>
                <td width="20px">
                    <asp:TextBox ID="txtProductPrice" runat="server" Width="30px"></asp:TextBox>
                </td>
                <td width="50px">
                    <asp:ImageButton ID="btnAddToBasket" runat="server" AlternateText="Add to Basket"
                        ImageUrl="~/Images/shopping_cart_add.png" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
