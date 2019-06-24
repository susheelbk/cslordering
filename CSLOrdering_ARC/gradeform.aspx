<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="gradeform.aspx.cs" Inherits="gradeform" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/UserControls/Installers.ascx" TagName="Installers" TagPrefix="ucInstallers" %>

<asp:Content ID="Content3" ContentPlaceHolderID="contentWrapper" runat="Server">
        <link rel="stylesheet" media="all" type="text/css" href="https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<link rel="stylesheet" media="all" type="text/css" href="Styles/jquery-ui-timepicker-addon.css" />
    <table width="100%" border="0" cellspacing="1" cellpadding="5">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="5" align="center">
                            <asp:Label ID="lblTitle" runat="server" Style="font-size: 1.5em; font-weight: bold; text-decoration: underline;" />
                        </td>
                    </tr>
                  
                    <tr valign="top">
                        <td width="150" height="282">&nbsp;
                        </td>
                        <td width="600">
                            <table width="100%" border="0" cellspacing="1" cellpadding="5">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="150" height="282">&nbsp;
                                                </td>
                                                <td width="750">
                                                    <table width="750" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
                                                        <tr valign="top">
                                                            <td width="750" height="20" align="center" valign="middle">
                                                                <asp:Label ID="disText" runat="server">If transferring to another ARC please use Reassignment form. As airtime is charged by NUA please make sure that Dualcom has not been swapped etc. Please contact CSL Dualcom if confirmation is required.</asp:Label><asp:Label
                                                                    ID="recText" runat="server">Please note: Reconnection of Dual signaling can take up to 24 hours from notification. There is a £25.00 charge for each reconnection.</asp:Label>
                                                            </td>
                                                        </tr>
                                                          <tr>
                                                            <td colspan="5">
                                                                <div id="divregradeinst"  runat="server" >
                                                                <div id="accordion" >
                                                                            <h3><b>View Instructions >></b></h3>

                                                                            <div id="divEmizonInstructions" visible="false" runat="server">
                                                                                <h3><b><i>To process the regrade request, please follow instructions below:</i></b></h3>
                                                                                <ol>
                                                                                       <li>Please make sure your unit is in test mode for the given time slot for the regrade process.<br /></li>
                                                                                       <li>Select your installer company.<br /></li>
                                                                                       <li>Find your device by EM number or install ID for the request or key in the details on the required fields at the bottom of the table.<br /></li>
                                                                                        <li>If there are multiple search results, click ‘Select’ on the device you want to regrade.<br /></li>
                                                                                        <li>You must select the desired product from the dropdown list, as well as a time for regrade process to commence at.<br /></li>
                                                                                        <li>Once the required fields are populated, click ‘Add items to the list’. <br /></li>
                                                                                        <li>You can add multiple devices to this list by following steps 2 to 5.<br /></li>
                                                                                        <li>You must tick the box confirming you are instructing CSL to regrade this unit.<br /></li>
                                                                                        <li>Submit the request by clicking ‘Submit items on list’.<br /></li>
                                                                                        <li>CSL will verify if this unit can be regraded automatically – this will take up to 10 seconds. <br /></li>
                                                                                        <li>This regrade process will start at the time selected within the request. If the request includes an engineer’s required visit time within  the ‘regrade time’ column, then please continue and submit the request but remember to contact CSL Technical Support to advise.<br /></li>
                                                                                        <li>Submitted request(s) can be seen on the regrade request form, along with an option to cancel any requests that are no longer required. This is possible up until the time originally selected within the request.</li>
                                                                                </ol>
                                                                            </div>

                                                                            <div id="divCSLInstructions" visible="false" runat="server">
                                                                                <h3><b><i>To process the Upgrade/Downgrade request, please follow instructions below:</i></b></h3>
                                                                                <ol>
                                                                                       <li>Please make sure your unit is in test mode for the given time slot for the regrade process.<br /></li>
                                                                                       <li>Select your installer company.<br /></li>
                                                                                       <li>Find your device by chip number/data number/install ID for the request or key in the details on the required fields at the bottom of the table.<br /></li>
                                                                                       <li>If there are multiple search results, click ‘Select’ on the device you want to Upgrade/Downgrade.<br /></li>
                                                                                        <li>You must select the existing grade and the new required grade from the dropdown list.<br /></li>
                                                                                        <li>For Downgrade, you must select the reason. <br /></li>
                                                                                        <li>Once the required fields are populated, click ‘Add items to the list’. <br /></li>
                                                                                        <li>You can add multiple devices to this list by following steps 2 to 5.<br /></li>
                                                                                        <li>You must tick the box confirming you are instructing CSL to Upgrade/Downgrade this unit. The change will take up to 24 hours. Downgrade is only available after initial 12 month contract is completed.<br /></li>
                                                                                        <li>Submit the request by clicking ‘Submit items on list’. <br /></li>
                                                                                </ol>
                                                                            </div>

                                                                        </div><br />
                                                                    </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div id="divuc2" runat="server" class="clearfix divuc2">
                                                                    <asp:UpdatePanel ID="pnlInstallers" runat="server" Visible="false">
                                                                        <ContentTemplate>
                                                                            <fieldset>
                                                                                <ucInstallers:Installers ID="Installers" runat="server" />
                                                                            </fieldset>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                    <asp:UpdatePanel ID="pnlInstallersPC" runat="server" Visible="false">
                                                                        <ContentTemplate>
                                                                            <fieldset>
                                                                                <div id="divuc1" runat="server" class="clearfix divuc1">
                                                                                    Please select an Installer Company for this order. 
                                                                                    <br />
                                                                                    Please type the Postcode of the Installer Company into the search tool and click Search. 
                                                                                    <br />
                                                                                    If you are unable to find the Installer Company, click on More... to search by Installer Company name.
                                                                                    <br />
                                                                                    If you are still unable to find the Installer Company, please call our Customer Services team on +44 (0)1895 474474.

                                                                                    
                                                                                </div>
                                                                                <asp:Panel ID="pnl" runat="server" DefaultButton="buttonSearch">
                                                                                    <table border="0" width="600">
                                                                                        <tr>
                                                                                            <td width="75%" class="left" style="padding-right: 5px;">
                                                                                                <asp:TextBox ID="txtPostCode" MaxLength="256" Width="98%" TabIndex="1" runat="server">
                                                                                                </asp:TextBox>
                                                                                                <cc1:TextBoxWatermarkExtender ID="TBWE2" runat="server" TargetControlID="txtPostCode"
                                                                                                    WatermarkText="Search by Postcode..."
                                                                                                    WatermarkCssClass="watermarked" />
                                                                                            </td>
                                                                                            <td class="left" style="padding-left: 5px;">
                                                                                                <asp:Button ID="btnSearch" Text="Search" CssClass="css_btn_class" runat="server"
                                                                                                    OnClick="btnSearch_Click" />
                                                                                            </td>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>
                                                                                                <asp:LinkButton ID="btnShowSearch" runat="server" OnClick="btnShowSearch_Click">More...</asp:LinkButton>
                                                                                                <asp:LinkButton ID="btnHideSearch" Visible="false" runat="server" OnClick="btnHideSearch_Click">Less...</asp:LinkButton>
                                                                                            </td>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>
                                                                                                <asp:Button ID="buttonClear" Text="Clear Search" runat="server"
                                                                                                    OnClick="Clear_Click" float="right" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr runat="server" id="advancedSearch" visible="false">
                                                                                            <td width="75%" class="left" style="padding-right: 5px;">
                                                                                                <asp:TextBox ID="installerCompanyName" MaxLength="256" Width="98%" TabIndex="1" runat="server">
                                                                                                </asp:TextBox>
                                                                                                <cc1:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server" TargetControlID="installerCompanyName"
                                                                                                    WatermarkText="Search by Company Name..."
                                                                                                    WatermarkCssClass="watermarked" />
                                                                                            </td>
                                                                                            <td class="left" style="padding-left: 5px;">
                                                                                                <asp:Button ID="buttonSearch" Text="Search" CssClass="css_btn_class" runat="server"
                                                                                                    OnClick="btnSearch_Click" Visible="false" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <asp:Repeater runat="server" ID="rptInstallerCompanies" OnItemCommand="rptInstallerCompanies_ItemCommand">
                                                                                            <ItemTemplate>
                                                                                                <table cellpadding="10" cellspacing="2" border="0" style="width: 100%">
                                                                                                    <tr>
                                                                                                        <td style="width: 60%; padding-left: 100px;">
                                                                                                            <strong>
                                                                                                                <asp:Label ID="lblCompanyName" runat="server" Text='<%# Eval("CompanyName") %>' CommandArgument='<%# Eval("CompanyName") %>' /></strong>
                                                                                                            <br />
                                                                                                            <asp:Label ID="lblAccreditation" runat="server" Text='<%# Eval("Accreditation") %>' CommandArgument='<%# Eval("Accreditation") %>' />
                                                                                                            ,&nbsp;
                                <asp:Label ID="lblUniqueCode" runat="server" Text='<%# String.Format("CSL Code: {0}", Eval("UniqueCode")) %>' CommandArgument='<%# Eval("UniqueCode") %>' />
                                                                                                            <br />
                                                                                                            <asp:Label ID="lblAddressOne" runat="server" Text='<%# Eval("AddressOne") %>' CommandArgument='<%# Eval("AddressOne") %>' />
                                                                                                            ,&nbsp;
                                <asp:Label ID="lblAddressTwo" runat="server" Text='<%# Eval("AddressTwo") %>' CommandArgument='<%# Eval("AddressTwo") %>' />
                                                                                                            <br />
                                                                                                            <asp:Label ID="lblTown" runat="server" Text='<%# Eval("Town") %>' CommandArgument='<%# Eval("Town") %>' />
                                                                                                            ,&nbsp;
                                <asp:Label ID="lblCounty" runat="server" Text='<%# Eval("County") %>' CommandArgument='<%# Eval("County") %>' />
                                                                                                            <br />
                                                                                                            <asp:Label ID="lblPostCode" runat="server" Text='<%# Eval("PostCode") %>' CommandArgument='<%# Eval("PostCode") %>' />
                                                                                                            <br />
                                                                                                            <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("Country") %>' CommandArgument='<%# Eval("Country") %>' />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Button ID="btnSelect" Text="Select this Installer" CssClass="css_btn_class" Height="40px" Width="150px" runat="server" CommandName='<%# Eval("CompanyName") %>' CommandArgument='<%# Eval("InstallerCompanyID") %>' />
                                                                                                        </td>
                                                                                                        <hr />
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </ItemTemplate>
                                                                                        </asp:Repeater>
                                                                                        <tr>
                                                                                            <td class="left">
                                                                                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" SkinID="LabelRed"></asp:Label>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="left">
                                                                                                <asp:Literal ID="lblInstaller" runat="server"></asp:Literal>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </asp:Panel>
                                                                            </fieldset>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr valign="top">
                                                            <td width="750">
                                                                <asp:Panel ID="pnlForm" runat="server" DefaultButton="imgBtnGetDevice">
                                                                    <fieldset>
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="9"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="9">
                                                                                    <div id="div1" runat="server" style="width: 800px; float: left; min-height: 80px;">
                                                                                          <table><tr>
                                                                                        <td colspan="5"><span><strong>Search for device using one or more fields</strong> </span></td>
                                                                                           </tr>
                                                                                        <tr>
                                                                                        <td>
                                                                                         Chip Number
                                                                                        </td><td>
                                                                                     <asp:TextBox ID="txtChipNo" runat="server" MaxLength="6" Width="150"></asp:TextBox>
                                                                                            </td>
                                                                                        <td>
                                                                                     Data Number
                                                                                            </td>
                                                                                    <td>
                                                                                            <asp:TextBox ID="txtDatano" runat="server" MaxLength="20" Width="150"></asp:TextBox> 
                                                                                        </td>
                                                                                    <td>
                                                                                        </td><td>
                                                                                        EM number 
                                                                                        </td>
                                                                                        <td>
                                                                                        <asp:TextBox ID="txtEMNo" runat="server" MaxLength="20" Width="150"></asp:TextBox>
                                                                                        </td>
                                                                                            </tr>
                                                                                        <tr>
                                                                                        <td>
                                                                                        Install ID
                                                                                        </td>
                                                                                        <td>
                                                                                        <asp:TextBox ID="txtInstallID" runat="server" MaxLength="20" Width="150"></asp:TextBox>
                                                                                        </td>
                                                                                           <%-- <td>
                                                                                        TCD No
                                                                                        </td>
                                                                                            <td>
                                                                                        <asp:TextBox ID="txtTCDNo" runat="server" MaxLength="20" Width="150"></asp:TextBox>
                                                                                        </td>--%>
                                                                                            <td></td><td></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="7" align="center">  <asp:Button ID="imgBtnGetDevice" runat="server" CssClass="css_btn_class" Text="Find Device" OnClick="GetDevice_Click" Style="position: relative;" /></td>
                                                                                        </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="9">&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="9">
                                                                                    <asp:GridView Width="100%" ID="gvDevicelist" AutoGenerateColumns="False" runat="server"
                                                                                        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                                                                        CellPadding="4" ForeColor="Black" GridLines="Vertical" DataKeyNames="Dev_Inst_UnqCode"
                                                                                        AutoGenerateSelectButton="True" OnSelectedIndexChanged="gvDevicelist_SelectedIndexChanged">
                                                                                        <AlternatingRowStyle BackColor="White" />
                                                                                        <Columns>
                                                                                            <asp:BoundField DataField="Dev_Account_Code" HeaderText="Chip No / InstallID" />
                                                                                            <asp:BoundField DataField="Dev_Connect_Number" HeaderText="Data No" />
                                                                                            <asp:BoundField DataField="Dev_Code" HeaderText="SIM NO" />
                                                                                            <asp:BoundField DataField="EMNo" HeaderText="EMNo" />
                                                                                            <asp:BoundField DataField="Dev_Type" HeaderText="Type" />
                                                                                            <asp:BoundField DataField="Dev_Arc_Primary" HeaderText="ARC Code" Visible="false" />
                                                                                            <asp:BoundField DataField="InstallerName" HeaderText="Installer on Record" />
                                                                                            <asp:BoundField DataField="ARCName" HeaderText="ARC" />
                                                                                        </Columns>
                                                                                        <FooterStyle BackColor="#CCCC99" />
                                                                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                                                        <PagerStyle ForeColor="Black" HorizontalAlign="Right" />
                                                                                        <RowStyle />
                                                                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                                                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                                                                                        <SortedAscendingHeaderStyle BackColor="#848384" />
                                                                                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                                                                                        <SortedDescendingHeaderStyle BackColor="#575357" />
                                                                                    </asp:GridView>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <span>Note1 :<i>If your unit is not listed through the above Find functionality you can still proceed by keying in the details below.</i><br />
                                                                            <span>Note2 :<i>Current time in GMT/BST TimeZone(as when page was last refreshed) - </i><b><asp:Label runat="server" ID="lblCurrentTime"></asp:Label></b> </span>
                                                                        </span>
                                                                        <table>
                                                                            <tr>
                                                                                <td></td>
                                                                                <td><asp:Label ID="lblFrom" runat="server">From</asp:Label>
                                                                                </td>
                                                                                <td>To
                                                                                </td>
                                                                                <td>SIM Number
                                                                                </td>
                                                                                <td><asp:Label ID="lblDataNo" runat="server">Data Number</asp:Label>
                                                                                </td>
                                                                                <td>Chip Number
                                                                                </td>
                                                                                 <td><asp:Label ID="lblEMno" runat="server">EM No</asp:Label>
                                                                                </td>
                                                                                <td><asp:Label ID="lblArcRef" runat="server" Visible="false">ARC Reference</asp:Label>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:Label ID="ddlTitle" runat="server">Reason for downgrade</asp:Label>
                                                                                </td>
                                                                                <td><asp:Label ID="lblRegradeTime" runat="server">Regrade Time(GMT/BST)</asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td></td>
                                                                                <td>
                                                                                    <asp:DropDownList ID="ddlFrom" runat="server" />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:DropDownList ID="ddlTo" runat="server" />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="esn_sim" runat="server" CssClass="GradeShiftDowngrade_input"></asp:TextBox>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="nua_data" runat="server" CssClass="GradeShiftDowngrade_input"></asp:TextBox>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="chip" runat="server" CssClass="GradeShiftDowngrade_input"></asp:TextBox>
                                                                                </td>
                                                                                 <td>
                                                                                     <asp:TextBox ID="SelectedEMNo" runat="server" CssClass="GradeShiftDowngrade_input" />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="ARCRef" runat="server" CssClass="GradeShiftDowngrade_input" Visible="false"></asp:TextBox>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:DropDownList ID="ddlReason" runat="server">
                                                                                        <asp:ListItem Value="n/a" Text="Please Select" />
                                                                                        <asp:ListItem Value="Cost" Text="Cost" />
                                                                                        <asp:ListItem Value="Insurance" Text="Insurance" />
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td> <asp:TextBox runat="server" ID="txtRegradeDateTime"  CssClass="RegradeDateTime" > </asp:TextBox></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle" align="center" colspan="9" height="35">
                                                                                    <asp:Button ID="lnkAdd" OnClick="btnAdd_Click" runat="server" Text="Add Item to List"
                                                                                        CssClass="css_btn_class"></asp:Button>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="middle" align="center" colspan="8" height="35">
                                                                                    <asp:Label ID="lblValidation" runat="server" ForeColor="red" Visible="false">At least one of the following fields must contain a value *<br />SIM Number&nbsp;&nbsp;<br />Data Number&nbsp;&nbsp;<br />Chip Number&nbsp;&nbsp;<br />EM Number&nbsp;&nbsp;<br /><br /></asp:Label>
                                                                                    <asp:Label ID="lblValidationDIGI" runat="server" ForeColor="red" Visible="false">At least one of the following fields must contain a value *<br />SIM Number&nbsp;&nbsp;<br />Chip Number&nbsp;&nbsp;<br /><br /></asp:Label>
                                                                                    <asp:Label ID="lblDropValid" runat="server" ForeColor="red" Visible="false">Please select an installer *<br /><br /></asp:Label><asp:Label
                                                                                        ID="lblUpValid" runat="server" ForeColor="red" Visible="false">You can only upgrade to a higher grade specification *<br /><br /></asp:Label><asp:Label
                                                                                            ID="lblDownValid" runat="server" ForeColor="red" Visible="false">You can only downgrade to a lower grade specification *<br /><br /></asp:Label><asp:Label
                                                                                                ID="lblFromToValid" runat="server" ForeColor="red" Visible="false">Please select an option from the above list *<br /><br /></asp:Label>
                                                                                    <asp:Label ID="lblAddItem" runat="server" ForeColor="red" Visible="false">This is already choosen*</asp:Label><br />
                                                                                    <br />
                                                                                    <br />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table>
                                                                            <asp:Repeater ID="rpList" runat="server">
                                                                                <HeaderTemplate>
                                                                                    <tr bgcolor="#E3E3E3">
                                                                                        <td style="padding: 4px;visibility:hidden">PRODUCT CODE
                                                                                        </td>
                                                                                        <td style="padding: 4px">FROM
                                                                                        </td>
                                                                                        <td style="padding: 4px">TO
                                                                                        </td>
                                                                                        <td style="padding: 4px">SIM
                                                                                        </td>
                                                                                        <td style="padding: 4px">DATA
                                                                                        </td>
                                                                                        <td style="padding: 4px">CHIP/InstallID
                                                                                        </td>
                                                                                        <td style="padding: 4px">EMNo
                                                                                        </td>
                                                                                        <td style="padding: 4px">INSTALLER
                                                                                        </td>
                                                                                          <td style="padding: 4px">REGRADE TIME
                                                                                        </td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF"></td>
                                                                                    </tr>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <tr bgcolor="#fbcaca">
                                                                                        <td style="padding: 4px;visibility:hidden">
                                                                                            <%# GetCode() %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "ItemFrom") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "ItemToDescription") %>
                                                                                        </td>
                                                                                        <td runat="server" id="tdSim" style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Simno") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Datano") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Chipno") %>
                                                                                        </td>
                                                                                         <td style="padding: 4px">
                                                                                             <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "ISEmizonUnit" ))== true ? "display:block" :  "display:none"  %>" > 
                                                                                                    <%# DataBinder.Eval(Container.DataItem, "EMNo") %>
                                                                                             </div>
                                                                                             <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "ISEmizonUnit" ))== true ? "display:none" : "display:block"   %>" > 
                                                                                                 <span>n/a</span>
                                                                                             </div>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# GetInstallerName(DataBinder.Eval(Container.DataItem, "Installer").ToString()) %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">

                                                                                            <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "NeedsEngineer" ))== true ? "display:none" : "display:block" %>" > 
                                                                                                <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "ISEmizonUnit" ))== true ? "display:block" :  "display:none"  %>" > 
                                                                                                     <span> <%# DataBinder.Eval(Container.DataItem, "RegradeDateTime") %></span>
                                                                                                </div>
                                                                                                <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "ISEmizonUnit" ))== true ? "display:none" : "display:block"   %>" > 
                                                                                                     <span>n/a</span>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div style=" <%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "NeedsEngineer" ))== true ? "display:block" : "display:none" %>" > 
                                                                                                <span>Need Engineer Visit </span>
                                                                                            </div>

                                                                                            </td>
                                                                                         
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF">
                                                                                            <asp:LinkButton ID="remove" Text="remove" runat="server" OnCommand="btnRemove_Click"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "UD_Id") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    <tr bgcolor="#FFFFFF">
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px"></td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF"></td>
                                                                                    </tr>
                                                                                </FooterTemplate>
                                                                            </asp:Repeater>
                                                                            <tr>
                                                                                <td valign="bottom" align="center" colspan="11" height="20">
                                                                                    <asp:CheckBox ID="chkConfirm" runat="server" Text="By ticking this box you are instructing CSL to upgrade this unit."></asp:CheckBox>
                                                                                    <br />
                                                                                    <asp:Label ID="lblSubmitConfirm" runat="server" Visible="false" ForeColor="red" Text="You must tick the checkbox to confirm your instruction to CSL"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td valign="bottom" align="center" colspan="11" height="40">
                                                                                    <asp:Button ID="btnSubmit" OnClick="btnSubmit_Click" runat="server" CssClass="css_btn_class"
                                                                                        Text="Submit Items on List"></asp:Button>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                </asp:Panel>

                                                                  <asp:Panel ID="PnlAwaitingtoBeProcessed" runat="server" Visible="false">
                                                                            <asp:Literal runat="server" ID="ltAwaitingtoBeProcessed" Visible="true" Text="<h2><b>The below units are scheduled for Regrade and will be processed by system</b></h2>"></asp:Literal>
                                                                            <asp:Repeater ID="rptAwaitingtobeProcessed" runat="server">
                                                                                <HeaderTemplate>
                                                                                    <table border="0">
                                                                                    <tr bgcolor="#fbcaca">
                                                                                        <td style="padding: 4px">InstallID
                                                                                        </td>
                                                                                        <td style="padding: 4px">Installer
                                                                                        </td>
                                                                                        <td style="padding: 4px">EmNo
                                                                                        </td>
                                                                                        <td style="padding: 4px">Regrade Time
                                                                                        </td>
                                                                                        <td style="padding: 4px">Action</td>
                                                                                    </tr>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <tr>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Chipno") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# GetInstallerName(DataBinder.Eval(Container.DataItem, "installer").ToString()).ToString() %>
                                                                                        </td>
                                                                                         <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "EMNo") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "RegradeDateTime") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF">
                                                                                            <asp:LinkButton ID="remove" Text="remove" runat="server" OnCommand="btnRemove_Click"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "UD_ID") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    </table>
                                                                                </FooterTemplate>
                                                                            </asp:Repeater>
                                                                        </asp:Panel>


                                                                <asp:Panel ID="pnlConfirm" runat="server" Visible="false">
                                                                    <table>
                                                                        <tr>
                                                                            <td>Your request has been submitted successfully.<br />
                                                                                <br />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </asp:Panel>
                                                            </td>
                                                            <td width="17" class="quotes">&nbsp;
                                                            </td>
                                                            <td width="188" class="quotes"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Literal runat="server" ID="ltrARCDetails" Visible="false" Text="ARC details missing, please login and try again."></asp:Literal>
    <asp:Literal runat="server" ID="ltrEnterNo" Visible="false" Text="Please provide a value any one field to search."></asp:Literal>
    <asp:Literal runat="server" ID="ltrValidChpNo" Visible="false" Text="Please enter a valid chip number."></asp:Literal>
    <asp:Literal runat="server" ID="ltrAccount" Visible="false" Text="This does not belong to your account."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDetails" Visible="false" Text="Could not find the details."></asp:Literal>

    <script type="text/javascript" src="scripts/jquery-ui-timepicker-addon.js"></script>
    <script type="text/javascript">

            $('.RegradeDateTime').datetimepicker({
            dateFormat: 'dd-mm-yy',
            stepMinute: 5
        });


        $(function () {
            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });


    </script>
    
    
</asp:Content>
