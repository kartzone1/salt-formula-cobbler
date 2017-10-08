epel7:
  cmd.run:
    - name: cobbler repo add --name=epel7 --breed=yum --mirror=http://ftp.heanet.ie/pub/fedora/epel/7/x86_64 --mirror-locally=false
    - creates: /var/lib/cobbler/config/repos.d/epel7.json
  require:
    - service: cobblerd
