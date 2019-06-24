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
    /// Summary description for PreviousOrderView.
    /// </summary>
    public class PreviousOrderView : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Literal OrderRef;
        protected System.Web.UI.WebControls.Literal OrderCode;
        protected System.Web.UI.WebControls.Literal OrderDate;
        protected System.Web.UI.WebControls.Literal RegUser;
        protected System.Web.UI.WebControls.Literal ARC;
        protected System.Web.UI.WebControls.Literal PriceBand;
        protected System.Web.UI.WebControls.DropDownList OrderStatus;
        protected System.Web.UI.WebControls.Literal InstallerAddress;
        protected System.Web.UI.WebControls.Literal DeliveryAddress;
        protected System.Web.UI.WebControls.Repeater ProductRepeater;
        protected System.Web.UI.WebControls.Repeater AncillaryRepeater;
        protected System.Web.UI.WebControls.Literal DeliveryCost;
        protected System.Web.UI.WebControls.Literal TotalCost;
        protected System.Web.UI.WebControls.Literal PrintAddress;

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
            this.Load += new System.EventHandler(this.Page_Load);

        }
        #endregion
    }
}
