set -e
#export PATH="/remote/miniconda/bin:$PATH"
#export PATH="/remote/conda-lsst/bin:$PATH"
#source eups-setups.sh
#mkdir remote
cd remote
#conda config --set always_yes yes --set changeps1 no
#conda config --add channels http://eupsforge.net/conda/dev
#conda install -q lsst-sims-maf
#conda clean -y -t -p -s > /dev/null 2>&1
#conda remove -q -y lsst-sims-sed-library > /dev/null 2>&1
#conda remove -q -y lsst-sims-dustmaps > /dev/null 2>&1
#wget https://raw.githubusercontent.com/marcusbooyah/sims_maf_contrib/master/sims-maf.sh
rm -rf sims_maf_contrib
git clone git@github.com:marcusbooyah/sims_maf_contrib.git
cd sims_maf_contrib
setup sims_maf
cd tutorials
echo done.
echo
echo "Downloading necessary files."
wget -nc -q http://www.astro.washington.edu/users/lynnej/opsim/ops2_1114_sqlite.db
#http://ops2.tuc.noao.edu/runs/ops2_1114/data/ops2_1114_sqlite.db
if [[ ! -f enigma_1189_sqlite.db ]] 2>"f.out"; then
	wget -q -O - http://www.astro.washington.edu/users/lynnej/opsim/enigma_1189_sqlite.db.gz | gunzip -c > enigma_1189_sqlite.db
fi 
echo done.
echo
ERROR=0
if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then
	git diff --name-only $TRAVIS_BRANCH HEAD > changes.out
	cat changes.out | grep -o 'tutorials/.*\.ipynb$' | cut -f2- -d'/' > notebooks.out
	echo The following IPython notebooks will be tested:
	cat notebooks.out
	echo
	while read line
		do
			echo "Processing $line"
                	if runipy "$line" "tested-$line" 2>"$line.out"; then
                       		echo "$line" passed.
				echo
                	else
                    		echo "$line" failed.
                        	ERROR=1
				echo
                	fi
		done < notebooks.out
	exit $ERROR
else
	for f in *.ipynb; do
		echo "Processing $f"
		if [[ "$f" == SDSSSlicer.ipynb ]]; then
			continue
		fi
		if [[ "$f" == MAFCameraGeom.ipynb ]]; then
          	continue
       		fi
		if runipy "$f" "tested-$f" 2>"$f.out"; then
			echo "$f" passed.
			echo
		else
			echo "$f" failed.
			ERROR=1
			echo
		fi
	done
fi
exit $ERROR
