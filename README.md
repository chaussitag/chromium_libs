# what's this
some great libraries such as libbase,  porting from the chromium opensource project.
the chromium code base comes from release tag 38.0.2125.114 of the chromium project.

# build
the latest(2018-12-06) ndk-bundle bundled with android studio(3.2.1) doesn't support gcc,
but the ported chromium code needs gcc to build,
so plz change the ndk used by android studio to some standalone ndk(ndk-r15c is verified).
