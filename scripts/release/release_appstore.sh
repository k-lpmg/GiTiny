export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

sh bump_version.sh

cd ../..
fastlane store
