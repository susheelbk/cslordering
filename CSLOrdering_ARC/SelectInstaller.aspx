<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="SelectInstaller.aspx.cs" Inherits="SelectInstaller" %>

<%@ Register Src="~/UserControls/Installers.ascx" TagName="Installers" TagPrefix="ucInstallers" %>
<%@ Register Src="~/UserControls/InstallersPC.ascx" TagName="InstallersPC" TagPrefix="ucInstallersPC" %>

<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Select Installer
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <br />
    
    <div style="width: 800px; float: left;">
        <asp:UpdatePanel ID="pnlInstallers" runat="server">
            <ContentTemplate>
                <fieldset>
                    <ucInstallers:Installers ID="Installers" runat="server" Visible="false" />
                    <ucInstallersPC:InstallersPC ID="InstallersPC" runat="server" Visible="false" />
                </fieldset>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
