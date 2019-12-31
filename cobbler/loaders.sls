{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'pxe' in cobbler_map and 'manage' in cobbler_map.loaders and cobbler_map.loaders.manage == True %}

{% if cobbler_map.loaders.sync == True %}
cobbler get-loaders:
  cmd.run
{% endif %}

{% if 'sources' in cobbler_map.loaders %}
{% for source in cobbler_map.loaders.sources %}
loaders-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.lookup.lib_dir }}/loaders/
{% endfor %}
{% endif %}

{% endif %}
