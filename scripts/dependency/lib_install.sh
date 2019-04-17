cd ../..

export LANG=en_US.UTF-8
pod repo update
pod install

rm -rf ~/Library/Developer/Xcode/DerivedData/*
