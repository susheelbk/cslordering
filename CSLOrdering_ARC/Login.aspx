<%@ Page Title="CSL - Ordering Login" Language="C#" MasterPageFile="~/site.master"
    AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="Ajax" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="Server">
     <script type="text/javascript" src="scripts/SetSessionStorage.js"></script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPageTitle" runat="Server">
    <%--<div class="fontSize">
        Login
    </div>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <asp:Panel ID="panelLogin" runat="server">
        <br />
        <br />
        <asp:Login ID="cslLogin" runat="server" RememberMeSet="True" RememberMeText="Remember Me"
            TitleText="Login" TextLayout="TextOnTop" EnableViewState="False" OnAuthenticate="MyLogin_Authenticate">
            <LayoutTemplate>
                <div style="width: 320; height: 350; position: static; padding-top: 5px; padding-left: 1px; padding-right: 1px; padding-bottom: 5px; background: #ABA9AA;">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr style="background-color: white;">
                            <td>
                                <table border="0" cellpadding="2" cellspacing="0" width="350px">
                                    <tr>
                                        <td align="center" colspan="2">Login
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="User Name:" EnableViewState="false"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="UserName" autofocus="autofocus" runat="server" Width="150px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="cslLogin">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:" EnableViewState="false"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="cslLogin">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:CheckBox ID="RememberMe" runat="server" Checked="True" />
                                            Save Me
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color: Red;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <asp:Button ID="LoginImageButton" runat="server" ImageUrl="~/Images/login.gif"
                                                Text="Login" Width="80" ValidationGroup="cslLogin" CommandName="Login" CssClass="css_btn_class" />
                                        </td>
                                    </tr>
                                </table>
                                <tr>
                                    <td>
                                        <a style="color: #ff0000; padding-left: 35px;" target="_blank" href="http://passwordrecovery.csldual.com/">Click here</a> for forgotten Username and Password.
                                    </td>
                                </tr>
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
            </LayoutTemplate>
        </asp:Login>
        <br />
        <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
    </asp:Panel>
</asp:Content>
