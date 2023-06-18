output "lb_ipv4" {
  description = "Web server IP address"
  value = hcloud_server.web.*.ipv4_address
}