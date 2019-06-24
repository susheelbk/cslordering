using CSLOrderingARCBAL.Common;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;
using System.Text;

namespace CSLOrderingARCBAL.BAL
{
    public class ArcBAL
    {
        public static ARC GetArcInfoByUserId(Guid userID)
        {
            ARC arcDetails = new ARC();
            LinqToSqlDataContext db = new LinqToSqlDataContext();

            arcDetails = (from arc in db.ARCs
                          join aup in db.ARC_User_Maps on arc.ARCId equals aup.ARCId
                          where
                          (
                              (arc.IsDeleted == false)
                              &&
                              (aup.UserId == userID)
                          )
                          select arc).FirstOrDefault();
            db.Dispose();
            return arcDetails;
        }



        public static List<BOS_Device> GetDevices()
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<BOS_Device> devices = (from devs in db.BOS_Devices
                                        where
                                        (
                                            (devs.Dev_Delete_Flag == false)
                                            &&
                                            (devs.Dev_Active == true)
                                        )
                                        select devs).ToList();
            db.Dispose();
            return devices;
        }
        public static List<BOSDeviceDTO> GetDevice(string chipNo, string ARC_Code, string dataNo, string EMNo = null, string InstallID = null)
        {
            List<BOSDeviceDTO> deviceList = new List<BOSDeviceDTO>();

            List<string> ARClists = GetArcBranches(ARC_Code);
            ARClists.Add(ARC_Code); 

            if (!string.IsNullOrWhiteSpace(chipNo) && !string.IsNullOrWhiteSpace(dataNo))
            {
                deviceList = GetDeviceByChipNoandDataNo(chipNo, dataNo, ARClists); 
            }
            else if (!string.IsNullOrWhiteSpace(EMNo) && !string.IsNullOrWhiteSpace(InstallID))
            {
                deviceList = GetDeviceByEMNoandInstallID(EMNo, InstallID, ARClists); 
            }
            else if (!string.IsNullOrWhiteSpace(chipNo))
            {
                deviceList = GetDeviceByChipNo(chipNo, ARClists); 
            }
            else if (!string.IsNullOrWhiteSpace(dataNo))
            {
                deviceList = GetDeviceByDataNo(dataNo, ARClists); 
            }
            else if (!string.IsNullOrWhiteSpace(EMNo))
            {
                deviceList = GetDeviceByEMNo(EMNo, ARClists); 
            }
            else if (!string.IsNullOrWhiteSpace(InstallID))
            {
                deviceList = GetDeviceByInstallID(InstallID, ARClists); 
            }
            return deviceList;
        }



