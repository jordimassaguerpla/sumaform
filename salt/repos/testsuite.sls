{% if grains.get('testsuite') | default(false, true) %}
{% if 'client' in grains.get('roles') or 'minion' in grains.get('roles') or 'sshminion' in grains.get('roles') %}

{% if (grains['os'] == 'SUSE') or (grains['os_family'] == 'RedHat') %}

uyuni_key_for_fake_packages:
  file.managed:
    - name: /tmp/uyuni.key
    - source: salt://default/gpg_keys/uyuni.key
  cmd.wait:
    - name: rpm --import /tmp/uyuni.key
    - watch:
      - file: uyuni_key_for_fake_packages

test_repo_rpm_pool:
  pkgrepo.managed:
    - baseurl: http://{{ grains.get("mirror") | default("download.opensuse.org", true) }}/sync-obs/systemsmanagement:/Uyuni:/Test-Packages:/Pool/rpm/
    - refresh: True
    - gpgcheck: 0

{% elif grains['os_family'] == 'Debian' %}

test_repo_deb_pool:
  pkgrepo.managed:
    - name: deb http://{{ grains.get("mirror") | default("download.opensuse.org", true) }}/sync-obs/systemsmanagement:/Uyuni:/Test-Packages:/Pool/deb/ /
    - refresh: True
    - file: /etc/apt/sources.list.d/test_repo_deb_pool.list
    - gpgcheck: 0

{% endif %}
{% endif %}
{% endif %}

# WORKAROUND: see github:saltstack/salt#10852
{{ sls }}_nop:
  test.nop: []
