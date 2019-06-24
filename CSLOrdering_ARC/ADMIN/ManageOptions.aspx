<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageOptions.aspx.cs" Inherits="ADMIN_ManageOptions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .style1
        {
            width: 255px;
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

        function ConfirmDelete() {
            return confirm('Are you sure you want to delete?');
        }
     
    </script>
    <div>
        <table width="102%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                   <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style ="line-height:20px">
                        <li>
                                Options are the protocol for communicating the alarm signals like Contact ID, FastFormat, and SIA.<br />
                        </li>
                        <li>
                            A new option can be created.<br />
                        </li>
                        <li>
                           An option can be edited/deleted.<br />
                        </li>
                    </ul>
                   </div>
                       </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Options</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="100%">
                                <asp:Panel ID="pnlOptionList" runat="server">
                                    <table width="100%">
                                        <tr>
                                            <td valign="top" class="style1">
                                                Option Name: &nbsp;
                                                <asp:TextBox ID="txtoptsrch" runat="server"></asp:TextBox>
                                            </td>
                                            <td colspan="2">
                                                <asp:Button ID="Btnsrch" runat="server" Text="Search" Width="130" CssClass="css_btn_class" OnClick="btnSearch_Click" />
                                                <asp:Button ID="btnShowAll" runat="server" Text="ShowAll" Width="130" CssClass="css_btn_class" OnClick="btnShowAll_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                        <td colspan="3">
                                                Choose an Option from below to edit    OR  
                                                <asp:Button ID="btnNewOption"  runat="server" Text="Create new OPTION" 
                                                    CssClass="css_btn_class" onclick="btnNewOption_Click"></asp:Button>  
                                                  
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="7">
                                                <div id="ScrollList">
                                                    <asp:GridView ID="gvOpt" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                        Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                        OnPageIndexChanging="gvopt_PageIndexChanging">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <EmptyDataTemplate>
                                                            <asp:Label ID="lblNoRow" runat="server" Text="No Records Found For This Date!" ForeColor="Red"
                                                                Font-Bold="true"></asp:Label>
                                                        </EmptyDataTemplate>
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="OptID" runat="server" Text='<%# Eval("OptID") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="OptionName" HeaderText="Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="OptionDesc" HeaderText="Decription" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LinkButtonupdate_click">Edit</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtondelete" runat="server" OnClientClick="return ConfirmDelete();"
                                                                        OnClick="LinkButtondelete_click">Delete</asp:LinkButton>
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
                                    </asp:Panel>
                                </td>
                            </tr>
                            <tr> 
                                <td>
                                <asp:Panel ID="pnlOptionDetails" runat="server" Visible="false">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                               <asp:Literal runat="server" ID="litAction" Text=""></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                <label>
                                                    Option Name *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtoptName" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtoptName"
                                                    ErrorMessage="*" ForeColor="#FF3300" SetFocusOnError="True" ValidationGroup="a"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                <label>
                                                    Description</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtdesc" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                              
                                                <Span style="font-style:italic">* Required Fields</Span>
                                            
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" colspan="2">
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                                                    onclick="btnCancel_Click" />
                                    <asp:Button ID ="btnReset" runat="server" Text="Reset" CssClass="css_btn_class" 
                                                    Style="Width:118px;" onclick="btnReset_Click" />
                                                <asp:Button ID="Btnsave" runat="server" CssClass="css_btn_class" Text="Save" Width="148px" OnClick="Btnsave_Click"
                                                    ValidationGroup="a" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                     </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrOptionUpdated" Visible="false" Text="Option Updated."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOptionCreated" Visible="false" Text="Option Created."></asp:Literal>
    <asp:Literal runat="server" ID="ltrOptionDeleted" Visible="false" Text="Option Deleted."></asp:Literal>
</asp:Content>
