{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'pxe' in cobbler_map and 'manage' in cobbler_map.snippets and cobbler_map.snippets.manage == True %}
{% if 'sources' in cobbler_map.snippets %}
{% for source in cobbler_map.snippets.sources %}
snippets-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.lookup.lib_dir }}/snippets/
{% endfor %}
{% endif %}
{% endif %}
