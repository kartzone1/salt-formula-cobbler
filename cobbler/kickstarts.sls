{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'pxe' in cobbler_map and 'manage' in cobbler_map.kickstarts and cobbler_map.kickstarts.manage == True %}
{% if 'sources' in cobbler_map.kickstarts %}
{% for source in cobbler_map.kickstarts.sources %}
kickstarts-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.lookup.lib_dir }}/kickstarts/
{% endfor %}
{% endif %}
{% endif %}
