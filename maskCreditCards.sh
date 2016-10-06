#this is a rudimentary way to mask credit card numbers. pass the filename as the parameter
sed -i 's/[0-9]\{12\}\([0-9]\{3\}\)/************\1/g' $1 
