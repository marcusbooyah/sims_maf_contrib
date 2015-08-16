set -e
ERROR=0
source eups-setups.sh
setup sims_maf
while read line
        do
          	echo "Processing $line"
                if runipy --pylab "./$line" "./$line-tested.ipynb"; then # 2>"./$line.out"; then
                                echo "$line" passed.
                        echo
                else
                        echo "$line" failed.
                        cp ./$line-tested.ipynb ./failed-notebooks
			ERROR=1
                        echo
                fi
        done < notebooks.out
exit $ERROR
