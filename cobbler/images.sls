{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'images' in cobbler_map and 'manage' in cobbler_map.images and cobbler_map.images.manage == True %}
{% if 'sources' in cobbler_map.images %}
{% for source in cobbler_map.images.sources %}
images-from-{{ source }}:
  file.recurse:
    - source: {{ source }}
    - name: {{ cobbler_map.settings.webdir }}/ks_mirror/
{% endfor %}
{% endif %}
{% endif %}
