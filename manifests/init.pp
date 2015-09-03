# Class: controlmagent_fixpack
#
# This module silently installs Fix Pack for Control-M/Agent 8 on Linux/UNIX
#
# version 0.0.7: 26 November 2014 by Tomasz Wladyczanski
#
# https://www.linkedin.com/in/tomekw
# http://uid-0.blogspot.com
#
# Module parameters and their defaults:
#
# userLogin           => 'root',                                    # user account for which Control-M/Agent 8 has been installed
# installLogin        => 'root',                                    # user account under which Control-M/Agent 8 will be restarted (and default mode of the agent) 
# binFile             => 'PAKAI.8.0.00.300_Linux-i386_INSTALL.BIN', # fix pack installation file
# installAgentVersion => 'DRKAI.8.0.00'                             # installed version of the agent to check in the installed-versions.txt
# installFixVersion   => 'PAKAI.8.0.00.300'                         # installed version of the fix to check in the installed-versions.txt
# tempDir             => '/tmp/CONTROLM_AGENT_FP',                  # directory where the installation file will be placed and unpacked
# extraOpts           => '-f'                                       # extra options of the installer, e.g. -f (to install 32-bit Fix Pack on 64-bit Linux), -d (to unpack in directory different from /tmp).
#
class controlmagent_fixpack (
$userLogin = 'root',
  $installLogin = 'root',
  $binFile = 'PAKAI.8.0.00.300_Linux-i386_INSTALL.BIN',
  $installAgentVersion = 'DRKAI.8.0.00',
  $installFixVersion = 'PAKAI.8.0.00.300',
  $tempDir = '/tmp/CONTROLM_AGENT',
  $extraOpts = '-f' )
{

  Exec['controlmagent_fixpack: Check the agent']     ->
  Exec['controlmagent_fixpack: Check the fix pack']  ->
  Exec['controlmagent_fixpack: Prepare']             ->
  File['Control-M/Agent Fix Pack file']              ->
  Exec['controlmagent_fixpack: Shut down the agent'] ->
  Exec['controlmagent_fixpack: Run installer']       ->
  Exec['controlmagent_fixpack: Start the agent']


  exec {'controlmagent_fixpack: Check the agent':
    path    => '/bin:/usr/bin',
    command => "su - ${userLogin} -c \"find ~/installed-versions.txt | xargs grep \"${installAgentVersion}\"\"",
  }

  exec {'controlmagent_fixpack: Check the fix pack':
    path    => '/bin:/usr/bin',
    command => "su - ${userLogin} -c \"find ~/installed-versions.txt | xargs grep \"${installFixVersion}\"\"",
    returns => 123,
  }

  exec {'controlmagent_fixpack: Prepare':
    path    => '/bin:/usr/bin',
    command => "su - ${userLogin} -c \"mkdir -p ${tempDir}\"",
  }

  file { 'Control-M/Agent Fix Pack file':
    owner  => $userLogin,
    mode   => '0755',
    source => "puppet:///files/${binFile}",
    path   => "${tempDir}/${binFile}"
  }

  exec { 'controlmagent_fixpack: Shut down the agent':
    path    => '/bin:/usr/bin',
    onlyif  => "test -f ${tempDir}/${binFile}",
    command => "su - ${installLogin} -c \"`su - ${userLogin} -c \"which shut-ag\"` -u ${userLogin} -p ALL\"",
  }

  exec { 'controlmagent_fixpack: Run installer':
    path    => '/bin:/usr/bin',
    onlyif  => "test -f ${tempDir}/${binFile}",
    command => "su - ${userLogin} -c \"${tempDir}/${binFile} -s ${extraOpts}\"",
  }

  exec { 'controlmagent_fixpack: Start the agent':
    path    => '/bin:/usr/bin',
    onlyif  => "test -f ${tempDir}/${binFile}",
    command => "su - ${installLogin} -c \"`su - ${userLogin} -c \"which start-ag\"` -u ${userLogin} -p ALL\"",
  }

  # maybe to write later

  #service { ‘controlm_agent service’:
  #  ensure => running,
  #  name   => 'controlm_agent',
  #  enable => true,
  #}

}
