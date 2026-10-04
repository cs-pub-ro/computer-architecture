sdc_user_info() {
  printf 'User: %s\n' "$(id -un)"
  printf 'Groups: %s\n' "$(id -Gn)"
  printf 'Repository: %s\n' "${SDC_ROOT:-unset}"
}
