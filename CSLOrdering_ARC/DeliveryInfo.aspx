<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DeliveryInfo.aspx.cs" Inherits="DeliveryInfo" %>


<asp:Content ContentPlaceHolderID="contentPageTitle" ID="contentTitle" runat="server">
    <div class="fontSize">
        Delivery Info
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">
    <br />
    <br />
    <br />
    <div>

        <p>
            <%--<strong style="font-size: 14px;">UK Mainland Orders</strong>--%>
            <strong style="font-size: 18px;">UK Mainland Orders</strong>
            <p>
                CSL offers a Next Day delivery service for all UK Mainland orders. If you place your order by 3pm Monday- Friday, your order will be dispatched the same day for a Next Day delivery. Any orders placed after 3pm will get dispatched the following day.
            </p>
            <p>
                Our courier will deliver the parcel between 9am-6pm. If you are not available to receive the parcel, our courier will leave a delivery attempted card. You will be able to contact the local depot from details on the delivery card to re-arrange a delivery date. 
            </p>
            <p>
                The Next Day delivery cost is £7.95
            </p>
            We also offer the following timed delivery options.
				<ul style="padding-left: 10px; margin: 16px;">
                    <li>Pre 9:00 am - £25.00 </li>
                    <li>Pre 10:30 am - £15.00</li>
                    <li>Pre 12:00 pm - £11.95 </li>
                </ul>
            <p>
                If you have selected a timed delivery for your order, this will be delivered from 7am onwards.
            </p>
            <p>
                <b>Please allow up to 3 working days for delivery to the following parts of Scotland:
                </b>
                <ul style="padding-left: 10px; margin: 16px;">
                    <li>Scottish Highlands</li>
                    <li>Arran</li>
                    <li>Cowal Peninsula</li>
                </ul>
            </p>
            <br />
            <br />
            <strong style="font-size: 18px;">Northern Ireland Orders</strong>
            <br />
            <br />
            <p>
                Orders being sent to Northern Ireland will be delivered within 2 working days and the delivery will be charged at £20. All orders received by 3pm will be dispatched the same day.
            </p>
            <p>
                Our courier will deliver the parcel between 9am-6pm. If you are not available to receive the parcel, our courier will leave a delivery attempted card. You will be able to contact the local depot from the details on the delivery card to re-arrange a delivery date. 
            </p>
            <p>
                Please note we do not operate a delivery service on Bank Holidays.
            </p>
            <p>
                If you have any queries regarding orders, please contact our Logistics Department on +44 (0)1895 474465 or email <a style="font-weight: bold; color: #585858;" href="mailto:orders@csldual.com">orders@csldual.com</a>. 
            </p>
            <br />
            <br />
            <strong style="font-size: 18px;">Republic of Ireland Orders</strong>
            <br />
            <br />
            <p>
                Orders being sent to the Republic of Ireland will be delivered within 2-3 business days and delivery is charged at £25.00. All orders received by 3pm will be dispatched the same day.
            </p>
            <p>
                Our courier will deliver the parcel between 9am-6pm. If you are not available to receive the parcel, our courier will leave a delivery attempted card. You will be able to contact the local depot from the details on the delivery card to re-arrange a delivery date. 
            </p>
            <p>
                Please note we do not operate a delivery service on Bank Holidays.
            </p>
            <p>
                If you have any queries regarding orders, please contact our Logistics Department on +44 (0)1895 474465 or email <a style="font-weight: bold; color: #585858;" href="mailto:orders@csldual.com">orders@csldual.com</a>. 
            </p>

        </p>

    </div>
</asp:Content>

