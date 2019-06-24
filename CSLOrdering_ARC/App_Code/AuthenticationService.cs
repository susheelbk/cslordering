using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.Text;
using System.Net.Http.Headers;
using CSLOrderingARCBAL;


/// <summary>
/// Summary description for AuthenticationService
/// </summary>
public class AuthenticationService
{
    public async Task<bool> ValidateUser(string UserName, string Password)
    {

        try
        {
            var url = "http://localhost:8080/auth/realms/CSLPortal/protocol/openid-connect/token";

            var dict = new Dictionary<string, string>();
            dict.Add("grant_type", "password");
            dict.Add("username", UserName);
            dict.Add("password", Password);
            dict.Add("client_id", "CSLPortalDev");
            dict.Add("client_secret", "5b89e774-9a99-48f8-ad5a-6b15a19ca24e");
            dict.Add("scope", "openid");
            var httpClient = new HttpClient();
            var Content = new FormUrlEncodedContent(dict);
            HttpResponseMessage response = await httpClient.PostAsync(url, Content);
            
            if (response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                var response_content = await response.Content.ReadAsStringAsync();
                var response_content_json = JObject.Parse(response_content);
                var access_token = response_content_json["access_token"].ToString(); 
                var reqParam = new Dictionary<string, string>();
                reqParam.Add("access_token",access_token);
                Content = new FormUrlEncodedContent(reqParam);
                response = await httpClient.PostAsync("http://localhost:8080/auth/realms/CSLPortal/protocol/openid-connect/userinfo", Content);
                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    response_content = await response.Content.ReadAsStringAsync();
                    response_content_json = JObject.Parse(response_content);
                    var KeyCloak_UserID = response_content_json["sub"].ToString(); 
                }

                return true;
            }
            else
            {
                var x = await response.Content.ReadAsStringAsync();//  Log the reason on failure ?
                return false;
            }
        }
        catch(Exception e)
        { return false;  }
    }

    public void MigratetoKeyCloak(string UserName, string Password,string Email, string FirstName,string LastName,Guid OrderingUserId,DateTime LastPasswordChangedDate)
    {
        try
        {
            CSLOrderingARCBAL.User_Migration_KC _migrateduserdetail =  GetMigratedUserDetail(OrderingUserId);
            Guid? KeyCloakUserID = null;

            if (_migrateduserdetail != null)
            {
                if(_migrateduserdetail.ModifiedOn >= LastPasswordChangedDate)
                {  //**User added already and password hasnt been changed since **//
                    return;
                }
                KeyCloakUserID = _migrateduserdetail.KeyCloakUserId;
            }

            string access_token = GetAdminToken().Result;
            if (!string.IsNullOrWhiteSpace(access_token))
            {

                keycloakuser keycloakuser = new keycloakuser(UserName, FirstName, LastName, Email, Password);
                string JsonObject = Newtonsoft.Json.JsonConvert.SerializeObject(keycloakuser);
                var Jsoncontent = new StringContent(JsonObject, Encoding.UTF8, "application/json");
                Jsoncontent.Headers.ContentType = new MediaTypeHeaderValue("application/json");

                if (KeyCloakUserID == null)// ** New User 
                {
                   var adduser = AddasNewUser(access_token, OrderingUserId, Jsoncontent).Result;
                }
                else // ** Already in KeyCloak
                {
                    var updateuser = UpdateExistingUser(access_token, OrderingUserId, KeyCloakUserID.ToString(), Jsoncontent).Result;
                }
            }
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "MigratetoKeyCloak -" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, OrderingUserId.ToString());
        }
        
    }

    private async Task<bool> AddasNewUser(string access_token, Guid OrderingUserId, StringContent Jsoncontent)
    {
        HttpResponseMessage response = new HttpResponseMessage();
        Guid? KeyCloakUserID;

        try
        {
            using (var client = new HttpClient())
            {
                var url = KCConfiguration.KCCreateUserURL;
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + access_token);
                response = await client.PostAsync(url, Jsoncontent);
            }
            if (response.IsSuccessStatusCode)
            {
                KeyCloakUserID = new Guid(response.Headers.Location.Segments[Convert.ToInt32(KCConfiguration.KCUserIdSegmentNo)]);
                AuditCreationofUser(OrderingUserId, KeyCloakUserID);
            }
            else
            {
                LogIssue("AddasNewUser", response.ReasonPhrase + OrderingUserId.ToString(), OrderingUserId.ToString());
            }
            
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "AddasNewUser" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, response.Headers.Location.Segments.ToString());
        }
        return true;
    }


    private async Task<bool> UpdateExistingUser(string access_token, Guid OrderingUserId, String KeyCloakUserId,StringContent Jsoncontent)
    {
        HttpResponseMessage response;

        try
        {
            using (var client = new HttpClient())
            {
                var url = KCConfiguration.KCCreateUserURL + "/" + KeyCloakUserId;
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + access_token);
                response = await client.PutAsync(url, Jsoncontent);
            }
            if (!response.IsSuccessStatusCode)
            {
                LogIssue("UpdateExistingUser", response.ReasonPhrase, OrderingUserId.ToString());
            }
            else
            {
                AuditUpdateofUser(OrderingUserId, new Guid(KeyCloakUserId));
            }
                
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "UpdateExistingUser" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, OrderingUserId.ToString());
        }
        return true;
    }


    private async Task<String> GetAdminToken()
    {
        string access_token = string.Empty;
        try
        {
            var url = KCConfiguration.KCAdminURL;

            var dict = new Dictionary<string, string>();
            dict.Add("grant_type", "password");
            dict.Add("username", KCConfiguration.KCUserName);
            dict.Add("password", KCConfiguration.KCPassword);
            dict.Add("client_id", KCConfiguration.KCAdminClientId);

            var httpClient = new HttpClient();
            var Content = new FormUrlEncodedContent(dict);
            HttpResponseMessage response = await httpClient.PostAsync(url, Content);

            if (response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                var response_content = await response.Content.ReadAsStringAsync();
                var response_content_json = JObject.Parse(response_content);
                access_token = response_content_json["access_token"].ToString();

            }
            else
            {
                LogIssue("GetAdminToken", "Cannot get Admin Token", String.Empty);
            }

        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "GetAdminToken", Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, String.Empty);
        }
        return access_token;
    }

    private void AuditCreationofUser(Guid OrderingUserId,Guid? KeycloakUserId)
    {
        try {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();

            CSLOrderingARCBAL.User_Migration_KC _usermigration = new CSLOrderingARCBAL.User_Migration_KC();
            _usermigration.UserId = OrderingUserId;
            _usermigration.KeyCloakUserId = KeycloakUserId;
            _usermigration.CreatedOn = System.DateTime.Now;
            _usermigration.ModifiedOn = System.DateTime.Now;
            db.User_Migration_KCs.InsertOnSubmit(_usermigration);
            db.SubmitChanges();
        }
        catch(Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "AuditCreationofUser" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, OrderingUserId.ToString());
        }
    }

    private void AuditUpdateofUser(Guid OrderingUserId, Guid? KeycloakUserId)
    {
        try
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            CSLOrderingARCBAL.User_Migration_KC _usermigration = (from user in db.User_Migration_KCs
                          where user.UserId == OrderingUserId
                          select user).SingleOrDefault();
            _usermigration.ModifiedOn = System.DateTime.Now;
            db.SubmitChanges();
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "AuditUpdateofUser" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, OrderingUserId.ToString());
        }
    }

    private CSLOrderingARCBAL.User_Migration_KC GetMigratedUserDetail(Guid OrderingUserId)
    {
        CSLOrderingARCBAL.User_Migration_KC _usermigration = null;
        try
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            _usermigration = (from user in db.User_Migration_KCs
                                                                  where user.UserId == OrderingUserId
                                                                  select user).SingleOrDefault();
            return _usermigration;
        }
        catch (Exception objException)
        {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", "GetKeyCloakUserId" + OrderingUserId.ToString(), Convert.ToString(objException.Message), Convert.ToString(objException.InnerException), Convert.ToString(objException.StackTrace), "", "", false, OrderingUserId.ToString());
        }
        return _usermigration;
    }

    private void LogIssue(String Title,String FailureReason,String ReferenceString)
    {
        try {
            CSLOrderingARCBAL.LinqToSqlDataContext db;
            db = new CSLOrderingARCBAL.LinqToSqlDataContext();
            db.USP_SaveErrorDetails("Authentication Service", Title, FailureReason, "", "", "", "", false, ReferenceString);
        }
        catch (Exception) { }
    }
}

public class keycloakuser
{
    public string username { get; set; }
    public string firstName { get; set; }
    public string lastName { get; set; }
    public string email { get; set; }
    public bool emailVerified { get; set; }
    public bool enabled { get; set; }

    public List<keycloakcredential> credentials { get; set; }

    public keycloakuser(string _username, string _firstName,string _lastName, string _email,string _password)
    {
        username = _username;
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        emailVerified = true;
        enabled = true;
        credentials = new List<keycloakcredential>();
        credentials.Add(new keycloakcredential(_password)); 
    }

}
public class keycloakcredential
{
    public string type { get; set; }
    public string value { get; set; }
    public bool temporary { get; set; }

    public keycloakcredential(string _password)
    {
        type = "password";
        value = _password;
        temporary = false;
    }
}
