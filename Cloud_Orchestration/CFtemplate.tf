resource "aws_cloudformation_stack" "CONetwork" {
    name = "CONetwork"
    template_body = file("${path.module}/CO_Network.yml")
}

resource "aws_cloudformation_stack" "CO_ASG" {
    name = "COASG"
    depends_on = [aws_cloudformation_stack.CONetwork]
    template_body = file("${path.module}/CO_ASG.yml")
}

resource "aws_cloudformation_stack" "COSwarmMaster" {
    name = "COSwarmMaster"
    depends_on = [aws_cloudformation_stack.CONetwork]
    template_body = file("${path.module}/CO_SwarmMaster.yml")
}