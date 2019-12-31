{% for name, system in salt['pillar.get']('cobbler:systems', {}).items() %}

{%- if system == None -%}
{%- set system = {} -%}
{%- endif -%}

{%- set profile = system.get('profile') -%}
{%- set mac = system.get('mac') -%}
{%- set interface = system.get('interface') -%}
{%- set ksmeta = system.get('ksmeta', '') -%}

systems_{{ name }}:
  cmd.run:
    - name: cobbler system add --name={{ name }} --profile={{ profile }} --mac={{ mac }} --interface={{ interface }} --ksmeta='{{ ksmeta }}'
    - unless: cobbler system report --name={{ name }}

{% endfor %}
