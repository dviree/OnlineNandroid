# Magisk / KernelSU / APatch module installer for Online Nandroid
ui_print "- Installing onandroid to /system/bin"
set_perm $MODPATH/system/bin/onandroid 0 0 0755
ui_print "- Done. Run: su -c onandroid --help"
