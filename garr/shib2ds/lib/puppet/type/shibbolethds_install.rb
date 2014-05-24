# This Puppet Resource Type runs the "install.sh" and install the Shibboleth DS on the underlying system.
#
# Example:
# 
#  shibboleth_install { 'execute_install':
#    idpfqdn => $idpfqdn,
#    keystorepassword => $keystorepassword,
#    javahome => $shib2idp::java::params::java_home,
#    tomcathome => $tomcat::tomcat_home,
#  }

module Puppet

	newtype(:shibbolethds_install) do
		@doc = "Install Shibboleth DS sources downloaded from Internet2 site"

		newparam(:name, :namevar => true) do
			desc "The name of the action"
		end

		newparam(:sourcedir) do
			desc "Path where the Shibboleth IdP sources are extracted."
			defaultto "/usr/local/src/shibboleth-discovery-service"
		end

		newparam(:dsfqdn) do
			desc "The Shibboleth DS's FQDN"
			defaultto Facter.value("fqdn")
		end
    
		newparam(:installdir) do
			desc "The Shibboleth DS installation directory"
			defaultto "/opt/shibboleth-ds"
		end
    
		newparam(:javahome) do
			desc "The Java home"
		end
    
		newparam(:tomcathome) do
			desc "The Tomcat installation directory"
		end
		
		newparam(:curtomcat) do
			desc "The current Tomcat version"
		end
    
		validate do
			fail("javahome cwd is required") if self[:javahome].nil?
			fail("tomcathome cwd is required") if self[:tomcathome].nil?
		end
      
		def refresh
			debug("Shibbolethds_install[name] = " + @parameters[:name].value + ".")
			debug("Shibbolethds_install[sourcedir] = " + @parameters[:sourcedir].value + ".")
			debug("Shibbolethds_install[dsfqdn] = " + @parameters[:dsfqdn].value + ".")
			debug("Shibbolethds_install[installdir] = " + @parameters[:installdir].value + ".")
			debug("Shibbolethds_install[javahome] = " + @parameters[:javahome].value + ".")
			debug("Shibbolethds_install[tomcathome] = " + @parameters[:tomcathome].value + ".")
			debug("Shibbolethds_install[curtomcat] = " + @parameters[:curtomcat].value + ".")
      
			filename = "/tmp/dsautoinstall.sh"  # Creates a new bash script who adds JAVA_HOME environment variable to the underlying system and calls the "install.sh" to install the Shibboleth IdP.
        
			File.open(filename, "w") do |saved_file|  # Open it and complete it line by line
				saved_file.write("#!/bin/bash\n")
				saved_file.write(". /etc/environment\n")
				saved_file.write("export JAVA_HOME\n")
				saved_file.write("\n")
				saved_file.write("cd " + @parameters[:sourcedir].value + "\n")
				saved_file.write("/bin/sh install.sh\n")
			end
      
			debug("Executing install script.")
			system("/bin/bash " + filename) or raise Puppet::Error, "Error while installing Shibboleth DS." # If the system() return 'false' reise up the message "Error while..."

			debug("Deleting file " + filename + ".")
			File.delete(filename)
			
			system("/bin/chown " + @parameters[:curtomcat].value + ":" + @parameters[:curtomcat].value + " " + @parameters[:installdir].value + "/logs/ " + @parameters[:installdir].value + "/metadata/") or raise Puppet::Error, "Error while setting credentials."        
		end
	end
end