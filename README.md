# Toddle Toddle

## build

### build hive model 
`flutter packages pub run build_runner build  --delete-conflicting-outputs`

### build app icon
`flutter pub run flutter_launcher_icons:main`

### create splash image
`flutter pub run flutter_native_splash:create`

### android build
use key.properties, key.jks
`flutter build appbundle`
check `./build/app/outputs/bundle/release/app-release.aab``