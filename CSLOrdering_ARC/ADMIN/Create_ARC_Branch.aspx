<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Create_ARC_Branch.aspx.cs" Inherits="ADMIN_Create_ARC_Branch" %> 
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
        <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div id="accordion">
                        <h3><b>Page Description</b></h3>
                        <div>
                            <ul style="line-height: 20px">
                                <li>The new ARC branch will be created under ARC.<br />
                                </li>

                            </ul>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage ARC Branch</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                    <table width="100%">
                                        <tr>
                                            <td class="style1" width="30%">
                                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Select ARC's" Width="112px"
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1" width="70%">
                                                <asp:DropDownList ID="ddlArc" runat="server" OnSelectedIndexChanged="ddlArc_SelectedIndexChanges"
                                                    AutoPostBack="true" Width="404px" >
                                                </asp:DropDownList>
                                                  <asp:Label ID="lblNOARCsAvailable" Text="Please select Manage ARC link and set the option Is ARC Allowed For Branch to the ARC"
                                                                    runat="server" ForeColor="Red" Width="100%"></asp:Label>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="ddlArc" InitialValue="0"
                                                     runat="server" ErrorMessage="*" ForeColor="#FF5050"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <td class="style1"  width="30%">
                                                <asp:Label ID="lblBranchArcCode" runat="server" Font-Bold="True" Text="Branch ARC Code*" 
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1" width="70%">
                                                <asp:TextBox ID="txtBranchArcCode" runat="server" Width="400px"  >
                                                </asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtBranchArcCode"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="arcBranch"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                           <tr>
                                            <td class="style1">
                                                <asp:Label ID="lblBranchArcName" runat="server" Font-Bold="True" Text="Branch ARC Name*" 
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1">
                                                <asp:TextBox ID="txtBranchArcName" runat="server" Width="400px"   >
                                                </asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtBranchArcName"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="arcBranch"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td class="style1">
                                                <asp:Label ID="lblBranchArcIdentifier" runat="server" Font-Bold="True" Text="Branch ARC Identifier" 
                                                    EnableViewState="false"></asp:Label>
                                            </td>
                                            <td class="style1">
                                               <asp:TextBox ID="txtBranchArcIdentifier" runat="server"  Width="400px"  >
                                                </asp:TextBox>
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtBranchArcIdentifier"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="arcBranch"></asp:RequiredFieldValidator>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">                                               
                                            </td>
                                            <td class="style1">
                                               <asp:CheckBox ID="chkIsDeleted" runat="server"  Text="Is Deleted" Visible="false">
                                                </asp:CheckBox>                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="7">
                                                <div>
                                                    
                                                    <asp:GridView ID="gvArcBranches" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"
                                                        CellPadding="2" Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15" OnPageIndexChanging="gvArcBranches_PageIndexChanging">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333"  />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>

                                                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="Branch_ARC_Code" HeaderText="Branch ARC Code" HeaderStyle-HorizontalAlign="Left">
                                                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Branch_ARC_Name" HeaderText="Branch ARC Name" HeaderStyle-HorizontalAlign="Left">
                                                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="Branch_ARC_Identifier" HeaderText="Branch ARC Identifier" HeaderStyle-HorizontalAlign="Left">
                                                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                                            </asp:BoundField>
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="ARCId" runat="server" Text='<%# Eval("ARCId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField> 
                                                            <asp:TemplateField HeaderText="Deleted">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkDelete" Enabled="false" runat="server" Checked='<%# Eval("IsDeleted") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Edit">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" OnClick="lnkEdit_Click" />
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
                                    <%--<asp:Button ID="btnDeleted" runat="server" visible="false" Text="Delete" Width="118px" OnClick="btnDeleted_Click"
                                        />--%>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:HiddenField ID="hdnAlarmDelARCMapId" Value="0" runat="server" />
    <asp:Literal runat="server" ID="ltrNoMap" Visible="false" Text="No branch mapped with this ARC."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectARC" Visible="false" Text="Please select an ARCs to create the branch."></asp:Literal>
    <asp:Literal runat="server" ID="ltrCreateArc" Visible="false" Text="ARCs branch created successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUpdateArcBranch" Visible="false" Text="ARCs branch updated successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrAlreadyExits" Visible="false" Text="Branch name or code already exists for selected ARCs."></asp:Literal>
    <asp:Literal runat="server" ID="ltrArcBranchDeleted" Visible="false" Text="ARCs branch deleted successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrNoSelectedToDelete" Visible="false" Text="Please select records to delete."></asp:Literal>
</asp:Content>

