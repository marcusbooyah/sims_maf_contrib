set -x
export PATH="/remote/miniconda/bin:$PATH"
export PATH="/remote/conda-lsst/bin:$PATH"
source eups-setups.sh
#mkdir remote
cd remote
# keep the pkginfo cache database outside the conda-lsst dir
# so Travis can cache it easily.
mkdir -p pkginfo-cache

#
# Install Miniconda
#

if [[ ! -f "$PWD/miniconda/.installed" ]] 2>"f.out"; then
        case "$OSTYPE" in
                linux*)  MINICONDA_SH=Miniconda-latest-Linux-x86_64.sh ;;
                darwin*) MINICONDA_SH=Miniconda-latest-MacOSX-x86_64.sh ;;
                *)	 echo "Unsupported OS $OSTYPE. Exiting."; exit -1 ;;
        esac

	rm -f "$MINICONDA_SH"
        rm -rf "$PWD/miniconda"
        curl -O https://repo.continuum.io/miniconda/"$MINICONDA_SH"
        bash "$MINICONDA_SH" -b -p "$PWD/miniconda"
        rm -f "$MINICONDA_SH"

        #
	# Install prerequisites
        #
	export PATH="$PWD/miniconda/bin:$PATH"
        conda install -q conda-build jinja2 binstar requests sqlalchemy pip --yes > /dev/null 2>&1

        pip install requests_file > /dev/null 2>&1

        # marker that we're done
        touch "$PWD/miniconda/.installed"
else
    	echo
	echo "Found Miniconda in $PWD/miniconda; skipping Miniconda install."
        echo
fi

hash -r
conda config --set always_yes yes --set changeps1 no
conda config --add channels http://eupsforge.net/conda/dev
conda install -q lsst-sims-maf
conda clean -y -t -p -s > /dev/null 2>&1
conda remove -q -y lsst-sims-sed-library > /dev/null 2>&1
conda remove -q -y lsst-sims-dustmaps > /dev/null 2>&1
wget https://raw.githubusercontent.com/marcusbooyah/sims_maf_contrib/master/sims-maf.sh
cd demos
cd sims_maf_contrib
git pull
bash sims-maf.sh
