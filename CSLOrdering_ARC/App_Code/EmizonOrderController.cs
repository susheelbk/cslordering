using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Messaging;

/// <summary>
/// Summary description for EmizonOrderController
/// </summary>
public class EmizonOrderController
{
	public EmizonOrderController()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="queuePath"></param>
    /// <param name="newEMNoRequest"></param>
    public static void AddAPIRequestToQueue(string queuePath, 
        Emizon.APIModels.MSMQTypes.QueueOrderMessage newEMNoRequest
        )
    {
            System.Messaging.MessageQueue msmq = new System.Messaging.MessageQueue(queuePath);
            msmq.Send(newEMNoRequest, "Emizon Order: " + newEMNoRequest.orderID.ToString());
    }

    #region AddtoMSMQ
    public static void AddtoMSMQ(string QPath, object EmizonMSMQ, string label = "")
    {
            MessageQueue objQue = new MessageQueue(QPath);
            Message msg = new Message();
            msg.Recoverable = true;
            msg.Label = label;
            msg.Body = EmizonMSMQ;
            objQue.Send(msg);
    }
    #endregion

}