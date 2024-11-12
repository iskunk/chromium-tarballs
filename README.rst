# Automated Chromium tarballs via CI

This repository uses GitHub CI to automate the process documented below.

Sometimes upstream's CI breaks and it's up to us to create our very own Chromium tarball for a given release.

Required: `export_tarball.py <https://chromium.googlesource.com/chromium/tools/build/+/refs/heads/main/recipes/recipe_modules/chromium/resources/export_tarball.py>`_

While this seems daunting it's not *that* bad.

1. First get a copy of Depot Tools and add it to $PATH.
2. Then create a quick gclient config and modify it to only include the OSes we want (hint: we only want linux, but there are other options)
3. Check out the sources
4. Then run some post-checkout commands
5. touch a file required for tests
6. Grab the appropriate PGO profiles
7. Then generate some tarballs

.. code-block:: bash

    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    export PATH="$(pwd)/depot_tools:${PATH}"

    gclient config --name src https://chromium.googlesource.com/chromium/src.git@130.0.6723.91
    echo "target_os = [ 'linux' ]" >> .gclient
    gclient sync --nohooks --no-history

    src/build/util/lastchange.py -o src/build/util/LASTCHANGE
    src/build/util/lastchange.py -m GPU_LISTS_VERSION --revision-id-only --header src/gpu/config/gpu_lists_version.h
    src/build/util/lastchange.py -m SKIA_COMMIT_HASH -s src/third_party/skia --header src/skia/ext/skia_commit_hash.h
    src/build/util/lastchange.py -s src/third_party/dawn --revision src/gpu/webgpu/DAWN_VERSION

    touch src/chrome/test/data/webui/i18n_process_css_test.html

    src/tools/update_pgo_profiles.py '--target=linux' update '--gs-url-base=chromium-optimization-profiles/pgo_profiles'

    ./export_tarball.py --version --xz --test-data --remove-nonessential-files chromium-130.0.6723.91 --progress --src-dir src/
    mv chromium-130.0.6723.91.tar.xz chromium-130.0.6723.91-testdata.tar.xz
    ./export_tarball.py --version --xz --remove-nonessential-files chromium-130.0.6723.91 --progress --src-dir src/
