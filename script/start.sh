cd ~geoquest
cd eXist/bin/
nohup ./startup.sh &
echo $! > ~/exist_pid.txt

cd ~geoquest
cd rails/GeoQuest-Editor/current/
nohup rails server -d
echo $! > ~/editor_pid.txt