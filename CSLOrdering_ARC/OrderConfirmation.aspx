<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="OrderConfirmation.aspx.cs" Inherits="OrderConfirmation" %>


<asp:Content ID="Content1" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Order Confirmed
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <br />
    <div>
        <asp:Panel ID="Panel1" runat="server" Style="display: block; padding: 20px;">
            <asp:Literal ID="ltrMessage" runat="server" Text="Your Order has been confirmed and we are processing your order. Please store your order number."></asp:Literal>
            <div style="margin-left: auto; margin-right: auto">
                <br />
                CSL  Online Order No :&nbsp; <b>
                    <asp:Label ID="lblOrderNumber" runat="server" Font-Size="1.5em"></asp:Label></b>
                <br />
                <br />
                Customer Order Ref :&nbsp; <b>
                    <asp:Label ID="lblOrderRef" runat="server" Font-Size="1.5em"></asp:Label></b>
                <br />
            </div>

            <br />
            <center>
                <asp:Button ID="btnAlertOrderConfirmation" runat="server" Text="Done" OnClick="btnAlertOrderConfirmation_Click" CssClass="css_btn_class"/></center>
        </asp:Panel>
    </div>
    <asp:HiddenField ID="lnkRedirectURL" runat="server" Value="categories.aspx" />
</asp:Content>
