<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageProductCategory.aspx.cs" Inherits="ADMIN_ManageProductCategory" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        .style1
        {
            width: 255px;
        }
          .style2
        {
            width: 25%;
        }
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />
    <script language="javascript" type="text/javascript">

        function ConfirmDelete() {
            return confirm('Are you sure you want to delete?');
        }
     
    </script>
    <div>
        <table width="102%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <hr />
                    <ul>
                        <li> Page not in use</li>
                    </ul>
                    <hr />
                </td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color: red; font-size: 14px;">Manage Category Related Product</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="95%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                Select Category *
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlCategory" runat="Server" AutoPostBack="true"  Height="20px" 
                                                    Width="269px" onselectedindexchanged="ddlCategory_SelectedIndexChanged"  >
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                          <asp:Panel ID="pnlProductList" runat="server" Visible="false">
                                        <tr>
                                        
                                            <td colspan="2" style="width: 300px;">
                                                <asp:UpdatePanel ID="upProduct" runat="server">
                                                    <ContentTemplate>
                                                        <div style="padding-left: 10px;">
                                                            <asp:Panel ID="pnlOverallHeader" runat="server" Height="40px" SkinID="NoSkin" Width="800px">
                                                                <div style="float: left; width: 750px" class="Trackerbutton">
                                                                    <asp:Label ID="lblProducts" Text="Related Products for this category" runat="server" Font-Bold="true"></asp:Label>
                                                                </div>
                                                                <div style="float: right; width: 30px; vertical-align: middle;">
                                                                    <asp:ImageButton ID="ImageButtonProductsOverallSummary" runat="server" ImageUrl="../Images/collapse.jpg"
                                                                        AlternateText="(Show Details...)" />
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="pnlSearchProduct" runat="server">
                                                                <table style="background-color: #fff; border: none; margin-left: 5px; width: 800px;"
                                                                    cellspacing="5">
                                                                    <tr>
                                                                        <td>
                                                                            <%--<asp:Panel ID="pnlProduct" runat="server" Height="300" ScrollBars="Auto" HorizontalAlign="Left"
                                                                                BackColor="White" BorderStyle="Solid" BorderWidth="3" BorderColor="#CFCFCF">
                                                                                <asp:CheckBoxList ID="CheckBoxProd" runat="Server" RepeatColumns="3" CssClass="CheckBoxList3"
                                                                                    Width="100%">
                                                                                </asp:CheckBoxList>
                                                                            </asp:Panel>--%>
                                                                              <asp:GridView ID="gvctg" runat="server" AutoGenerateColumns="False" RowStyle-BackColor="#F6CECE"
                                                                         BorderStyle="None" CellPadding="0" CellSpacing="0"
                                                                        DataKeyNames="CategoryID" Font-Size="10" Font-Names="Arial" GridLines="none"
                                                                        Width="100%" OnRowDataBound="gvctg_RowDataBound">
                                                                        <Columns>
                                                                            <asp:TemplateField>
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="chkctg" runat="server" AutoPostBack="true" Text='<%# Eval("CategoryDisp") %>'
                                                                                        OnCheckedChanged="chkctg_CheckedChanged" />
                                                                                    <asp:GridView ID="gvinner" RowStyle-BackColor="White" AutoGenerateColumns="False"
                                                                                        BorderStyle="None"  CellPadding="0" CellSpacing="0"
                                                                                        DataKeyNames="ProductId" Font-Size="10" Width="100%" Font-Names="Arial" GridLines="none"
                                                                                        runat="server" ShowHeader="false">
                                                                                        <Columns>
                                                                                            <asp:TemplateField HeaderStyle-BackColor="white">
                                                                                                <ItemTemplate>
                                                                                                    <asp:CheckBox ID="chkprod" width="4%" runat="server" OnCheckedChanged="chkprod_CheckedChanged"  AutoPostBack="true"  />
                                                                                                </ItemTemplate>
                                                                                            </asp:TemplateField>
                                                                                            <asp:BoundField HeaderStyle-BackColor="White" ItemStyle-Width="96%" DataField="ProductDisp" />
                                                                                        </Columns>
                                                                                    </asp:GridView>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                        <RowStyle BackColor="#F6CECE"></RowStyle>
                                                                    </asp:GridView>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </asp:Panel>
                                                            <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server" TargetControlID="pnlSearchProduct"
                                                                ExpandedImage="../Images/collapse.jpg" CollapsedImage="../Images/expand.jpg"
                                                                SuppressPostBack="false" Collapsed="false" ExpandControlID="pnlOverallHeader"
                                                                ImageControlID="ImageButtonProductsOverallSummary" CollapseControlID="pnlOverallHeader">
                                                            </cc1:CollapsiblePanelExtender>
                                                        </div>
                                                        <br />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upProduct">
                                                    <ProgressTemplate>
                                                        <div style="text-align: center;">
                                                            <span style="text-align: center"><b>Please wait...</b></span>
                                                        </div>
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                                
                                            </td>
                                           
                                        </tr>
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                <asp:Button ID ="btnReset" runat="server" Text="Reset" OnClientClick="" CssClass="css_btn_class" Style="Width:118px;" OnClick="btnReset_Click" />
                                                <asp:Button ID="Btnsave" runat="server" Text="Save" ValidationGroup="a"
                                                    OnClick="btnSave_Click" CssClass="css_btn_class" Style="Width:118px;margin-right:-350px"/>
                                            </td>
                                        </tr>
                                         </asp:Panel>
                                        <tr>
                                            <td class="style2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrSaved" Visible="false" Text="Successfully Saved."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFill" Visible="false" Text="Please fill required details correctly."></asp:Literal>
    <asp:Literal runat="server" ID="ltrChooseCat" Visible="false" Text="Please choose a Category."></asp:Literal>
    <asp:Literal runat="server" ID="ltrNoProd" Visible="false" Text="There are no related products set under this Category."></asp:Literal>
</asp:Content>
