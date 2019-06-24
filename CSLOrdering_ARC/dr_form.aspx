<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="dr_form.aspx.cs" Inherits="dr_form" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/UserControls/Installers.ascx" TagName="Installers" TagPrefix="ucInstallers" %>
<asp:Content ID="Content3" ContentPlaceHolderID="contentWrapper" runat="Server">
    <table width="100%" border="0" cellspacing="1" cellpadding="5">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="5" align="center">
                            <asp:Label ID="lblTitle" runat="server" Style="font-size: 1.5em; font-weight: bold; text-decoration: underline;"  />
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
                                                    <table width="730" border="0" align="center" cellpadding="0" cellspacing="0" summary="">
                                                        <tr valign="top">
                                                            <td width="650" align="center" height="70" valign="middle">
                                                                <asp:Label ID="disText" runat="server">Please contact CSL if confirmation is required</asp:Label>
                                                                <asp:Label
                                                                    ID="recText" runat="server">Please note: Reconnection of signalling can take up to 24 hours from notification. There is a £25.00 charge for each reconnection.</asp:Label></p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div id="divdisconnectioninst"  runat="server">
                                                                <div id="emizonaccordion" >
                                                                            <h3><b>View Instructions for EMIZON TCD Disconnections >></b></h3>

                                                                            <div id="divEmizonInstructions" runat="server">
                                                                                <h3><b><i>To process the disconnection request, please follow instructions below:</i></b></h3>
                                                                                <ol>
                                                                                       <li>Before you proceed with the request please ensure you have de-activated and disassociated the installation for the required device.<br /></li>
                                                                                       <li>Select the relevant installer company.<br /></li>
                                                                                       <li> Find your device by chip number/data number/install ID for the request or key in the details on the required fields at the bottom of the table.<br /></li>
                                                                                       <li> If there are multiple search results, click ‘Select’ on the device you want to disconnect.<br /></li>
                                                                                        <li> You must choose the valid reason for disconnection before moving on to the next step.<br /></li>
                                                                                       <li> Once the required fields are populated, click ‘Add items to the list’. CSL will verify if this unit can be disconnected (refer to step 1). This will take up to 10 seconds.<br /></li>
                                                                                        <li> You can add multiple devices to this list by following steps 2 to 5.<br /></li>
                                                                                        <li> You must tick the box confirming you are instructing CSL to remove this unit from all signaling.<br /></li>
                                                                                        <li> Submit the request by clicking ‘Submit items on list’.<br /></li>
                                                                                        <li> This disconnection request will be processed at the end of the day. <br /><br /></li>
                                                                                        <li> Submitted request(s) can be seen on the disconnection request form, along with an option to cancel any requests that are no longer required. This is possible up until 6pm (GMT/BST) on the day on which the request was made.</li>
                                                                                </ol>
                                                                            </div>

                                                                        </div><br />
                                                                    <div id="cslaccordion" >
                                                                            <h3><b>View Instructions for CSL Disconnections  >></b></h3>

                                                                             <div id ="divCSLInstructions"  runat="server">
                                                                                <h3><b><i>To process the disconnection request, please follow instructions below:</i></b></h3>
                                                                                <ol>
                                                                                       <li>Before you proceed with the request please ensure you have de-activated and disassociated the installation for the required device.<br /></li>
                                                                                       <li>Select the relevant installer company.<br /></li>
                                                                                       <li> Find your device by EM number or install ID for the request or key in the details on the required fields at the bottom of the table.<br /></li>
                                                                                       <li> If there are multiple search results, click ‘Select’ on the device you want to disconnect.<br /></li>
                                                                                        <li> You must choose the valid reason for disconnection before moving on to the next step.<br /></li>
                                                                                       <li> Once the required fields are populated, click ‘Add items to the list’. CSL will verify if this unit can be disconnected (refer to step 1). This will take up to 10 seconds.<br /></li>
                                                                                        <li> You can add multiple devices to this list by following steps 2 to 5.<br /></li>
                                                                                        <li> You must tick the box confirming you are instructing CSL to remove this unit from all signaling.<br /></li>
                                                                                        <li> Submit the request by clicking ‘Submit items on list’.<br /></li>
                                                                                        <li> This disconnection request will be processed at the end of the day. <br /><br /></li>
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
                                                            <td width="795px">
                                                                <asp:Panel ID="pnlForm" runat="server" DefaultButton="imgBtnGetDevice">
                                                                    <fieldset>
                                                                        <table>
                                                                            <tr>
                                                                                <td colspan="5"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="5"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="5">
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
                                                                                        <asp:Literal ID="ltrUnitDetail" runat="server"></asp:Literal>
                                                                                        
                                                                                </td>
                                                                            </tr>

                                                                            <tr>
                                                                                <td colspan="5">
                                                                                    <asp:GridView Width="100%" ID="gvDevicelist" AutoGenerateColumns="False" runat="server"
                                                                                        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                                                                        CellPadding="4" ForeColor="Black" GridLines="Vertical" DataKeyNames="Dev_Inst_UnqCode"
                                                                                        AutoGenerateSelectButton="True"
                                                                                        OnSelectedIndexChanged="gvDevicelist_SelectedIndexChanged">
                                                                                        <AlternatingRowStyle BackColor="White" />
                                                                                        <Columns>
                                                                                            <asp:BoundField DataField="Dev_Account_Code" HeaderText="Chip No / InstallID" />
                                                                                            <asp:BoundField DataField="Dev_Connect_Number" HeaderText="Data No" />
                                                                                            <asp:BoundField DataField="Dev_Code" HeaderText="SIM NO" />
                                                                                            <asp:BoundField DataField="EMNo" HeaderText="EMNo" />
                                                                                            <asp:BoundField DataField="Dev_Type" HeaderText="Type" />
                                                                                            <asp:BoundField DataField="Dev_Arc_Primary" HeaderText="ARC Code"  Visible="false"/>
                                                                                            <asp:BoundField DataField="InstallerName" HeaderText="Installer on Record"  />
                                                                                            <asp:BoundField DataField="ARCName" HeaderText="ARC"  />
                                                                                            <asp:BoundField DataField="PostCode" HeaderText="PostCode"  />
                                                                                            <%--<asp:BoundField DataField="Dev_Poll_Color" HeaderText="" />
                                                                        <asp:BoundField DataField="Dev_First_Poll_DateTime" Visible="false" />
                                                                         <asp:BoundField DataField="Dev_Inst_UnqCode" Visible="false" />--%>
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

                                                                            <tr>
                                                                                <td colspan="4">
                                                                                    <span>Note :                                                                                       
																								<i>If your unit is not listed through the above Find functionality you can still proceed by keying in the details below.</i>																																								
                                                                                    </span>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>ESN/SIM Number
                                                                                </td>
                                                                                <td>NUA/Data Number
                                                                                </td>
                                                                                <td>Chip Number
                                                                                </td>
                                                                                <td>EM No
                                                                                </td>
                                                                                <td>
                                                                                    <asp:Label ID="ddlTitle" runat="server">Reason for Disconnection</asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:TextBox ID="esn_sim" runat="server"  />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="nua_data" runat="server" />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="chip" runat="server" />
                                                                                </td>
                                                                                <td>
                                                                                     <asp:TextBox ID="SelectedEMNo" runat="server" />
                                                                                </td>
                                                                                <td>
                                                                                    <asp:DropDownList ID="ddlReason" runat="server">
                                                                                        <asp:ListItem Value="Contract Cancelled" Text="Contract Cancelled" />
                                                                                        <asp:ListItem Value="Technical Issue" Text="Technical Issue" />
                                                                                        <asp:ListItem Value="Premises Vacated" Text="Premises Vacated" />
                                                                                        <asp:ListItem Value="Replaced by Other DualCom" Text="Replaced by Other DualCom" />
                                                                                        <asp:ListItem Value="Replaced by Other Provider" Text="Replaced by Other Provider" />
                                                                                        <asp:ListItem Value="Upgrade to GPRS" Text="Upgrade to GPRS" />
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td>&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                                                                                                       <tr>
                                                                                <td colspan="5" align="center" height="35" valign="middle">
                                                                                    <asp:Button ID="lnkAdd" runat="server" OnClick="btnAdd_Click" Text="Add Item to List"
                                                                                        CssClass="css_btn_class" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="5" align="center" height="35" valign="middle">
                                                                                    <asp:Label ID="lblValidation" runat="server" Visible="false" ForeColor="red">At least one of the following fields must contain a value *<br />ESN / SIM Number&nbsp;&nbsp;<br />NUA / Data Number&nbsp;&nbsp;<br />Chip Number&nbsp;&nbsp;<br />EM Number&nbsp;&nbsp;<br /></asp:Label>
                                                                                    <asp:Label ID="lblDropValid" runat="server" Visible="false" ForeColor="red">Please select an installer from the list provided *<br /><br /></asp:Label><br />
                                                                                    <asp:Label ID="lblAddItem" runat="server" Visible="false" ForeColor="red">This is already Choosen*<br /><br /></asp:Label><br />
                                                                                </td>
                                                                            </tr>
                                                                            <asp:Repeater ID="rpList" runat="server">
                                                                                <HeaderTemplate>
                                                                                    <tr bgcolor="#E3E3E3">
                                                                                        <td style="padding: 4px">Sim
                                                                                        </td>
                                                                                        <td style="padding: 4px">Data No
                                                                                        </td>
                                                                                        <td style="padding: 4px">Chip No
                                                                                        </td>
                                                                                        <td style="padding: 4px">Selected Installer
                                                                                        </td>
                                                                                        <td style="padding: 4px">EmNo
                                                                                        </td>
                                                                                        <td style="padding: 4px">Reason
                                                                                        </td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF"></td>
                                                                                    </tr>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <tr bgcolor="#fbcaca">
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
                                                                                            <%# GetInstallerName(DataBinder.Eval(Container.DataItem, "installer").ToString()).ToString() %>
                                                                                        </td>
                                                                                         <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "EMNo") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Reason") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF">
                                                                                            <asp:LinkButton ID="remove" Text="remove" runat="server" OnCommand="btnRemove_Click"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DrId") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                            </asp:Repeater>
                                                                            <tr>
                                                                                <td colspan="5" align="center" height="20" valign="bottom">
                                                                                    <asp:CheckBox ID="chkConfirm" runat="server" Text="By ticking this box you are instructing CSL to remove this unit from all signalling" /><br />
                                                                                    <br />
                                                                                    <asp:Label ID="lblSubmitConfirm" runat="server" Text="You must tick the checkbox to confirm your instruction to CSL"
                                                                                        ForeColor="red" Visible="false" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="5" align="center" height="40" valign="bottom">
                                                                                    <%--<asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Return to Menu" />&nbsp;&nbsp;--%>
                                                                                    <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Submit Items on List"
                                                                                        CssClass="css_btn_class" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        
                                                                        
                                                                        <asp:Panel ID="PnlAwaitingtoBeProcessed" runat="server" Visible="false">
                                                                            <asp:Literal runat="server" ID="ltAwaitingtoBeProcessed" Visible="true" Text="The below items will be presented for disconnection at end of day"></asp:Literal>
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
                                                                                        <td style="padding: 4px">Reason
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
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Reason") %>
                                                                                        </td>
                                                                                        <td style="padding: 4px" bgcolor="#FFFFFF">
                                                                                            <asp:LinkButton ID="remove" Text="remove" runat="server" OnCommand="btnRemove_Click"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DrId") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    </table>
                                                                                </FooterTemplate>
                                                                            </asp:Repeater>
                                                                        </asp:Panel>
                                                                            

                                                                    </fieldset>
                                                                </asp:Panel>
                                                                <asp:Panel ID="pnlConfirm" runat="server" Visible="false">
                                                                    <table>
                                                                        <tr>
                                                                            <td>Your request has been submitted successfully.<br />
                                                                                <br />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <%-- <asp:LinkButton ID="menu1" runat="server" Text="Return to menu" OnCommand="menu_Click"
                                                            CommandArgument="A" />--%>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <%--<asp:LinkButton ID="menu2" runat="server" Text="Online Ordering" OnCommand="menu_Click"
                                                            CommandArgument="B" />--%>
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
   <script language="javascript" type="text/javascript">
    $(function () {

        $("#cslaccordion").accordion({
            collapsible: true,
            active: false
        });
    });

    $(function () {

        $("#emizonaccordion").accordion({
            collapsible: true,
            active: false
        });
    });
    </script>
</asp:Content>
