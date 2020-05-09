#android_sdk_home=/home/dagger/tools/android/sdk
android_sdk_home=/home/daiguozhou/tools/android/sdk

android_sdk_cmake_version="3.10.2.4988404"
#android_sdk_cmake_version="3.6.4111459"
cmake_cmd=${android_sdk_home}/cmake/${android_sdk_cmake_version}/bin/cmake
#cmake_cmd=cmake

if [ ! -f ${cmake_cmd} ]; then
  echo "ERROR: ${cmake_cmd} does not exist"
  exit 1
fi

ndk_root=${android_sdk_home}/ndk-bundle
#ndk_root=/home/dagger/tools/android/ndk/android-ndk-r17b
#ndk_root=/home/dagger/tech/code/chromium/src/third_party/android_ndk

android_abi="arm64-v8a" # armeabi-v7a
android_platform="android-19"
build_type="Release" # Debug

prj_dir=$(pwd)


build_dir=${prj_dir}/android_build/${android_abi}/${build_type}

if [ -d "${build_dir}" ]; then
  rm -fr ${build_dir}
fi

${cmake_cmd} -H${prj_dir} -B${build_dir} \
  -DANDROID_ABI=${android_abi} \
  -DANDROID_PLATFORM=${android_platform} \
  -DCMAKE_BUILD_TYPE=${build_type} \
  -DANDROID_NDK=${ndk_root} \
  -DCMAKE_TOOLCHAIN_FILE=${ndk_root}/build/cmake/android.toolchain.cmake \
  -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
  -DANDROID_ARM_NEON=TRUE \
  -DANDROID_TOOLCHAIN=clang \
  -DANDROID_ARM_MODE=arm \
  -DANDROID_STL=c++_shared

pushd ${build_dir}
make -j8
popd