        public static List<BOSDeviceDTO> GetDeviceByChipNo(string chipNo, List<string> ARC_Code)
        {
                      
            LinqToSqlDataContext db = new LinqToSqlDataContext();                      

            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                           join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                           join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code                                           
                                            
                                           where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false 
                                               && devs.EMNo == null && devs.Dev_Account_Code==chipNo
                                           )
                                           select new BOSDeviceDTO {
                                               Dev_Account_Code= devs.Dev_Account_Code,
                                               Dev_Connect_Number = devs.Dev_Connect_Number,
                                               Dev_Code = devs.Dev_Code,
                                               EMNo = devs.EMNo,
                                               Dev_Type = devs.Dev_Type,
                                               Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                               InstallerName = installer.CompanyName,
                                               Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                               ARCName = arcs.CompanyName,
                                               PostCode = devs.Dev_Post_Code                                 

                                           }).ToList();
            db.Dispose();
            return deviceList;
        }
        public static List<BOSDeviceDTO> GetDeviceByDataNo(string DataNo, List<string> ARC_Code)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                           join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                             join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code
                                           where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false &&
                                               devs.Dev_Connect_Number == DataNo
                                                && devs.EMNo == null
                                           )
                                           select new BOSDeviceDTO
                                           {
                                               Dev_Account_Code = devs.Dev_Account_Code,
                                               Dev_Connect_Number = devs.Dev_Connect_Number,
                                               Dev_Code = devs.Dev_Code,
                                               EMNo = devs.EMNo,
                                               Dev_Type = devs.Dev_Type,
                                               Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                               InstallerName = installer.CompanyName,
                                               Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                               ARCName = arcs.CompanyName

                                           }).ToList();
            db.Dispose();
            return deviceList;
        }
        public static List<BOSDeviceDTO> GetDeviceByEMNo(string EMNo, List<string> ARC_Code)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string[] ArrayEMNo = EMNo.Split(',');
            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                             join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                             join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code
                                           where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false &&
                                               ArrayEMNo.Contains(devs.EMNo)
                                           )
                                             select new BOSDeviceDTO
                                             {
                                                 Dev_Account_Code = devs.Dev_Account_Code,
                                                 Dev_Connect_Number = devs.Dev_Connect_Number,
                                                 Dev_Code = devs.Dev_Code,
                                                 EMNo = devs.EMNo,
                                                 Dev_Type = devs.Dev_Type,
                                                 Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                                 InstallerName = installer.CompanyName,
                                                 Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                                 ARCName = arcs.CompanyName

                                             }).ToList();
            db.Dispose();
            return deviceList;
        }
        public static List<BOSDeviceDTO> GetDeviceByInstallID(string InstallID, List<string> ARC_Code)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string[] ArrayInstallID = InstallID.Split(',');
            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                             join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                             join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code
                                           where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false &&
                                               ArrayInstallID.Contains(devs.Dev_Account_Code)
                                           )
                                           select new BOSDeviceDTO
                                           {
                                               Dev_Account_Code = devs.Dev_Account_Code,
                                               Dev_Connect_Number = devs.Dev_Connect_Number,
                                               Dev_Code = devs.Dev_Code,
                                               EMNo = devs.EMNo,
                                               Dev_Type = devs.Dev_Type,
                                               Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                               InstallerName = installer.CompanyName,
                                               Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                               ARCName = arcs.CompanyName

                                           }).ToList();
            db.Dispose();
            return deviceList;
        }
        public static List<BOSDeviceDTO> GetDeviceByChipNoandDataNo(string ChipNo, string DataNo, List<string> ARC_Code)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                           join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                           join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code
                                            
                                             where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false &&
                                                devs.Dev_Account_Code == ChipNo &&
                                               devs.Dev_Connect_Number == DataNo
                                                && devs.EMNo == null
                                           )
                                           select new BOSDeviceDTO
                                           {
                                               Dev_Account_Code = devs.Dev_Account_Code,
                                               Dev_Connect_Number = devs.Dev_Connect_Number,
                                               Dev_Code = devs.Dev_Code,
                                               EMNo = devs.EMNo,
                                               Dev_Type = devs.Dev_Type,
                                               Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                               InstallerName = installer.CompanyName,
                                               Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                               ARCName = arcs.CompanyName
                                              

                                           }).ToList();
            db.Dispose();
            return deviceList;
        }

        public static List<BOSDeviceDTO> GetDeviceByEMNoandInstallID(string EMNo, string InstallID, List<string> ARC_Code)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string[] ArrayEMNo = EMNo.Split(',');
            string[] ArrayInstallID = InstallID.Split(',');
            List<BOSDeviceDTO> deviceList = (from devs in db.BOS_Devices
                                             join installer in db.Installers on devs.Dev_Inst_UnqCode equals installer.UniqueCode
                                             join arcs in db.ARCs on devs.Dev_Arc_Primary equals arcs.ARC_Code
                                           where
                                           (
                                               ARC_Code.Contains(devs.Dev_Arc_Primary) 
                                               && devs.Dev_Active == true && devs.Dev_Delete_Flag == false &&
                                              ArrayInstallID.Contains(devs.Dev_Account_Code) &&
                                              ArrayEMNo.Contains(devs.EMNo)
                                           )
                                             select new BOSDeviceDTO
                                             {
                                                 Dev_Account_Code = devs.Dev_Account_Code,
                                                 Dev_Connect_Number = devs.Dev_Connect_Number,
                                                 Dev_Code = devs.Dev_Code,
                                                 EMNo = devs.EMNo,
                                                 Dev_Type = devs.Dev_Type,
                                                 Dev_Arc_Primary = devs.Dev_Arc_Primary,
                                                 InstallerName = installer.CompanyName,
                                                 Dev_Inst_UnqCode = devs.Dev_Inst_UnqCode,
                                                 ARCName = arcs.CompanyName

                                             }).ToList();
            db.Dispose();
            return deviceList;
        }
    
        public static string GetARCName(string id)
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string returnstring = "";
            returnstring = (from arc in db.ARCs
                            where arc.ARCId == Convert.ToInt32(id)
                            select arc.CompanyName).SingleOrDefault();

            db.Dispose();
            return returnstring;
        }

        public static string GetARCNameByCode(string ARC_Code)
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string returnstring = "";
            returnstring = (from arc in db.ARCs
                            where arc.ARC_Code == ARC_Code
                            select arc.CompanyName).SingleOrDefault();

            db.Dispose();
            return returnstring;
        }

        public static string GetEmizonArcNobyARCID(string ARCID)
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string returnstring = "";
            returnstring = (from arc in db.ARCs
                            where arc.ARCId == Convert.ToInt32(ARCID)
                            select arc.EM_ARCNo).SingleOrDefault();

            db.Dispose();
            return returnstring;
        }

        public static string GetEmizonPlatformbyARCID(string ARCID)
        {

            LinqToSqlDataContext db = new LinqToSqlDataContext();
            string returnstring = "";
            returnstring = (from arc in db.ARCs
                            where arc.ARCId == Convert.ToInt32(ARCID)
                            select arc.EM_Platform).SingleOrDefault();

            db.Dispose();
            return returnstring;
        }

        public static ARC CreateARC(ARC arc)
        {
            using (LinqToSqlDataContext db = new LinqToSqlDataContext())
            {
                if (string.IsNullOrEmpty(arc.UNiqueCode))
                {
                    ISingleResult<SP_GenerateAccountUniqueCodeResult> result = db.SP_GenerateAccountUniqueCode(arc.CompanyName, arc.ArcTypeId.HasValue ? arc.ArcTypeId : 1, arc.CreatedBy);
                    if (result == null)
                        throw new Exception("Unable to Generate a Unique Code using the SP: SP_GenerateAccountUniqueCode");
                    else
                        arc.UNiqueCode = result.FirstOrDefault().Column1.Value.ToString();
                }
                db.ARCs.InsertOnSubmit(arc);
                db.SubmitChanges();
            }

            return arc; //returns the same object with ARCId filled in
        }

        /// <summary>
        /// Get ARC Branches for selected ARC 
        /// </summary>
        /// <param name="arcId"></param>
        private static List<string> GetArcBranches(string ARCCode)
        {
            LinqToSqlDataContext db = new LinqToSqlDataContext();
                var returnstring = (from ARCs in db.ARCs
                                     join AM in db.AlarmDeliveryARCMappings on ARCs.ARCId equals AM.ARCId
                                     where ARCs.ARC_Code == ARCCode
                                     select AM.Branch_ARC_Code).ToList();
                db.Dispose();
                return returnstring;  

        }

    }
}
