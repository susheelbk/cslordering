<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Preview.aspx.cs" Inherits="ADMIN_Preview" %>
<!DOCTYPE html>



<head>
    <title>Preview</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">
    <link href="../Content/styles.css" rel="stylesheet" />

    <%--<script src="../scripts/jquery-1.10.0.min.js" type="text/javascript"></script>--%>
    <link href="~/Styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <%--//added by priya--%>
    <script src="../scripts/alertify.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../scripts/jquery-1.10.2.js"> </script>
    <%--//added by priya--%>
    <script type="text/javascript" src="../scripts/jquery-ui.js"></script>
    <link rel="stylesheet" href="~/Styles/Default.css" type="text/css" />
    <link rel="stylesheet" href="../Content/Site.css" />
    <script type="text/javascript" src="../scripts/bootstrap.min.js"></script>
        <script type="text/javascript" src="../scripts/bootstrap.js"></script>
       <script type="text/javascript" src=""></script>
    <script src="../scripts/moment.js"></script>
    <script src="../scripts/moment-datepicker.js"></script>
   

    <!-- Bootstrap core CSS -->
  <%--  <link href="../Content/bootstrap.css" rel="stylesheet">--%>

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="../../assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="../bootstrap.css" rel="stylesheet" />
    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="../../assets/js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
        
</head>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<span id="previewContent" runat="server"></span>  
</body>
</html>