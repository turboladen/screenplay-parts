class Epel < Drama::Part
  def play(os_version: 5, arch: 'x86_64')
    rpm_version = os_version == 5 ? '5-4' : '6-8'
    rpm_destination = "/tmp/epel-release-#{rpm_version}.noarch.rpm"
    rpm_source = "http://dl.fedoraproject.org/pub/epel/#{os_version}/#{arch}/epel-release-#{rpm_version}.noarch.rpm"

    host.rpm package: 'epel', on_fail: -> {
      host.file path: rpm_destination, source: rpm_source
      host.rpm package: rpm_destination, sudo: true
    }

    host.yum update_cache: true, sudo: true
    host.yum upgrade: true, sudo: true
  end
end
