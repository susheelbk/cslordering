<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeFile="BulkUploadMultipleOrders.aspx.cs" Inherits="BulkUploadMultipleOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    
    <script type="text/javascript">
        
        function showProgressBar()
        {
            var objInputFile = document.getElementById('ctl00_contentWrapper_fileUploadCon');
            var objLoader = document.getElementById('ctl00_contentWrapper_divLoader');
            var objbtnUpload = document.getElementById('ctl00_contentWrapper_btnUpload');

            if (objInputFile.value !='') {
                
                objLoader.style.display = "block";
                objbtnUpload.style.display = 'none';
            }
            else
            {
                objLoader.style.display = "none";
                objbtnUpload.style.display = 'block';
                
            }
        }
    </script>   
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        <%--Upload Multiple Orders--%>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper"  runat="Server">
    
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
                        <span style="color: #fff"><b>UPLOAD MULTIPLE ORDERS</b></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <ul>
                            <li>Please upload an excel file with "DualComGradeRequired and NewChipNumber is mandatory" per
                                row.                                
                            <li>Header row is mandatory with column names "OrderId,RedcareChipNumber,CustomerName,PostalCode,RedCareType
                                ,DualComGradeRequired,NewChipNumber,CustomerOrderNo,SiteName</li>
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
                        <asp:Button ID="btnUpload" runat="server" Text="Upload" Width="80" OnClick="btnUpload_Click" CssClass="css_btn_class" OnClientClick="showProgressBar(1);" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id="divDuplicatesAllowed" runat="server">
                            <asp:CheckBox ID="chkDuplicatesAllowed" Text="We have noticed some of the chip numbers have been previously used or may exist in your current order. Please tick here to accept duplicate chip numbers."
                                runat="server" Font-Bold="true" ForeColor="Red" />
                            <br />
                            <br />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="3" id="trUploadedProducts" runat="server" visible="false">
                        <b>Products which are valid and could be uploaded</b>
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div style="max-height: 350px; overflow: auto;" runat="server" id="divValidProducts" visible="false">
            <table width="100%" cellpadding="5" cellspacing="2" border="0">
                <asp:Repeater runat="server" ID="rptUploadedProducts">
                    <HeaderTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label10" Text="Excel Order ID" Width="100px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label12" Text="Product Code" Width="100px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label16" Text="GPRS Chip Number" Width="120px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label9" Text="Post Code" Width="80px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label6" Text="Sitename" Width="80px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label18" Text="Signalling Format" Width="80px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label13" Text="Is Duplicate ChipNo" Width="70px" runat="server"></asp:Label></b>
                            </td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center">
                                <asp:Label ID="Label11" runat="server"><%# Eval("OrderId")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label3" runat="server"><%# Eval("ProductCode")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label1" runat="server"><%# Eval("GPRS")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label2" runat="server"><%# Eval("PostCode")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label8" runat="server"><%# Eval("Sitename")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label19" runat="server"><%# Eval("OptionName")%></asp:Label>
                            </td>
                            <td align="center">
                                <%# (Boolean.Parse(Eval("IsAnyDuplicate").ToString())) ? "Yes" : "No" %>
                            </td>
                        </tr>

                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        <br />
        <table width="100%" cellpadding="5" cellspacing="2" border="0">
            <tr>
                <td align="left" colspan="4" id="trCouldNotUpload" runat="server" visible="false">
                    <b>Products which could not be uploaded</b>
                </td>
            </tr>
        </table>
        <div style="max-height: 350px; overflow: auto;" runat="server" id="divNotValidProducts" visible="false">
            <table width="100%" cellpadding="5" cellspacing="2" border="0">
                <asp:Repeater runat="server" ID="rptErrorProducts">
                    <HeaderTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label10" Text="Excel Order ID" Width="100px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label12" Text="Product Code" Width="100px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label16" Text="GPRS Chip Number" Width="120px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label9" Text="Post Code" Width="100px" runat="server"></asp:Label></b>
                            </td>
                            <td align="center">
                                <b>
                                    <asp:Label ID="Label5" Text="Status" runat="server"></asp:Label></b>
                            </td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr bgcolor="#cccccc">
                            <td align="center">
                                <asp:Label ID="Label11" runat="server"><%# Eval("OrderId")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label3" runat="server"><%# Eval("ProductCode")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label1" runat="server"><%# Eval("GPRS")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label2" runat="server"><%# Eval("PostCode")%></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="Label4" runat="server"><%# Eval("Result")%></asp:Label>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        <br />
        <div style="max-height: 350px; overflow: auto;" runat="server" id="divBasketItems" visible="false">
            <table width="100%" cellpadding="5" cellspacing="0" border="0">
                <tr>
                    <td align="left" colspan="4">
                        <b>You have already below items in your basket which is not yet processed.<br />
                            Please process it first by clicking on proceed to basket.</b>
                    </td>
                </tr>
                <tr>
                    <td style="border: groove;">
                        <asp:Repeater runat="server" ID="rptBasketItems">
                            <HeaderTemplate>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr bgcolor="#cccccc">
                                        <td align="left" width="20%">
                                            <asp:Label ID="Label10" Text="Order No" Width="100px" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="left" width="20%">
                                            <asp:Label ID="Label12" Text="Company Name" Width="200px" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="left" width="30%">
                                            <asp:Label ID="Label7" Text="Order Ref No" Width="150px" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="left" width="30%">
                                            <asp:Label ID="Label15" Text="Uploaded On" Width="150px" runat="server"></asp:Label></b>
                                        </td>
                                    </tr>
                                </table>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td align="left" width="20%">
                                            <asp:Label ID="Label11" Width="100px" runat="server"><%# Eval("OrderNo")%></asp:Label>
                                        </td>
                                        <td align="left" width="20%">
                                            <asp:Label ID="Label3" runat="server" Width="200px"><%# Eval("CompanyName")%></asp:Label>
                                        </td>
                                        <td align="left" width="30%">
                                            <asp:Label ID="Label14" runat="server" Width="150px"><%# Eval("OrderRefNo")%></asp:Label>
                                        </td>
                                        <td align="left" width="30%">
                                            <asp:Label ID="Label17" runat="server" Width="150px"><%# Eval("UploadedOn")%></asp:Label>
                                        </td>

                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:Repeater>
                    </td>
                </tr>

            </table>
        </div>

        <br />
        <div>
            <right>
                <asp:Button ID="btnProceed" runat="server" Text="Proceed to basket" Width="130" 
                    onclick="btnProceed_Click" CssClass="css_btn_class" OnClientClick="showProgressBar(1);" Visible="false" /></right>
        </div>
        <br />
        <br />
    </div>
    <asp:Literal runat="server" ID="ltrUploadLimit" Visible="false" Text="Not allowed to upload more then 250 items."></asp:Literal>
    <asp:Literal runat="server" ID="ltrFileType" Visible="false" Text="Invalid file type."></asp:Literal>
    <asp:Literal runat="server" ID="ltrSelectFile" Visible="false" Text="Please select the file first."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDuplicate" Visible="false" Text="We have noticed some of the chip numbers have been previously used or may exists in your current order, please continue to basket page and confirm the duplicates as you are allowed."></asp:Literal>
    <asp:Literal runat="server" ID="ltrUpload" Visible="false" Text="Please upload the items first."></asp:Literal>
    <asp:Literal runat="server" ID="ltrAllItemsDuplicated" Visible="false" Text="We have noticed all chip numbers have been previously used or may exists in your current order.Please accept duplicate or update the chip number."></asp:Literal>
    
    
</asp:Content>
