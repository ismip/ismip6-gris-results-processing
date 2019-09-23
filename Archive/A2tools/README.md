# ismip6-gris-results-processing

## This Archive is storing the download in orginal resolution from the models
The difference to the ftp is that we try to fix incorrect res suffix naming 
(see option 'flg_strip') and remap names to common experiment names

### Download files into local Archive
./download_rec.sh

### Remap experiment directory names to common standard
./name_remapping.sh

### Check experiment directory names
./name_checking.sh

