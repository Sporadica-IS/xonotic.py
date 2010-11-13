#!/bin/sh

set -e

echo "The Big Benchmark"
echo " ================="
echo
echo "WARNING: running this script will destroy ANY local changes you"
echo "might have on the repository."
echo
echo "Are you absolutely sure you want to run this?"
echo
while :; do
	echo -n "y/n: "
	read -r yesno
	case "$yesno" in
		y)
			break
			;;
		n)
			echo "Aborted."
			exit 1
			;;
	esac
done

set -x
rm -f data/benchmark.log
./all clean --reclone
./all compile -r
./all run -nohome -benchmarkruns 3 -benchmark demos/the-big-keybench.dem +//div0-stable
./all clean -r -f
(
	cd darkplaces
	git checkout master || git checkout -t origin/master || exit 1
)
./all compile -r
./all run -nohome -benchmarkruns 3 -benchmark demos/the-big-keybench.dem +//master
./all clean -r -f -u
set +x

echo
echo "Please provide the the following info to the Xonotic developers:"
echo " - CPU speed"
echo " - memory size"
echo " - graphics card (which vendor, which model)"
echo " - operating system (including whether it is 32bit or 64bit)"
echo " - graphics driver version"
echo " - the following info:"
cat data/benchmark.log
echo
echo "Thank you"