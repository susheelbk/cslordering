<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true" 
    CodeFile="OverrideBillingCodes.aspx.cs" Inherits="ADMIN_OverrideBillingCodes" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    
    </asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="contentWrapper">
    <div style="float: left; width:100%">
    <asp:Button ID="btnAddNew" runat="server" Text="Add New" CssClass="css_btn_class" OnClick="btnAddNew_Click" />
    <asp:GridView width="100%" ID="gvBillingCodes" runat="server"  style="margin-left: 0px; margin-top: 0px;" AutoGenerateColumns="False" OnRowCancelingEdit="gvBillingCodes_RowCancelingEdit" OnRowDeleting="gvBillingCodes_RowDeleting" OnRowEditing="gvBillingCodes_RowEditing" OnRowUpdating="gvBillingCodes_RowUpdating" HeaderStyle-BackColor="#FF6257"  >
        <Columns>
            <asp:TemplateField HeaderText="ID" Visible="false">
                <ItemTemplate>
                    <asp:Label ID="lblId" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="CompanyName">
                <EditItemTemplate>
                    <asp:TextBox ID="txtCompanyName" runat="server"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblCompanyName" runat="server" Text='<%# Bind("CompanyName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="OriginalCode">
                <EditItemTemplate>
                    <asp:TextBox ID="txtOriginalcode" runat="server"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblOriginalCode" runat="server" Text='<%# Bind("OriginalCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="OverrideCode">
                <EditItemTemplate>
                    <asp:TextBox ID="txtOverrideCode" runat="server"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblOverrideCode" runat="server" Text='<%# Bind("OverideCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Action">                              
                <EditItemTemplate>
                    <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" CommandArgument ='<%# Bind("id") %>'>Update</asp:LinkButton>
                    <br />
                    <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Bind("id") %>' CommandName="Edit">Edit</asp:LinkButton>
                </ItemTemplate>            
              
            </asp:TemplateField>
            <asp:CommandField HeaderText="Action" ShowDeleteButton="True" />
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

