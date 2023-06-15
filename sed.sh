dos2unix ansible-inventory
sed 's/^[ \t]*//;s/[ \t]*$//' -i ansible-inventory
sed 's/^"\|"$//g' -i ansible-inventory
sed 's/^]//g' -i ansible-inventory
sed 's/^},//g' -i ansible-inventory
sed 's/^}//g' -i ansible-inventory
sed 's/^hosts\"\: \[//g' -i ansible-inventory 
sed 's/^: {\s*//' -i ansible-inventory
sed 's/^{//' -i ansible-inventory
sed -i '/^$/d' ansible-inventory
sed 's/_meta": {//' -i ansible-inventory
sed 's/hostvars": {}//' -i ansible-inventory
sed 's/1P.6": {//' -i ansible-inventory
sed 's/": {$//' -i ansible-inventory
sed 's/",*$//' -i ansible-inventory
