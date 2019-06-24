<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductBadge.ascx.cs"
    Inherits="Modules_ProductBadge" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:UpdatePanel runat="server" ID="productBox1" UpdateMode="Always">
    <ContentTemplate>
        <div class="productbox">
            <div class="productsummarydisplaywrapper">
                <div class="productsummaryimageholder">
                    <asp:ImageButton ID="lnkProductView" runat="server" ImageAlign="Middle" Width="200"
                        Height="150" OnClick="lnkProductView_Click" />
                </div>
                <div class="productsummarytext">
                    <div class="productsummaryproductname">
                        <asp:Label ID="lblProductCode" runat="server"></asp:Label>
                        <br />
                        <asp:Label ID="lblProductTitle" runat="server"></asp:Label>
                    </div>
                    <div class="productsummaryproductprice">
                        <asp:Label ID="lblProductPrice" runat="server"></asp:Label>
                        <div class="productdetailSpace">
                        </div>
                        <asp:ImageButton ID="btnAddToBasket" runat="server" AlternateText="Add to Basket"
                            ImageUrl="~/Images/badgeAddtobasket.gif" OnClick="btnAddToBasket_Click" />
                    </div>
                    <asp:Panel ID="pnlLoginMsg" runat="server" CssClass="animationbox">
                        <asp:Label ID="lblItemAddedMsg" SkinID="LabelWhite" runat="server" Text="Item added to basket">
                        </asp:Label>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
