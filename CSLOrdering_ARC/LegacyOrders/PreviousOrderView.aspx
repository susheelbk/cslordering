<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System" %>
<%@ Page %>
<HTML>
	<HEAD>
		<title>CSL - Previous Orders</title>
		<script language="C#" runat="server">

string ConnString;
int Id;

void Page_Load(object sender, EventArgs e)
{
	
	LoadDefaults();
	
	if(Request["Id"] == null)
		Response.Redirect("PreviousOrders.aspx");
	
	try{Id = int.Parse(Request["Id"].ToString());}
	catch{Id = 0;}	
	
	if(!IsPostBack)
	{
		LoadData();
		LoadBasket();
	}
}


void LoadBasket()
{
	int OrderId = Id;
	DataTable dt = new DataTable();
	
	using(SqlConnection conn = new SqlConnection())
	{
		string SQL = @"Select op.ID as 'op_ID', * From [OrderProduct] op, [Product] p Where op.Qty > 0 And p.Id = op.ProductId And op.OrderId = @Id";
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@Id", OrderId);
		SqlDataAdapter adapter = new SqlDataAdapter();
		adapter.SelectCommand = command;
		adapter.Fill(dt);
		
		conn.Close();
	}
	
	ProductRepeater.DataSource = dt;
	ProductRepeater.DataBind();
	
	DataTable dt2 = new DataTable();
	
	using(SqlConnection conn = new SqlConnection())
	{
		string SQL = @"Select a.ID AS 'A_ID',* From [OrderAncillary] oa, [Ancilllary] a Where oa.Qty > 0 And a.Id = oa.AncillaryId And oa.OrderId = @Id";
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@Id", OrderId);
		SqlDataAdapter adapter = new SqlDataAdapter();
		adapter.SelectCommand = command;
		adapter.Fill(dt2);
		
		conn.Close();
	}
	
	if(dt2.Rows.Count <= 0)
		AncillaryRepeater.Visible = false;

	AncillaryRepeater.DataSource = dt2;
	AncillaryRepeater.DataBind();
	
}

void ProductRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
{
	if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
	{
		DataRowView dr = (DataRowView) e.Item.DataItem;
		
		Literal Qty = (Literal) e.Item.FindControl("Qty");
		if(Qty != null)
		{
			Qty.Text = dr["Qty"].ToString();
		}
		
		Literal DisplayPrice = (Literal) e.Item.FindControl("DisplayPrice");
		if(DisplayPrice != null)
		{
			if (dr["UnitCost"].ToString() == "0")
			{
			//calculate unit cost for those arcs who don't pay anything...
			
			string szPriceBand = "Price"+Request.QueryString["pb"].ToString();
						
			//set path to DB from SubFolder
        string DB = ConnString;

        string Sql = "Select " + szPriceBand + " From [Product] Where code = '" + dr["Code"].ToString() + "'";

        using (SqlConnection Connection = new SqlConnection(DB))
        {
            Connection.Open();
            SqlCommand Command = new SqlCommand(Sql, Connection);
            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                DisplayPrice.Text = String.Format("{0:0.00}", double.Parse(DataReader[szPriceBand].ToString()));

            }

            DataReader.Close();
            Connection.Close();

        }
				
			}
			else
			{
			DisplayPrice.Text = String.Format("{0:0.00}", double.Parse(dr["UnitCost"].ToString()));
			}
		}
		
		
		TextBox SimNumber = (TextBox) e.Item.FindControl("SimNumber");
		if(SimNumber != null)
			SimNumber.Text = dr["sim"].ToString();
		
		Literal TelOne = (Literal) e.Item.FindControl("TelOne");
		if(TelOne != null)
			TelOne.Text = dr["TelOne"].ToString();
			
		Literal TelTwo = (Literal) e.Item.FindControl("TelTwo");
		if(TelTwo != null)
			TelTwo.Text = dr["TelTwo"].ToString();
			
		Literal NUAOne = (Literal) e.Item.FindControl("NUAOne");
		if(NUAOne != null)
			NUAOne.Text = dr["NUAOne"].ToString();
			
		Literal NUATwo = (Literal) e.Item.FindControl("NUATwo");
		if(NUATwo != null)
			NUATwo.Text = dr["NUATwo"].ToString();	
			
		Literal ChipGPRS = (Literal) e.Item.FindControl("ChipGPRS");
		if(ChipGPRS != null)
			ChipGPRS.Text = dr["ChipGPRS"].ToString();
			
		Literal ChipPSTN = (Literal) e.Item.FindControl("ChipPSTN");
		if(ChipPSTN != null)
			ChipPSTN.Text = dr["ChipPSTN"].ToString();				
		
		Literal OrderProductId = (Literal) e.Item.FindControl("OrderProductId");
		if(OrderProductId != null)
		{
			OrderProductId.Text = dr["op_ID"].ToString();
		}
		
		PlaceHolder TelephonePanel = (PlaceHolder) e.Item.FindControl("TelephonePanel");
		if(TelephonePanel != null)
		{
			TelephonePanel.Visible = bool.Parse(dr["Telephone"].ToString());
		}
	
	}
}

void AncillaryRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
{
	if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
	{
		DataRowView dr = (DataRowView) e.Item.DataItem;

		Literal DisplayPrice = (Literal) e.Item.FindControl("DisplayPrice");
		if(DisplayPrice != null)
		{
			if (dr["UnitCost"].ToString() == "0")
			{
			//calculate unit cost for those arcs who don't pay anything...
			
			string szPriceBand = "Price"+Request.QueryString["pb"].ToString();
						
			//set path to DB from SubFolder
        string DB = ConnString;

        string Sql = "Select " + szPriceBand + " From [Ancilllary] Where code = '" + dr["Code"].ToString() + "'";

        using (SqlConnection Connection = new SqlConnection(DB))
        {
            Connection.Open();
            SqlCommand Command = new SqlCommand(Sql, Connection);
            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                DisplayPrice.Text = String.Format("{0:0.00}", double.Parse(DataReader[szPriceBand].ToString()));

            }

            DataReader.Close();
            Connection.Close();

        }
				
			}
			else
			{
			DisplayPrice.Text = String.Format("{0:0.00}", double.Parse(dr["UnitCost"].ToString()));
			}
		}
		
		Literal AncillaryProductId = (Literal) e.Item.FindControl("AncillaryProductId");
		if(AncillaryProductId != null)
		{
			AncillaryProductId.Text = dr["a_Id"].ToString();
		}
	

		Literal Qty = (Literal) e.Item.FindControl("Qty2");
		if(Qty != null)
		{
			Qty.Text = dr["Qty"].ToString();
		}
	}
}

string UserDisplayPrice(int ProductId, bool Ancillary)
{
	string PriceBand = "";
	string Price = "";
	string SQL;
	
	using(SqlConnection conn = new SqlConnection())
	{
		SQL = "Select * From [User] Where [Id] = @UserId";
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@UserId", int.Parse(Session["UserId"].ToString()));
		SqlDataReader reader = command.ExecuteReader();
		if(reader.Read())
		{
			PriceBand = reader["PriceBand"].ToString();
		}
				
		conn.Close();
	}
	
	if(Ancillary)
		SQL = "Select * From Ancilllary Where Id = @Id";
	else
		SQL = "Select * From Product Where Id = @Id";
	
	using(SqlConnection conn = new SqlConnection())
	{
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@Id", ProductId);
		SqlDataReader reader = command.ExecuteReader();
		if(reader.Read())
		{
			Price = reader["Price" + PriceBand].ToString();
		}
				
		conn.Close();
	}

	return String.Format("{0:0.00}", double.Parse(Price));

}

