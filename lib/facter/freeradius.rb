# Grab the FreeRADIUS version from the output of radiusd -v
Facter.add('freeradius') do
  setcode do
    versions = {}

    dist = Facter.value(:os.family)
    binary = case dist
             when %r{RedHat}
               'radiusd'
             when %r{Debian}
               'freeradius'
             else
               'radiusd'
             end

    begin
      version_string = Facter::Core::Execution.execute("#{binary} -v")
      versions['full'] = version_string.split(%r{\n})[0].match(%r{FreeRADIUS Version (\d+\.\d+\.\d+)})[1].to_s
      versions['minor'] = version['full'].match(%r{(\d+\.\d+)\.\d+})[1].to_s
      versions['major'] = version['full'].match(%r{(\d+)\.\d+\.\d+})[1].to_s
    rescue Facter::Core::Execution::ExecutionFailure => e
      Facter.debug("Unable to determine radius version: #{e}")
      versions = {
        'full'  => nil,
        'minor' => nil,
        'major' => nil,
      }
    end

    { 'version' => versions }
  end
end
