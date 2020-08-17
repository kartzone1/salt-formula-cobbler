{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'pxe' in cobbler_map and 'manage' in cobbler_map.triggers and cobbler_map.triggers.manage == True %}
{% if 'sources' in cobbler_map.triggers %}
{% for source in cobbler_map.triggers.sources %}
triggers-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.lookup.lib_dir }}/triggers/
    - dir_mode: 2775
    - file_mode: '0755'
{% endfor %}
{% endif %}
{% endif %}
