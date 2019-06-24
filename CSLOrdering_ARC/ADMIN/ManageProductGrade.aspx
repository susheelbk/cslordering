<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageProductGrade.aspx.cs" Inherits="ADMIN_ManageProductGrade" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <link href="../Styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if (charCode < 48 || charCode > 57)
                    return false;
            return true;
        }

        function ConfirmDelete() {
            return confirm('Are you sure you want to delete?');
        }

        function isValidPrice(evt) {

            var key = (evt.which) ? evt.which : event.keyCode

            var parts = evt.srcElement.value.split('.');
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
    <style type="text/css">
        .style1
        {
            width: 278px;
        }
        
        .modalBackground
        {
            background-color: #666699;
            filter: alpha(opacity=50);
            opacity: 0.8;
        }
        
        .modalPopup
        {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: Red;
            width: 580px;
            padding: 2px;
            height: 400px;
            overflow: auto;
        }
    </style>
    <asp:Button ID="Btndummy" runat="server" Style="display: none;" />
    <cc1:ModalPopupExtender ID="PopupControlExtender2" runat="server" TargetControlID="Btndummy"
        PopupControlID="Panel1" BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" align="center" Style="display: none;
        vertical-align: middle;">
        <asp:CheckBoxList ID="Chklistproducts" runat="server" AutoPostBack="False" RepeatColumns="2"
            RepeatLayout="Table" TextAlign="Right">
        </asp:CheckBoxList>
        <asp:Button ID="btnSaveSibblings" runat="server" Text="OK" />
        <asp:Button ID="btncancel" runat="server" Text="Cancel" />
    </asp:Panel>
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                   <div id="accordion">
                            <h3><b>Page Description</b></h3>
                            <div>
                    <ul style="line-height:20px">
                        <li>
                            A product can be mapped to different grade.<br />
                        </li>
                        <li>
                            The grade mapping can be deleted.<br />
                        </li>
                    </ul>
                   </div>
                       </div>
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Product's Grade</b></legend>
                        <br />
                        <fieldset>
                            <legend>Product's Grade</legend>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="100%">
                                    <asp:Panel ID="pnlGradeList" runat="server">
                                        <table width="100%">
                                        <tr>
                                            <td colspan="7">
                                                Choose from below to edit    OR  
                                                <asp:Button ID="btnNewGrade"  runat="server" Text="Map new GRADE" 
                                                    CssClass="css_btn_class" onclick="btnNewGrade_Click"></asp:Button>  
                                                  
                                            </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">
                                                    <div>
                                                        <asp:GridView ID="gvGrade" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                            Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                            EmptyDataText="No Data Found">
                                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <%# Container.DataItemIndex + 1 %>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                  <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblProductGradeID" runat="server" Text='<%# Eval("ProductGradeID") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Product Code">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("ProductCode") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Grade">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblGrade" runat="server" Text='<%# Eval("Grade") %>' />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="LinkButtonupdate" runat="server"  OnClick="LinkButtonupdate_click">Edit</asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="LinkButtondelete" runat="server" OnClientClick="return ConfirmDelete();" OnClick="LinkButtondelete_click">Delete</asp:LinkButton>
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
                                    <asp:Panel ID="pnlGradeDetails" runat="server" Visible="false">
                                        <table width="95%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="2">
                                                     <asp:Literal runat="server" ID="litAction" Text=""></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        Product Code *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:TextBox ID="txtProductCode" runat="server" MaxLength="35" Width="150px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtProductCode"
                                                        ErrorMessage="*" ForeColor="#FF3300" SetFocusOnError="True" ValidationGroup="a"></asp:RequiredFieldValidator>
                                                    <cc1:AutoCompleteExtender ServiceMethod="GetCompletionList" MinimumPrefixLength="3"
                                                        CompletionInterval="0" EnableCaching="false" CompletionSetCount="10" TargetControlID="txtProductCode"
                                                        ID="autoCompleteExtender1" runat="server" FirstRowSelected="false">
                                                    </cc1:AutoCompleteExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <label>
                                                        Grade *</label>
                                                </td>
                                                <td class="style1">
                                                    <asp:DropDownList ID="ddlGrade" runat="server" Width="150px">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlGrade"
                                                        ErrorMessage="*" InitialValue="0" ForeColor="#FF5050" ValidationGroup="a" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                <Span style="font-style:italic">* Required Fields</Span>
                                                </td>
                                               
                                            </tr>
                                            <tr>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="padding-left: 100px;">
                                      <asp:Button ID="btnCancell" runat="server" Text="Cancel" OnClientClick="" 
                                            onclick="btnCancel_Click" />
                                    <asp:Button ID ="btnReset" runat="server" Text="Reset" CssClass="css_btn_class" 
                                            Style="Width:118px;" onclick="btnReset_Click" />
                                      <asp:Button ID="btnSave" runat="server" CssClass="css_btn_class" Text=" Save" Width="118px" ValidationGroup="a"
                                            OnClick="btnSave_Click" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <table>
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrDuplicate" Visible="false" Text="Duplicate Product-Code or Grade. Please Enter again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSaved" Visible="false" Text="Saved Successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrGrade" Visible="false" Text="Product's Grade Deleted Successfully."></asp:Literal>
</asp:Content>
