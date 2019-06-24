using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace CSLDual3
{
    /// <summary>
    /// Summary description for PreviousOrders.
    /// </summary>
    public class PreviousOrders : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.DropDownList StartDay;
        protected System.Web.UI.WebControls.DropDownList StartMonth;
        protected System.Web.UI.WebControls.DropDownList StartYear;
        protected System.Web.UI.WebControls.DropDownList EndDay;
        protected System.Web.UI.WebControls.DropDownList EndMonth;
        protected System.Web.UI.WebControls.DropDownList EndYear;
        protected System.Web.UI.WebControls.Button DateSearch;
        protected System.Web.UI.WebControls.DataGrid OrderGrid;

        private void Page_Load(object sender, System.EventArgs e)
        {
            // Put user code to initialize the page here
        }

        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.DateSearch.Click += new System.EventHandler(this.DateSearch_Click);
            this.Load += new System.EventHandler(this.Page_Load);

        }
        #endregion

        private void DateSearch_Click(object sender, System.EventArgs e)
        {

        }
    }
}
