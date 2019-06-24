<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ManageAppSetting.aspx.cs" Inherits="ADMIN_ManageAppSetting" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <script language="javascript" type="text/javascript">
        function ConfirmDelete() {
            return confirm('Are you sure you want to delete?');
        }

    </script>
    <style type="text/css">
        .chkListStyle td
        {
            padding-left: 35px;
        }
        
        .chkListStyle label
        {
            padding-left: 5px;
        }
        .style1
        {
            height: 62px;
        }
    </style>
    <br />
    <div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <fieldset>
                        <legend><b style="color:red; font-size:14px;">Application Setting</b></legend>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <br />
                                    <ul>
                                        <li><span style="font-weight: bold">Use Comma ',' as a separators for multiple
                                            Email Id's </span></li>
                                          <span style="font-weight: bold">  Example:</span> abc@csldual.com,xyz@csldual.com
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="95%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width: 20%">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                                <asp:DropDownList runat="server" ID="ddlAppSetting" OnSelectedIndexChanged="ddlAppSetting_SelectedIndexChanged" AutoPostBack="true" ></asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAppSetting" runat="server" Width="500px" ></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                &nbsp;
                                            </td>
                                            <td class="style1">
                                                &nbsp; &nbsp; &nbsp; &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%">
                                            </td>
                                            <td>
                                                <asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnSave_Click" Width="100px"
                                                    ValidationGroup="u" />
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
    <asp:Literal runat="server" ID="ltrAppSett" Visible="false" Text="App Setting updated successfully."></asp:Literal>
</asp:Content>
