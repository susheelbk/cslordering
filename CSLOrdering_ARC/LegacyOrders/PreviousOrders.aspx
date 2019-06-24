<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System" %>

<HTML>
	<HEAD>
		<title>CSL - Previous Orders</title>
		<script language="C#" runat="server">

string ConnString;

void Page_Load(object sender, EventArgs e)
{
		try
            {
                Session["UserId"] = Session[enumSessions.User_Id.ToString()] ;
                Session["ArcId"] = Session[enumSessions.ARC_Id.ToString()] ;

                if (Session["UserId"] == null || Session["ArcId"] == null )
                {
                    Response.Redirect("~/Login.aspx");
                }
            }
            catch
            {
                Response.Redirect("~/Login.aspx");
            }


LoadDefaults();

	if (!IsPostBack)
	{
	
	LoadDates();
	DateTime szDateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
	
    //removed to stop auto-search on page load	
	//string Sql;
			
    //DataTable dt = new DataTable();	
	
    //Sql = "Select * From [Order] o, [OrderArc] oa, [OrderProduct] op, [Product] p Where OrderEmailed=true AND o.Id Not In (0) AND o.Id = oa.OrderId AND o.Id = op.OrderId AND p.Id = op.ProductId and op.Qty > 0 And o.Id In(Select o.Id From [Order] o, [User] u, [Arc] a " +
    //        " Where o.UserId = u.Id And u.ArcId = a.Id And a.Id = @ArcId) and OrderDate > @OneMonth Order By OrderDate DESC";
	
	
    //using(OleDbConnection conn = new OleDbConnection())
    //{
    //    conn.ConnectionString = ConnString;
    //    conn.Open();		
    //    OleDbCommand command = new OleDbCommand(Sql, conn);
    //    OleDbDataAdapter adapter = new OleDbDataAdapter();
		
    //    command.Parameters.Add("@ArcId", int.Parse(Session["ArcId"].ToString()));
    //    command.Parameters.Add("@OneMonth", szDateTime);
					
    //    adapter.SelectCommand = command;
    //    adapter.Fill(dt);		
    //    conn.Close();
    //}	
	
    //OrderGrid.DataSource = dt;
    //OrderGrid.DataBind();	
		}
		
		else if (IsPostBack)
            {
                string ctrlname = Page.Request.Params["__EVENTTARGET"];

                if (ctrlname == "startMonth" || ctrlname == "startYear")
                {
                    if (startMonth.SelectedValue.ToString() == "4" | startMonth.SelectedValue.ToString() == "6" | startMonth.SelectedValue.ToString() == "9" | startMonth.SelectedValue.ToString() == "11")
                    {
                        startDay.Items.Remove("31");

                        if (startDay.Items.FindByValue("29") == null)
                        {
                            startDay.Items.Add("29");
                        }
                        if (startDay.Items.FindByValue("30") == null)
                        {
                            startDay.Items.Add("30");
                        }
                    }
                    if (startMonth.SelectedValue.ToString() == "1" | startMonth.SelectedValue.ToString() == "3" | startMonth.SelectedValue.ToString() == "5" | startMonth.SelectedValue.ToString() == "7" | startMonth.SelectedValue.ToString() == "8" | startMonth.SelectedValue.ToString() == "10" | startMonth.SelectedValue.ToString() == "12")
                    {
                        if (startDay.Items.FindByValue("29") == null)
                        {
                            startDay.Items.Add("29");
                        }
                        if (startDay.Items.FindByValue("30") == null)
                        {
                            startDay.Items.Add("30");
                        }
                        if (startDay.Items.FindByValue("31") == null)
                        {
                            startDay.Items.Add("31");
                        }
                    }

                    if (startMonth.SelectedValue.ToString() == "2")
                    {
                        if ((Int32.Parse(startYear.SelectedValue.ToString()) % 4 == 0) && (((Int32.Parse(startYear.SelectedValue.ToString()) % 100) != 0) || ((Int32.Parse(startYear.SelectedValue.ToString()) % 400) == 0)))
                        //leapyear
                        {
                            startDay.Items.Remove("31");
                            startDay.Items.Remove("30");
                            if (startDay.Items.FindByValue("29") == null)
                            {
                                startDay.Items.Add("29");
                            }
                        }
                        else
                        {
                            startDay.Items.Remove("31");
                            startDay.Items.Remove("30");
                            startDay.Items.Remove("29");
                        }


                    }

                }


                if (ctrlname == "endMonth" || ctrlname == "endYear")
                {
                    if (endMonth.SelectedValue.ToString() == "4" | endMonth.SelectedValue.ToString() == "6" | endMonth.SelectedValue.ToString() == "9" | endMonth.SelectedValue.ToString() == "11")
                    {
                        endDay.Items.Remove("31");

                        if (endDay.Items.FindByValue("29") == null)
                        {
                            endDay.Items.Add("29");
                        }
                        if (endDay.Items.FindByValue("30") == null)
                        {
                            endDay.Items.Add("30");
                        }
                    }
                    if (endMonth.SelectedValue.ToString() == "1" | endMonth.SelectedValue.ToString() == "3" | endMonth.SelectedValue.ToString() == "5" | endMonth.SelectedValue.ToString() == "7" | endMonth.SelectedValue.ToString() == "8" | endMonth.SelectedValue.ToString() == "10" | endMonth.SelectedValue.ToString() == "12")
                    {
                        if (endDay.Items.FindByValue("29") == null)
                        {
                            endDay.Items.Add("29");
                        }
                        if (endDay.Items.FindByValue("30") == null)
                        {
                            endDay.Items.Add("30");
                        }
                        if (endDay.Items.FindByValue("31") == null)
                        {
                            endDay.Items.Add("31");
                        }
                    }

                    if (endMonth.SelectedValue.ToString() == "2")
                    {
                        if ((Int32.Parse(endYear.SelectedValue.ToString()) % 4 == 0) && (((Int32.Parse(endYear.SelectedValue.ToString()) % 100) != 0) || ((Int32.Parse(endYear.SelectedValue.ToString()) % 400) == 0)))
                        //leapyear
                        {
                            endDay.Items.Remove("31");
                            endDay.Items.Remove("30");
                            if (endDay.Items.FindByValue("29") == null)
                            {
                                endDay.Items.Add("29");
                            }
                        }
                        else
                        {
                            endDay.Items.Remove("31");
                            endDay.Items.Remove("30");
                            endDay.Items.Remove("29");
                        }


                    }

                }
            }
}

