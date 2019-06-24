<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageARC_AccessCode.aspx.cs" Inherits="ADMIN_ManageARC_AccessCode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
<script type="text/javascript">
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
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
   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <div style="float: left; width:100%">
         
    <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                   <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
                            All products of an ARC have an access code associated with it via its PRM. <br />
                        </li>
                        <li>
                            A new access code can be created for ARC.<br />
                        </li>
                        <li>
                            The access code can be edited/deleted.<br />
                        </li>
                    </ul>
                   </div>
                       </div>
                </td>
            </tr>
        </table>
        <asp:Button ID="btnAdd" runat="server" Text="Add New" CssClass="css_btn_class" OnClick="btnAdd_Click" />&nbsp;
        <br />
        <asp:GridView Width="100%" ID="gvARCIns" runat="server" 
            AutoGenerateColumns="False" DataKeyNames="ARCId"
            OnRowEditing="gvARCIns_RowEditing" OnRowCancelingEdit="gvARCIns_RowCancelingEdit"
            OnRowDataBound="gvARCIns_RowDataBound" 
            OnRowUpdating="gvARCIns_RowUpdating" HeaderStyle-BackColor="#FF6257" 
            onrowdeleting="gvARCIns_RowDeleting">
            <Columns>
                <asp:TemplateField HeaderText="ARC" ItemStyle-Width="40%" HeaderStyle-Width="40%" HeaderStyle-HorizontalAlign="Left">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlArc" runat="server" Width="200px">
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblArc" runat="server" Text='<%# Bind("ARCDisp") %>' Font-Size="Medium"></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left"  width="20%"></HeaderStyle>
                    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Installer" ItemStyle-Width="20%" HeaderStyle-Width="20%" HeaderStyle-HorizontalAlign="Left">
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlInstallerUnqCode" runat="server"  Width="200px">
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                     <asp:Label ID="Label1" runat="server" Text='<%# Bind("CompanyName") %>' Font-Size="Medium"></asp:Label>
                        <asp:Label Visible="false" ID="lblInstallerUnqCode" runat="server" Text='<%# Bind("UniqueCode") %>' Font-Size="Medium"></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left"  width="30%"></HeaderStyle>                    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="AccessCode" ItemStyle-Width="10%" HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Left">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtAccessCode" onkeypress="return isNumber(event)" MaxLength="10" Text="" runat="server"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblAccessCode" runat="server" Text='<%# Bind("Accesscode") %>' Font-Size="Medium"></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left"  width="30%"></HeaderStyle>
                    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action" ItemStyle-Width="10%" HeaderStyle-Width="10%">
                    <EditItemTemplate>
                        <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" Text="Update"
                            CommandArgument='<%# Bind("ID") %>'></asp:LinkButton>
                        <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEdit"  runat="server" CommandName="Edit" Text="Edit" CommandArgument='<%# Bind("ID") %>'></asp:LinkButton>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left"  width="20%"></HeaderStyle>
                    
                </asp:TemplateField>
                <asp:CommandField HeaderText="Delete" ShowDeleteButton="True"  />
            </Columns>
        </asp:GridView>
       </div>
    <asp:Literal runat="server" ID="ltrInsertSuccess" Visible="false" Text="Insert Successful."></asp:Literal>
    <asp:Literal runat="server" ID="ltrInsertFail" Visible="false" Text="Insert Failed, Please Select All Values."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUpdateSuccess" Visible="false" Text="Update Successfull."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUpdateFail" Visible="false" Text="Update Failed, Please Select All Values."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDeleteSuccess" Visible="false" Text="Deleted."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDeleteFail" Visible="false" Text="Delete Failed."></asp:Literal>
</asp:Content>
