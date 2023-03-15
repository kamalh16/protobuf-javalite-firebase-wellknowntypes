#!/bin/bash

CURRENT=`pwd`
CONTEXT_DIR=`dirname "$0"`
TMPLIB=$CURRENT/tmpdir
EXTRACTED=$CURRENT/extracted
OUTPUT=$CURRENT/output

#echo "The script you are running has basename `basename "$0"` "
#echo "The script you are running has dirname `dirname "$0"` "
#echo "The present working directory is `pwd`"


proc_java(){
	## protobuf-java

	jar xf $TMPLIB/protobuf-java-*jar && echo "protobuf-java extracted OK " || ( echo "protobuf-java extraction failed. Exiting"; exit 1 )
}

proc_javalite(){
	## protobuf-javalite

	jar xf $TMPLIB/protobuf-javalite*jar && echo "protobuf-javalite extracted OK " || ( echo "protobuf-javalite extraction failed. Exiting"; exit 1 )
}

proc_gcommonprotos(){
	## proto-google-common-protos

	jar xf $TMPLIB/proto-google-common-protos*jar && echo "proto-google-common-protos extracted OK " || ( echo "proto-google-common-protos extraction failed. Exiting"; exit 1 )
}

proc_wellknowntypes(){
	## protolite-well-known-types
	## rename file with .aar to .jar
	mv $TMPLIB/protolite-well-known-types*aar $TMPLIB/protolite-well-known-types.jar
  
	jar xf $TMPLIB/protolite-well-known-types.jar && echo "protolite-well-known-types extracted OK " || ( echo "protolite-well-known-types extraction failed. Exiting"; exit 1 )

	## extract classes.jar generated by protolite-well-known-types.jar

	jar xf ./classes.jar && echo "classes extracted OK " || ( echo "classes extraction failed. Exiting"; exit 1 )

	rm ./classes.jar
}


echo 'changing dir to $CONTEXT_DIR'
cd $CONTEXT_DIR

echo 'init temp dir: $TMPLIB'
rm -r $TMPLIB
mkdir -p $TMPLIB  && echo "$TMPLIB created" || echo "$TMPLIB create failed"


echo 'init output dir: $OUTPUT'
rm -r $OUTPUT
mkdir -p $OUTPUT  && echo "$OUTPUT created" || echo "$OUTPUT create failed"

echo 'init output dir: $OUTPUT'
rm -r $EXTRACTED
mkdir -p $EXTRACTED  && echo "$EXTRACTED created" || echo "$EXTRACTED create failed"


##download artifacts to ./lib
mvn dependency:copy-dependencies -DoutputDirectory=$TMPLIB  && echo mvn dependencies downloaded OK || ( echo Failed; exit 1 )


## extract artifact classes into ./extracted
## note: there is a desired sequence of dependencies in order to override some class implementations

cd $EXTRACTED && echo "$EXTRACTED found" || ( echo "$EXTRACTED not found. Exiting" ; exit 1 )


#proc_javalite
#proc_gcommonprotos
#proc_wellknowntypes

#proc_java
proc_javalite
proc_gcommonprotos
proc_wellknowntypes


#proc_gcommonprotos
#proc_wellknowntypes
#proc_javalite


## create the output jar from extracted
jar cf $OUTPUT/anura-protobuf-javalite-firebase-wellknowntypes.jar  * && echo "anura-protobuf-javalite-firebase-wellknowntypes.jar created OK " || ( echo "anura-protobuf-javalite-firebase-wellknowntypes.jar create failed. Exiting"; exit 1 )

ls -l $OUTPUT

