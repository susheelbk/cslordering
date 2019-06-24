<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManagePriceBand.aspx.cs" Inherits="ADMIN_ManagePriceBand" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
   
    <style type="text/css">
        .style1 {
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">

            <script language="javascript" type="text/javascript">
                function isValidPrice(obj, evt) {

                    var key = (evt.which) ? evt.which : event.keyCode

                    var parts = (typeof evt.target != 'undefined') ? obj.value.split('.') : evt.srcElement.value.split('.');

                    //          var parts = evt.srcElement.value.split('.') || obj.value.split('.');
                    //          alert(parts); 
                    if (parts.length > 1 && key == 46)
                        return false;

                    if (!((key > 47 && key <= 57) || (key == 46) || (key == 8) || (key == 13) || (key == 9) || (key == 0) || (key == 127))) {
                        return false;
                    }
                    return true;
                }
            </script>
    <script type="text/javascript">
        //added by priya
        $(function () {
   
            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
    </script>

            <div>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                                <ul style="line-height: 20px">
                                    <li>Allows mapping the installer’s products to a specific price band.<br />
                                    </li>
                                </ul>
                                </div>
                                    </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <fieldset>
                                    <legend><b style="color: red; font-size: 14px;">Manage Installer Price Band</b></legend>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                            <ContentTemplate>
                                                <table width="100%">
                                                  
                                                    <tr>
                                                        <td colspan="7">
                                                            <hr />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1">
                                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Select Installer" Width="112px"
                                                                EnableViewState="false"></asp:Label>
                                                        </td>
                                                        <td class="style1">
                                                            <asp:DropDownList ID="ddlInstaller" runat="server" OnSelectedIndexChanged="ddlInstaller_SelectedIndexChanges"
                                                                AutoPostBack="true">
                                                            </asp:DropDownList>
                                                        </td>



                                                    </tr>
                                                    <tr runat="server" id="trCurrentBand" visible="false">
                                                        <td class="style1">
                                                            <asp:Label runat="server" Font-Bold="True" Text="Assigned Price Band : " Width="112px"
                                                                EnableViewState="false"></asp:Label>
                                                            </td>
                                                        <td class="style1">
                                                            <asp:Label ID="lblCurrentPriceBand" runat="server" Font-Bold="True" Text="N/A " Width="112px"
                                                                EnableViewState="false"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr runat="server" id="trUpdatePriceBand" visible="false">
                                                         <td class="style1">
                                                            <asp:Label runat="server" Font-Bold="True" Text="Change Price Band : " Width="112px"
                                                                EnableViewState="false"></asp:Label>
                                                            </td>
                                                          <td class="style1">
                                                            <asp:DropDownList runat="server" ID="ddlPriceBandMaster" ></asp:DropDownList>
                                                            <asp:Button ID="btnSave" runat="server" Text="Save" Width="118px" ValidationGroup="e"
                                        OnClick="btnSave_Click" />
                                                        </td>
                                                    </tr>
                                                
                                                    
                                                
                                                    
                                                 
                                                </table>
                                                </td> 
                                            </tr>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel2">
                                            <ProgressTemplate>
                                                <div style="text-align: center;">
                                                    <span style="text-align: center"><b>Please wait...</b></span>
                                                </div>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">&nbsp;
                                    
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                    </table>


               

            </div>
            <asp:Literal runat="server" ID="ltrNoMap" Visible="false" Text="No Product mapped with this Installer."></asp:Literal>
            <asp:Literal runat="server" ID="ltrProdPriceUpdate" Visible="false" Text="Installers Price Band updated successfully."></asp:Literal>
            <asp:Literal runat="server" ID="ltrEntered" Visible="false" Text="Please ensure you have entered all the details and modified at least one price."></asp:Literal>
            <asp:Literal runat="server" ID="ltrNoProdMap" Visible="false" Text="No Products mapped with this Installer."></asp:Literal>
            <asp:Literal runat="server" ID="ltrSelectInstaller" Visible="false" Text="Please select an Installer to update price."></asp:Literal>
            <asp:Literal runat="server" ID="ltrProdPriceDeleted" Visible="false" Text="Installers Price Band deleted successfully."></asp:Literal>
            <asp:Literal runat="server" ID="ltrOrderPlaced1" Visible="false" Text="An order had previously been placed by this Installer with another currency. Please select "></asp:Literal>
            <asp:Literal runat="server" ID="ltrOrderPlaced2" Visible="false" Text=" to continue."></asp:Literal>



</asp:Content>

