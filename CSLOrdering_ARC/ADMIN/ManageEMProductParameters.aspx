<%@ Page Title="" Language="C#" MasterPageFile="~/ADMIN/AdminMaster.master" AutoEventWireup="true" CodeFile="ManageEMProductParameters.aspx.cs" Inherits="ADMIN_ManageEMProductParameters" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentWrapper" runat="Server">

    <asp:GridView ID="gvEMParams" runat="server" AllowPaging="true" AllowSorting="true" DataSourceID="linqEMParamsSRC"
        ShowFooter="true" ShowHeader="true" ShowHeaderWhenEmpty="true" EnableTheming="true" AutoGenerateColumns="false"
        GridLines="None" CssClass="mGrid" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" OnSelectedIndexChanged="gvEMParams_SelectedIndexChanged"
        DataKeyNames="KeyID">
        <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" />
        <Columns>
            <asp:CommandField ShowSelectButton="true"  />
            <asp:BoundField DataField="KeyID" HeaderText="Key" />
            <asp:BoundField DataField="Desc" HeaderText="Billing Description" />
            <asp:BoundField DataField="CoreType" HeaderText="CoreType" />
            <asp:BoundField DataField="CoreService" HeaderText="CoreService" />
            <asp:BoundField DataField="CoreCluster" HeaderText="CoreCluster" />
            <asp:BoundField DataField="Core_Sec_Cluster" HeaderText="Secondary Cluster" />
            <asp:BoundField DataField="InstTypeID" HeaderText="TypeID" />
            <asp:BoundField DataField="LastUpdated" HeaderText="LastUpdated" DataFormatString="{0:D}" />
            <asp:BoundField DataField="LastUpdatedBy" HeaderText="Updated By" />
            <asp:BoundField DataField="AddedOn" HeaderText="Added On" DataFormatString="{0:D}" />
            <asp:BoundField DataField="Deleted" HeaderText="Deleted" HtmlEncode="false" HtmlEncodeFormatString="false" DataFormatString="{0:Yes/No}" />
        </Columns>
    </asp:GridView>
    <asp:LinqDataSource ID="linqEMParamsSRC" runat="server" TableName="EM_ProductParams" ContextTypeName="CSLOrderingARCBAL.LinqToSqlDataContext"
        OrderBy="EM_ProductBillingDesc ASC"
        Select="new(EM_ProductParamID as KeyID,EM_ProductBillingDesc as Desc, EM_CoreType as CoreType,EM_CoreService as CoreService,EM_CorePrimaryCluster as CoreCluster
                  ,EM_CoreSecondaryCluster as Core_Sec_Cluster,EM_InstType_Type as InstTypeID,EM_ModifiedOn as LastUpdated
                  ,EM_ModifiedBy as LastUpdatedBy,Is_Deleted_Flag as Deleted, EM_CreatedOn as AddedOn)">
    </asp:LinqDataSource>

    <asp:LinkButton ID="lnkNew" runat="server"  Text="Add new" OnClick="lnkNew_Click"></asp:LinkButton>
    <br />
    <div id="divForm" runat="server" clientidmode="Static">
        <table>
            <tr>
                <th colspan="4">
                    <h1><u>Record Details</u></h1> 
                </th>
            </tr>
            <tr>
                <td>Billing Description</td>
                <td>
                    <asp:TextBox runat="server" ID="txtBillingDesc"></asp:TextBox>
                </td>
                <td>Core Type
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtCoreType"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtCoreType" EnableClientScript="true" Display="Dynamic" ID="Regex1" runat="server" 
                        ValidationExpression="\d*"
                        Text="Please enter numbers only"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td>Core Service</td>
                <td>
                    <asp:TextBox runat="server" ID="txtCoreService"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtCoreService" EnableClientScript="true" Display="Dynamic"
                        ValidationExpression="\d*"
                         ID="RegularExpressionValidator1" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
                <td>Primary cluster</td>
                <td>
                    <asp:TextBox runat="server" ID="txtPriCluster"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtPriCluster" ValidationExpression="\d*" EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator2" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
            </tr>
            <tr>
                <td>Primary SubCluster</td>
                <td>
                    <asp:TextBox runat="server" ID="txtPriSubcluster"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtPriSubcluster" ValidationExpression="\d*"  EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator3" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
                <td>Secondary Cluster</td>
                <td>
                    <asp:TextBox runat="server" ID="txtSecondarycluster"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtSecondarycluster"  ValidationExpression="\d*" EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator4" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
            </tr>
            <tr>
                <td>Secondary Sub Cluster</td>
                <td>
                    <asp:TextBox runat="server" ID="txtSecondarySubCluster"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtSecondarySubCluster" ValidationExpression="\d*"  EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator5" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
                <td>Billing Commitment</td>
                <td>
                    <asp:TextBox runat="server" ID="txtBillingCommit"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtBillingCommit" ValidationExpression="\d*"  EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator6" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>

                </td>
            </tr>
            <tr>
                <td>Hardware Required</td>
                <td>
                    <asp:CheckBox ID="chkHWReq" runat="server" />
                </td>
                <td>Inst Type Equivalent</td>
                <td>
                    <asp:TextBox ID="txtInstTypeEquiv" runat="server" MaxLength="10"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <td>Inst Type - TypeID</td>
                <td>
                    <asp:TextBox ID="txtTypeID" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ControlToValidate="txtTypeID"  ValidationExpression="\d*" EnableClientScript="true" Display="Dynamic" ID="RegularExpressionValidator8" runat="server" Text="Please enter numbers only"></asp:RegularExpressionValidator>
                </td>
                <td>Deleted</td>
                <td>
                    <asp:CheckBox ID="chkDeleteFlag" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="4">&nbsp</td>
            </tr>
            <tr>
                <td ></td>
                <td colspan="3">
                    <asp:HiddenField ID="hdnEMPAramID" runat="server" />
                    <asp:Button runat="server" Text="Save" ID="btnSave" OnClick="btnSave_Click" />
                    <asp:CheckBox ID="chkAsNew" runat="server" Text="Save as New" />
                </td>
            </tr>

        </table>
    </div>

    <asp:Label runat="server" ID="lblErrorMsg"  ></asp:Label>

    <!--
    <asp:DetailsView  DataSourceID="linqSRC_EMPAramsID" runat="server" DataKeyNames="EM_ProductParamID" 
        AutoGenerateEditButton="true" AutoGenerateInsertButton="true" GridLines="None" CssClass="mGrid" 
        PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt"  AutoGenerateRows="false"  >
        <Fields>
            <asp:BoundField DataField="EM_ProductParamID" Visible="true" InsertVisible="false" HeaderText="ID" />
            <asp:BoundField DataField="EM_ProductBillingDesc" Visible="true" InsertVisible="true"  HeaderText="Description"/>
            <asp:BoundField DataField="EM_CoreType" Visible="true" InsertVisible="true"  HeaderText="Core Type" DataFormatString="{0:N0}" ApplyFormatInEditMode="true"/>
            <asp:BoundField DataField="EM_CoreService" Visible="true" InsertVisible="true"  HeaderText="Core Service" DataFormatString="{0:N0}"  ApplyFormatInEditMode="true"/>
            <asp:BoundField DataField="EM_CorePrimaryCluster" Visible="true" InsertVisible="true" HeaderText="Primary Cluster" DataFormatString="{0:N0}"  ApplyFormatInEditMode="true" />
            <asp:BoundField DataField="EM_CorePrimarySubCluster" Visible="true" InsertVisible="true" HeaderText="Primary Sub Cluster" DataFormatString="{0:N0}"  ApplyFormatInEditMode="true"/>
            <asp:BoundField DataField="EM_CoreSecondaryCluster" Visible="true" InsertVisible="true" HeaderText="Secondary Cluster" DataFormatString="{0:N0}"  ApplyFormatInEditMode="true"/>
            <asp:BoundField DataField="EM_CoreSecondarySubCluster" Visible="true" InsertVisible="true" HeaderText="Secondary Sub Cluster" DataFormatString="{0:N0}"  ApplyFormatInEditMode="true"/>
            <asp:BoundField DataField="EM_ProductBillingCommitment" Visible="true" InsertVisible="true" HeaderText="Billing Commitment" DataFormatString="{0:N0}" ApplyFormatInEditMode="true"/>
            
            <asp:CheckBoxField DataField="EM_HWRequired" Visible="true" InsertVisible="true" HeaderText="Hardware Required" />

            <asp:BoundField DataField="EM_InstType_Equivalent" Visible="true" InsertVisible="true" HeaderText="Inst Type Equivalent" />
            <asp:BoundField DataField="EM_InstType_Type" Visible="true" InsertVisible="true" HeaderText="TypeID"  DataFormatString="{0:N0}"  ApplyFormatInEditMode="true"/>

            <asp:TemplateField HeaderText="Added On"  >
                <ItemTemplate>
                    <asp:Label ID="lblAddedOnDate" runat="server" Text='<%# Eval("EM_CreatedOn") %>' ></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="EM_CreatedBy" Visible="true" InsertVisible="true" HeaderText="Added By" />

            <asp:BoundField DataField="EM_ModifiedBy" Visible="true" InsertVisible="true" HeaderText="Updated By" />
            <asp:TemplateField HeaderText="Modified On"  >
                <ItemTemplate>
                    <asp:Label ID="lblModifiedOnDate" runat="server" Text='<%# Eval("EM_ModifiedOn") %>' ></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:CheckBoxField DataField="Is_Deleted_Flag" Visible="true" InsertVisible="false" HeaderText="Deleted ?"  />

        </Fields>
    </asp:DetailsView>
    <asp:LinqDataSource ID="linqSRC_EMPAramsID" runat="server"  EnableUpdate="true" EnableInsert="true"
        TableName="EM_ProductParams" ContextTypeName="CSLOrderingARCBAL.LinqToSqlDataContext" >
        <SelectParameters>
            <asp:ControlParameter ControlID="gvEMParams"  Name="EM_ProductParamID"  />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Is_Deleted_Flag" DefaultValue="false" Type="Boolean" />
            <asp:Parameter Name="CreatedOn" Type="DateTime" DefaultValue='<%: DateTime.Now %>' />
             <asp:Parameter Name="ModifiedOn" Type="DateTime" DefaultValue='<%: DateTime.Now %>' />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Is_Deleted_Flag" DefaultValue="false" Type="Boolean" />
            <asp:Parameter Name="ModifiedOn" Type="DateTime" DefaultValue='<%: DateTime.Now %>' />
        </UpdateParameters>
    </asp:LinqDataSource>
    -->
</asp:Content>

