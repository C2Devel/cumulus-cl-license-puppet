Puppet::Type.type(:cumulus_license).provide :ruby do

  mk_resource_methods

  # If cl_license is missing or not configured as an exec
  # Puppet returns error:
  # "Could not find a suitable provider for cumulus_license"
  commands :cl_license => '/usr/cumulus/bin/cl-license'

  # If operating system is not cumulus
  # Puppet returns error:
  # "Could not find a suitable provider for cumulus_license"
  # someone asked for a way to log why provider is not suitable
  # but unable to find progress on it. http://bit.ly/17Dhny6
  confine :operatingsystem => [:debian, :cumulus_linux]

  def exists?
    @property_hash[:ensure] == :present
    # if license is forced to be installed, install it.
    if resource[:force] == :false
      return File.exist?('/etc/cumulus/.license.txt')
    else
      return false
    end
  end

  # install license
  def create
    begin
      cl_license(['-i', resource[:src]])
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("Failed to execute cl-license, #{e.inspect}")
    end
  end

end
