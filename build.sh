#!/bin/bash
## NOTEs:
### This simple build process is useful so the created date/time field only change for the new and updated charts (and remains the same for the old ones)
### We also will build only the package with new git TAGs

HELMREPO_DIR="./docs"
helm_package() {
    local chart_path=$1
    echo "Chart $chart_path: Packaging chart"
    helm package -u -d build/ "$chart_path"
}

git_tag() {
    local chart_path=$1
    local chart_name=$(helm show chart "$chart_path" | grep "^name:" | awk -F ': ' '{ print $2 }');
    local chart_version=$(helm show chart "$chart_path" | grep "^version:" | awk -F ': ' '{ print $2 }');
    echo "Chart $chart_path: Creating Git-Tag: $chart_name-$chart_version"
    git tag "$chart_name-$chart_version"
}

build() {
    local chart_path=$1
    git_tag "$chart_path"
    if [ $? -eq 0 ]; then
        helm_package "$chart_path"
    fi
}

## create build dir
mkdir -p build/

build "src/webmethods-apigateway"
build "src/webmethods-api-control-plane"
build "src/webmethods-devportal"
build "src/webmethods-microgateway"
build "src/webmethods-terracotta"
build "src/webmethods-microservicesruntime"
build "src/samplejavaapis-sidecar-microgateway"
build "src/webmethods-dbconfigurator"
build "src/webmethods-mws"

## check if anything was added to the build folder, and index if yes
built_packages=$(ls build/*.tgz)
if [ $? -eq 0 ]; then
    echo "Packages found in build folder...will update the helm repo index now!!"

    ## create new index with only the new modified charts
    helm repo index --merge ${HELMREPO_DIR}/index.yaml build/

    ## copy new index ot the final repo location
    echo "Copying new index and updated packages to the final repo location"
    cp -f build/index.yaml ${HELMREPO_DIR}/
    cp -f build/*.tgz ${HELMREPO_DIR}/
else
    echo "No package was build in the build folder...nothing to change"
fi

## clean up
rm -Rf build/
echo "Done!!"