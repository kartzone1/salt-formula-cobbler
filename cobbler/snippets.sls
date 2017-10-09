{% from "cobbler/map.jinja" import cobbler_map with context %}

snippets:
  file.recurse:
    - source: salt://cobbler/files/snippets/
    - name: {{ cobbler_map.lookup.lib_dir }}/snippets/
