set -e
echo "Setting up sims_maf environment"
##conda install lsst-sims-maf -y
#pip install runipy > /dev/null
conda config --set always_yes yes --set changeps1 no
conda config --add channels http://eupsforge.net/conda/dev
conda install -q lsst-sims-maf > /dev/null 2>&1
conda clean -y -t -p -s > /dev/null 2>&1
conda remove -y -q lsst-sims-sed-library > /dev/null 2>&1
conda remove -y -q lsst-sims-dustmaps > /dev/null 2>&1
source eups-setups.sh
eups declare -m none -r none sims_sed_library 2014.10.06
eups declare -m none -r none sims_dustmaps 0.10.1
setup sims_maf
echo "Done."
echo "Downloading necessary files."
cd tutorials
wget -nc -q http://www.astro.washington.edu/users/lynnej/opsim/ops2_1114_sqlite.db
#http://ops2.tuc.noao.edu/runs/ops2_1114/data/ops2_1114_sqlite.db
if [[ ! -f enigma_1189_sqlite.db ]] 2>"f.out"; then
	wget -q -O - http://www.astro.washington.edu/users/lynnej/opsim/enigma_1189_sqlite.db.gz | gunzip -c > enigma_1189_sqlite.db
fi
cd ../
echo "Done."

hash -r
