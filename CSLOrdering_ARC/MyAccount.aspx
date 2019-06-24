<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="MyAccount.aspx.cs" Inherits="MyAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="contentWrapper" runat="Server">
  <!--  <div>
        <ul style="line-height:20px">
            <li>
              This page lists the users under the ARC (ARC Manager role can access My Account).
            </li>
            <li>
           The user can be searched against Username/Role/Email.
            </li>
            <li>
             Show all button lists all the users under ARC(logged in user).
            </li>
            <li>
              Their details can be edited by clicking edit link in respective user row.  
                </li> 
            <li>
                Their password can be changed by clicking change password.
            </li>
            <li>
                The user can be blocked access by checking Is Blocked. The user can be allowed access by checking Is Approved.
            </li>
            <li>
                The Access Level to the user can be selected. Click Save to update the changes.
            </li>
            
            <li>
            The user can be deleted by clicking delete
            </li>
        </ul>
    </div>-->
    <script language="javascript" type="text/javascript">
        function ConfirmDelete() {
            return confirm('are you sure you want to delete?');
        }

    </script>
    <style type="text/css">
        .chkListStyle td {
            padding-right: 3px;
        }

        .chkListStyle label {
            padding-left: 5px;
        }
    </style>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />
    <br />
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <fieldset>
                        <legend>User</legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="100%">
                                    <table width="100%">
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Lbluname" runat="server" Font-Bold="True" Text="User Name"></asp:Label>
                                                    <asp:TextBox ID="Txtunamesrch" runat="server" Width="100px"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Role"></asp:Label>
                                                    <asp:DropDownList ID="ddrolesrch" runat="server" Width="130px">
                                                        <asp:ListItem Text="ARC_Admin" Value="ARC_Admin"></asp:ListItem>
                                                        <asp:ListItem Text="ARC_Manager" Value="ARC_Manager"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="E-Mail"></asp:Label>
                                                    <asp:TextBox ID="Txtuemailsrch" runat="server" Width="100px"></asp:TextBox>
                                                </td>
                                                <td valign="bottom">
                                                    <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" OnClick="btnSearch_Click" CssClass="css_btn_class" />
                                                </td>
                                                <td valign="bottom">
                                                    <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" OnClick="btnShowAll_Click" CssClass="css_btn_class" />
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td colspan="5">&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="5">
                                                <div>
                                                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CellPadding="4"
                                                        Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15" OnPageIndexChanging="gvUsers_PageIndexChanging">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex + 1 %>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="UserName" HeaderText="User Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="Email" HeaderText="Email" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="RoleName" HeaderText="Role" HeaderStyle-HorizontalAlign="Left" />
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
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtondelete" runat="server" OnClientClick="return ConfirmDelete();"
                                                                        OnClick="LinkButtondelete_click">Delete</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
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
                            <tr>
                                <td>
                                    <div id="divcreateuser" runat="server" visible="false">
                                        <table width="95%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 20%">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        User Name</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtuname" runat="server" MaxLength="35"></asp:TextBox>
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
                                                        Password</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtpwd" runat="server" TextMode="Password" MaxLength="35"></asp:TextBox>
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
                                                        Confirm Password</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" MaxLength="35"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtConfirmPwd"
                                                        ErrorMessage="*" ForeColor="#FF5050" ValidationGroup="u"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="PasswordConfirmCompareValidator" runat="server" ControlToValidate="txtConfirmPwd"
                                                        ForeColor="red" Display="Static" ControlToCompare="txtpwd" ErrorMessage="Confirm password must match password." />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        E-mail</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Txtuemail" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Txtuemail"
                                                        ErrorMessage="*" ForeColor="#FF5050" SetFocusOnError="True" ValidationGroup="u"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                        ControlToValidate="Txtuemail" runat="server" ForeColor="#FF5050" ErrorMessage="Invalid Email address"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 20%">
                                                    <label>
                                                        Security Question</label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlSecurityQuestion" TabIndex="8" runat="server" Width="220">
                                                        <asp:ListItem Text="What is your favourite Colour" Value="Fav Colour"></asp:ListItem>
                                                        <asp:ListItem Text="What was the make of your first car" Value="First Car"></asp:ListItem>
                                                        <asp:ListItem Selected="True" Text="What is your favourite place" Value="Favourite Place"></asp:ListItem>
                                                        <asp:ListItem Text="What is your Mother's Maiden Name" Value="Mothers Maiden Name"></asp:ListItem>
                                                        <asp:ListItem Text="Who is your favourite sports person" Value="Fav Sports Person"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlSecurityQuestion"
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
                                                        Security Answer</label>
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
                                        </table>
                                        <asp:Panel runat="server" ID="pnlManager">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:CheckBox ID="ChkBoxIsBlocked" Text="Is Blocked" runat="server" />
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox ID="ChkBoxIsapproved" Text="Is Approved" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label4" runat="server" Text="Access Level"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:CheckBoxList CellPadding="0" CellSpacing="0" ID="Chkboxroles" runat="Server"
                                                            RepeatColumns="1" RepeatLayout="Table" TextAlign="Right" Height="27px" CssClass="chkListStyle">
                                                            <asp:ListItem Value="2" Text="ARC_Manager"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="ARC_Admin"></asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text=" (Can view prices, manage users and view all orders under the same ARC.)"></asp:Label>
                                                        <br />
                                                        <asp:Label ID="Label3" runat="server" Text=" (Cannot view prices, manage other users or view other user's orders.)"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td align="center">&nbsp;
                                    <asp:Button ID="btnSave" runat="server" CssClass="css_btn_class" Text="Save" OnClick="btnSave_Click" Width="118px"
                                        ValidationGroup="u" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal runat="server" ID="ltrSixChars" Visible="false" Text="Password must be at least 6 characters."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectRole" Visible="false" Text="Please select a role for this user."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEmailExists" Visible="false" Text="The E-mail ID already exists."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFill" Visible="false" Text="Please fill the marked places."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUserDeleted" Visible="false" Text="User Deleted Successfully."></asp:Literal>
    <asp:Literal runat="server" ID="ltrNoMatch" Visible="false" Text="No matching results found."></asp:Literal>
</asp:Content>
