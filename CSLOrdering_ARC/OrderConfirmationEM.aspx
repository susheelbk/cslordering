<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="OrderConfirmationEM.aspx.cs"
    Inherits="OrderConfirmationEM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <link rel="stylesheet" href="Styles/jquery.dataTables.min.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPageTitle" runat="Server">
    Order Details
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="contentWrapper" runat="Server">

    <script type="text/javascript" src="scripts/jquery.linq.js"></script>
    <script type="text/javascript" src="scripts/jquery.linq-vsdoc.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(function () {
            var progressbar = $("#progressbar"),
              progressLabel = $(".progress-label");
            var tableLoaded = false;
            $('#orderTable').hide();
            $('#spReload').hide();

            progressbar.progressbar({
                max: 100,
                value: 0,
                change: function () {
                    progressLabel.text(progressbar.progressbar("value") + "%");
                },
                complete: function () {
                    progressLabel.text("Fetching order details");
                    if (!tableLoaded) {
                        fetchOrderData();
                        $('#orderTable').show();
                        $('#spReload').show();
                        tableLoaded = true;
                    }
                }
            });

            function progress() {
                var val = progressbar.progressbar("value") || 0;
                progressbar.progressbar("value", val + 25);
                if (val < 99) {
                    setTimeout(progress, 500);
                }
            }

            setTimeout(progress, 0);
        });


        var myLocalData = {};
        function fetchOrderData() {
            var table = $('#orderTable').DataTable();
            table.destroy();

            $.ajax({
                type: "Post",
                url: "OrderConfirmationEM.aspx/GetOrderInfo",
                data: " { 'orderid':" + $('#hdnOrderID').val() + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    myLocalData.OrderData = JSON.parse(response.d);
                    var trHTML = '';
                    $.each(myLocalData.OrderData, function (i, item) {
                        if (item.EM_APIStatusID == 9) {
                            trHTML += '<tr><td>' + item.ProductCode + '</td><td>' + item.ProductDesc + '</td><td>' + item.EMNO + '</td><td>InstallID: '
                            + '<input id=InstallID' + i + ' type=text value=' + item.InstallID + ' />'
                            + '<input id=OrderItemDetailID' + i + ' type=text value=' + item.OrderItemDetailId + ' style="display:none" />'
                            + '<div class="alert alert-danger"> Invalid InstallID! Please update and try again </div>'
                            + '<input type=button value="Save" class=css_btn_class onclick=UpdateInstallID(document.getElementById("InstallID' + i + '").value' + ',' + 'document.getElementById("OrderItemDetailID' + i + '").value); />'
                            + '</td><td>' + item.SerialNo + '</td><td>' + item.EM_APIMsg + '</td></tr>';
                        }
                        else {
                            trHTML += '<tr><td>' + item.ProductCode + '</td><td>' + item.ProductDesc +
                                '</td><td>' + item.EMNO + '</td><td>' + (item.InstallID ? 'InstallID: ' + item.InstallID : "") +
							'</td><td>' + item.SerialNo + '</td><td>' + item.EM_APIMsg + '</td></tr>';
                        }
                    });
                    $("#orderTable").find("tr:gt(0)").remove();
                    $('#orderTable').append(trHTML);
                    $('#orderTable').DataTable(
                         {
                             //"scrollY": "500px",
                             //"scrollCollapse": true,
                             //"paging": false
                         }
                        );
                },
                failure: function (msg) {
                    console.warn(msg);
                }
            });
        }

        function Reload() {
            $('#orderTable').hide();
            fetchOrderData();
            $('#orderTable').show();
        }

        function UpdateInstallID(InstallID,OrderItemDetailID) {

            $.ajax({
            type: "Post",
            url: "OrderConfirmationEM.aspx/UpdateInstallID",
            data: " { 'InstallID':" + InstallID + " , 'OrderItemDetailID':" + OrderItemDetailID + " ,'OrderID':" +  $('#hdnOrderID').val() +  "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnUpdateInstallIDSuccess,
            failure: function (msg) {
                console.warn(msg);
            }
            });
        }

        function OnUpdateInstallIDSuccess() {
            location.reload(true);
        }

    </script>


    <asp:Literal ID="ltrMessage" runat="server" Text="Your Order has been confirmed and we are processing your order. Please store your order number."></asp:Literal>
    <div style="margin-left: auto; margin-right: auto">
        <br />
        CSL  Online Order No :&nbsp; <b>
            <asp:Label ID="lblOrderNumber" runat="server" Font-Size="1.5em"></asp:Label></b>
        <br />
        Customer Order Ref :&nbsp; <b>
            <asp:Label ID="lblOrderRef" runat="server" Font-Size="1.5em"></asp:Label></b>
        <br />
    </div>
    <br />
    <br />

    <h3>Please wait while we fetch EMNo details</h3>
    <br />

    <div id="progressbar"></div>
    <br />
    <span id="spReload">If EMNo is not shown, please click on the below button. If the details are not shown, this could be due to an internal issue.
        <br />
        
        <input type="button" onclick="Reload()" value="Reload Order Info" class="ui-button" />
    </span>
    <br />
    <br />
    <table id="orderTable" class="table table-hover"> <%--class="display" width="100%" cellspacing="0">--%>
        <thead>
            <tr>
                <th>ProductCode</th>
                <th>ProductDesc</th>
                <th>EMNO</th>
                <th></th>
                <th>SerialNo</th>
                <th>API Message</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>ProductCode</th>
                <th>ProductDesc</th>
                <th>EMNo</th>
                <th></th>
                <th>SerialNo</th>
                <th>API Message</th>
            </tr>
        </tfoot>
    </table>
    <br />
    <%--<asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="true" class="display" Width="100%" CellSpacing="0">
    </asp:GridView>--%>

    <asp:HiddenField ID="hdnOrderID" runat="server" Value="38" ClientIDMode="Static" />

</asp:Content>

