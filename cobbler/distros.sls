{% for name, distro in salt['pillar.get']('cobbler:distros', {}).items() %}

{%- if distro == None -%}
{%- set distro = {} -%}
{%- endif -%}

{%- set kernel = distro.get('kernel') -%}
{%- set initrd = distro.get('initrd') -%}
{%- set arch = distro.get('arch') -%}
{%- set breed = distro.get('breed') -%}
{%- set osversion = distro.get('osversion') -%}

distros_{{ name }}:
  cmd.run:
    - name: cobbler distro add --name={{ name }} --kernel={{ kernel }} --initrd={{ initrd }} --arch={{ arch }} --breed={{ breed }} --os-version={{ osversion }}
    - unless: cobbler distro report --name={{ name }} 

{% endfor %}
