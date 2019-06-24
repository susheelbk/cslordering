<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CategoryBadge.ascx.cs"
    Inherits="Modules_CategoryBadge" %>


<div id="ProductTableUDL" runat="server">
    <asp:HiddenField ID="hdnCatID" runat="server" />
    <table width="100%" border="0" cellpadding="6" cellspacing="0" bgcolor="#fbcaca"
        summary="">
        <tr valign="top">
            <td class="producttitle">
                <asp:HyperLink ID="lnkCategoryName" runat="server" class="producttitle"></asp:HyperLink>
            </td>
            <td align="right" valign="bottom">
                <img src="images/arrow.gif" alt="more" width="6" height="9">
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellpadding="8" cellspacing="1" bgcolor="#ee2224"
        summary="">
        <tr valign="top" bgcolor="#ffffff">
            <td width="205">
                 <asp:HyperLink ID="lnkCategoryImage" runat="server">
                    <asp:Image ImageAlign="Middle" ImageUrl="" ID="imgCatProducts" runat="server"  />
                </asp:HyperLink>
            </td>
            <td>
                <p>
                     <asp:Label ID="lblCategoryDesc"  runat="server" Text="" Width="450" />
                </p>
                <p>
                    <asp:Button ID="Submit"  runat="server" CommandName="Submit" CssClass="css_btn_class"   CommandArgument="1" Text="Place Order >"></asp:Button>
                </p>
            </td>
        </tr>
    </table>
</div>
