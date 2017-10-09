{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'pxe' in cobbler_map and 'manage' in cobbler_map.pxe and cobbler_map.pxe.manage == True %}
{% if 'sources' in cobbler_map.pxe %}
{% for source in cobbler_map.pxe.sources %}
snippets-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.lookup.etc_dir }}/pxe/
{% endfor %}
{% endif %}
{% endif %}
