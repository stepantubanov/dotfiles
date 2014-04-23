# ---------------------------------------------------------------------------
# Pretty Git Log (grb)
# ---------------------------------------------------------------------------
# Log output:
#
# * 51c333e    (12 days)    <Gary Bernhardt>   add vim-eunuch
#
# The time massaging regexes start with ^[^<]* because that ensures that they
# only operate before the first "<". That "<" will be the beginning of the
# author name, ensuring that we don't destroy anything in the commit message
# that looks like time.
#
# The log format uses } characters between each field, and `column` is later
# used to split on them. A } in the commit subject or any other field will
# break this.

glog() {
  local commit_hash="%C(yellow)%h%Creset"
  local relative_time="%Cgreen(%ar)%Creset"
  local author="%C(bold 075)<%an>%Creset"
  local refs="%C(red)%d%Creset"
  local subject="%s"

  local format="$commit_hash}$relative_time}$author}$refs $subject"
  git log --graph --pretty="tformat:${format}" $* |
      # Replace (2 years ago) with (2 years)
      sed -Ee 's/(^[^<]*) ago\)/\1)/' |
      # Replace (2 years, 5 months) with (2 years)
      sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1)/' |
      # Line columns up based on } delimiter
      column -s '}' -t |
      # Page only if we need to
      less -FXRS
}

# Only 15 last
alias glor="glog -15"
alias bi="bundle exec"
