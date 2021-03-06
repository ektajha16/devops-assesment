output out_vpc_id {

    description = "This (string) vpc_id is the ID of the VPC that has just been created."
    value       = aws_vpc.this_vpc.id
}

output out_subnet_ids {

    description = "Every subnet ID in every availability zone of this VPC."
    value       = concat( aws_subnet.private.*.id, aws_subnet.public.*.id )
}


output out_private_subnet_ids {

    description = "The private subnet IDS in every availability zone of this VPC."
    value       = aws_subnet.private.*.id
}


output out_public_subnet_ids {

    description = "The public subnet IDS in every availability zone of this VPC."
    value       = aws_subnet.public.*.id
}
