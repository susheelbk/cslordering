<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageARCProductPrice.aspx.cs" Inherits="ADMIN_ManageARCProductPrice" %>

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
            debugger;
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
                    <ul style="line-height:20px">
                        <li>
                            The product under ARC can be given offer price and expiry for that offer.<br />
                        </li>
                        <li>
                            The offer can be deleted.<br />
                        </li>
                    </ul>
                    </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage ARC Product Price</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <table width="100%">
                                        <tr>
                                            <td class="style1">
                                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Select ARC's" Width="112px"
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1">
                                                <asp:DropDownList ID="ddlArc" runat="server" OnSelectedIndexChanged="ddlArc_SelectedIndexChanges"
                                                    AutoPostBack="true">
                                                </asp:DropDownList>
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
                                                        CellPadding="4" Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15" OnPageIndexChanging="gvProducts_PageIndexChanging">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="ProductCode" HeaderText="Code" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="ProductName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="ProductPrice" HeaderText="Actual Price" HeaderStyle-HorizontalAlign="Left" />


                                                            <asp:TemplateField HeaderText="Offer Price">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtPrice" runat="server" Text='<%#  Convert.ToString(Eval("Price"))%>'
                                                                        Width="50px" onKeyPress="return isValidPrice(this,event);"></asp:TextBox>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="ExpiryDate">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtExpiryDate" runat="server" Text='<%#Convert.ToString(Eval("ExpDate")) %>'
                                                                        Width="80px" ValidationGroup="e"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*"
                                                                        ControlToValidate="txtExpiryDate" ValidationExpression="^[0-9m]{1,2}/[0-9d]{1,2}/[0-9y]{4}$"
                                                                        ValidationGroup="e" Display="Dynamic" SetFocusOnError="true" ForeColor="Red"></asp:RegularExpressionValidator>
                                                                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtExpiryDate" Format="dd/MM/yyyy"
                                                                        Enabled="true">
                                                                    </asp:CalendarExtender>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="ProductId" runat="server" Text='<%# Eval("ProductId") %>' />

                                                                </ItemTemplate>
                                                            </asp:TemplateField>

                                                            <asp:TemplateField HeaderText="Delete">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkDelete" runat="server" />
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
                                    <asp:Button ID="btnDeleted" runat="server" Text="Delete" Width="118px" OnClick="btnDeleted_Click"
                                        OnClientClick="ResetMsg()" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrNoMap" Visible="false" Text="No Product mapped with this ARC."></asp:Literal>
    <asp:Literal runat="server" ID="ltrProdPriceUpdate" Visible="false" Text="ARC's Product Price updated successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEntered" Visible="false" Text="Please ensure you have entered an ARC Price and an Expiry Date."></asp:Literal>
    <asp:Literal runat="server" ID="ltrNoProdMap" Visible="false" Text="No Products mapped with this ARC."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectARC" Visible="false" Text="Please select an ARCs to update price."></asp:Literal>
    <asp:Literal runat="server" ID="ltrProdPriceDeleted" Visible="false" Text="ARC's Product Price deleted successfully."></asp:Literal>
</asp:Content>

