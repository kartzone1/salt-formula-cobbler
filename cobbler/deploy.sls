{% from "cobbler/map.jinja" import cobbler_map with context %}

{% for deploy_name, deploy_config in cobbler_map.deploy.items() %}
{{ deploy_name }}:
  cmd.run:
    - name: cobbler repo add --name={{ deploy_config.name }} --breed={{ deploy_config.breed }} --mirror={{ deploy_config.mirror }} --mirror-locally={{ deploy_config.mirror_locally }}
    - creates: /var/lib/cobbler/config/repos.d/{{ deploy_config.name }}.json
  require:
    - service: cobblerd
{% endfor %}
