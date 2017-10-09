{% from "cobbler/map.jinja" import cobbler_map with context %}

include:
  - cobbler.install

{% for selinux_bool in cobbler_map.selinux %}
cobbler-{{ selinux_bool }}:
  selinux.boolean:
    - name: {{ selinux_bool }}
    - value: True
    - persist: True
{% endfor %}

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
    - name: {{ cobbler_map.lookup.etc_dir }}/settings
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
    - name: {{ cobbler_map.lookup.etc_dir }}/modules.conf
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
    - name: {{ cobbler_map.lookup.etc_dir }}/users.conf
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
    - name: {{ cobbler_map.lookup.etc_dir }}/auth.conf
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
    - name: {{ cobbler_map.lookup.etc_dir }}/mongodb.conf
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

{% if cobbler_map.dnsmasq.manage == True %}
cobbler-dnsmasq-config:
  file.managed:
    - source: {{ cobbler_map.dnsmasq.template }}
    - name: {{ cobbler_map.lookup.etc_dir }}/dnsmasq.template
    - template: jinja
    - context:
      dnsmasq_settings: {{ cobbler_map.dnsmasq.settings }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.dhcp.manage == True %}
cobbler-dhcp-config:
  file.managed:
    - source: {{ cobbler_map.dhcp.template }}
    - name: {{ cobbler_map.lookup.etc_dir }}/dhcp.template
    - template: jinja
    - context:
      dhcpd_settings: {{ cobbler_map.dhcp.settings }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.named.manage == True %}
cobbler-named-config:
  file.managed:
    - source: {{ cobbler_map.named.template }}
    - name: {{ cobbler_map.lookup.etc_dir }}/named.template
    - template: jinja
    - context:
      named_settings: {{ cobbler_map.named.settings }}
    - user: root
    - group: root
    - mode: 0644
  require:
    - pkg: cobbler
{% endif %}

{% if cobbler_map.tftpd.manage == True %}
{{ cobbler_map.lookup.tftpboot }}:
  file.directory

{% if cobbler_map.tftpd.use_xinetd == True }
cobbler-tftpd-config:
  file.managed:
    - source: {{ cobbler_map.tftpd.template }}
    - name: {{ cobbler_map.lookup.etc_dir }}/tftpd.template
    - context:
      tftpd_settings: {{ cobbler_map.tftpd.settings }}
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: cobbler
      - file: {{ cobbler_map.lookup.tftpboot }}

cobbler-tftpd-service:
  service.running:
    - name: xinetd
    - enable: True
{% endif %}

{% if cobbler_map.tftpd.use_systemctl_service == True }
cobbler-tftpd-service:
  service.running:
    - name: tftp
    - enable: True
{% endif %}
{% endif %}

{% if cobbler_map.settings != {} %}
cobbler sync:
  cmd.run:
    - onchanges:
      - file: cobbler-settings-config
{% if cobbler_map.modules != {} %}
      - file: cobbler-modules-config
{% endif %}
{% if cobbler_map.users != {} %}
      - file: cobbler-users-config
{% endif %}
{% if cobbler_map.auth != {} %}
      - file: cobbler-auth-config
{% endif %}
{% if cobbler_map.mongodb != {} %}
      - file: cobbler-mongodb-config
{% endif %}
{% if cobbler_map.templates.dnsmasq == True %}
      - file: cobbler-dnsmasq-config
{% endif %}
{% if cobbler_map.templates.dhcp == True %}
      - file: cobbler-dhcp-config
{% endif %}
{% if cobbler_map.templates.named == True %}
      - file: cobbler-named-config
{% endif %}
{% if cobbler_map.templates.tftpd == True %}
      - file: cobbler-tftpd-config
{% endif %}
{% endif %}
