rbenv_dir=${HOME}/.rbenv
[ -d ${rbenv_dir} ] || git clone git://github.com/sstephenson/rbenv.git ${rbenv_dir}

profile_export='export PATH="${HOME}/.rbenv/bin:${PATH}"'
profile_eval='eval "$(rbenv init -)"'
[ -e ${HOME}/.bash_profile ] || touch ${HOME}/.bash_profile
grep "$profile_export" ${HOME}/.bash_profile >/dev/null || echo $profile_export >> ${HOME}/.bash_profile
grep "$profile_eval" ${HOME}/.bash_profile >/dev/null || echo $profile_eval >> ${HOME}/.bash_profile

build_dir=${HOME}/.rbenv/plugins/ruby-build
[ -d ${build_dir} ] || git clone git://github.com/sstephenson/ruby-build.git ${build_dir}

. ${HOME}/.bash_profile
rbenv rehash
rbenv install $1
