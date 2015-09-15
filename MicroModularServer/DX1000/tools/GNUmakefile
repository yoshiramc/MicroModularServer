
srcs    := AllCheck.sh PWONALL.sh PWOFFALL.sh ipmiaw2
pkgs    := ipmitool python

prefix  := /usr/local
scripts := $(patsubst %,$(prefix)/bin/%,$(srcs))

auth_dir   := $(HOME)/.atom
auth_srcs  := ipmi_user.txt ipmi_password.txt
auth_files := $(patsubst %,$(auth_dir)/%,$(auth_srcs))

install:
	sudo yum install -y $(pkgs)
	sudo install -o root -m 755 -d $(prefix)/bin
	sudo install -o root -m 755 $(srcs) $(prefix)/bin
	install -m 700 -d $(auth_dir)
	$(foreach file,$(auth_files),echo "Administrator" > $(file);)

distclean:
	@sudo rm -f $(scripts)
	@rm -fr $(auth_dir)
