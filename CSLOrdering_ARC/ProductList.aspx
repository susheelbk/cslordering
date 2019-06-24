<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="ProductList.aspx.cs" Inherits="ProductList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="UserControls/ProductBadge1.ascx" TagName="ProductBadge" TagPrefix="uc1" %>





<asp:Content ID="Content3" ContentPlaceHolderID="contentPageTitle" runat="Server">
    <div class="fontSize">
        Products
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="contentWrapper" runat="Server">
    <style type="text/css">
        .modalBackground {
            background-color: #666699;
            filter: alpha(opacity=50);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: Red;
            width: 280px;
            padding: 2px;
            height: 400px;
            overflow: auto;
        }
    </style>
    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if (charCode < 48 || charCode > 57)
                    return false;
            return true;
        }

        function checkMultilineTextBoxMaxLength(textBox, e, length) {
            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;
            var maxLength = parseInt(mLen);
            //if (!checkSpecialKeys(e)) {
            if (textBox.value.length > maxLength - 1) {
                if (window.event)//IE               
                    e.returnValue = false;
                else//Firefox
                    e.preventDefault();
                alert('maximum character length is ' + mLen);
                textBox.value = textBox.value.substring(0, mLen);
                //textBox.scrollTop = textBox.scrollHeight;
                // }
            }
        }

        function isNumberKeyOrEnterKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8 && charCode != 13)
                if (charCode < 48 || charCode > 57)
                    return false;
            return true;
        }


    </script>
    <script src="scripts/jquery.1.10.js" type="text/javascript"></script>
    <script src="scripts/scrollFixed.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(document).ready(function () {
            $('.btnProceedContianer').stickyfloat({
                duration: 0,
                offsetY: 60,
                stickToBottom: true,
                StartOffset: 0
            });
        });

    </script>
    <style type="text/css">
        .btnProceedContianer {
            position: absolute;
            top: 20%;
            right: -12%;
        }

            .btnProceedContianer .easing {
                overflow: hidden;
                margin: 10px 0;
            }
    </style>
    <br />
    <!--<div>
        <ul style="line-height:20px">
            <li>
         	   This page allows user to select the list of products needed by entering the quantity in the textbox and click Proceed to basket.
            </li>
           
        </ul>
    </div>-->
    <h2>
        <strong>
            <asp:Literal ID="lblCategoryName" runat="server" Visible="true"></asp:Literal></strong>
    </h2>
    <br />
    <strong>NOTICE: 
        <%=arcDescription%>
    </strong>
    <br />
    <br />
    <asp:Button ID="btnShow" runat="server" Text="" Style="display: none;" />
    <!-- ModalPopupExtender -->
    <cc1:ModalPopupExtender ID="mp1" runat="server" PopupControlID="Panel1" TargetControlID="btnShow"
        CancelControlID="btnClose" BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" align="center" 
        Style="display: none; vertical-align: middle;">
        <br />
        <b>
            <asp:Label ID="Label7" runat="server" Text="Chip Numbers" /></b>
        <br />
        <br />
        <asp:TextBox runat="server" ID="txtChipNo" Height="300px" 
            Width="100px" TextMode="MultiLine"
            onKeyPress="return isNumberKeyOrEnterKey(event);" 
            onKeyUp="checkMultilineTextBoxMaxLength(this,event,'700');" />
        <br />
        <br />
        <%--<asp:Button ID="btnSaveChipNo" runat="server" Text="Done" OnClick="btnSaveChipNo_Click" />--%>
        <asp:Button ID="btnClose" runat="server" Text="Cancel" />
    </asp:Panel>
    <!-- ModalPopupExtender -->
    
    <div class="clearfix" style="margin-top: 15px; width: 860px; position: relative">
        <br />
        <div class="btnProceedContianer clearfix">
            <asp:Button ID="btnProceed" Text="Proceed to basket" runat="server" 
                OnClick="btnProceed_Click" CssClass="css_btn_class" />
        </div>

        <div class="clearfix" style="float: left; position: relative;">
            <asp:HiddenField ID="p_id" runat="server" Value="0" />
            <asp:HiddenField ID="p_qty" runat="server" Value="0" />
            <asp:Repeater runat="server" ID="dlProducts" OnItemDataBound="ProductsRepeater_ItemBound">
                <HeaderTemplate>
                    <table cellpadding="10" cellspacing="2" border="0">
                        <tr bgcolor="#fbcaca">
                            <td>
                                <b>
                                    <asp:Label ID="Label4" Text="Code" runat="server" Width="120px"></asp:Label></b>
                            </td>
                            <td>
                                <b>
                                    <asp:Label ID="Label3" Text="Product Name" runat="server" Width="450px"></asp:Label></b>
                            </td>
                           
                            <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                               { %>
                            <td>
                                <b>
                                    <asp:Label ID="Label2" Text="Unit Price" runat="server" Width="70px"></asp:Label></b>
                            </td>
                            <%} %>

                            <td>
                                <b>
                                    <asp:Label ID="Label1" Text="Qty" runat="server" Width="66px"></asp:Label></b>
                            </td>
                            <%-- <td width="40px">
                                    <asp:Label ID="Label5" Text="" runat="server"></asp:Label>
                                </td>--%>
                        </tr>
                    </table>
                </HeaderTemplate>
                <ItemTemplate>
                    <table cellpadding="10" cellspacing="2" border="0">
                        <tr bgcolor="#cccccc">
                            <td>
                                <asp:TextBox ID="lblProductId" runat="server" Text='<%# Eval("ProductId") %>' Visible="false"></asp:TextBox>
                          
                                 <asp:Label ID="lblProductCode" runat="server" Width="120px" Text='<%# Eval("ProductCode")%>'></asp:Label>
                               <%-- <asp:Label ID="lblProductCode" runat="server" Width="60px"><%# ConfigurationManager.AppSettings["DCCProductCodes"].Contains(Eval("ProductCode").ToString())? (Eval("ProductCode")).ToString().Substring(0,6):(Eval("ProductCode"))%></asp:Label>--%>
                            </td>
                            
                            <td>
                                
                                <asp:Label ID="lblProductTitle" runat="server" Width="450px"  ><%# Eval("ProductName") %></asp:Label>
                                <asp:TextBox ID="lblProductType" runat="server" Width="60px" CssClass="NoStyleTextBox"
                                    Text='<%# Eval("ProductType")%>' Visible="false"></asp:TextBox>

                                 <asp:RadioButtonList ID="rdbCompanies" runat="server" RepeatDirection="horizontal" Visible="false" AppendDataBoundItems="true">
                                            <asp:ListItem Text="Please Select" Selected="True" ></asp:ListItem> 
                                            <asp:ListItem Text="Pyronix" Value="01" ></asp:ListItem>
                                            <asp:ListItem Text="Risco" Value="02"></asp:ListItem>
                                           <asp:ListItem Text="HoneyWell" Value="03"></asp:ListItem>
                                     <asp:ListItem Text="Eaton" Value="04"></asp:ListItem>                                             
                                 </asp:RadioButtonList>
                                 <asp:HiddenField id="hdnIsDCC" runat="server" Value='<%# Eval("IsDCC") %>'/>
                            </td>
                            
                            <% if (Session[enumSessions.User_Role.ToString()].ToString() != enumRoles.ARC_Admin.ToString())
                               { %>
                            <td>
                                <asp:Label ID="lblProductPrice" runat="server" Width="70px">£<%# Eval("Price")%></asp:Label>
                            </td>
                            <%} %> 

                            <td>
                                <asp:TextBox ID="txtProductQty" runat="server" Width="60px" onKeyPress="return isNumberKey(event);"></asp:TextBox>
                                <asp:RangeValidator ControlToValidate="txtProductQty" Display="Dynamic" Text="Max Qty can be 100 only."
                                    MinimumValue="0" MaximumValue="100" EnableClientScript="false" Type="Integer" ForeColor="Red"
                                    runat="server" />
                            </td>
                            <%--<td width="40px">
                                <asp:ImageButton ID="btnAddToBasket" runat="server" CommandName="AddToBasket" CommandArgument='<%# Eval("ProductId") %>'
                                    ImageUrl="~/Images/shopping_cart_add.png" ToolTip="Add to basket" />
                            </td>--%>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:Repeater>

        </div>

    </div>
    <asp:Literal runat="server" ID="ltrEnterQntty" Visible="false" Text="Please enter valid product quantity first."></asp:Literal>
   <asp:Literal runat="server" ID="ltrNotaValidProduct" Visible="false" Text="No Product exists.Please check with CSL"></asp:Literal>
   <asp:Literal runat="server" ID="ltrSelectManufacturer" Visible="false" Text="Please Select a Manufacturer"></asp:Literal>

   
</asp:Content>