DataTable ProductAncillary(int OrderProductId)
{
	DataTable dt = new DataTable();
	
	using(SqlConnection conn = new SqlConnection())
	{
		string SQL = "Select * From [Ancilllary] a,  [OrderAncillary] oa " +
		"Where a.Id = oa.AncillaryId And oa.OrderProductId = @OrderProductId";
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@OrderProductId", OrderProductId);
		SqlDataAdapter adapter = new SqlDataAdapter();
		adapter.SelectCommand = command;
		adapter.Fill(dt);	
		
		conn.Close();
	}
	
	return dt;
}

void LoadData()
{
	using(SqlConnection conn = new SqlConnection())
	{
		string SQL = "" +
			"Select o.Id as 'Order_ID',* From [Order] o, [OrderArc] oa, [User] u Where " +
			"o.Id = oa.OrderId And u.Id = o.UserId And o.Id = @Id";
		
		
		conn.ConnectionString = ConnString;
		conn.Open();
		
		SqlCommand command = new SqlCommand(SQL, conn);
		command.Parameters.Add("@Id", Id);
		SqlDataReader reader = command.ExecuteReader();
		if(reader.Read())
		{
			OrderRef.Text = reader["Order_ID"].ToString();
			OrderCode.Text = reader["OrderNumber"].ToString();
			OrderDate.Text = String.Format("{0:dd/MMM/yyyy}", DateTime.Parse(reader["OrderDate"].ToString()));
			RegUser.Text = reader["Username"].ToString();
			ARC.Text = reader["Arc_CompanyName"].ToString();
			PriceBand.Text = reader["Arc_PriceBand"].ToString();
			try{OrderStatus.Items.FindByValue(reader["OrderStatusId"].ToString()).Selected = true;}catch{}
			
			string InstallerText =  reader["Installer_PrimaryContact"].ToString() + "<br>&nbsp;" +
							reader["Installer_InstallerName"].ToString() + "<br>&nbsp;" +
							reader["Installer_AddressOne"].ToString() + "<br>&nbsp;" +
							reader["Installer_AddressTwo"].ToString() + "<br>&nbsp;" +
							reader["Installer_Town"].ToString() + "<br>&nbsp;" +
							reader["Installer_County"].ToString() + "<br>&nbsp;" +
							reader["Installer_Country"].ToString() + "<br>&nbsp;" +
							reader["Installer_PostCode"].ToString();
			
			DeliveryAddress.Text = reader["DeliveryAddress"].ToString().Replace("\n", "<br>");
			InstallerAddress.Text = InstallerText;
			PrintAddress.Text = DeliveryAddress.Text;
			
			DeliveryCost.Text = String.Format("{0:£0.00}", double.Parse(reader["DeliveryCost"].ToString()));
			TotalCost.Text = String.Format("{0:£0.00}", double.Parse(Request.QueryString["tot"].ToString()));
		}
	}
}

