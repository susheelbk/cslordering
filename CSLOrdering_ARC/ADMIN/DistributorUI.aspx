<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true" CodeFile="DistributorUI.aspx.cs" Inherits="ADMIN_AdministratorUI" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">

    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode != 8)
                if ((charCode < 48 || charCode > 57) && charCode != 43)
                    return false;
            return true;
        }
        function EnterEvent(e) {
            if (e.keyCode == 13) {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        //added by priya
        $(function () {

            $("#accordion").accordion({
                collapsible: true,
                active: false
            });
        });
    </script>
    <style type="text/css">
        .style1 {
            width: 278px;
        }

        .style2 {
            /*width: 25%;*/
        }

        .chkListStyle td {
            padding-left: 35px;
        }

        .chkListStyle label {
            padding-left: 5px;
        }
    </style>
    <link href="../Styles/DropdownStyles.css" type="text/css" rel="stylesheet" />

    <div>
        <table width="102%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div id="accordion">
                    <h2> <b>Instructions for new distributor landing page (applies to M2M Portal only):</b></h2>                   
                    <div>
                        <ul style="line-height: 20px">                            
                        <li>Click on "Create new Distributor" to create a new landing page. The page also displays existing landing pages along with search option.</li>
                        <li>Once all graphics are added, click on save to first save the images to server and confirm to be published on m2m portal.</li>
                        <li>Specify a unique name which is then used to access the page. Ex: landingpage1 - the url will then look like https://m2mconnect.csldual.com/landingpage1</li>
                        <li>Provide graphics for each section of the page.</li>
                        <li>Url Name  : landingpage1</li>
                        <li>Header Image: select an image for top left corner header logo  </li>
                        <li>Main Image : the graphic which goes in the middle of the page on aligned to left.</li>
                        <li>Banner Image  : graphic which is displayed under the main graphic.<br /></li>

                        <li>Color codes: LEAVE BLANK FOR DEFAULT, Colour code is a html code ex: #ff22ff, <a href="https://htmlcolorcodes.com/color-picker/" target="_blank">click here for codes</a></li>
                        <li>Colour code from image: <a href="https://html-color-codes.info/colors-from-image/" target="_blank">Pick color codes from any images by clicking here.</a></li> 
                        <li>Footer Background Color: Please select a background colour code, make sure this matches with the footer icons background.  </li>
                        <li>Footer Text Color : html colour code to be used on the text displayed under the footer icons<br /></li>

                        <li>Footer1 Image : Footer icon 1, this is displayed on the bottom ribbon </li>
                        <li> Footer1Text : used as an image alternate text and also text displayed under the footer icon.</li>
                        <li>Footer1URL : fully formed URL used as a navigation link when clicked on the footer icon.<br /></li>

                        <li>Footer2 Image : same as above, leave the fields to remain blank</li>
                        <li>Footer2 Text : </li>
                        <li>Footer2 URL  * Provide complete url ex. "https://www.test.com" <br /></li>

                        <li>Footer3 Image:  </li>
                        <li>Footer3 Text : </li>
                        <li>Footer3 URL  * Provide complete url ex. "https://www.test.com" <br /></li>

                        <li>Footer4 Image:  </li>
                        <li>Footer4 Text : </li>
                        <li>Footer4 URL  * Provide complete url ex. "https://www.test.com" <br /></li>

                        <li>SignIn Button color : html colour code to be used on the sign-in button. ex: #ff4522 </li>
                        <li>SignUp Hyperlink color: same as above <br /></li>

                       
                            </ul>
                        </div>                   
                </div>

                </td>
            </tr>
             <tr>
            <td>
                <fieldset>
                    <legend><b style="color: red; font-size: 14px;">Manage Distributor</b></legend>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="100%">
                                <asp:Panel ID="pnluserlist" runat="server">
                                    <table width="100%">
                                        <tr>
                                            <td>
                                                <asp:Label ID="LblDname" runat="server" Font-Bold="True" Text="URL Name"></asp:Label>
                                                <asp:TextBox ID="txtDName" runat="server" Width="100px"></asp:TextBox>
                                                <asp:Button ID="btnSearch" runat="server" Text="Search" Width="80px" CssClass="css_btn_class" OnClick="btnSearch_Click" />
                                                 <asp:Button ID="btnShowAll" runat="server" Text="Show All" Width="80px" CssClass="css_btn_class" OnClick="btnShowAll_Click" />
                                            </td>                                           
                                            
                                           
                                        </tr>
                                        <tr>

                                            <td colspan="7">Choose a Distributer from below to edit    OR 
                                                <asp:Button ID="btnnewdistributor" runat="server" Text="Create new Distributor"
                                                    CssClass="css_btn_class" OnClick="btnnewdistributor_Click"></asp:Button>

                                            </td>

                                        </tr>
                                            <tr>
                                            <td colspan="7">
                                                <div id="ScrollList">
                                                    <asp:GridView ID="gvDistributors" runat="server" AutoGenerateColumns="false" CellPadding="4"
                                                        Width="100%" ForeColor="#333333" GridLines="Horizontal" AllowPaging="True" PageSize="15"
                                                        OnPageIndexChanging="gvDistributors_PageIndexChanging" EmptyDataText="No Data Found">
                                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                        <EmptyDataTemplate>
                                                            <asp:Label ID="lblNoRow" runat="server" Text="No Records Found!" ForeColor="Red"
                                                                Font-Bold="true"></asp:Label>
                                                        </EmptyDataTemplate>
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="S.No." HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <%# Container.DataItemIndex +1%>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="UrlName" HeaderText="Url Name" HeaderStyle-HorizontalAlign="Left" />
                                                            <asp:BoundField DataField="Active" HeaderText="Is Active" HeaderStyle-HorizontalAlign="Left" />
                                                           
                                                            <asp:TemplateField Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="IDKey" runat="server" Text='<%# Eval("ID") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Action" HeaderStyle-HorizontalAlign="Left">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="LinkButtonupdate" runat="server" OnClick="LinkButtonupdate_Click">Edit</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <PagerStyle BackColor="#284775" CssClass="gridPage" ForeColor="White" HorizontalAlign="Center" />
                                                        <PagerSettings Mode="NumericFirstLast" />
                                                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                        <EditRowStyle BackColor="#999999" />
                                                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                    </asp:GridView>
                                                </div>
                                            </td>
                                        </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="pnldistributordetails" runat="server" Visible="false">
                            <table>
                                <tr>
                                    <td align="left">
                                        <table width="95%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Literal ID="litAction" runat="server"></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width:30%">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                        Url Name </label>
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox ID="txtUrlName" runat="server"  Width="400px"></asp:TextBox> 
                                                
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width:30%" align="left">
                                                    <label>
                                                        Header Image </label>
                                                </td>
                                                <td align="left">
                                                    <asp:FileUpload ID="fuHeaderImage" runt="server" Width="400px" runat="server" /><br />
                                                      <asp:Image ID="imgHeaderImage" runat="server"  BorderColor="Black" Width="126px" Height="45px" BorderStyle="Dotted" BorderWidth="1" />
                                                    <!--<asp:TextBox ID="txtHeaderImage" runat="server"  Width="400px"></asp:TextBox>-->
                                                
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                       Main Image </label>
                                                </td>
                                                <td align="left">
                                                    <asp:FileUpload ID="fuMainImage" runt="server" Width="400px" runat="server" />  <br />
                                                    <asp:Image ID="imgMainImage" runat="server" BorderColor="Black" Width="612px" Height="408px" BorderStyle="Dotted" BorderWidth="1"/>                                               
                                                
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                       Banner Image </label>
                                                </td>
                                                <td align="left">
                                                    <asp:FileUpload ID="fuBannerImage" runt="server" Width="400px" runat="server" />  <br />
                                                    <asp:Image ID="imgBannerImage" runat="server" BorderColor="Black" Width="900px" Height="33px" BorderStyle="Dotted" BorderWidth="1"/>                                               
                                                
                                                </td>
                                            </tr>


                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="width: 30%" align="left">                                                
                                                       <label> Footer Background Color </label>
                                                </td>
                                                <td align="left">
                                               
                                                    <asp:TextBox ID="txtFooterBgColor" runat="server" Width="200px" class="colorPicker evo-cp0" />
                                                  <font size="2" color="#136301"> * LEAVE BLANK FOR DEFAULT, Colour code is a html code ex: #ff22ff, <a href="https://htmlcolorcodes.com/color-picker/" target="_blank">click here for codes</a></font>
                                                                                     
                                                    <br />
                                                
                                                </td>

                                         
                                            </tr>
                                            <tr><td>&nbsp;</td></tr>                                     
                                        
                                             <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                        Footer Text Color </label>
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox ID="txtFooterTextColor" runat="server"  Width="200px" ToolTip="Click here to see color pallette."></asp:TextBox>
                                                       <font size="2" color="#136301"> * LEAVE BLANK FOR DEFAULT, Colour code is a html code ex: #ff22ff, <a href="https://htmlcolorcodes.com/color-picker/" target="_blank">click here for codes</a></font> 
                                                </td>
                                             
                                            </tr>
                                             <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                        SignIn Button color </label>
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox ID="txtSignInButtoncolor" runat="server"  Width="200px" ToolTip="Click here to see color pallette."></asp:TextBox>
                                                     <font size="2" color="#136301"> * LEAVE BLANK FOR DEFAULT, Colour code is a html code ex: #ff22ff, <a href="https://htmlcolorcodes.com/color-picker/" target="_blank">click here for codes</a></font>
                                                </td>
                                            
                                            </tr>
                                        <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%" align="left">
                                                    <label>
                                                        SignUp Hyperlink color</label>
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox ID="txtSignUpHyperlinkcolor" runat="server"  Width="200px"></asp:TextBox>
                                                   <font size="2" color="#136301"> * LEAVE BLANK FOR DEFAULT, Colour code is a html code ex: #ff22ff, <a href="https://htmlcolorcodes.com/color-picker/" target="_blank">click here for codes</a></font>
                                               
                                            
                                                </td>
                                            
                                            </tr>
                                             <tr>
                                                <td>&nbsp;
                                                </td>
                                            </tr>
                                              <tr>
                                                <td colspan="2">
                                                    <table style="border-width: thin;border-spacing: 0px;border-style: none;border-color: black;" >
                                                        <tr  style="background-color:#5D7B9D;color:white;border: 1px solid black;">
                                                            <th style="border: 1px solid black;">Items</th>
                                                            <th style="border: 1px solid black;">  Delete Footer1</th>
                                                            <th style="border: 1px solid black;">  Delete Footer2</th>
                                                            <th style="border: 1px solid black;">  Delete Footer3</th>
                                                            <th style="border: 1px solid black;">  Delete Footer4</th>
                                                        </tr>
                                                        <tr style="border: 1px solid black;">
                                                            <td style="border: 1px solid black;"><b>Footer Image</b></td>
                                                            <td style="border: 1px solid black;"><asp:FileUpload ID="fuFooter1Image" runt="server" Width="200px" runat="server" />   <br />   
                                                            <asp:Image ID="imgFooter1Image" runat="server" BorderColor="Black" BorderStyle="Dotted" BorderWidth="1" Width="64px" Height="64px"  />
                                                            </td>
                                                            <td style="border: 1px solid black;"><asp:FileUpload ID="fuFooter2Image" runt="server" Width="200px" runat="server" /><br />
                                                                <asp:Image ID="imgFooter2Image" runat="server" BorderColor="Black" BorderStyle="Dotted" BorderWidth="1" Width="64px" Height="64px"  />
                                                            </td>
                                                            <td style="border: 1px solid black;"> <asp:FileUpload ID="fuFooter3Image" runt="server" Width="200px" runat="server" /><br />   
                                                                 <asp:Image ID="imgFooter3Image" runat="server" BorderColor="Black" BorderStyle="Dotted" BorderWidth="1" Width="64px" Height="64px"  />
                                                            </td>
                                                            <td style="border: 1px solid black;">
                                                                <asp:FileUpload ID="fuFooter4Image" runt="server" Width="200px" runat="server" /><br />   
                                                                <asp:Image ID="imgFooter4Image" runat="server" BorderColor="Black" BorderStyle="Dotted" BorderWidth="1" Width="64px" Height="64px" />
                                                            </td>
                                                          </tr>
                                                        <tr style="border: 1px solid black;">
                                                            <td style="border: 1px solid black;"><b> Text</b></td>
                                                            <td style="border: 1px solid black;"> <asp:TextBox ID="txtFooter1Text" runat="server"  Width="200px"></asp:TextBox></td>
                                                            <td style="border: 1px solid black;"> <asp:TextBox ID="txtFooter2Text" runat="server"  Width="200px"></asp:TextBox></td>
                                                            <td style="border: 1px solid black;">  <asp:TextBox ID="txtFooter3Text" runat="server"  Width="200px"></asp:TextBox></td>
                                                            <td style="border: 1px solid black;">  <asp:TextBox ID="txtFooter4Text" runat="server"  Width="200px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr style="border: 1px solid black;">
                                                            <td style="border: 1px solid black;"><b>Footer URL</b></td>
                                                            <td style="border: 1px solid black;">
                                                                <asp:TextBox ID="txtFooter1URL" runat="server"  Width="150px"></asp:TextBox><br />
                                                                <font size="2" color="#136301">* Provide complete url<br /> ex. "https://www.test.com"</font>
                                                            </td>
                                                            <td style="border: 1px solid black;"> <asp:TextBox ID="txtFooter2URL" runat="server"  Width="150px"></asp:TextBox>
                                                               <br /> <font size="2" color="#136301">* Provide complete url<br /> ex. "https://www.test.com"</font>
                                                            </td>
                                                            <td style="border: 1px solid black;">
                                                                <asp:TextBox ID="txtFooter3URL" runat="server"  Width="150px"></asp:TextBox>
                                                               <br /> <font size="2" color="#136301">* Provide complete url<br /> ex. "https://www.test.com"</font>
                                                            </td>
                                                            <td style="border: 1px solid black;">
                                                                <asp:TextBox ID="txtFooter4URL" runat="server"  Width="150px"></asp:TextBox>
                                                                <br /> <font size="2" color="#136301">* Provide complete url<br /> ex. "https://www.test.com"</font>
                                                            </td>
                                                        </tr>
                                                        <tr >
                                                            <td style="border: 1px solid black;"><b>Action</b></td>
                                                            <td align="center" style="border: 1px solid black;"><asp:Button ID="btnDeleteFooter1" runat="server" Text="Delete Footer1" OnClick="btnDeleteFooter1_Click" ToolTip="Delete Footer1" /></td>
                                                            <td align="center" style="border: 1px solid black;align-content:center"><asp:Button ID="btnDeleteFooter2" runat="server" Text="Delete Footer2" OnClick="btnDeleteFooter2_Click" ToolTip="Delete Footer2" /></td>
                                                            <td align="center" style="border: 1px solid black;align-content:center"><asp:Button ID="btnDeleteFooter3" runat="server" Text="Delete Footer3" OnClick="btnDeleteFooter3_Click" ToolTip="Delete Footer3" /></td>
                                                            <td align="center" style="border: 1px solid black;align-content:center"><asp:Button ID="btnDeleteFooter4" runat="server" Text="Delete Footer4" OnClick="btnDeleteFooter4_Click" ToolTip="Delete Footer4" /></td>
                                                  
                                                        </tr>

                                                    </table>
                                                </td>
                                            </tr>                                    
                                      
                                                                
                                        </table>
                                    </td>
                                </tr>
                          
                                <tr>
                                    <td align="left"><br />
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" ToolTip="Cancel the change" Style="width: 118px; margin-right: 20px" 
                                             />                                   
                                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" ToolTip="Save the record." Style="width: 118px; margin-right: 20px" CssClass="css_btn_class"
                                             />                                    
                                        <asp:Button ID="btnPreview" runat="server" Text="Preview" ToolTip="Preview the change" OnClick="btnPreview_Click" Style="width: 118px; margin-right: 20px" CssClass="css_btn_class"
                                            />
                                        <asp:Button ID="btnConfirm" runat="server" Text="Confirm Changes (Prerequisite : Save Changes)" ToolTip="Confirm the changes to reflect in M2M." Visible="false" OnClick="btnConfirm_Click" Style="width: 320px;height:50px; margin-right: 20px;float:right" CssClass="css_btn_class"
                                            />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
