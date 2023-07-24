#!/bin/bash

OPTIONS="3.1 2.9"
select opt in $OPTIONS; do
	if [[ $opt == '3.1' ]]; then
		dart pub global deactivate melos
		dart pub global activate melos 3.1.0
	else
		dart pub global deactivate melos
		dart pub global activate melos 2.9.0
	fi
done
