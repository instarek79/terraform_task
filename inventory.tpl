[app_servers]
%{ for instance in private_ips }
${instance.private_ip}
%{ endfor }
