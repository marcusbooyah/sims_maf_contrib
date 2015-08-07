set -e
ERROR=0
echo "Installing runipy."
pip install runipy > /dev/null
echo "Done."
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
exit $ERROR
