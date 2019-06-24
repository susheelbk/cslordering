<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Manager_Admin_Menu.aspx.cs" Inherits="Manager_Admin_Menu" %>


<asp:Content ID="Content3" ContentPlaceHolderID="contentWrapper" Runat="Server">
   <%-- <div>
        <ul style="line-height:20px">
            <li>
                This page is used to upgrade/downgrade/reconnect/disconnect the unit installed.
            </li>
            <li>
                The request with the unit details (chip number/data number) are made and sent to the billing team.
            </li>
        </ul>
    </div>--%>

    <table width="100%" border="0" cellspacing="1" cellpadding="5">
				<tbody><tr>
					<td width="250">
						<!--<p>ARC Administration</p>-->
						<p>Please select an option from below.</p>
						<table border="0" cellspacing="5" cellpadding="5">
						    <!--
						    <tr>
								<td><a href="manager_installer_menu.aspx" class="two"><img id="bt_reassign" tabindex="1" src="/images/bt_installer.jpg" style="border-width:0px;" /></a>
								</td>
							</tr>
							-->
							<tbody>
                            <tr>
								<td><a href="gradeform.aspx?dr=u" class="two">UPGRADE REQUEST</a>
								</td>
							</tr>
							<tr>
								<td><a href="gradeform.aspx?dr=d" class="two">DOWNGRADE REQUEST</a>
								</td>
							</tr>
                                <tr>
								<td><a href="gradeform.aspx?dr=r" class="two">REGRADE REQUEST (EMIZON)</a>
								</td>
							</tr>
							<tr>
								<td><a href="dr_form.aspx?dr=r" id="reconnect" class="two">RECONNECT REQUEST</a>
								</td>
							</tr>
							<tr>
								<td>
								<a href="dr_form.aspx?dr=d" id="disconnect" class="two">DISCONNECT REQUEST</a>
								</td>
							</tr>
							<td>

							<br/>							<br/>							<br/>
						

							</td>

					
						</tbody></table>
					</td>
					<!--<td align="center" height="180" width="250">
						<br/>
						&nbsp;&nbsp;<a href="ProductList.aspx?CategoryId=6"><img src="Images/GradeShift_Logo.png" border="0"></a></td>-->
					<td></td>
				</tr>
			</tbody></table>
</asp:Content>


