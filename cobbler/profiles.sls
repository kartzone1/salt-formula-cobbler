{% for name, profile in salt['pillar.get']('cobbler:profiles', {}).items() %}

{%- if profile == None -%}
{%- set profile = {} -%}
{%- endif -%}

{%- set distro = profile.get('distro') -%}
{%- set kickstart = profile.get('kickstart') -%}

profiles_{{ name }}:
  cmd.run:
    - name: cobbler profile add --name={{ name }} --distro={{ distro }} --kickstart={{ kickstart }}
    - unless: cobbler profile report --name={{ name }}

{% endfor %}
