<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Installers.ascx.cs" Inherits="Modules_Installers" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Panel ID="pnl" runat="server" DefaultButton="buttonSearch">
    <div id="div2" runat="server" class="installerSearchText">
        You must select an Installer Company.
        <br />
        Type the Installer company name or the first few letters of the company name and
        click GO.
        <br />
        If you Can't find an installer company, please call our customer services at +44
        (0)1895 474 474 .
        <br />
        <font color="red">Try searching by Postcode. Please enter at least four characters</font>
    </div>
    <br />
    <table border="0" width="600">
        <tr>
            <td width="75%" class="left" style="padding-right: 5px;">
                <asp:TextBox ID="installerCompanyName" MaxLength="256" Width="98%" TabIndex="1" runat="server">
                </asp:TextBox>
            </td>
            <td class="left" style="padding-left: 5px;">
                <asp:Button ID="buttonSearch" Text="Search" CssClass="css_btn_class" runat="server"
                    OnClick="SelectHeadOffice_Click" />
            </td>
        </tr>
        <tr>
            <td class="left">
                <asp:DropDownList ID="ddlInstallers" TabIndex="4" runat="server" Width="98%" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlInstallers_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
            <td>
                &nbsp;<asp:Button ID="buttonClear" Text="Clear Search" CssClass="css_btn_class" runat="server"
                    OnClick="Clear_Click" />
            </td>
        </tr>
        <tr>
            <td colspan="2" height="100px">
                <asp:Literal ID="ltrCompanyInfo" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td>
                <br />
                <asp:Button ID="btnSelect" Text="Select this Installer Company" CssClass="css_btn_class"
                    runat="server" OnClick="Select_Click" />
            </td>
            <td>
            </td>
        </tr>
    </table>
    <asp:Literal runat="server" ID="ltrSelect" Visible="false" Text="Please select an installer first."></asp:Literal>
</asp:Panel>
