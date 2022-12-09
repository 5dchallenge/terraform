variable "instance_count" {
  type        = number
  description = "number of instances to launch"
  default     = 1
}

variable "ami" {
  type        = string
  description = "Image ID"
  default     = "ami-02ee763250491e04a"

  validation {
    condition = (
      length(var.ami) > 4 &&
      substr(var.ami, 0, 4) == "ami-"
    )
    error_message = "Please provide a valiid AMI id, starting with \"ami-\"."
  }

}

variable "instance_type" {
  type        = string
  description = "Type of Instance"
  default     = "t2.micro"
}



variable "disable_api_termination" {
  type        = bool
  description = "Enable Termination Protection"
  default     = true
}


variable "tags" {
  type = object({
    Name       = string
    App        = string
    Maintainer = string
    Role       = string
  })
  description = "SSH Key Pair to Create"
  default = {
    Name       = "tf-frontend-01"
    App        = "devops-demo"
    Maintainer = "Devops Demo"
    Role       = "frontend"
  }
}

