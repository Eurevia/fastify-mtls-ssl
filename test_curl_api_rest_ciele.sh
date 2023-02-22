# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# le certificat Server a été généré pour qu'il accepte SERVER_ALT_NAME="DNS:regate.local,DNS:localhost,IP:127.0.0.1,IP:192.168.200.1"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 
# > pour faire un test, il est possible de rajouter  dans /etc/hosts l'adresse ip de la regate associée à regate.local
# > 192.168.2.105 regate.local
# > 
#
# doit renvoyer {"root":true}
curl --cacert ./certificates/ca/eureviaCACert.pem \
     --cert ./certificates/client/eureviaClientCert.pem \
     --key ./certificates/client/eureviaClientKey.pem \
     https://regate.local:443/
