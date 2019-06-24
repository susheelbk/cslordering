using CSLOrderingARCBAL.BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL
{
    public class EmizonService 
    {

        public List<EM_InstallIDRegister> GetAllInstallIDList()
        {
            List<EM_InstallIDRegister> data = new List<EM_InstallIDRegister>(); 
            using (LinqToSqlDataContext dbContext = new LinqToSqlDataContext())
            {
                data = dbContext.EM_InstallIDRegisters.ToList();
            }
            return data;
        }


        public List<EM_InstallIDRegister> GetARCInstallIDList(int arcID)
        {
            List<EM_InstallIDRegister> data = new List<EM_InstallIDRegister>();
            using (LinqToSqlDataContext dbContext = new LinqToSqlDataContext())
            {
                data = dbContext.EM_InstallIDRegisters.Where(x => x.CSLARCId == Convert.ToInt32(arcID)).ToList();
            }
            return data;
        }



        



        public Tuple<bool, string> AddInstallID(List<EM_InstallIDRegister> entities)
        {
            Tuple<bool, string> data = new Tuple<bool, string>(false, "");

            try
            {
                using (LinqToSqlDataContext dbContext = new LinqToSqlDataContext())
                {
                    foreach (EM_InstallIDRegister entity in entities)
                    {
                        entity.CreatedOn = DateTime.Now;
                        dbContext.EM_InstallIDRegisters.InsertOnSubmit(entity);
                    };
                    dbContext.SubmitChanges();
                    data = new Tuple<bool, string>(true, "records added to database");
                }
            }
            catch (Exception exp)
            {
                data = new Tuple<bool, string>(false, exp.Message);
            }
            return data;
        }



        public static int AddtoEmizonRequestQueue(string EMNo, string QueueType)
        {
            int retvalue = -1;
             try
            {
                using (LinqToSqlDataContext dbContext = new LinqToSqlDataContext())
                {
                    EmizonQueueRequest _EmizonQueueRequest = new EmizonQueueRequest();
                    _EmizonQueueRequest.EMNo = EMNo;
                    _EmizonQueueRequest.QueueType = QueueType;
                    _EmizonQueueRequest.Createdon = System.DateTime.Now;
                    _EmizonQueueRequest.Modifiedon = System.DateTime.Now;
                    dbContext.EmizonQueueRequests.InsertOnSubmit(_EmizonQueueRequest);
                    dbContext.SubmitChanges();
                    retvalue = _EmizonQueueRequest.ID;
                }
            }
             catch (Exception exp)
             {
                 retvalue = -1;
             }
            return retvalue;
        }


        private static string GetResponseValueforEmizonRequestQueue(int RequestReference, ref string  ResponseMessage  )
        {

            try
            {
                using (LinqToSqlDataContext dbContext = new LinqToSqlDataContext())
                {

                    EmizonQueueRequest _EmizonQueueRequest = (from EQR in dbContext.EmizonQueueRequests
                                                              where EQR.ID == RequestReference
                                                              select EQR).SingleOrDefault();

                    ResponseMessage = _EmizonQueueRequest.ResponseValue2;
                    return (_EmizonQueueRequest.ResponseValue);
                }
            }
            catch (Exception exp)
            {
                return null;
            }

        }

        public static  string WaitandGetResponse(int RequestReference, ref string  ResponseMessage ,int MaxAttempts = 3 )
        {
            int icounter = 1;
            string ResponseVal = null;
            while (icounter <= MaxAttempts && string.IsNullOrEmpty(ResponseVal))
                {
                    System.Threading.Thread.Sleep(2000);
                    ResponseVal = GetResponseValueforEmizonRequestQueue(RequestReference,ref ResponseMessage );
                    icounter++;
                }
            return ResponseVal;
        }

    }
}