void LoadDefaults()
{
       ConnString =   @"Data Source=172.16.16.20\SQLEXPRESS;Initial Catalog=ARC_Ordering_Access;User ID=sa;Password=m3g4stream;MultipleActiveResultSets=True";
}

	</script>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="/csl.css" type="text/css">
			<style> 			
			
			#onlyforprint { DISPLAY: none } 			
			
			@media Print { #NotForprint { DISPLAY: none } 			
			
			#onlyforprint { DISPLAY: block }} 			
			
			</style>
	</HEAD>
	<body bgcolor="#ffffff" text="#000000">
		<form runat="server" ID="Form1">
			<div id="NotForPrint">
				<!--#include file="header.aspx" -->
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" summary="" style=" min-width:1000px;">
        <tr>

            <td align="left" valign="bottom" bgcolor="#cccccc" width="30%">
                <a href="~/Default.aspx" style="color: #ff0000; padding-left:50px;">Home
                                </a>
            </td>
            <td width="100%" valign="bottom">

                <table width="730" border="0" cellpadding="0" cellspacing="0" summary="">
                    <tr>
                        <td valign="middle" background=<%= Page.ResolveUrl("~/Images/grey.gif")%> style="font-size:14px;font-family:Arial,Verdana,Franklin Gothic Book,sans-serif; color:red; font-weight: bold;" class="pagetitle">
										&gt; <a href="previousorders.aspx">Previous Orders[Orders placed before  July 2013]</a> &gt; View Order</td>
                        <td width="88" align="right" valign="top">
                            <img src="../Images/white.png" alt="vodafone" width="88" height="53">
                        </td>
                        <td width="193" align="right" valign="top">
                            <img src="../Images/CSL_Logo_Bottom.png" alt="DualCom" width="193"
                                height="54">
                        </td>
                    </tr>
                </table>
            </td>

    
        </tr>
    </table>
				
				<table width="100%" border="0" cellspacing="1" cellpadding="5">
					<tr>
						<td>
							<table id="Table3" cellSpacing="2" cellPadding="0" border="0">
								<tr>
									<td align="right" colSpan="1" rowSpan="1"><STRONG>Order ref:</STRONG></td>
									<td>&nbsp;<asp:Literal id="OrderRef" runat="server"></asp:Literal>
									</td>
								</tr>
								<TR>
									<TD align="right"><STRONG>Order Code:</STRONG></TD>
									<TD>&nbsp;<asp:Literal id="OrderCode" runat="server"></asp:Literal></TD>
								</TR>
								<tr>
									<td align="right"><STRONG>Date:</STRONG></td>
									<td>&nbsp;<asp:Literal id="OrderDate" runat="server"></asp:Literal>
									</td>
								</tr>
								<tr>
									<td align="right"><STRONG>Registered User:</STRONG></td>
									<td>&nbsp;<asp:Literal id="RegUser" runat="server"></asp:Literal>
									</td>
								</tr>
								<tr>
									<td align="right"><STRONG>ARC:</STRONG></td>
									<td>&nbsp;<asp:Literal id="ARC" runat="server"></asp:Literal>
									</td>
								</tr>
								<tr>
									<td align="right"><STRONG>Pricing band:</STRONG></td>
									<td>&nbsp;<asp:Literal id="PriceBand" runat="server"></asp:Literal>
									</td>
								</tr>
								<TR>
									<TD vAlign="top" align="right"><STRONG>Order Status:</STRONG></TD>
									<TD>&nbsp;
										<asp:DropDownList id="OrderStatus" runat="server">
											<asp:ListItem Value="1">Placed by ARC</asp:ListItem>
											<asp:ListItem Value="3">Placed by Installer</asp:ListItem>
											<asp:ListItem Value="2">Updated With SIM Details</asp:ListItem>
										</asp:DropDownList></TD>
								</TR>
								<tr>
									<td vAlign="top" align="right"><STRONG>Installer&nbsp;address:</STRONG></td>
									<td>
										<P>&nbsp;
											<asp:Literal id="InstallerAddress" runat="server"></asp:Literal>
										</P>
									</td>
								</tr>
								<tr>
									<td vAlign="top" align="right"><STRONG>Delivery&nbsp;address:</STRONG></td>
									<td>
										<P>
											<asp:Literal id="DeliveryAddress" runat="server"></asp:Literal>
											<BR>
											<BR>
											<A href="javascript: void(0)" onclick="javascript: window.print();">Print Address</A>
										</P>
									</td>
								</tr>
								<TR>
									<TD vAlign="top" align="right"></TD>
									<TD></TD>
								</TR>
							</table>
							<p><b>Basket</b></p>
							<table border="0" CellPadding="2" CellSpacing="1">
								<asp:Repeater ID="ProductRepeater" Runat="server" OnItemDataBound="ProductRepeater_ItemDataBound">
									<ItemTemplate>
										<tr bgColor="#fbcaca">
											<td></td>
											<td></td>
											<td>Qty</td>
											<td>Unit Cost</td>
										</tr>
										<tr bgColor="#cccccc">
											<td width="78"><%# DataBinder.Eval(Container.DataItem, "Code") %></td>
											<td width="400"><%# DataBinder.Eval(Container.DataItem, "Title") %></td>
											<td>
												<asp:Literal ID="Qty" Runat="server"></asp:Literal>
												<asp:Literal ID="OrderProductId" Runat="server" Visible="false"></asp:Literal>
											</td>
											<TD>£
												<asp:Literal ID="DisplayPrice" Runat="server"></asp:Literal></TD>
										</tr>
										<tr bgColor="#cccccc">
											<td colspan="4">
												<asp:PlaceHolder ID="TelephonePanel" Runat="server" Visible="False">
											
											<STRONG>Tel No. 1:&nbsp;</STRONG>
											<asp:Literal ID="TelOne" Runat="server"></asp:Literal>&nbsp;
											
											
											<STRONG>&nbsp;Tel No. 2:&nbsp;</STRONG>
											<asp:Literal ID="TelTwo" Runat="server"></asp:Literal>&nbsp;<br>
											
											<STRONG>NUA No. 1:&nbsp;</STRONG>
											<asp:Literal ID="NUAOne" Runat="server"></asp:Literal>&nbsp;
											
											
											<STRONG>&nbsp;NUA No. 2:&nbsp;</STRONG>
											<asp:Literal ID="NUATwo" Runat="server"></asp:Literal>&nbsp;<br>
											
											</asp:PlaceHolder>
												<STRONG>ChipGPRS No.:</STRONG>&nbsp;
												<asp:Literal ID="ChipGPRS" Runat="server"></asp:Literal>&nbsp;<br>
												<STRONG>ChipPSTN No.:</STRONG>&nbsp;
												<asp:Literal ID="ChipPSTN" Runat="server"></asp:Literal>&nbsp;
											</td>
										</tr>
										<tr>
											<TD height="10">
											</TD>
										</tr>
										<TR>
											<TD width="78" height="10"></TD>
										</TR>
									</ItemTemplate>
								</asp:Repeater>
								<asp:Repeater ID="AncillaryRepeater" Runat="server" OnItemDataBound="AncillaryRepeater_ItemDataBound">
									<HeaderTemplate>
										<tr bgColor="#fbcaca">
											<td colSpan="2"><b>Ancillaries</b></td>
											<td>&nbsp;</td>
											<TD></TD>
										</tr>
									</HeaderTemplate>
									<ItemTemplate>
										<tr bgColor="#cccccc">
											<td width="78"><%# DataBinder.Eval(Container.DataItem, "Code") %></td>
											<td><%# DataBinder.Eval(Container.DataItem, "Description") %></td>
											<td>
												<asp:Literal ID="Qty2" Runat="server"></asp:Literal>
											</td>
											<TD>£
												<asp:Literal ID="DisplayPrice" Runat="server"></asp:Literal>
												<asp:Literal ID="AncillaryProductId" Runat="server" Visible="False"></asp:Literal>
											</TD>
										</tr>
									</ItemTemplate>
								</asp:Repeater>
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										&nbsp;
									</td>
									<td bgColor="#cccccc">
										Delivery:
									</td>
									<td bgColor="#cccccc">
										<asp:Literal id="DeliveryCost" runat="server"></asp:Literal>
									</td>
								</tr>
								<TR>
									<TD>&nbsp;</TD>
									<TD>&nbsp;</TD>
									<TD bgColor="#cccccc">Total:</TD>
									<TD bgColor="#cccccc">
										<asp:Literal id="TotalCost" runat="server"></asp:Literal></TD>
								</TR>
							</table>
						</td>
					</tr>
				</table>
				<!--#include virtual="footer.aspx" --></div>
			<div id="onlyforprint">
				<asp:Literal ID="PrintAddress" Runat="server"></asp:Literal>
			</div>
		</form>
	</body>
</HTML>
