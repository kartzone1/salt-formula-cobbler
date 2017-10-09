{% from "cobbler/map.jinja" import cobbler_map with context %}

{% for repo_name, repo_config in cobbler_map.deploy.items() %}
{% if 'name' in repo_config %}
{% set repo_name = repo_config.name %}
{% endif %}
{% if 'options' in repo_config %}
cobbler-repo-add-{{ repo_name }}:
  cmd.run:
    - name: cobbler repo add --name={{ repo_name }} {%- for option_name, option_value in repo_config.options.items() %}--{{ option_name }}={{ option_value }} {% endfor %}
    - creates: {{ cobbler_map.lookup.lib_dir }}/config/repos.d/{{ repo_name }}.json
  require:
    - service: cobblerd
{% endif %}
{% endfor %}
