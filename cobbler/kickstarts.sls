{% from "cobbler/map.jinja" import cobbler_map with context %}

kickstarts:
  file.recurse:
    - source: salt://cobbler/files/kickstarts/
    - name: {{ cobbler_map.lookup.lib_dir }}/kickstarts/
