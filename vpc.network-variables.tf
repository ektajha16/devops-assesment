
### ########### ###
### in_vpc_cidr ###
### ########### ###

variable in_vpc_cidr {

    description = "The CIDr block defining the range of IP addresses allocated to this VPC."
    default     = "10.42.0.0/16"
    type        = string
}


### ###################### ###
### in_num_private_subnets ###
### ###################### ###

variable in_num_private_subnets {

    description = "The number of private subnets to create."
    default     = 1
    type        = number
}


### ##################### ###
### in_num_public_subnets ###
### ##################### ###

variable in_num_public_subnets {

    description = "The number of public subnets to create (defaults to 3 if not specified)."
    default     = 1
    type        = number
}


### ############## ###
### in_subnets_max ###
### ############## ###

variable in_subnets_max {

    description = "Two to the power of in_subnets_max is the maximum number of subnets carvable from VPC described by in_vpc_cidr."
    default     = 4
    type        = number
}




### ############ ###
### in_ecosystem ###
### ############ ###

variable in_ecosystem {
    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
    default = "vpc-network"
    type    = string
}


### ############ ###
### in_timestamp ###
### ############ ###

variable in_timestamp {
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
    default     = "timestamp"
    type        = string
}


### ############## ###
### in_description ###
### ############## ###

variable in_description {
    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
    default     = "This VPC network was created for an ecosystem."
    type        = string
}
