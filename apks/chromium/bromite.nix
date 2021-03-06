{ chromiumBase, fetchFromGitHub, git }:

let
  version = "80.0.3987.118";

  bromite_src = fetchFromGitHub {
    owner = "bromite";
    repo = "bromite";
    rev = version;
    sha256 = "07rz0jraqpqj06lvd23l5dk1dj76xa3620s3z45q24dhr0cif3ks";
  };

in (chromiumBase.override {
  inherit version;
  versionCode = "398711800"; # TODO: Calculate
  customGnFlags = { # From bromite/build/GN_ARGS
    blink_symbol_level=1;
    dcheck_always_on=false;
    debuggable_apks=false;
    dfmify_dev_ui=false;
    disable_android_lint=true;
    disable_autofill_assistant_dfm=true;
    disable_tab_ui_dfm=true;
    enable_av1_decoder=true;
    enable_dav1d_decoder=true;
    enable_feed_in_chrome=false;
    enable_gvr_services=false;
    enable_hangout_services_extension=false;
    enable_iterator_debugging=false;
    enable_mdns=false;
    enable_mse_mpeg2ts_stream_parser=true;
    enable_nacl=false;
    enable_nacl_nonsfi=false;
    enable_remoting=false;
    enable_reporting=false;
    enable_resource_whitelist_generation=false;
    enable_vr=false;
    fieldtrial_testing_like_official_build=true;
    icu_use_data_file=true;
    is_cfi=true;
    is_component_build=false;
    is_debug=false;
    is_official_build=true;
    rtc_build_examples=false;
    safe_browsing_mode=0;
    symbol_level=1;
    use_debug_fission=true;
    use_errorprone_java_compiler=false;
    use_official_google_api_keys=false;
    use_openh264=true;
    chrome_pgo_phase=0;
    full_wpo_on_official=true;
    use_sysroot=false;

    # XXX: Hack. Not sure why it's not being set correctly
    rtc_use_x11=false;
  };
}).overrideAttrs (attrs: {
  postPatch = ''
    ( cd src
      cat ${bromite_src}/build/bromite_patches_list.txt | while read patchfile; do
        ${git}/bin/git apply --unsafe-paths "${bromite_src}/build/patches/$patchfile"
      done
    )
  '' + attrs.postPatch;
})
