; Datos Generales de la ZONA
$TTL    86400

; Record Inicio de la Autoridad de la ZONA
@       IN      SOA     ns1.atol.com. jcpleitez.atol.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;

; Name Servers para el dominio
@       IN      NS      ns1.atol.com.

; Los registros para direcciones
ns1     IN      A       190.87.1.130
www     IN      A       190.87.1.130
www     IN      AAAA    2001::7

