#!/bin/bash

###Test Variables###
HOSTS=( sequoia picea ) 
LDAPSSLPORT="636"
LDAPPORT="389"
DNSPORT="53"
KRB5PORT="88"
 
######Do not make modifications below######
### Binaries ###
SENDEMAIL=/usr/local/bin/sendEmail
ADMIN_EMAIL=( email@tld.com pwlit@pwlpartnership.com )
HOSTNAME=`hostname`
TELNET=$(which telnet)

### TESTS ###
for i in "${HOSTS[@]}"; {
#LDAPS
(
echo "quit"
) | $TELNET $i $LDAPSSLPORT | grep Connected > /dev/null 2>&1
if [ "$?" -ne "1" ]; then #Ok
  echo "PORT CONNECTED"
else #Connection failure
	for j in "${ADMIN_EMAIL[@]}"; {
  	$SENDEMAIL -f "email@tld.com" -t $j -u Cannot connect to port $LDAPSSLPORT on $i -s smtp.gmail.com:587 -xu email@tld.com -xp "" -m "SSL LDAP port check failed"
}
	logger -t SSL LDAP Port Check -p local0.emerg "SSL LDAP port check failed"
fi
#LDAP
(
echo "quit"
) | $TELNET $i $LDAPPORT | grep Connected > /dev/null 2>&1
if [ "$?" -ne "1" ]; then #Ok
  echo "PORT CONNECTED"
else #Connection failure
	for j in "${ADMIN_EMAIL[@]}"; {
  	$SENDEMAIL -f "email@tld.com" -t $j -u Cannot connect to port $LDAPPORT on $i -s smtp.gmail.com:587 -xu email@tld.com -xp "" -m "LDAP port check failed"
}
	logger -t LDAP Port Check -p local0.emerg "LDAP port check failed"
fi
#DNS
(
echo "quit"
) | $TELNET $i $DNSPORT | grep Connected > /dev/null 2>&1
if [ "$?" -ne "1" ]; then #Ok
  echo "PORT CONNECTED"
else #Connection failure
		for j in "${ADMIN_EMAIL[@]}"; {
  	$SENDEMAIL -f "email@tld.com" -t $j -u Cannot connect to port $DNSPORT on $i -s smtp.gmail.com:587 -xu email@tld.com -xp "" -m "DNS port check failed"
}
	logger -t DNS Port Check -p local0.emerg "DNS port check failed"
fi
#KRB5
(
echo "quit"
) | $TELNET $i $KRB5PORT | grep Connected > /dev/null 2>&1
if [ "$?" -ne "1" ]; then #Ok
  echo "PORT CONNECTED"
else #Connection failure
		for j in "${ADMIN_EMAIL[@]}"; {
  	$SENDEMAIL -f "email@tld.com" -t $j -u Cannot connect to port $KRB5PORT on $i -s smtp.gmail.com:587 -xu email@tld.com -xp "" -m "Kerberos port check failed"
}
	logger -t Kerberos Port Check -p local0.emerg "Kerberos port check failed"
fi
}

