The controlmagent_fixpack module is for installation of BMC Control-M/Agent 8 Fix Pack on Linux/UNIX.  
  
version 0.0.7: 26 November 2014 by Tomasz Wladyczanski  
  
https://www.linkedin.com/in/tomekw  
http://uid-0.blogspot.com  
  
Module parameters and their defaults:  
  
; user account for which Control-M/Agent 8 has been installed    
userLogin => 'root',                          		  	  
  
; user account under which Control-M/Agent 8 will be restarted (and default mode of the agent)  
installLogin => 'root',                       			   
  
; fix pack installation file   
binFile => 'PAKAI.8.0.00.300_Linux-i386_INSTALL.BIN',  
  
; installed version of the agent to check in the installed-versions.txt  
installAgentVersion => 'DRKAI.8.0.00'  
  
; installed version of the fix to check in the installed-versions.txt                       
installFixVersion => 'PAKAI.8.0.00.300'                	
  
; directory where the installation file will be placed      
tempDir => '/tmp/CONTROLM_AGENT_FP',          			
  
; extra options of the installer, e.g. -f (to install 32-bit Fix Pack on 64-bit Linux), -d (to unpack in directory different from /tmp).    
extraOpts => '-f'                                       	    
