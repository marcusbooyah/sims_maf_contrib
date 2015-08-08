set -e
ERROR=0
source eups-setups.sh
setup sims_maf
echo "Installing runipy."
pip install runipy > /dev/null
echo "Done."
while read line
        do
          	echo "Processing $line"
                if runipy "$line" "$line-tested.ipynb" 2>"$line.out"; then
                                echo "$line" passed.
                        echo
                else
                                echo "$line" failed.
                        ERROR=1
                        echo
                fi
        done < notebooks.out
exit $ERROR

