if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then
  echo "This is a pull request, only changed files will be tested."
	git diff --name-only $TRAVIS_BRANCH HEAD > changes.out
	cat changes.out | grep -o 'tutorials/.*\.ipynb$' | cut -f2- -d'./' > notebooks.out
else
  echo "This is not a pull request, all files will be tested."
  find -name '*.ipynb' > notebooks.out
fi
