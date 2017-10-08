{% from "cobbler/map.jinja" import cobbler_map with context %}

cobbler-deps:
  pkg.installed:
    - pkgs: {{ cobbler_map['pkgs']|json }}

{% for selinux_bool in cobbler_map.selinux.cobbler %}
cobbler-{{ selinux_bool }}:
  selinux.boolean:
    - name: {{ selinux_bool }}
    - value: True
    - persist: True
{% endfor %}

cobbler:
  pkg.installed:
    - refresh: True
  service.running:
    - name: cobblerd
    - enable: True
    - require:
{% for selinux_bool in cobbler_map.selinux.cobbler %}
      - selinux: cobbler-{{ selinux_bool }}
{% endfor%}

{% if grains['os'] == 'Ubuntu' %}
/tftpboot:
{% else %}
/var/lib/tftpboot:
{% endif %}
  file.directory

{% if grains['os'] == 'Ubuntu' %}
{% if grains['osrelease_info'][0] <= 12  %}
/usr/share/cobbler/web/cobbler_web/urls.py:
  file.replace:
    - pattern: "from django.conf.urls import patterns"
    - repl: "from django.conf.urls.defaults import *"
{% endif %}
{% endif %}
{% from "cobbler/map.jinja" import cobbler_map with context %}

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
  require:
    - pkg: cobbler

kickstarts:
  file.recurse:
    - source: salt://cobbler/files/kickstarts/
    - name: /var/lib/cobbler/kickstarts/

snippets:
  file.recurse:
    - source: salt://cobbler/files/snippets/
    - name: /var/lib/cobbler/snippets/
