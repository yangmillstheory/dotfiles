backup() {
  suffix=`date +%Y-%m-%d.%H%M.bak`
  for f in $@; do
    echo mv $f $f.$suffix
    echo cp -p $f.$suffix $f
  done | sh -x
}

v() {
  if [ $# -gt 0 ]; then
    nvim --cmd "echom 'Started nvim with args: $*'" "$@"
  elif [ -f Session.vim ]; then
    nvim --cmd "echom 'Session.vim found. Loaded session.'" -S Session.vim
  else
    nvim --cmd "echom 'No Session.vim found. Started Obsession.'" -c Obsession
  fi
}
