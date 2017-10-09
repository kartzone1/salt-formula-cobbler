{% from "cobbler/map.jinja" import cobbler_map with context %}

{% if 'reposync' in cobbler_map %}
{% if 'sync_all' in cobbler_map.reposync and cobbler_map.reposync.sync_all == True %}
cobbler-reposync:
  cmd.run:
    - name: cobbler reposync {{ cobbler_map.reposync.options }}
{% else %}
{% if 'sync_only' in cobbler_map.reposync %}
{% for repo_name in cobbler_map.reposync.sync_only %}
cobbler-reposync-{{ repo_name }}:
  cmd.run:
    - name: cobbler reposysnc --only={{ repo_name }} {{ cobbler_map.reposync.options }}
{% endfor %}
{% endif %}
{% endif %}
{% endif %}
