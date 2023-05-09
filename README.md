# This is outdated, update to the latest protobuf version and this should be resolved. Version `3.19.3` onwards seems to have the fix.

## firestore and inappmessaging protobuf dependecy with protobuf-java artifacts

This repo is in response to issues encountered when transitioning to firebase firestore and inappmessaging. 
These firebase projects rely on protobuf-lite which causes issues for protobuf-java (protobuf-javalite) dependent projects.

Here are some issues reported in the community related to this workaround:

- [Git 7094](https://github.com/protocolbuffers/protobuf/issues/7094)
- [Git 1889](https://github.com/protocolbuffers/protobuf/issues/1889)
- [Git 5608](https://github.com/googleapis/google-cloud-java/issues/5608)
- [Git 25](https://github.com/googleapis/java-dialogflow/issues/25)


### Getting started
Clone this project:

```
git clone https://github.com/kamalh16/protobuf-javalite-firebase-wellknowntypes.git
```

** If you have special version requirements, edit the pom.xml file to reflect the artifact versions you require. **

### Create the fatjar
Run the bash script

```
cd protobuf-javalite-firebase-wellknowntypes/
./run.sh
```

The expected output should look like this:
```
mvn dependencies downloaded OK
extracted/ created
extracted/ found
protobuf-javalite extracted OK 
proto-google-common-protos extracted OK 
protolite-well-known-types extracted OK 
classes extracted OK 
anura-protobuf-javalite-firebase-wellknowntypes.jar created OK 
```

anura-protobuf-javalite-firebase-wellknowntypes.jar can be found in output dir.


If successful fatjar will be in output directory.

### Import the fatjar into android studio

1. Copy the fatjar into your Android studio project lib directory. 
2. Update the app build.gradle dependencies:

Remove other dependencies:
```
configurations {
    compile.exclude group: 'com.google.protobuf', module: 'protobuf-lite'
    compile.exclude group: 'com.google.firebase', module: 'protolite-well-known-types'
    compile.exclude group: 'com.google.protobuf' , module: 'protobuf-java-util'
    compile.exclude group: 'com.google.protobuf' , module: 'protobuf-java'
    compile.exclude group: 'com.google.protobuf' , module: 'protobuf-javalite'
 }
```

Add the fatjar artifact in dependencies using either of the following lines, if you have both then the .jar file will be included twice and cause a conflict error.
```
dependencies {
  implementation fileTree(dir: 'libs', include: ['*.jar'])
}
```
OR:
```
dependencies {
  implementation files('libs/anura-protobuf-javalite-firebase-wellknowntypes.jar')
}
```

3. Recompile.

