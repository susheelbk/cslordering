<%@ Page Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="MapInstallerARCToProducts.aspx.cs" Inherits="ADMIN_MapInstallerARCToProducts" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    
    <script type="text/javascript">
        //added by priya
        $(function () {

            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
        $(document).ready(function () {
            var select = $("#<%=lstProductsFrom.ClientID %>");
            var text = $("#<%=lblShowProductFrom.ClientID %>");
            select.change(function (e) {
                var result = "";
                var options = select.children("option:selected");
                $.each(options, function (i, el) {
                    result += $(el).val();
                    if (i < options.length - 1) {
                        result += ", ";
                    }
                });
              
               
                text.text(result);
            });

            var select1 = $("#<%=lstProductsTo.ClientID %>");
            var text1 = $("#<%=lblShowProductTo.ClientID %>");
         
            select1.change(function (e) {
                var result = "";
                var options = select1.children("option:selected");
                $.each(options, function (i, el) {
                    result += $(el).val();
                    if (i < options.length - 1) {
                        result += ", ";
                    }
                });

              
                text1.text(result);
            });

        });
    </script>
    <style type="text/css">
        .style1 {
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <div>
        <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: separate !important;">
            <tr>
                <td>
                   <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
	                        All Installers/Arc Mappings of a product can be mapped to another product.<br />
                        </li>
                        <li>
	                        Only the Products that has some mapping with Installers/ARcs will be listed on the Map From drop down Box.<br />
                        </li>
                        
                    </ul>
                       </div>
                       </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Mapping Installer/ARC With Products</b></legend>
                        <br />
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width: 20%">&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="style1" style="width: 50%">
                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Map From :" Width="200px"
                                        EnableViewState="false"></asp:Label>
                                </td>

                                <td class="style1">
                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Map To :" Width="300px"
                                        EnableViewState="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                   
                                 <asp:ListBox ID="lstProductsFrom"   runat="server" Height="200px" Width="350px" SelectionMode="Single" ClientIDMode="Static"   ></asp:ListBox>
                                     </td>
                                <td style="width: 30%">

                                 
                                <asp:ListBox ID="lstProductsTo" runat="server" Height="200px" Width="350px" SelectionMode="Single"></asp:ListBox>
                                     </td>
                            </tr>
                            <tr>
                                <td class="style1">
                                    <asp:Label ID="lblShowProductFrom" runat="server" Font-Bold="True"  Width="300px"
                                        EnableViewState="false"></asp:Label>
                                </td>
                                <td class="style1">
                                    <asp:Label ID="lblShowProductTo" runat="server" Font-Bold="True"  Width="300px"
                                        EnableViewState="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style1">&nbsp;
                                </td>
                                <td class="style1">&nbsp; &nbsp; &nbsp; &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%">
                                    <asp:CheckBox ID="chkInstallers" Text="Installers" runat="server" OnCheckedChanged="chkInstallers_CheckedChanged" AutoPostBack="true" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%">
                                    <asp:CheckBox ID="chkArcs" Text="Arcs" runat="server" OnCheckedChanged="chkArcs_CheckedChanged" AutoPostBack="true" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%">
                                    <asp:Label ID="lblChkInstallers"  runat="server" Text="* All the previous Installer Mappings will be deleted for product "  style=" font-size: 13px;" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                               <td style="width: 100%">
                                    <asp:Label ID="lblChkARCs"  runat="server" Text="* All the previous ARC Mappings will be deleted for product in 'Map To Product'" style=" font-size: 13px;" Visible="false"></asp:Label>
                                </td>
                            </tr>
                             <tr>
                               <td style="width: 100%">
                                    <asp:Label ID="lblProductWarn"  runat="server" Text="Please select Product" style=" font-size: 13px;color:red" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>

                                </td>
                                <td align="left" style="padding-right: 10px;">
                                    <asp:Button ID="btnCancel" ValidationGroup="" runat="server" Text="Cancel" OnClientClick=""
                                        OnClick="btnCancel_Click"   />

                                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                                        Style="width: 118px; margin-right: 10px" ValidationGroup="a" CssClass="css_btn_class" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
     

</asp:Content>
