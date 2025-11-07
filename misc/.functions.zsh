backup() {
  suffix=`date +%Y-%m-%d.%H%M.bak`
  for f in $@; do
    echo mv $f $f.$suffix
    echo cp -p $f.$suffix $f
  done | sh -x
}

v() {
  if test $# -gt 0; then
    echo "Starting nvim with args $@."
    sleep 1
    env nvim "$@"
  elif test -f Session.vim; then
    echo "Session.vim found. Starting nvim -c -S Session.vim."
    sleep 1
    env nvim -S Session.vim
  else
    echo "No Session.vim found. Running nvim -c Obsession."
    sleep 1
    env nvim -c Obsession
  fi
}
