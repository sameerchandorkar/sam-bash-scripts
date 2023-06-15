for i in `cat site-up`  
do 
echo -n $i >> site-expiry.csv ; echo -e -n '\t' >> site-expiry.csv ; echo -n | openssl s_client -servername $i -connect $i:443 2> /dev/null| openssl x509 -noout -enddate  >>  site-expiry.csv
done
