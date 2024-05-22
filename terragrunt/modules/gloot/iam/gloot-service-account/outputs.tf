
output "refresh_token" {
  value = zipmap([
    for k, v in gloot_refresh_token.token :
    k
    ], [
    for k, v in gloot_refresh_token.token :
    base64decode(v.refresh_token)
  ])
}
