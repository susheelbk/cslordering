<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/ADMIN/AdminMaster.master"
    CodeFile="ManageUser.aspx.cs" Inherits="ManageUser" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
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
        .chkListStyle td {
            padding-left: 35px;
        }

        .chkListStyle label {
            padding-left: 5px;
        }
    </style>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
               
                <div id="accordion">
                    <h3><b>Page Description</b></h3>
                    <div>
                        <ul style="line-height: 20px">
                            <li>The user can be searched by
                                <br />
                                1.	User Name<br />
                                2.	Roles<br />
                                3.	E-Mail ID<br />
                                4.	ARC Code
                                <br />
                                5.	ARC Name<br />
                            </li>
                            <li>A new user can be created, related to an ARC and roles can be allotted to the user.<br />
                            </li>
                            <li>The user details can be edited and saved.
                            </li>
                        </ul>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <fieldset>
                    <legend><b style="color: red; font-size: 14px;">Manage User</b></legend>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="100%">
                                <asp:Panel ID="pnluserlist" runat="server">
                                    <table width="100%">
                                        <tr>
                                            <td>
                                                <asp:Label ID="Lbluname" runat="server" Font-Bold="True" Text="User Name"></asp:Label>
                                                <asp:TextBox ID="Txtunamesrch" runat="server" Width="100px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Role"></asp:Label>
                                                <asp:DropDownList ID="ddrolesrch" runat="server" Width="130px">
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="E-Mail"></asp:Label>
                                                <asp:TextBox ID="Txtuemailsrch" runat="server" Width="130px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="ARC-Code"></asp:Label>
                                                <asp:TextBox ID="txtArcCodeSrch" runat="server" Width="100px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="ARC-Name"></asp:Label>
                                                <asp:TextBox ID="Txtuarcsrch" runat="server" Width="100px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" CssClass="css_btn_class" OnClick="btnSearch_Click" />
                                            </td>
                                            <td>
                                                <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" CssClass="css_btn_class" OnClick="btnShowAll_Click" />
                                            </td>
                                        </tr>
                                        <tr>

                                            <td colspan="7">Choose a User from below to edit    OR 
                                                <asp:Button ID="btnnewuser" runat="server" Text="Create new USER"
                                                    CssClass="css_btn_class" OnClick="btnnewuser_Click"></asp:Button>

                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="7">
                                                <div id="ScrollList">
                                                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CellPadding="4"
                                                        Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                        OnPageIndexChanging="gvUsers_PageIndexChanging" EmptyDataText="No Data Found">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <EmptyDataTemplate>
                                                            <asp:Label ID="lblNoRow" runat="server" Text="No Records Found!" ForeColor="Red"
                                                                Font-Bold="true"></asp:Label>
                                                        </EmptyDataTemplate>
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex +1%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="UserName" HeaderText="User Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="Email" HeaderText="Email Id" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="RoleName" HeaderText="Role" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="ARC_Code" HeaderText="ARC Code" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="CompanyName" HeaderText="ARC" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="UserKey" runat="server" Text='<%# Eval("UserId") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LinkButtonupdate_click">Edit</asp:LinkButton>
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
                        <asp:Panel ID="pnluserdetails" runat="server" Visible="false">
                            <tr>
                                <td>
                                    <table width="95%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="2">
                                                <asp:Literal ID="litAction" runat="server"></asp:Literal>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    User Name *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtuname" runat="server" MaxLength="35" Width="200px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtuname"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr runat="server" id="trPassLnk">
                                            <td>&nbsp;
                                                <asp:LinkButton runat="server" Text="Change Password.." ID="lnkChangePassword" OnClick="lnkChangePassword_Click"></asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr runat="server" id="trPass" visible="false">
                                            <td class="style4">
                                                <label>
                                                    Password *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtpwd" runat="server" TextMode="Password" MaxLength="35" Width="200px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtpwd"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr runat="server" id="trPassConf" visible="false">
                                            <td class="style4">
                                                <label>
                                                    Confirm Password *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" MaxLength="35" Width="200px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtConfirmPwd"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="PasswordConfirmCompareValidator" runat="server" ControlToValidate="txtConfirmPwd"
                                                    ForeColor="red" Display="Static" ControlToCompare="txtpwd" ValidationGroup="u"
                                                    ErrorMessage="Confirm password must match password." />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    Security Question *</label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlSecurityQuestion" TabIndex="8" runat="server" Width="220">
                                                    <asp:ListItem Text="What is your favourite Colour" Value="Fav Colour"></asp:ListItem>
                                                    <asp:ListItem Text="What was the make of your first car" Value="First Car"></asp:ListItem>
                                                    <asp:ListItem Selected="True" Text="What is your favourite place" Value="Favourite Place"></asp:ListItem>
                                                    <asp:ListItem Text="What is your Mother's Maiden Name" Value="Mothers Maiden Name"></asp:ListItem>
                                                    <asp:ListItem Text="Who is your favourite sports person" Value="Fav Sports Person"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlSecurityQuestion"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4">
                                                <label>
                                                    Security Answer *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAnswer" runat="server" MaxLength="35"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtAnswer"
                                                    ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    E-mail *</label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="Txtuemail" runat="server" Width="200px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Txtuemail"
                                                    ErrorMessage="*" ForeColor="#FF5050" SetFocusOnError="True" ValidationGroup="u"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                    ControlToValidate="Txtuemail" runat="server" ForeColor="#FF5050" ErrorMessage="Invalid Email address"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <label>
                                                    ARC *</label>
                                            </td>
                                            <td style="width: 820px;">
                                                <asp:DropDownList ID="ddlARC" runat="server">
                                                </asp:DropDownList>
                                                <span style="font-style: italic">You can type the first few characters to select..</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="ChkBoxIsBlocked" Text="Is Blocked" runat="server" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="ChkBoxIsapproved" Checked="false" Text="Is Approved" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label4" runat="server" Text="ROLES"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 300px;">
                                    <asp:CheckBoxList ID="Chkboxroles" runat="Server" RepeatColumns="2" RepeatLayout="Table"
                                        TextAlign="Right" Height="27px" Width="700px" CssClass="chkListStyle">
                                    </asp:CheckBoxList>
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
                                <td align="right">
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
                                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="css_btn_class" Style="width: 118px;" OnClick="btnReset_Click" />
                                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" Style="width: 118px; margin-right: 20px" CssClass="css_btn_class"
                                        ValidationGroup="u" />
                                </td>
                            </tr>
                        </asp:Panel>
                    </table>
                </fieldset>
            </td>
        </tr>
    </table>
    <asp:Literal runat="server" ID="ltrSelectARC" Visible="false" Text="Please select an ARC for this user."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectRole" Visible="false" Text="Please select a role for this user."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEmailExists" Visible="false" Text="The E-mail ID already exists."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFill" Visible="false" Text="Please fill the marked places."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDeleted" Visible="false" Text="User Deleted Successfully."></asp:Literal>
</asp:Content>
