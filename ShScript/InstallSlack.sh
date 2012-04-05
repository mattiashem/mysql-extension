#
# Install all mysql functions on a slackware computer.
#

# Compile
#gcc -Wall -fPIC -I /usr/src/packages/BUILD/mysql-4.1.20/include/  -shared -lstdc++ -o ../Bin/FoFunctions.so ../FoFunctions.cpp 
#gcc -Wall -fPIC -I /usr/src/packages/BUILD/mysql-4.1.20/include/  -shared -lstdc++ -o ../Bin/FoLanguage.so  ../FoLanguage.cpp 

gcc  -Wall -I /usr/local/mysql/include -shared -lstdc++ -o ../Bin/FoFunctions.so ../FoFunctions.cpp
gcc  -Wall -I /usr/local/mysql/include -shared -lstdc++ -o ../Bin/FoLanguage.so  ../FoLanguage.cpp


sudo mysql.sh stop
cp ../Bin/FoFunctions.so /usr/lib/FoFunctions.so
cp ../Bin/FoLanguage.so  /usr/lib/FoLanguage.so
sudo mysql.sh start

mysql -uroot -p < ../Sql/InstallFoFunctions.sql
mysql -uroot -p < ../Sql/InstallFoLanguage.sql
echo "Finished"