private void LoadDates()
        {

            int i;
            string[] monthName = {"January", "February", "March", "April", "May", "June",
									 "July", "August", "September", "October", "November", "December"};
            DateTime now = DateTime.Now;
            DateTime WeekAgo = now.Add(new TimeSpan(-7, 0, 0, 0));

            for (i = 1; i <= 31; i++)
            {
                startDay.Items.Add(new ListItem(i.ToString(), i.ToString()));
                endDay.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            for (i = 1; i <= monthName.Length; i++)
            {
                startMonth.Items.Add(new ListItem(monthName[i - 1], i.ToString()));
                endMonth.Items.Add(new ListItem(monthName[i - 1], i.ToString()));
            }

            for (i = now.Year - 3; i < now.Year + 1; i++)
            {
                startYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
                endYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            startDay.Items.FindByValue(WeekAgo.Day.ToString()).Selected = true;
            startMonth.Items.FindByValue(WeekAgo.Month.ToString()).Selected = true;
            startYear.Items.FindByValue(WeekAgo.Year.ToString()).Selected = true;
            endDay.Items.FindByValue(now.Day.ToString()).Selected = true;
            endMonth.Items.FindByValue(now.Month.ToString()).Selected = true;
            endYear.Items.FindByValue(now.Year.ToString()).Selected = true;

            if (startMonth.SelectedValue.ToString() == "4" | startMonth.SelectedValue.ToString() == "6" | startMonth.SelectedValue.ToString() == "9" | startMonth.SelectedValue.ToString() == "11")
            {
                startDay.Items.Remove("31");

                if (startDay.Items.FindByValue("29") == null)
                {
                    startDay.Items.Add("29");
                }
                if (startDay.Items.FindByValue("30") == null)
                {
                    startDay.Items.Add("30");
                }
            }
            if (startMonth.SelectedValue.ToString() == "1" | startMonth.SelectedValue.ToString() == "3" | startMonth.SelectedValue.ToString() == "5" | startMonth.SelectedValue.ToString() == "7" | startMonth.SelectedValue.ToString() == "8" | startMonth.SelectedValue.ToString() == "10" | startMonth.SelectedValue.ToString() == "12")
            {
                if (startDay.Items.FindByValue("29") == null)
                {
                    startDay.Items.Add("29");
                }
                if (startDay.Items.FindByValue("30") == null)
                {
                    startDay.Items.Add("30");
                }
                if (startDay.Items.FindByValue("31") == null)
                {
                    startDay.Items.Add("31");
                }
            }

            if (startMonth.SelectedValue.ToString() == "2")
            {
                if ((Int32.Parse(startYear.SelectedValue.ToString()) % 4 == 0) && (((Int32.Parse(startYear.SelectedValue.ToString()) % 100) != 0) || ((Int32.Parse(startYear.SelectedValue.ToString()) % 400) == 0)))
                //leapyear
                {
                    startDay.Items.Remove("31");
                    startDay.Items.Remove("30");
                    startDay.Items.Add("29");
                }
                else
                {
                    startDay.Items.Remove("31");
                    startDay.Items.Remove("30");
                    startDay.Items.Remove("29");
                }


            }
            if (endMonth.SelectedValue.ToString() == "4" | endMonth.SelectedValue.ToString() == "6" | endMonth.SelectedValue.ToString() == "9" | endMonth.SelectedValue.ToString() == "11")
            {
                endDay.Items.Remove("31");

                if (endDay.Items.FindByValue("29") == null)
                {
                    endDay.Items.Add("29");
                }
                if (endDay.Items.FindByValue("30") == null)
                {
                    endDay.Items.Add("30");
                }
            }
            if (endMonth.SelectedValue.ToString() == "1" | endMonth.SelectedValue.ToString() == "3" | endMonth.SelectedValue.ToString() == "5" | endMonth.SelectedValue.ToString() == "7" | endMonth.SelectedValue.ToString() == "8" | endMonth.SelectedValue.ToString() == "10" | endMonth.SelectedValue.ToString() == "12")
            {
                if (endDay.Items.FindByValue("29") == null)
                {
                    endDay.Items.Add("29");
                }
                if (endDay.Items.FindByValue("30") == null)
                {
                    endDay.Items.Add("30");
                }
                if (endDay.Items.FindByValue("31") == null)
                {
                    endDay.Items.Add("31");
                }
            }

            if (endMonth.SelectedValue.ToString() == "2")
            {
                if ((Int32.Parse(endYear.SelectedValue.ToString()) % 4 == 0) && (((Int32.Parse(endYear.SelectedValue.ToString()) % 100) != 0) || ((Int32.Parse(endYear.SelectedValue.ToString()) % 400) == 0)))
                //leapyear
                {
                    endDay.Items.Remove("31");
                    endDay.Items.Remove("30");
                    endDay.Items.Add("29");
                }
                else
                {
                    endDay.Items.Remove("31");
                    endDay.Items.Remove("30");
                    endDay.Items.Remove("29");
                }


            }


        }

private void DateSearch_Click(object sender, System.EventArgs e)
		{
		string Sql;
		
	DataTable dt = new DataTable();	
	
	Sql = @"Select o.ID as 'Order_ID',*  From [Order] o, [OrderArc] oa, [OrderProduct] op, [Product] p Where OrderEmailed=1 AND o.Id Not In (0) AND o.Id = oa.OrderId AND o.Id = op.OrderId AND p.Id = op.ProductId and op.Qty > 0 And o.Id In(Select o.Id From [Order] o, [User] u, [Arc] a " +
			" Where o.UserId = u.Id And u.ArcId = a.Id And a.Id = @ArcId) and OrderDate Between @StartDate And @EndDate Order By OrderDate DESC";
	
	
	using(SqlConnection conn = new SqlConnection())
	{
		conn.ConnectionString = ConnString;
		conn.Open();		
		SqlCommand command = new SqlCommand(Sql, conn);
		SqlDataAdapter adapter = new SqlDataAdapter();
		
		command.Parameters.Add("@ArcId", int.Parse(Session["ArcId"].ToString()));
		command.Parameters.Add("@StartDate", new DateTime(int.Parse(startYear.SelectedItem.Value),int.Parse(startMonth.SelectedItem.Value),int.Parse(startDay.SelectedItem.Value)));
			command.Parameters.Add("@EndDate", new DateTime(int.Parse(endYear.SelectedItem.Value),int.Parse(endMonth.SelectedItem.Value),int.Parse(endDay.SelectedItem.Value), 23, 59, 59  ));
					
		adapter.SelectCommand = command;
		adapter.Fill(dt);		
		conn.Close();
	}	
	
	OrderGrid.DataSource = dt;
	OrderGrid.DataBind();	
	
		}


	
	


void LoadDefaults()
{
    ConnString =   @"Data Source=172.16.16.20\SQLEXPRESS;Initial Catalog=ARC_Ordering_Access;User ID=sa;Password=m3g4stream;MultipleActiveResultSets=True";
}

void OrderGrid_ItemDataBound(object sender, DataGridItemEventArgs e)
{
	if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
	{
		string PriceBand = e.Item.Cells[6].Text;
		int szOrderID = Int32.Parse(e.Item.Cells[0].Text);
		string szPriceBand = "Price" + e.Item.Cells[6].Text;
		double Total = 0;
		 string DB = ConnString;
		
		string Sql = "SELECT p." + szPriceBand + ", o.Qty FROM [Product] p INNER JOIN OrderProduct o on p.id = o.ProductId Where o.Qty > 0 and o.orderid = " + szOrderID;
		
		string Sqla = "SELECT a." + szPriceBand + ", o.Qty FROM [Ancilllary] a INNER JOIN OrderAncillary o on a.id = o.AncillaryId Where o.Qty > 0 and o.orderid = " + szOrderID;
		
		string Sqlb = "SELECT DeliveryCost FROM [Order] Where id = " + szOrderID;
		
		
		using (SqlConnection Connection = new SqlConnection(DB))
        {
            Connection.Open();
            SqlCommand Command = new SqlCommand(Sql, Connection);
            SqlDataReader  DataReader = Command.ExecuteReader();

            while (DataReader.Read())
            {
				Total += double.Parse(DataReader[szPriceBand].ToString())*Int32.Parse(DataReader["Qty"].ToString());
			}

            DataReader.Close();
            Connection.Close();
            }
            
            using (SqlConnection Connectiona = new SqlConnection(DB))
        {
            Connectiona.Open();
            SqlCommand Commanda = new SqlCommand(Sqla, Connectiona);
            SqlDataReader  DataReadera = Commanda.ExecuteReader();

            while (DataReadera.Read())
            {
				Total += double.Parse(DataReadera[szPriceBand].ToString())*Int32.Parse(DataReadera["Qty"].ToString());
			}

            DataReadera.Close();
            Connectiona.Close();
            }
            
             using (SqlConnection Connectionb = new SqlConnection(DB))
        {
            Connectionb.Open();
            SqlCommand Commandb = new SqlCommand(Sqlb, Connectionb);
            SqlDataReader  DataReaderb = Commandb.ExecuteReader();

            while (DataReaderb.Read())
            {
				Total += double.Parse(DataReaderb["DeliveryCost"].ToString());
			}

            DataReaderb.Close();
            Connectionb.Close();
            }
            
		e.Item.Cells[3].Text = String.Format("{0:0.00}",Total);
	}
}

void OrderGrid_ItemCommand(object sender, DataGridCommandEventArgs e)
{
	if(e.CommandName == "View")
	{
		Response.Redirect("PreviousOrderView.aspx?Id=" + e.Item.Cells[0].Text + "&pb=" + e.Item.Cells[6].Text + "&tot=" + e.Item.Cells[3].Text);
	}
}
		</script>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="../csl.css" type="text/css">
	</HEAD>
	<body bgcolor="#ffffff" text="#000000">
		<form runat="server" ID="Form1">
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
                        <td valign="left" background=<%= Page.ResolveUrl("~/Images/grey.gif")%> class="pagetitle">
                            &nbsp;
                            <div style="font-size: 1.2em; font-weight: bold;color:#999999">
                            </div>
                        </td>
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
			<table>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td align="right">Start Date:</td>
					<td>
						<asp:DropDownList id="startDay" runat="server"></asp:DropDownList></td>
					<td>
						<asp:DropDownList id="startMonth" runat="server" AutoPostBack="true"></asp:DropDownList></td>
					<td>
						<asp:DropDownList id="startYear" runat="server" AutoPostBack="true"></asp:DropDownList></td>
				</tr>
				<tr>
					<td align="right">End Date:</td>
					<td>
						<asp:DropDownList id="endDay" runat="server"></asp:DropDownList></td>
					<td>
						<asp:DropDownList id="endMonth" runat="server" AutoPostBack="true"></asp:DropDownList></td>
					<td>
						<asp:DropDownList id="endYear" runat="server" AutoPostBack="true"></asp:DropDownList></td>
				</tr>
				<tr>
					<td colspan="4" align="right"><asp:Button ID="DateSearch"  Text="Search by Date" Runat="server" OnClick="DateSearch_Click"></asp:Button></td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="1" cellpadding="5">
				<tr>
					<td>
						<p>&nbsp;</p>
						<asp:DataGrid ID="OrderGrid" Runat="server" OnItemDataBound="OrderGrid_ItemDataBound" OnItemCommand="OrderGrid_ItemCommand"
							GridLines="None" CellPadding="2" CellSpacing="1" AutoGenerateColumns="False">
							<Columns>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									DataField="Order_ID" Visible="False"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Order Ref" DataField="Order_ID" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Date" DataField="OrderDate" Visible="true" DataFormatString="{0:dd/MMM/yyyy}"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Amount" DataField="Total" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="ARC" DataField="Arc_CompanyName" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Status" DataField="OrderStatusId" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Price Band" DataField="Arc_PriceBand" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Installer" DataField="Installer_InstallerName" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Product Code" DataField="Code" Visible="true"></asp:BoundColumn>
								<asp:BoundColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="Quantity" DataField="Qty" Visible="true"></asp:BoundColumn>
								<asp:ButtonColumn HeaderStyle-BackColor="#fbcaca" HeaderStyle-Font-Bold="True" ItemStyle-BackColor="#cccccc"
									HeaderText="View" CommandName="View" ButtonType="LinkButton" Text="View"></asp:ButtonColumn>
							</Columns>
						</asp:DataGrid>
						<p>&nbsp;</p>
					</td>
				</tr>
			</table>
			<!--#include virtual="footer.aspx" -->
		</form>
	</body>
</HTML>
