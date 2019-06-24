<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="UploadOrder.aspx.cs" Inherits="UploadOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">
        function showProgressBar() {
            var objInputFile = document.getElementById('ctl00_contentWrapper_fileUploadCon');
            var objLoader = document.getElementById('ctl00_contentWrapper_divLoader');
            var objbtnUpload = document.getElementById('ctl00_contentWrapper_btnUpload');
            if (objInputFile.value != '') {

                objLoader.style.display = "block";
                objbtnUpload.style.display = 'none';
            }
            else {
                objLoader.style.display = "none";
                objbtnUpload.style.display = 'block';

            }
        }
        function showProgressBarOnProceedToBasket(val)
        {
            
            var objLoader = document.getElementById('ctl00_contentWrapper_divLoader');
            var objbtnUpload = document.getElementById('ctl00_contentWrapper_btnProceed');
            var objUploadedItems = document.getElementById('ctl00_contentWrapper_hdnUploadedItems');            
            if(objUploadedItems.value>0)
            {
                    objLoader.style.display = "block";
                    objbtnUpload.style.display = 'none';
            }
            else {
                objLoader.style.display = "none";
                objbtnUpload.style.display = 'block';

            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Upload Order
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <div class="modal" id="divLoader" runat="server" style="display: none; width: 93%; height: 100%">
        <div style="text-align: center">
            <img alt="" src="Images/ajax-loading.gif" />
        </div>
    </div>
    <div style="float: left; vertical-align: top; position: relative; width: 800px;">
        <div>
            <table width="95%" cellpadding="5" cellspacing="2" border="0">
                <tr>
                    <td colspan="2" bgcolor="gray">
                        <span style="color: #fff"><b>BULK UPLOAD</b></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <ul>
                            <li>Please upload an excel file with "ProductCode, GPRSChipNo
, Postcode(Not mandatory), Sitename(Not mandatory), ActivatingICCID
(Not mandatory), PanelID(Not mandatory)"
 per
                                row. </li>
                             <li>ActivatingICCID - ICCID to be entered for Activation Orders </li>
                            <li>Header row is mandatory with column names "ProductCode, GPRSChipNo, Postcode, Sitename, ActivatingICCID, PanelID" </li>
                            <li>Invalid product codes will be ignored </li>
                            <li>If any duplicate chip number is found, you will then need to confirm these.</li>
                            <li>
                                <asp:LinkButton ID="lnkbtndownload" runat="server" OnClick="lnkbtndownload_Click"
                                    ForeColor="blue">Click Here</asp:LinkButton>
                                &nbsp;to Download the template. </li>
                            <li>
                                <asp:LinkButton ID="lnkbtnProduclist" runat="server" OnClick="lnkbtnProduclist_Click" ForeColor="blue">Click Here</asp:LinkButton>
                                &nbsp;to Download the Products list.
                                <asp:Literal ID="litProducts" runat="server" Mode="Transform"></asp:Literal>
                            </li>
                        </ul>
                        <br />
                        <asp:Label ID="lbltemplatemsg" runat="server" Text="" ForeColor="Red"></asp:Label>

                        <hr />
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <asp:FileUpload ID="fileUploadCon" runat="server" />
                        <asp:Button ID="btnUpload" runat="server" Text="Upload" Width="80" OnClick="btnUpload_Click" CssClass="css_btn_class" OnClientClick="showProgressBar();" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div style="max-height: 350px; overflow: auto;">
            <table width="95%" cellpadding="5" cellspacing="2" border="0">
                <tr>
                    <td align="left" colspan="3">
                        <b>Uploaded Products</b>
                    </td>
                </tr>
                <asp:Repeater runat="server" ID="rptUploadedProducts">
                    <HeaderTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center" width="10%">
                                <b>
                                    <asp:Label ID="Label12" Text="Product Code"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="15%">
                                <b>
                                    <asp:Label ID="Label16" Text="GPRS Chip Number"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="15%">
                                <b>
                                    <asp:Label ID="Label9" Text="Post Code"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="15%">
                                <b>
                                    <asp:Label ID="Label6" Text="Sitename"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="15%">
                                <b>
                                    <asp:Label ID="Label7" Text="Activating ICCID" runat="server"></asp:Label></b>
                            </td>
                            <td align="center"  width="30%">
                                <b>
                                    <asp:Label ID="Label14" Text="Panel ID" runat="server"></asp:Label></b>
                            </td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center" width="10%">
                                <asp:Label ID="Label3" runat="server"><%# Eval("ProductCode")%></asp:Label>
                            </td>
                            <td align="center"  width="15%">
                                <asp:Label ID="Label1" runat="server"><%# Eval("GPRS")%></asp:Label>
                            </td>
                            <td align="center"  width="15%">
                                <asp:Label ID="Label2" runat="server"><%# Eval("PostCode")%></asp:Label>
                            </td>
                            <td align="center" width="15%">
                                <asp:Label ID="Label8" runat="server"><%# Eval("Sitename")%></asp:Label>
                            </td>
                            <td align="center" width="15%">
                                <%#Eval("Ident")%>
                            </td>
                             <td align="center" width="30%">
                                <asp:Label ID="Label10" runat="server"><%# Eval("GSMNo")%></asp:Label>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        <br />
        <div style="max-height: 350px; overflow: auto;">
            <table width="95%" cellpadding="5" cellspacing="2" border="0">
                <tr>
                    <td align="left" colspan="4">
                        <b>Products which could not be uploaded</b>
                    </td>
                </tr>
                <asp:Repeater runat="server" ID="rptErrorProducts">
                    <HeaderTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center" width="10%">
                                <b>
                                    <asp:Label ID="Label12" Text="Product Code"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="20%">
                                <b>
                                    <asp:Label ID="Label16" Text="GPRS Chip Number" runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="20%">
                                <b>
                                    <asp:Label ID="Label9" Text="Post Code"  runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="15%">
                                <b>
                                    <asp:Label ID="Label11" Text="Panel ID" runat="server"></asp:Label></b>
                            </td>
                            <td align="center" width="35%">
                                <b>
                                    <asp:Label ID="Label5" Text="Status" runat="server"></asp:Label></b>
                            </td>
                            
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center" width="10%">
                                <asp:Label ID="Label3" runat="server"><%# Eval("ProductCode")%></asp:Label>
                            </td>
                            <td align="center" width="20%">
                                <asp:Label ID="Label1" runat="server"><%# Eval("GPRS")%></asp:Label>
                            </td>
                            <td align="center" width="20%">
                                <asp:Label ID="Label2" runat="server"><%# Eval("PostCode")%></asp:Label>
                            </td>
                            <td align="left" width="15%">
                                <asp:Label ID="Label13" runat="server"><%# Eval("GSMNo")%></asp:Label>
                            </td>
                            <td align="left" width="35%">
                                <asp:Label ID="Label4" runat="server"><%# Eval("Result")%></asp:Label>
                            </td>
                            
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>        
        <br />
        <div>
            <right>
                <asp:Button ID="btnProceed" runat="server" Text="Proceed to basket" Width="130" 
                    onclick="btnProceed_Click" OnClientClick="showProgressBarOnProceedToBasket()"   CssClass="css_btn_class"/></right>
            <asp:HiddenField ID="hdnUploadedItems" runat="server" Value="0" />
        </div>
        <br />
        <br />
    </div>
    <asp:Literal runat="server" ID="ltrUploadLimit" Visible="false" Text="Not allowed to upload more then 250 items."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFileType" Visible="false" Text="Invalid file type."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectFile" Visible="false" Text="Please select the file first."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDuplicate" Visible="false" Text="We have noticed some of the chip numbers have been previously used or may exists in your current order, please continue to basket page and confirm the duplicates as you are allowed."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUpload" Visible="false" Text="Please upload the items first."></asp:Literal>
</asp:Content>

