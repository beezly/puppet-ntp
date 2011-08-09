# Class: ntp
#
# This module manages ntp and is standard for all hosts
#
# Requires:
#   $ntpServerList must be set in site manifest
#
# Sample Usage:
#   include ntp
#
class ntp {

	# Solaris uses a different package name

	packageName => $operatingsystem ? {
		Solaris => "SUNWntpu",
		default => "ntp"
	}
	
	# RedHat uses "ntpd", whereas "ntp" works for nearly everything else
	
	serviceName => $operatingsystem ? {
		/(RedHat|CentOS|Fedora)/ => "ntpd",
		default => "ntp"
	}

    package { "ntp": 
		name => "$packageName"
	}

    file { "/etc/ntp.conf":
        mode    => "644",
        content => template("ntp/client-ntp.conf.erb"),
        notify  => Service["ntpd"],
        require => Package["ntp"],
    } # file

    service { "ntpd":
		name => "$serviceName",
        ensure  => running,
        enable  => true,
        require => Package["ntp"],
    } # service
} # class ntp
