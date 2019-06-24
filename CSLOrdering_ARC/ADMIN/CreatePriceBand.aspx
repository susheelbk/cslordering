<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="CreatePriceBand.aspx.cs" Inherits="ADMIN_CreatePriceBand" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .style1 {
            height: 26px;
        }
    </style>
    <script type="text/javascript">
        //added by priya
        $(function () {
            
            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
    </script>
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
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
                            Each band has got a price set for all the products listed on M2M Connect<br />
                        </li>
                        <li>
                            A new price band can be created and can be assigned price for each M2M connect product.<br />
                        </li>
                    </ul>
                   </div>
                        </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Create Price Band</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <table width="100%">
                                        
                                        <tr>
                                            <td class="style1">
                                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Select Price Band" Width="112px"
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1">
                                                <asp:DropDownList ID="ddlPriceBand" runat="server" OnSelectedIndexChanged="ddlPriceBand_SelectedIndexChanges"
                                                    AutoPostBack="true" Visible="false">
                                                </asp:DropDownList>
                                                <asp:TextBox runat="server" ID="txtNewPriceBand" Visible="false" MaxLength="100" />
                                                <asp:Button Text="Create New Band" runat="server" ID="btnNewPriceBand" OnClick="btnNewPriceBand_Click" CssClass="css_btn_class" Visible="false" />
                                                <asp:Button Text="Add" runat="server" ID="btnAddNewPriceBand" OnClick="btnAddNewPriceBand_Click" CssClass="css_btn_class" Visible="false" />
                                                <asp:Button Text="Cancel" runat="server" ID="btnCancelNewPriceBand" OnClick="btnCancelNewPriceBand_Click" CssClass="css_btn_class" Visible="false" />
                                            </td>
                                        </tr>
                                        <tr runat="server" id="trCurrency" visible="false">
                                            <td class="style1">
                                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Select Currency" Width="112px"
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList runat="server" ID="ddlCurrency" AutoPostBack="true" OnSelectedIndexChanged="ddlCurrency_SelectedIndexChanged"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="7">
                                                <div>
                                                    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductId"
                                                        CellPadding="4" Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="100"
                                                        OnPageIndexChanging="gvProducts_PageIndexChanging">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="ProductCode" HeaderText="Code" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="ProductName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:TemplateField HeaderText="Currency">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblCurrency" runat="server" Text='<%#  Convert.ToString(Eval("CurrencySymbol"))%>'
                                                                        Width="50px"></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Price">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtPrice" runat="server" Text='<%#  Convert.ToString(Eval("Price"))%>'
                                                                        Width="50px" onKeyPress="return isValidPrice(this,event);"></asp:TextBox>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="AnnualPrice">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtAnnualPrice" runat="server" Text='<%#  Convert.ToString(Eval("AnnualPrice"))%>'
                                                                        Width="50px" onKeyPress="return isValidPrice(this,event);"></asp:TextBox>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="ProductId" runat="server" Text='<%# Eval("ProductId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <PagerStyle BackColor="#284775" CssClass="gridPage" ForeColor="White" HorizontalAlign="Center" />
                                                        <PagerSettings Mode="NumericFirstLast" />
                                                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <EditRowStyle BackColor="#999999" />
                                                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                    </asp:GridView>
                                                </div>
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
                                    <asp:Button ID="btnSave" runat="server" Text="Save" Width="118px" ValidationGroup="e"
                                        OnClick="btnSave_Click" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrNoMap" Visible="false" Text="No Product mapped with this Price Band."></asp:Literal>
    <asp:Literal runat="server" ID="ltrProdPriceUpdate" Visible="false" Text="Price Band updated successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEntered" Visible="false" Text="Please ensure you have entered all the details and modified at least one price."></asp:Literal>
    <asp:Literal runat="server" ID="ltrNoProdMap" Visible="false" Text="No Products mapped with this Installer."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectInstaller" Visible="false" Text="Please select a Price Band to update price."></asp:Literal>
    <asp:Literal runat="server" ID="ltrBandExists" Visible="false" Text="Price Band name already exists."></asp:Literal>
    <asp:Literal runat="server" ID="ltrBandCreated" Visible="false" Text="Price Band created."></asp:Literal>
    <asp:Literal runat="server" ID="ltrBandNotCreated" Visible="false" Text="Price Band not created."></asp:Literal>
    <asp:Literal runat="server" ID="ltrBandNameLength" Visible="false" Text="Price Band must be 1 character."></asp:Literal>
    <asp:Literal runat="server" ID="ltrCreateBand" Visible="false" Text="Price Band and Currency combination does not exist, please create first."></asp:Literal>
</asp:Content>

