#!/bin/bash
cd "$(dirname "$0")"/..

if [ ! -d ../cryptstorage/specs ]; then
    echo "ERROR! OpenAPI specification(s) not found! Make sure that backend and this project are placed as:"
    echo "|-- root"
    echo "|   |-- cryptstorage"
    echo "|   |-- cryptstorage_app"
    return 1
fi

echo "Removing old generated API files ... "
rm -r lib/generated 2> /dev/null

echo "Copying specification to temporary folder ... "
cp -R ../cryptstorage/specs lib

echo "Generating API files ... "
flutter pub run build_runner build --delete-conflicting-outputs

echo "Removing temporary folder ... "
rm -r lib/specs

echo "Done! Generated API files can be found in lib/generated"