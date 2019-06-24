using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CSLOrderingARCBAL;

public partial class ADMIN_ManageEMProductParameters : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            divForm.Visible = false;
        }
    }


    protected void gvEMParams_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                int paramID = 0;
                int.TryParse(gvEMParams.SelectedValue.ToString(), out paramID);
                var productParameters = db.EM_ProductParams.Where(x => x.EM_ProductParamID == paramID).FirstOrDefault();
                if (productParameters != null)
                {
                    chkAsNew.Checked = false ;
                    txtBillingDesc.Text = productParameters.EM_ProductBillingDesc;
                    txtBillingCommit.Text = productParameters.EM_ProductBillingCommitment.ToString();
                    txtCoreService.Text = productParameters.EM_CoreService.ToString();
                    txtCoreType.Text = productParameters.EM_CoreType.ToString();
                    txtInstTypeEquiv.Text = productParameters.EM_InstType_Equivalent.ToString();
                    txtPriCluster.Text = productParameters.EM_CorePrimaryCluster.ToString();
                    txtPriSubcluster.Text = productParameters.EM_CorePrimarySubCluster.ToString();
                    txtSecondarycluster.Text = productParameters.EM_CoreSecondaryCluster.ToString();
                    txtSecondarySubCluster.Text = productParameters.EM_CoreSecondarySubCluster.ToString();
                    txtTypeID.Text = productParameters.EM_InstType_Type.ToString();
                    chkDeleteFlag.Checked = productParameters.Is_Deleted_Flag;
                    divForm.Visible = true;
                }
                else
                {
                    lblErrorMsg.Text = "Unable to get data from database.";
                }
            }
        }
        catch (Exception exp)
        {
            lblErrorMsg.Text = exp.Message;
        }
    }




    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                EM_ProductParam productParameters = new EM_ProductParam();
                if (!chkAsNew.Checked)
                {
                    int paramID = 0;
                    int.TryParse(gvEMParams.SelectedValue.ToString(), out paramID);
                    productParameters = db.EM_ProductParams.Where(x => x.EM_ProductParamID == paramID).FirstOrDefault();

                    if (productParameters == null)
                    {
                        lblErrorMsg.Text = "Record not found to update.";
                        return;
                    }
                }

                productParameters.EM_ProductBillingDesc = txtBillingDesc.Text;
                productParameters.EM_ProductBillingCommitment = Convert.ToInt32(txtBillingCommit.Text);

                productParameters.EM_CoreService = Convert.ToInt32(txtCoreService.Text);
                productParameters.EM_CoreType = Convert.ToInt32(txtCoreType.Text);
                productParameters.EM_InstType_Equivalent = txtInstTypeEquiv.Text;
                productParameters.EM_CorePrimaryCluster = Convert.ToInt32(txtPriCluster.Text);
                productParameters.EM_CorePrimarySubCluster = Convert.ToInt32(txtPriSubcluster.Text);
                productParameters.EM_CoreSecondaryCluster = Convert.ToInt32(txtSecondarycluster.Text);
                productParameters.EM_CoreSecondarySubCluster = Convert.ToInt32(txtSecondarySubCluster.Text);
                productParameters.EM_InstType_Type = Convert.ToInt32(txtTypeID.Text);
                string username = SiteUtility.GetUserName();
                productParameters.EM_ModifiedBy = username;
                productParameters.EM_ModifiedOn = DateTime.Now;
                productParameters.Is_Deleted_Flag = chkDeleteFlag.Checked;

                if (chkAsNew.Checked)
                {
                    productParameters.EM_CreatedBy = username;
                    productParameters.EM_CreatedOn = DateTime.Now;
                    db.EM_ProductParams.InsertOnSubmit(productParameters);
                }

                db.SubmitChanges();
                ResetForm();
                gvEMParams.DataBind();
                divForm.Visible = false;
            }
        }
        catch (Exception exp)
        {
            lblErrorMsg.Text = exp.Message;
        }
    }


    public void ResetForm()
    {
        txtBillingDesc.Text = string.Empty;
        txtBillingCommit.Text = string.Empty;
        txtCoreService.Text = string.Empty;
        txtCoreType.Text = string.Empty;
        txtInstTypeEquiv.Text = string.Empty;
        txtPriCluster.Text = string.Empty;
        txtPriSubcluster.Text = string.Empty;
        txtSecondarycluster.Text = string.Empty;
        txtSecondarySubCluster.Text = string.Empty;
        txtTypeID.Text = string.Empty;
        lblErrorMsg.Text = string.Empty;
    }


    protected void lnkNew_Click(object sender, EventArgs e)
    {
        ResetForm();
        divForm.Visible = true ;
        chkAsNew.Checked = true;
    }
}