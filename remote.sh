set -x
export PATH="/remote/miniconda/bin:$PATH"
export PATH="/remote/conda-lsst/bin:$PATH"
source eups-setups.sh
#mkdir remote
cd remote

#conda config --set always_yes yes --set changeps1 no
#conda config --add channels http://eupsforge.net/conda/dev
#conda install -q lsst-sims-maf
#conda clean -y -t -p -s > /dev/null 2>&1
#conda remove -q -y lsst-sims-sed-library > /dev/null 2>&1
#conda remove -q -y lsst-sims-dustmaps > /dev/null 2>&1
#wget https://raw.githubusercontent.com/marcusbooyah/sims_maf_contrib/master/sims-maf.sh
cd demos
cd sims_maf_contrib
git pull
bash sims-maf.sh
