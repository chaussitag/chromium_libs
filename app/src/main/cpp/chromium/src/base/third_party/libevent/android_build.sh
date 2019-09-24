cmake_cmd=/home/dagger/tools/android/sdk/cmake/3.6.4111459/bin/cmake
#cmake_cmd=cmake

#ndk_root=/home/dagger/tech/code/chromium/src/third_party/android_ndk
ndk_root=/home/dagger/tools/android/sdk/ndk-bundle
#ndk_root=/home/dagger/tools/android/ndk/android-ndk-r16b
#ndk_root=/home/dagger/tools/android/ndk/android-ndk-r17b

prj_dir=$(pwd)
build_dir=${prj_dir}/android_build

if [ -d "${build_dir}" ]; then
  rm -fr ${build_dir}
fi

${cmake_cmd} -H${prj_dir} -B${build_dir} \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-21 \
  -DCMAKE_BUILD_TYPE=Release \
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
