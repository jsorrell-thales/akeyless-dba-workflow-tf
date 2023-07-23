variable "access_id" {
  type        = string
  description = "value of the Akeyless API access id (This Access ID MUST be configured in the allowedAccessIDs of the Gateway or BE the adminAccessId for the Gateway)"
}

variable "access_key" {
  type        = string
  description = "value of the Akeyless API access key"
  sensitive   = true
}

variable "api_gateway_address" {
  type        = string
  description = <<-EOF
    value of the Akeyless Gateway 8081 port address 
    Examples:
    - http://localhost:8081 if using port forwarding
    - http://your-gateway-ip-address:8081 if using a port
    - https://your-gateway-api-address.com that maps to the 8081 port
    EOF
}