{% from "cobbler/map.jinja" import cobbler_map with context %}

cobbler-deps:
  pkg.installed:
    - pkgs: {{ cobbler_map.lookup['pkgs']|json }}

{% for selinux_bool in cobbler_map.selinux %}
cobbler-{{ selinux_bool }}:
  selinux.boolean:
    - name: {{ selinux_bool }}
    - value: True
    - persist: True
{% endfor %}

cobbler:
  pkg.installed:
    - refresh: True
    - require:
      - pkg: cobbler-deps

service-cobbler:
  service.running:
    - name: cobblerd
    - enable: True
    - require:
      - pkg: cobbler-deps
{% for selinux_bool in cobbler_map.selinux %}
      - selinux: cobbler-{{ selinux_bool }}
{% endfor%}

{% if cobbler_map.settings != {} %}
cobbler-settings-config:
  file.managed:
    - name: /etc/cobbler/settings
    - source: salt://cobbler/files/settings
    - template: jinja
    - context:
      cobbler_settings: {{ cobbler_map.settings }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.modules != {} %}
cobbler-modules-config:
  file.managed:
    - name: /etc/cobbler/modules.conf
    - source: salt://cobbler/files/modules.conf
    - template: jinja
    - context:
      cobbler_modules: {{ cobbler_map.modules }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.users != {} %}
cobbler-users-config:
  file.managed:
    - name: /etc/cobbler/users.conf
    - source: salt://cobbler/files/users.conf
    - template: jinja
    - context:
      cobbler_users: {{ cobbler_map.users }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.auth != {} %}
cobbler-auth-config:
  file.managed:
    - name: /etc/cobbler/auth.conf
    - source: salt://cobbler/files/auth.conf
    - template: jinja
    - context:
      cobbler_auth: {{ cobbler_map.auth }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.mongodb != {} %}
cobbler-mongodb-config:
  file.managed:
    - name: /etc/cobbler/mongodb.conf
    - source: salt://cobbler/files/mongodb.conf
    - template: jinja
    - context:
      cobbler_mongodb: {{ cobbler_map.mongodb}}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.templates.dnsmasq == True %}
cobbler-dnsmasq-config:
  file.managed:
    - source: salt://cobbler/files/dnsmasq.template
    - name: /etc/cobbler/dnsmasq.template
    - template: jinja
    - context:
      dnsmasq_settings: {{ cobbler_map.dnsmasq }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.templates.dhcp == True %}
cobbler-dhcp-config:
  file.managed:
    - source: salt://cobbler/files/dhcp.template
    - name: /etc/cobbler/dhcp.template
    - template: jinja
    - context:
      dhcpd_settings: {{ cobbler_map.dhcpd }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.templates.named == True %}
cobbler-named-config:
  file.managed:
    - source: salt://cobbler/files/named.template
    - name: /etc/cobbler/named.template
    - template: jinja
    - context:
      named_settings: {{ cobbler_map.named }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{{ cobbler_map.lookup.tftpboot }}:
  file.directory

{% if cobbler_map.templates.tftpd == True %}
cobbler-tftpd-config:
  file.managed:
    - source: salt://cobbler/files/tftpd.template
    - name: /etc/cobbler/tftpd.template
    - context:
      tftpd_settings: {{ cobbler_map.tftpd }}
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: cobbler
      - file: {{ cobbler_map.lookup.tftpboot }}
{% endif %}

kickstarts:
  file.recurse:
    - source: salt://cobbler/files/kickstarts/
    - name: /var/lib/cobbler/kickstarts/

snippets:
  file.recurse:
    - source: salt://cobbler/files/snippets/
    - name: /var/lib/cobbler/snippets/
