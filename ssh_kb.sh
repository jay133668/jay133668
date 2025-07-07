sshd -T |  egrep -i "ciphers|macs|kexalgorithm"
ssh -vvv id@ip >&1 |  egrep -i "ciphers|macs|algorithm"
#測試 指定KexAlgorithms 連接：
ssh -oKexAlgorithms=diffie-hellman-group-exchange-sha1 id@ip 

ssh -vvv `w | awk '{print $1}' | sed -n 3p`@`hostname -i` 2>&1 | egrep -i "algorithms|macs|ciphers"

ssh -vvv `w | awk '{print $1}' | sed -n 3p`@`hostname -I | awk '{print $1}'` 2>&1 | egrep -i "algorithms|macs|ciphers"

mf=/etc/ssl/openssl.cnf
export 'OPENSSL_CIPHER_SUITE="HIGH:!aNULL:!eNULL:!SSLv2:!SSLv3:!TLSv1"'
[ -f $mf ] && cp -p $mf $mf-bk ||  echo -e 'CipherString = HIGH:!aNULL:!eNULL:!SSLv2:!SSLv3:!TLSv1' | tee -a /etc/ssl/openssl.cnf
############################################################################

sudo update-crypto-policies --show
sudo update-crypto-policies --set DEFAULT
openssl ciphers -v | egrep  "TLSv1$|SSLv3"
openssl ciphers -v | egrep  -v "TLSv1.2|TLSv1.3"
############################################################################

#disable 弱算法:
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config`date +%F`
ll /etc/ssh/sshd_config*
echo "ciphers aes128-ctr,aes192-ctr,aes256-ctr,rijndael-cbc@lysator.liu.se,aes128-gcm@openssh.com,aes256-gcm@openssh.com
kexalgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com" | tee -a /etc/ssh/sshd_config

egrep -ri "exchange-sha1|-cbc|-etm@openssh.com|poly1305" /usr/share/crypto-policies/DEFAULT/

cp -pr /usr/share/crypto-policies/DEFAULT /usr/share/crypto-policies/DEFAULT`date +%F`
echo "Ciphers aes256-gcm@openssh.com,aes256-ctr,aes128-gcm@openssh.com,aes128-ctr
MACs hmac-sha2-256,umac-128@openssh.com,hmac-sha2-512
GSSAPIKexAlgorithms gss-curve25519-sha256-,gss-nistp256-sha256-,gss-group14-sha256-,gss-group16-sha512-
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512
PubkeyAcceptedKeyTypes ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa,ssh-rsa-cert-v01@openssh.com
CASignatureAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-256,rsa-sha2-512,ssh-rsa" | tee /usr/share/crypto-policies/DEFAULT/openssh.txt > /dev/null

echo "Ciphers aes256-gcm@openssh.com,aes256-ctr,aes128-gcm@openssh.com,aes128-ctr
MACs hmac-sha2-256,hmac-sha1,hmac-sha2-512
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512
HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa,ssh-rsa-cert-v01@openssh.com
PubkeyAcceptedKeyTypes ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa,ssh-rsa-cert-v01@openssh.com" | tee /usr/share/crypto-policies/DEFAULT/libssh.txt > /dev/null

echo "CRYPTO_POLICY='-oCiphers=aes256-gcm@openssh.com,aes256-ctr,aes128-gcm@openssh.com,aes128-ctr -oMACs=hmac-sha2-256,hmac-sha1,umac-128@openssh.com,hmac-sha2-512 -oGSSAPIKexAlgorithms=gss-curve25519-sha256-,gss-nistp256-sha256-,gss-group14-sha256-,gss-group16-sha512- -oKexAlgorithms=curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512 -oHostKeyAlgorithms=ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa,ssh-rsa-cert-v01@openssh.com -oPubkeyAcceptedKeyTypes=ecdsa-sha2-nistp256,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,ssh-rsa,ssh-rsa-cert-v01@openssh.com -oCASignatureAlgorithms=ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-256,rsa-sha2-512,ssh-rsa'" | tee /usr/share/crypto-policies/DEFAULT/opensshserver.txt > /dev/null
systemctl restart sshd
