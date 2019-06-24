<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Categories.aspx.cs" Inherits="Categories" %>

<%@ Register Src="UserControls/CategoryBadge.ascx" TagName="CategoryBadge" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>

<asp:Content ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Categories
    </div>
    
    
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
   <%-- <div>
        <ul style="line-height:20px">
            <li>
         	    This page lists the various Categories that CSL DUALCOM provides.
            </li>
            <li>
                On clicking Place Order on a specific category, it lists the products under this category in the Product page.
            </li>
        </ul>
    </div>
    <br />
    <br />
    <br />--%>


    <asp:DataList ID="dtCategories" runat="server" RepeatColumns="1" ItemStyle-VerticalAlign="Top"
        AlternatingItemStyle-VerticalAlign="Top" RepeatDirection="Horizontal" CellSpacing="20"
        ItemStyle-BorderWidth="0" ItemStyle-BorderColor="Gray">
        <ItemTemplate>
            <uc1:CategoryBadge ID="CategoryBadgeDisplay" runat="server" CategoryID='<%#Eval("CategoryId") %>'
                CategoryName='<%#Eval("CategoryName") %>' CategoryCode='<%#Eval("CategoryCode") %>'
                CategoryDefaultImage='<%# Eval("CategoryDefaultImage") %>' CategoryDesc='<%#Eval("CategoryDesc") %>' />
        </ItemTemplate>
    </asp:DataList>
    <asp:Literal runat="server" ID="ltrUser" Visible="false" Text="User does not belong to any ARC."></asp:Literal>
</asp:Content>
