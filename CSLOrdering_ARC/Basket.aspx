<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Basket.aspx.cs" Inherits="Basket" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPageTitle" runat="server">
    <div class="fontSize">
        Basket
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <script type="text/javascript" src="scripts/jquery.linq.js"></script>
    <script type="text/javascript" src="scripts/jquery.linq-vsdoc.js"></script>
  
    <script type="text/javascript">

        function ShowConfirmation() {
            if (confirm('Are you sure you want to remove this item from basket?'))
                return true;
            else
                return false;

        }

        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if (charCode < 48 || charCode > 57)
                    return false;
            return true;
        }

        function isValidateIPKeys(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if (charCode < 48 || charCode > 57) {

                    if (charCode != 46)
                        return false;
                }

            return true;
        }

        function checkSpecialKeys(evt) {
            var k = (evt.charCode) ? evt.charCode : ((evt.which) ? evt.which : evt.keyCode);
            if ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8 || k == 32 || (k >= 48 && k <= 57))
                return true;
            else
                return false;
        }

        function ValidateStockandCategory(source, args) {

            if (args.Value.length == 19) {
                args.Value = "E" + args.Value;
            }
            if (args.Value.substring(0, 1) == "0") {
                args.Value = "E" + args.Value.substring(1);
            }
            var iccid = args.Value;
            var catid = $(source).attr('cid'); // no more validating cross category check

            if ($.inArray(iccid, myLocalData.repICCIDStock, 0) >= 0) {
                args.IsValid = true;
            } else { args.IsValid = false; }
        }

        function ValidateInstallID(source, args) {
            var installID = args.Value;
            var strategy = $('#hdnInstallIDStrategy').val();
            var installIDlength = $('#hdnInstallIDLen').val();


            if (strategy == "1") //numerics only
            {
                if (installID.substr(0, 1) == "0") {
                    alertify.alert('Please remove leading zero\'s from InstallID "' + installID + '"');
                    args.IsValid = false;
                    return;
                }

                if (isNaN(installID)) {
                    alertify.alert('InstallID "' + installID + '" is invalid as only numbers are allowed!');
                    args.IsValid = false;
                    return;
                }
                installID = parseInt(installID);
            }

            if (strategy == "2") //numerics with leading zeros only
            {
                if (isNaN(installID)) {
                    alertify.alert('InstallID "' + installID + '" is invalid as only numbers are allowed!');
                    args.IsValid = false;
                    return;
                }
            }

            if (installIDlength.length == 3) //ex:2,6
            {
                var minlength = installIDlength.substr(0, 1);
                var maxlength = installIDlength.substr(2, 1);

                if (installID.toString().length < minlength) {
                    alertify.alert('InstallID "' + installID + '" cannot be less than "' + (minlength) + '" characters.');
                    args.IsValid = false; // return fail as InstallID in use for ARC
                    return;
                }
                if (installID.toString().length > maxlength) {
                    alertify.alert('InstallID "' + installID + '" cannot be more than "' + (maxlength) + '" characters.');
                    args.IsValid = false; // return fail as InstallID in use for ARC
                    return;
                }
            }

            /* Below Logic needs reactivating once CSL Inbound API is setup to receive InstallID changes

            if ($.inArray(installID.toString(), myLocalData.InstallIDList, 0) >= 0) {
                alertify.alert('InstallID "' + installID + '" has already been allocated.');
                args.IsValid = false; // return fail as InstallID in use for ARC

            } else {
                args.IsValid = true;
            }
            */
        }

        function VerifyTCD(source, args) {
            var tcdNo = args.Value;

            if (tcdNo == "0000")//allowed for replenishment stock, serialno's are scanned by despatch team
                args.IsValid = true;

            tcdSerialCheck(source, args);
            return args.IsValid;

            //return args.IsValid = tcdSerialCheck(source,args); // Temp override till we get our inbound API working so deassociate is pushed into our systems

            //if ($.inArray(tcdNo, myLocalData.TCDList, 0) >= 0) {
            //    args.IsValid = true;
            //} else {
            //    args.IsValid = false;
            //    alertify.alert('Serial No "' + tcdNo + '" not recognised as replenishment stock. Please use registered stock for Activation');
            //}
        }


        function tcdSerialCheck(source, arguments) {
            var inputData = arguments.Value
            var iAcc = 0;
            var iMul = 1;
            var i;
            var iCheck;
            for (i = 0; i < 9; i++) {
                if (i != 2) {
                    iAcc = iAcc + (iMul * (inputData.charAt(i)));
                    iMul = iMul * 3;
                }
            }
            iAcc = iAcc % 10;
            iCheck = (10 - iAcc);
            iCheck = iCheck % 10;
            if (iCheck == inputData.charAt(10)) {
                arguments.IsValid = true;
            } else {
                arguments.IsValid = false;
            }
        }


        $(function () {
           // getEMIDList();
           // getTCDList();
            getRepStockList();
        });

        var myLocalData = {};

        function getEMIDList() {
            var installID_Flag = $('#hdnInstallID_Flag').val();

            if (installID_Flag.toUpperCase() == "FALSE") {
                //console.warn('InstallID not fetched');
                return;
            }


            if (myLocalData.InstallIDList != null) {
                //console.warn('data exist');
                return;
            }

            $.ajax({
                type: "Post",
                url: "Basket.aspx/GetARCActiveInstallIDList",
                data: " { 'id':" + $('#HiddenFieldARCid').val() + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    myLocalData.InstallIDList = JSON.parse(response.d);
                    //alert("InstallID: " + myLocalData.InstallIDList);
                },

                failure: function (msg) {
                    console.warn(msg);
                }
            });
        }

        function getTCDList() {
            var tcdStock_Flag = $('#hdnTCDStockCheck').val();
            if (tcdStock_Flag.toUpperCase() == "FALSE") {
                return;
            }
            if (myLocalData.TCDList != null) {
                return;
            }

            $.ajax({
                type: "Post",
                url: "Basket.aspx/GetTCDAvailableStockNos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    myLocalData.TCDList = JSON.parse(response.d);
                    //alert("TCD: " + myLocalData.TCDList);
                },

                failure: function (msg) {
                    console.warn(msg);
                }
            });
        }

        function getRepStockList() {
            var csd_Flag = $('#hdnARCisCSD').val();
            if (csd_Flag.toUpperCase() == "FALSE") {
                // alert("Non CSD ARC, Ident not fetched!");
                return;
            }

            if (myLocalData.repICCIDStock != null) {
                // alert('data exist');
                return;
            }

            $.ajax({
                type: "Post",
                url: "Basket.aspx/GetReplenishmentStock",
                data: " { 'arcid':" + $('#HiddenFieldARCid').val() + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json", 
                success: function (response) {
                    myLocalData.repICCIDStock = JSON.parse(response.d);
                    //alert("CSD : " + myLocalData.repICCIDStock);
                },

                failure: function (msg) {
                    console.warn(msg);
                }
            });
        }

    </script>
    <div style="position: relative;">
        <strong>
            <asp:Literal ID="ltrARCDescription" runat="server"></asp:Literal>
            <br />
            <br />
           
            <asp:LinkButton ID="lbClearBasket" CssClass="lbClearBasket css_btn_class" runat="server"
                OnClick="lbClearBasket_Click"><i class="thrash"></i>Clear Basket</asp:LinkButton>
            <br />
            <span id="replenishmentMsg" runat="server" visible="false"><font color="red">If you are ordering consignment stock please tick the Replenishment box.</font></span>
        </strong>
    </div>
    <br />

    <div style="float: left; vertical-align: top; position: relative;">
        <table width="100%" cellpadding="5" cellspacing="2" border="0" id="MasterBasketTable">
            <tr bgcolor="#fbcaca">
                <td width="10%">
                    <b>
                        <asp:Label ID="Label4" Text="Code" runat="server"></asp:Label></b>
                </td>
                <td width="20%">
                    <b>
                        <asp:Label ID="Label3" Text="Product Name" runat="server" Width="385px"></asp:Label></b>
                </td>
                <td id="tdManufacturerHeader" runat="server" visible="true" width="10%">
                    <b>
                        <asp:Label ID="Label2" Text=" " runat="server" Width="80px"></asp:Label></b>
                </td>

                <td id="tdCSDHeader" runat="server" visible="false" width="10%">
                    <b>
                        <asp:Label ID="lbliscsd" Text="CSD     ?" runat="server" Width="50px"></asp:Label><br />
                        <asp:Label ID="lbliscsd2" Text="[Activation]" runat="server" Width="80px"></asp:Label></b>
                </td>
                <td id="tdReplenishmentHeader" runat="server" visible="false" width="10%">
                    <b>
                        <asp:Label ID="lblReplenishment" Text="Replenishment ?" runat="server" Width="100px"></asp:Label></b>
                </td>
                <td id="tdReplenishmentHeaderFill" runat="server" width="10%"></td>
                <td class="auto-style1">
                    <b>
                        <asp:Label ID="Label1" Text="Quantity" runat="server" Width="50px"></asp:Label></b>
                </td>
                <td id="tdHeaderPrice" runat="server" class="auto-style2" width="20%">
                    <b>
                        <asp:Label ID="lblHeaderPrice" Text="Unit Price" runat="server" Width="80px"></asp:Label></b>
                </td>
                <td id="tdHeaderTotalAmount" runat="server" width="15%">
                    <b>
                        <asp:Label ID="lblHeaderAmount" Text="Amount" runat="server" Width="80px"></asp:Label></b>
                </td>
                <td width="5%">
                    <b>
                        <asp:Label ID="Label7" Text="" Width="30px" runat="server"></asp:Label></b>
                </td>
            </tr>
            <asp:Repeater runat="server" ID="dlProducts" OnItemDataBound="ProductsRepeater_ItemBound"
                OnItemCommand="ProductsRepeater_ItemCommand">
                <ItemTemplate>
                    <tr bgcolor="#cccccc" runat="server" id="trdlProducts">
                        <td width="10%">
                            <asp:TextBox ID="lblIsGPRSChipEmpty" runat="server" Text='<%# Eval("IsGPRSChipEmpty") %>' Visible="false"></asp:TextBox>
                            <asp:TextBox ID="lblProductId" runat="server" Text='<%# Eval("ProductId") %>' Visible="false"></asp:TextBox>
                            <asp:Label ID="lblProductCode" runat="server" Text='<%# Eval("ProductCode")%>'></asp:Label>
                            <asp:Label ID="lblOrderitemid" runat="server" Visible="false" Text='<%# Eval("OrderItemId")%>'></asp:Label>
                            <asp:TextBox ID="lblProductCategoryID" runat="server" Visible="false" Text='<%# Eval("CategoryId")%>'></asp:TextBox>
                        </td>
                        <td width="20%">
                            <asp:Label ID="lblProductTitle" runat="server" Width="385px"><%# Eval("ProductName") %></asp:Label>
                            <asp:Literal ID="lblConnectionOnlydescription" Visible='<%# Eval("IsConnectionOnlyProduct")%>' runat="server" Text="<br/><br/><i><b>Note:</b> This is an airtime only product, the TCD is not supplied. If you require a TCD device please order a Bundle product or order hardware only from the accessories section </i>"></asp:Literal>
                            <asp:TextBox ID="lblProductType" runat="server" CssClass="NoStyleTextBox" Text='<%# Eval("ProductType")%>' Visible="false"></asp:TextBox>
                            <asp:Label ID="lblOptionId" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblProductOptionsCount" runat="server" Text='<%# Eval("ProductOptionsCount") %>' Visible="false"></asp:Label>
                            <asp:Label ID="lblIsCSDProd" runat="server" Visible="false" Text='<%# Eval("IsCSDProd")%>'></asp:Label>
                            <asp:Label ID="lblIsReplenishmentProd" runat="server" Visible="false" Text='<%# Eval("IsReplenishmentProd")%>'></asp:Label>
                            <asp:Label ID="lblIsConnectionOnlyEM" runat="server" Visible="false" Text='<%# Eval("IsConnectionOnlyProduct")%>'></asp:Label>
                        </td>
                        <td id="tdManufacturer" runat="server" visible="true" width="10%">
                            <asp:Label ID="lblManufacturer" runat="server" Width="80px"></asp:Label>
                        </td>
                        <td align="center" runat="server" id="tdCSDValue" visible="false" width="10%">
                            <asp:RadioButton runat="server" ID="rdbCSD" OnCheckedChanged="rdbCSD_CheckedChanged" AutoPostBack="true"
                                Visible="false" GroupName="rdbCSDGroup" />
                        </td>
                        <td align="center" runat="server" id="tdReplenishment" visible="false" width="10%">
                            <asp:RadioButton runat="server" ID="rdbReplenishment" OnCheckedChanged="rdbReplenishment_CheckedChanged"
                                AutoPostBack="true" Visible="false" GroupName="rdbCSDGroup" />
                        </td>
                        <td id="tdReplenishmentFill" runat="server" width="10%"></td>
                        <td width="10%">
                            <asp:Label ID="lblProductQty" runat="server" Width="50px"><%# Eval("ProductQty")%></asp:Label>
                        </td>
                        <td id="tdProductPrice" runat="server" width="20%">
                            <asp:Label ID="lblProductPrice" runat="server" Width="65px">£<%# Eval("Price")%></asp:Label>
                        </td>
                        <td id="tdProductPriceTotal" runat="server" width="15%">
                            <asp:Label ID="lblProductPriceTotal" runat="server" Width="80px">£<%# Eval("ProductPriceTotal")%></asp:Label>
                        </td>

                        <td width="30px">
                            <asp:ImageButton ID="btnRemoveFromBasket" runat="server" CommandName="RemoveFromBasket"
                                CommandArgument='<%# Eval("OrderItemId") %>' ValidationGroup="no" ImageUrl="~/Images/shopping_cart_remove.png" ToolTip="Remove from basket" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2" align="left" width="100%" style="border-left-width: 0;">
                            <asp:Repeater runat="server" ID="rptrChipNos"
                                OnItemCommand="rptrChipNos_ItemCommand"
                                OnItemDataBound="rptrChipNos_ItemBound" EnableViewState="true">
                                <HeaderTemplate>
                                    <table cellpadding="5" cellspacing="1" border="0" id='<%# Eval("ProductCode")%>'>
                                        <tr bgcolor="#cccccc" id="trlblIdent" runat="server">
                                            <td align="center" id="thChipNo" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="LabelChipNo" Text="Chip No" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="thInstallID" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="lblInstallID" Text="Install ID" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="thTCDSerialNo" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="lblTCDSerialNo" Text="TCD Serial No" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="thSiteName" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="lblSiteName" Text="Site Name" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="tdlblIdent" runat="server" visible='false'>
                                                <b>
                                                    <asp:Label ID="lblIdent" Text="Ident" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="thPanelID" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="lblPanelID" Text="PanelID" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center">
                                                <b>
                                                    <asp:Label ID="Label16" Text="Post Code" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="thOptions" runat="server">
                                                <asp:Label ID="lblOptions" Text="Options" Width="120px" runat="server"></asp:Label></b>
                                            </td>
                                            <td align="center" id="tdMainIPAddress" runat="server" visible="false">
                                                <b>
                                                    <asp:Label ID="lblIP" Text="IP" Width="120px" runat="server"></asp:Label>
                                                </b>
                                            </td>
                                            <td align="center">
                                                <b>
                                                    <asp:Label ID="Label9" Text="" runat="server"></asp:Label></b>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr bgcolor="#cccccc" id="trtxtPSTNNo" runat="server">
                                        <td align="center" runat="server" id="tdChipNo" visible='<%# Eval("ChipNo_Flag")%> '>
                                            <asp:TextBox ID="txtChipNo" runat="server" Width="80px" Text='<%# Eval("GPRSNo")%>'
                                                onKeyPress="return isNumberKey(event);" MaxLength="6" >
                                            </asp:TextBox>
                                        </td>
                                        <td align="center" id="tdInstallID" runat="server" visible='<%# Eval("InstallID_Flag")%>'>
                                            <asp:TextBox ID="txtInstallID" runat="server" Width="80px" Text='<%# Eval("GPRSNo")%>' MaxLength="10">
                                            </asp:TextBox>
                                            <asp:CustomValidator ID="CustomValidator199" runat="server" ControlToValidate="txtInstallID"
                                                ErrorMessage="Invalid !" Display="Dynamic" SetFocusOnError="true"
                                                ValidationGroup="1" Enabled='<%# Eval("InstallID_Flag")%>'
                                                ClientValidationFunction="ValidateInstallID"
                                                ForeColor="Red">
                                            </asp:CustomValidator>
                                            <asp:RequiredFieldValidator ID="RVFInstallID" runat="server" ErrorMessage="*" EnableClientScript="true"
                                                ForeColor="Red" ControlToValidate="txtInstallID" SetFocusOnError="true" InitialValue="0000"
                                                ValidationGroup="1" Display="Static"></asp:RequiredFieldValidator>

                                        </td>
                                        <td align="center" id="tdTCDSerialNo" runat="server" visible='<%# Eval("TCD_Flag")%>'>
                                            <asp:TextBox ID="txtTCDSerialNo" runat="server" Width="80px" 
                                                Text='<%# Eval("EM_TCD_SerialNo")%>' MaxLength="20">
                                            </asp:TextBox>
                                            <asp:RegularExpressionValidator id="txtRegexValTCD"
                                                ControlToValidate="txtTCDSerialNo" EnableClientScript="true" runat="server" Display="Dynamic" 
                                                ValidationExpression="^([0-9]{2}[-])([0-9]{6}[-])([0-9]{1})" ErrorMessage="Invalid format." ForeColor="Red"
                                                SetFocusOnError="true" ValidationGroup="1" ></asp:RegularExpressionValidator>
                                            <asp:CustomValidator ID="CustomValidator2" runat="server" ControlToValidate="txtTCDSerialNo"
                                                ErrorMessage="Invalid SerialNo!" Display="Dynamic" SetFocusOnError="true"
                                                ValidationGroup="1" ClientValidationFunction="VerifyTCD" ForeColor="Red">
                                            </asp:CustomValidator>
                                        </td>
                                        <td align="center" id="tdSiteName" runat="server" visible='<%# Eval("ShowSitename") %>'>
                                            <asp:TextBox ID="txtSiteName" runat="server" Width="80px" Text='<%# Eval("SiteName")%>' MaxLength="64"></asp:TextBox>
                                        </td>

                                        <td align="center" id="tdtxtpanelID" runat="server" visible="false">
                                            <asp:TextBox ID="txtPanelID" runat="server" Width="140px" Text='<%# Eval("GSMNo")%>'
                                                onKeyPress="return checkSpecialKeys(event);" MaxLength="11"></asp:TextBox>
                                        </td>

                                        <td align="center" id="tdtxtPSTNNo" runat="server"
                                            visible='<%# Convert.ToBoolean(Eval("IsEmizonProduct")) ? false : Eval("IsCSDUser")%>'>
                                            <asp:TextBox ID="txtPSTNNo" runat="server" Width="140px" Text='<%# Eval("PSTNNo")%>' MaxLength="20"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFietor1" runat="server" ErrorMessage="*" EnableClientScript="true"
                                                ForeColor="Red" ControlToValidate="txtPSTNNo" SetFocusOnError="true" InitialValue="Select"
                                                ValidationGroup="1" Display="Static"></asp:RequiredFieldValidator>
                                            <asp:CustomValidator ID="valIdentPSTNNo" runat="server" ControlToValidate="txtPSTNNo"
                                                ErrorMessage="Invalid Ident!" Display="Static" SetFocusOnError="true"
                                                ValidationGroup="1" CID='<%# Eval("CategoryID")%>'
                                                ClientValidationFunction="ValidateStockandCategory"
                                                ForeColor="Red">
                                            </asp:CustomValidator>
                                        </td>
                                        <td align="center">
                                            <asp:TextBox ID="txtPostCode" runat="server" Width="80px" Text='<%# Eval("GPRSNoPostCode")%>'
                                                onKeyPress="return checkSpecialKeys(event);" MaxLength="10"></asp:TextBox>
                                        </td>
                                        <td align="center" id="tdOptionId" runat="server">
                                            <asp:Label ID="lblOptionId" runat="server" Width="65px" Text='<%# Eval("OptionId")%>'
                                                Visible="false"></asp:Label>
                                            <asp:DropDownList ID="ddlOptions" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                        <td align="center" id="tdlblMainIPAddress" runat="server" visible="false">

                                            <asp:DropDownList ID="ddlMainIPAddress" runat="server" OnSelectedIndexChanged="ddlMainIPAddress_SelectedIndexChanged" AutoPostBack="true">
                                                <asp:ListItem Value="1" Text="Static"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Dynamic" Selected="True"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td align="center">
                                            <asp:ImageButton ID="btnRemoveFromBasket" runat="server" CommandName="RemoveFromBasket"
                                                CommandArgument='<%# Eval("OrderItemDetailId") %>' ImageUrl="~/Images/shopping_cart_remove.png"
                                                ToolTip="Remove from basket" />

                                            <asp:HiddenField ID="hdnSitenameEnabled" runat="server" Value='<%# Eval("ShowSitename") %>' />
                                            <asp:HiddenField ID="hdnOrderItemDetailId" runat="server" Value='<%# Eval("OrderItemDetailId") %>' />
                                            <asp:HiddenField ID="hdnInstallIDFlag" runat="server" Value='<%# Eval("InstallID_Flag") %>' />
                                            <asp:HiddenField ID="hdnIsEmizonProduct" runat="server" Value='<%# Eval("IsEmizonProduct") %>' />
                                            <asp:HiddenField ID="hdnConnectionOnly" runat="server" Value='<%# Eval("IsConnectionOnly") %>' />
                                        </td>
                                    </tr>

                                    <tr id="trStaticIPDetailsHeader" bgcolor="#cccccc" runat="server" visible="false">
                                        <td style="background-color: white"></td>
                                        <td align="center" id="tdlblIPAddress" runat="server" visible="true">
                                            <b>
                                                <asp:Label ID="lblIPAddress" Text="IP Address" Width="80px" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="center" id="tdlblMask" runat="server" visible="true">
                                            <b>
                                                <asp:Label ID="lblMask" Text="Mask" Width="80px" runat="server"></asp:Label></b>
                                        </td>
                                        <td align="center" id="tdlblGateway" runat="server" visible="true">
                                            <b>
                                                <asp:Label ID="lblGateway" Text="Gateway" Width="80px" runat="server"></asp:Label></b>
                                        </td>

                                    </tr>

                                    <%--ORD:42--%>
                                    <tr bgcolor="#cccccc" id="trStaticIPDetails" runat="server" visible="false">
                                        <td bgcolor="#ffffff"></td>
                                        <td align="center" id="tdtxtIPAddress" runat="server" visible="True">
                                            <asp:TextBox ID="txtIPAddress" runat="server" Width="80px" onKeyPress="return isValidateIPKeys(event);"
                                                MaxLength="15" ValidationGroup="1" Text='<%# Eval("IPAddress")%>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                ForeColor="Red" ControlToValidate="txtIPAddress" SetFocusOnError="true" BackColor="Yellow"
                                                ValidationGroup="1" Display="Static"></asp:RequiredFieldValidator>
                                        </td>
                                        <td align="center" id="tdtxtMask" runat="server" visible="True">
                                            <asp:TextBox ID="txtMask" runat="server" Width="80px"
                                                MaxLength="15" onKeyPress="return isValidateIPKeys(event);" Text='<%# Eval("Mask")%>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                ForeColor="Red" ControlToValidate="txtMask" SetFocusOnError="true" BackColor="Yellow"
                                                ValidationGroup="1" Display="Static"></asp:RequiredFieldValidator>
                                        </td>
                                        <td align="center" id="tdtxtGateway" runat="server" visible="True">
                                            <asp:TextBox ID="txtGateway" runat="server" Width="80px"
                                                MaxLength="15" onKeyPress="return isValidateIPKeys(event);" Text='<%# Eval("Gateway")%>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                ForeColor="Red" ControlToValidate="txtGateway" SetFocusOnError="true" BackColor="Yellow"
                                                ValidationGroup="1" Display="Static"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <%--END - ORD:42--%>

                                    <tr bgcolor="#cccccc" runat="server">
                                        <td colspan="7" id="tdlblWarnForPanelID" runat="server" visible="false">
                                            <asp:Label ID="lblWarn" runat="server" Text="Please note – CSL only require the first 11 digits of the Panel ID " Font-Size="10" ForeColor="red">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </ItemTemplate>

                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <tr bgcolor="#fbcaca">
                        <td colspan="7">&nbsp
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td colspan="3" align="right">
                            <asp:Label ID="Label4" Text="Grand Total" runat="server" Width="470px" Visible="false"></asp:Label>
                        </td>
                        <td style="border-right: 0;">
                            <asp:Label ID="lblTotalQty" Text="" runat="server" Width="45px" Visible="false"></asp:Label>
                        </td>
                        <td style="border-left: 0;">
                            <asp:Label ID="Label8" Text="" runat="server" Width="50px" Visible="false"></asp:Label>
                        </td>
                        <td colspan="2">
                            <asp:Label ID="lblTotalPrice" Text="" runat="server" Width="110px" Visible="false"></asp:Label>
                        </td>
                    </tr>
                </FooterTemplate>
            </asp:Repeater>
        </table>
        <br />
        <br />
        <div id="divDuplicatesAllowed" runat="server">
            <asp:CheckBox ID="chkDuplicatesAllowed" Text="We have noticed some of the chip numbers have been previously used or may exist in your current order. Please tick here to accept duplicate chip numbers."
                runat="server" Font-Bold="true" ForeColor="Red" />
            <br />
            <br />
        </div>
        <div id="divDuplicatePanelIDAllowed" runat="server">
            <asp:CheckBox ID="chkDuplicatePanelIDAllowed" Text="We have noticed some of the PanelID numbers have been previously used or may exist in your current order. Please tick here to accept duplicate PanelID numbers."
                runat="server" Font-Bold="true" ForeColor="Red" />
            <br />
            <br />
        </div>
        <div id="divReplenishmentAllowed" runat="server" visible="false">
            <asp:CheckBox ID="chkReplenishmentAllowed" runat="server" Font-Bold="true" Font-Size="1.2em" ForeColor="Red" />
            <br />
            <br />
        </div>
        <div id="divPanelIDNotEntered" runat="server" visible=" false">
            <asp:Label ID="ChkPanelIDNotEntered" Text="Please note – The panel ID must be entered before signals can be sent to the ARC. This should be obtained from the installer, if known at this stage. If not known the installer must call CSL Technical Support to update this field upon commissioning " runat="server" Font-Bold="true" Font-Size="1em" ForeColor="Red" />
            <br />
            <br />
        </div>
        <div style="float: right; vertical-align: top; position: relative;">
            <asp:Button ID="btnContinueShopping" Text="Confirm and Add more products" CssClass="css_btn_class"
                runat="server" OnClick="btnContinueShopping_Click" ValidationGroup="1" />
            <asp:Button ID="btnCheckout" Text="Confirm and proceed to Checkout" CssClass="css_btn_class"
                runat="server" OnClick="btnCheckout_Click" ValidationGroup="1" />
        </div>
    </div>
    <asp:HiddenField ID="lnkRedirectURL" runat="server" Value="~/Default.aspx" />
    <asp:HiddenField ID="hdnSafelinkbyIPSec" runat="server" />
    <asp:HiddenField ID="hdnLocktoDefaultOption" runat="server" />
    <asp:HiddenField ID="HiddenFieldARCid" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnInstallID_Flag" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnInstallIDStrategy" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnInstallIDLen" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnTCDStockCheck" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnARCisCSD" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnEMConnectionOnlycodes" runat="server" />

    <asp:Literal runat="server" ID="ltrReplenishment" Visible="false" Text="Please ensure you tick the Replenishment checkbox for any consignment products."></asp:Literal>
    <asp:Literal runat="server" ID="ltrIdentRpt" Visible="false" Text="IDENT should not be repeat."></asp:Literal>
    <asp:Literal runat="server" ID="ltrPostcode" Visible="false" Text="At least one of the Postcode values is invalid."></asp:Literal>
    <asp:Literal runat="server" ID="ltrIdentCSD" Visible="false" Text="IDENT is mandatory for CSD."></asp:Literal>
    <%-- <asp:Literal runat="server" ID="ltrPanelID" Visible="false" Text="Please note – The panel ID must be entered before signals can be sent to the ARC. This should be obtained from the installer, if known at this stage. If not known the installer must call CSL to update this field upon commissioning"></asp:Literal>--%>
    <asp:Literal runat="server" ID="ltrSiteName" Visible="false" Text="Site Name is mandatory."></asp:Literal>
    <asp:Literal runat="server" ID="ltrChpNoVal" Visible="false" Text="At least one of the Chip Number values already exist."></asp:Literal>
    <asp:Literal runat="server" ID="ltrPostcodeVal" Visible="false" Text="At least one of the Postcode values is invalid."></asp:Literal>
    <asp:Literal runat="server" ID="ltrIdentMand" Visible="false" Text="IDENT is mandatory."></asp:Literal>
    <asp:Literal runat="server" ID="ltrChpNoInvld" Visible="false" Text="At least one of the Chip Number Values is invalid."></asp:Literal>
    <asp:Literal runat="server" ID="ltrBasket" Visible="false" Text="Please add products to basket first."></asp:Literal>
    <asp:Literal runat="server" ID="ltrCSD" Visible="false" Text="Please select either CSD [Activation] or Replenishment."></asp:Literal>
    <asp:Literal runat="server" ID="ltrReplenishmentCount1" Visible="false" Text="You currently have "></asp:Literal>
    <asp:Literal runat="server" ID="ltrReplenishmentCount2" Visible="false" Text=" replenishment products that have not yet been activated. Please tick here to continue."></asp:Literal>
    <asp:Literal runat="server" ID="ltdPanelIDMand" Visible="false" Text=" Please note – For Risco, the panel ID must be entered before signals can be sent to the ARC. This should be obtained from the installer, if known at this stage. If not known the installer must call CSL Technical Support to update this field upon commissioning"></asp:Literal>
    <asp:Literal runat="server" ID="ltrIPAddress" Visible="false" Text=" Please enter Valid IP Address."></asp:Literal>
    <asp:Literal runat="server" ID="ltrMask" Visible="false" Text=" Please enter Valid Mask."></asp:Literal>
    <asp:Literal runat="server" ID="ltrGateway" Visible="false" Text=" Please enter Valid Gateway."></asp:Literal>
    <asp:Literal runat="server" ID="ltrPyronixChipNos" Visible="false" Text="Please provide 6 digits for Pyronix products. Please append 00  at the beginning of the Chip No."></asp:Literal>
    <asp:Literal runat="server" ID="ltrInstallIDMsg" Visible="false" Text="Please provide Install ID."></asp:Literal>
    <asp:Literal runat="server" ID="ltrDuplicateInstallIDMsg" Visible="false" Text="Duplicate Install ID is not allowed"></asp:Literal>
    <asp:Literal runat="server" ID="ltrTCDRequiredAlert" Visible="false" Text="TCD SerialNo is mandatory on Activation orders."></asp:Literal>
    <asp:Literal runat="server" ID="ltrTCDDuplicate" Visible="false" Text="TCD SerialNo is duplicated."></asp:Literal>
</asp:Content>
<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .auto-style1 {
            width: 19%;
        }

        .auto-style2 {
            width: 156px;
        }
    </style>
</asp:Content>

