{% from "cobbler/map.jinja" import cobbler_map with context %}

{% for selinux_bool in cobbler_map.web.selinux %}
cobbler-{{ selinux_bool }}:
  selinux.boolean:
    - name: {{ selinux_bool }}
    - value: True
    - persist: True
{% endfor %}

cobbler-web:
  pkg.installed:
    - name: cobbler-web
    - refresh: True
    - require:
{% for selinux_bool in cobbler_map.web.selinux %}
      - selinux: cobbler-{{ selinux_bool }}
{% endfor%}

/var/lib/cobbler/webui_sessions:
  file.directory:
    - user: apache
    - require:
      - pkg: cobbler-web
