
# Additional functions to run commands and puppet apply over WinRM instead of ssh
# Version: 2016-05-03-001
# Reference: https://github.it.mgt/kpn-puppet-forge/puppet-kpn-module-skeleton/blob/master/skeleton/spec/spec_helper_acceptance.rb.erb

def winrm_command(host, command, opts = {})
  require 'winrm'
  # Get parameters
  user = host[:ssh][:user]
  pass = host[:ssh][:password]
  hostname = host.to_s
  acceptable_exit_codes = nil
  if opts.key?(:acceptable_exit_codes) and not opts[:acceptable_exit_codes].nil?
    acceptable_exit_codes = opts[:acceptable_exit_codes]
  else
    acceptable_exit_codes = opts[:acceptable_exit_codes] = [ 0, ]
  end

  run_as_cmd = false
  if opts.key?(:run_as_cmd) and not opts[:acceptable_exit_codes].nil?
    run_as_cmd = true
  end

  # Setup winrm
  endpoint = 'http://' + hostname + ':5985/wsman'
  winrm = WinRM::WinRMWebService.new(endpoint, :negotiate, user: user, pass: pass)
  winrm.set_timeout 300

  # Debugging
  host.logger.debug "Running command '#{command}' via winrm"

  # Execute command via winrm
  winrm.create_executor do |e|
    if run_as_cmd
      @result = e.run_cmd(command) do |stdout, stderr|
        host.logger.debug stdout
        host.logger.debug stderr
      end
    else
      @result = e.run_powershell_script(command) do |stdout, stderr|
        host.logger.debug stdout
        host.logger.debug stderr
      end
    end
  end

  # Convert result structure into "flat" hash
  @stdout = ""
  @stderr = ""
  for datahashes in @result[:data] do
    @stdout = @stdout + datahashes[:stdout] unless not datahashes.key?(:stdout) or datahashes[:stdout].nil?
    @stderr = @stderr + datahashes[:stderr] unless not datahashes.key?(:stderr) or datahashes[:stderr].nil?
  end
  exitcode = @result[:exitcode]

  # Debugging
  host.logger.debug "winrm - stdout  :#{stdout}"
  host.logger.debug "winrm - stderr  :#{stderr}"
  host.logger.debug "winrm - exitcode:#{exitcode}"

  # Raise error when exit code is not in list with acceptable exitcodes.
  if not acceptable_exit_codes.include?(exitcode)
    raise StandardError, "Command '#{command}' failed with unacceptable exit code:#{exitcode} on host '#{hostname}'\n" +
                         "Stdout:#{@stdout}\n" +
                         "Stderr:#{@stderr}\n"
  end

  # Return flat hash with stdout, stderr and the exitcode
  return { :stdout   => @stdout,
           :stderr   => @stderr,
           :exitcode => exitcode }
end

def apply_manifest_on_winrm(host, manifest, opts = {})
  if [opts[:catch_changes],opts[:catch_failures],opts[:expect_failures],opts[:expect_changes]].compact.length > 1
    raise StandardError, "only one of :catch_changes, :catch_failures, :expect_failures and :expect_changes should be set"
  end

  acceptedexitcodes = [ 0, ]

  if opts[:catch_changes]
    acceptedexitcodes = [ 0, ]
  end

  if opts[:catch_failures]
    acceptedexitcodes = [ 0, 2 ]
  end

  if opts[:expect_failures]
    acceptedexitcodes = [ 1, 4, 6 ]
  end

  if opts[:expect_changes]
    acceptedexitcodes = [ 2, ]
  end

  file_path = host.tmpfile('apply_manifest.pp')
  create_remote_file(host, file_path, manifest + "\n")

  winrm_command(host,'puppet apply --detailed-exitcodes ' + file_path + '; exit $lastexitcode', { :acceptable_exit_codes => acceptedexitcodes, } )
end



