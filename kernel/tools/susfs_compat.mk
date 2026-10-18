# susfs selinux_hide feature
# old susfs won't have this manual hook
# and nongki 4.14- can't use simonpunk's hook for that
# check it, when there doesn't have, fallback to auto hook
ifeq ($(shell grep -q "ksu_selinux_hide_running" $(srctree)/security/selinux/hooks.c; echo $$?),0)
$(info -- $(REPO_NAME)/susfs_feature_check: selinux_hide manual hook found)
ccflags-y += -DKSU_COMPAT_HAS_SUSFS_FEATURE_SELINUX_HIDE
endif

# susfs's dev branch currently using post_execve_hook
# but in other branch, it still direcctly call ksu_install_su_fd
# to avoid install su fd repeatedly
ifeq ($(shell grep -q "ksu_install_su_fd" $(srctree)/fs/exec.c; echo $$?),0)
$(info -- $(REPO_NAME)/compat: ksu_install_su_fd direct call found)
ccflags-y += -DKSU_COMPAT_HAS_SUSFS_INSTALL_SU_FD_DIRECT_CALL
endif

# NOTE (Inventor365): BakaSU's upstream $(error "Please wait susfs update.")
# build block is lifted here. This tree syncs susfs to the latest
# simonpunk gki-android14-6.1, which is the sync BakaSU was waiting on, so
# the hard stop no longer applies. The compat probes above still emit the
# correct -DKSU_COMPAT_* flags for whichever susfs hook style is present.
$(info -- $(REPO_NAME): susfs synced to latest simonpunk gki-android14-6.1; build block lifted)