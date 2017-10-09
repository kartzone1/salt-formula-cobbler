{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if grains['os_family'] == 'Debian' %}
cobbler-repo:
  pkgrepo.managed:
    - humanname: Cobbler Repo
    {% if grains['os'] == 'Ubuntu' %}
    - name: "deb http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/x{{ grains['os'] }}_{{ grains['osrelease'] }} ./"
    {% else %}
    - name: "deb http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/{{ grains['os'] }}_{{ grains['osrelease'] }} ./"
    {% endif %}
    - dist: ./
    - file: /etc/apt/sources.list.d/cobbler.list
    - key_url: salt://cobbler/files/Release.key
    - require_in:
      - pkg: cobbler
{% else %}
{# Fedora/RHEL/CentOS/SLE/ScientificLinux/openSUSE #}
cobbler-repo-key:
  file.managed:
    - name: /etc/pki/rpm-gpg/libertas-ict.pub
    - source: salt://cobbler/files/libertas-ict.pub
    - user: root
    - group: root
    - mode: 0644

rpm --import /etc/pki/rpm-gpg/libertas-ict.pub:
  cmd.run:
    - onchanges:
      - file: cobbler-repo-key

cobbler-repo:
  pkgrepo.managed:
    - name: cobbler
    - humanname: cobbler
    - baseurl: http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/{{ grains['os'] }}_{{ grains['osmajorrelease'] }}/
    - gpgcheck: 1
    - key_url: file:///etc/pki/rpm-gpg/libertas-ict.pub
    - require:
      - file: cobbler-repo-key
{% endif %}

cobbler-deps:
  pkg.installed:
    - pkgs: {{ cobbler_map.lookup['pkgs']|json }}
    - require:
      - pkgrepo: cobbler-repo

cobbler:
  pkg.installed:
    - refresh: True
    - require:
      - pkg: cobbler-deps
      - pkgrepo: cobbler-repo
