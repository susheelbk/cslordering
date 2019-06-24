<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InstallersPC.ascx.cs" Inherits="Modules_InstallersPC" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Panel ID="pnl" runat="server" DefaultButton="buttonSearch">
    <div id="div1" runat="server" class="installerSearchText">
        Please select an Installer Company for this order. 
                <br />
        Please type the Postcode of the Installer Company into the search tool and click Search. 
                <br />
        If you are unable to find the Installer Company, click on More... to search by Installer Company name.
				<br />
        If you are still unable to find the Installer Company, please call our Customer Services team on +44 (0)1895 474474.
    </div>
    <br />
    <table border="0" width="600">
        <tr>
            <td width="75%" class="left" style="padding-right: 5px;">
                <asp:TextBox ID="txtPostCode" MaxLength="256" Width="98%" TabIndex="1" runat="server">
                </asp:TextBox>
                <cc1:TextBoxWatermarkExtender ID="TBWE2" runat="server" TargetControlID="txtPostCode"
                    WatermarkText="Search by Postcode..."
                    WatermarkCssClass="watermarked" />
            </td>
            <td class="left" style="padding-left: 5px;">
                <asp:Button ID="btnSearch" Text="Search" CssClass="css_btn_class" runat="server"
                    OnClick="btnSearch_Click" />
            </td>
            <td>&nbsp;</td>
            <td>
                <asp:LinkButton ID="btnShowSearch" runat="server" OnClick="btnShowSearch_Click">More...</asp:LinkButton>
                <asp:LinkButton ID="btnHideSearch" Visible="false" runat="server" OnClick="btnHideSearch_Click">Less...</asp:LinkButton>
            </td>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="buttonClear" Text="Clear Search" runat="server"
                    OnClick="Clear_Click" float="right" />
            </td>
        </tr>
        <tr runat="server" id="advancedSearch" visible="false">
            <td width="75%" class="left" style="padding-right: 5px;">
                <asp:TextBox ID="installerCompanyName" MaxLength="256" Width="98%" TabIndex="1" runat="server">
                </asp:TextBox>
                <cc1:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server" TargetControlID="installerCompanyName"
                    WatermarkText="Search by Company Name..."
                    WatermarkCssClass="watermarked" />
            </td>
            <td class="left" style="padding-left: 5px;">
                <asp:Button ID="buttonSearch" Text="Search" CssClass="css_btn_class" runat="server"
                    OnClick="btnSearch_Click" Visible="false" />
            </td>
        </tr>
        <asp:Repeater runat="server" ID="rptInstallerCompanies" OnItemCommand="rptInstallerCompanies_ItemCommand">
            <ItemTemplate>
                <table cellpadding="10" cellspacing="2" border="0" style="width: 100%">
                    <tr>
                        <td style="width: 60%; padding-left: 100px;">
                            <strong>
                                <asp:Label ID="lblCompanyName" runat="server" Text='<%# Eval("CompanyName") %>' CommandArgument='<%# Eval("CompanyName") %>' /></strong>
                            <br />
                            <asp:Label ID="lblAccreditation" runat="server" Text='<%# Eval("Accreditation") %>' CommandArgument='<%# Eval("Accreditation") %>' />
                            ,&nbsp;
                                <asp:Label ID="lblUniqueCode" runat="server" Text='<%# String.Format("CSL Code: {0}", Eval("UniqueCode")) %>' CommandArgument='<%# Eval("UniqueCode") %>' />
                            <br />
                            <asp:Label ID="lblAddressOne" runat="server" Text='<%# Eval("AddressOne") %>' CommandArgument='<%# Eval("AddressOne") %>' />
                            ,&nbsp;
                                <asp:Label ID="lblAddressTwo" runat="server" Text='<%# Eval("AddressTwo") %>' CommandArgument='<%# Eval("AddressTwo") %>' />
                            <br />
                            <asp:Label ID="lblTown" runat="server" Text='<%# Eval("Town") %>' CommandArgument='<%# Eval("Town") %>' />
                            ,&nbsp;
                                <asp:Label ID="lblCounty" runat="server" Text='<%# Eval("County") %>' CommandArgument='<%# Eval("County") %>' />
                            <br />
                            <asp:Label ID="lblPostCode" runat="server" Text='<%# Eval("PostCode") %>' CommandArgument='<%# Eval("PostCode") %>' />
                            <br />
                            <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("Country") %>' CommandArgument='<%# Eval("Country") %>' />
                        </td>
                        <td>
                            <asp:Button ID="btnSelect" Text="Select this Installer" CssClass="css_btn_class" Height="40px" Width="150px" runat="server" CommandName='<%# Eval("CompanyName") %>' CommandArgument='<%# Eval("InstallerCompanyID") %>' />
                        </td>
                        <hr />
                    </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
        <tr>
            <td class="left">
                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" SkinID="LabelRed"></asp:Label>
            </td>
        </tr>
    </table>
    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No Installers match your search criteria, please try again."></asp:Literal>
</asp:Panel>
