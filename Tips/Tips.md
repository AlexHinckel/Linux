# File Descriptor

>1 STDOUT - SAIDA EM TELA
>2 STDERR - Erros / gerado na tela
>0 STDIN  - 

# Curl

curl -so /dev/null https://xxx.xxx.xxx.xxx -w '%{size_download}'
20003

curl -so /dev/null https://xxx.xxx.xxx.xxx -w '%{size_header}'
418

# Filtrar IP de origem ordenando por mais acessos...
cat access.log | awk '{print $1}' | sort -n | uniq -c | sort -nr >> IP_LIST.txt


# egrep
egrep -v "nologin|false" passwd

# awk
awk -F : '{print $1}' passwd

# cut
cut -d : f1 passwd
