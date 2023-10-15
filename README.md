# Terraform Overview & Examples<!-- omit in toc -->

## Contents <!-- omit in toc -->

- [1. What's Terraform?](#1-whats-terraform)
- [2. First steps in terraform](#2-first-steps-in-terraform)
- [3. Terraform HCL - Basic](#3-terraform-hcl---basic)
  - [3.1. Variables Types](#31-variables-types)
    - [3.1.1. Simple types](#311-simple-types)
    - [3.1.2. Complex types](#312-complex-types)
  - [3.2. Outputting attributes](#32-outputting-attributes)
- [4. Provisioning software](#4-provisioning-software)
- [5. Scenarios](#5-scenarios)
- [6. Packer](#6-packer)
- [7. DevOps using terraform](#7-devops-using-terraform)
- [8. CDK Terraform](#8-cdk-terraform)
- [9. Commands](#9-commands)

# 1. What's Terraform?

- Infrastructure as **Code** (IaC).
- **Automation** of your infrastructure.
- Keep your infrastructure in a certain **state** (compliant).
  - Example: 2 web instances with 2 volumes, and 1 load balancer.
- Make your infrastructure **auditable**.
  - You can keep your infrastructure change history in a version control system like **GIT**.
- Ansible, Chef, Puppet, Saltstack have a focus on automating the **installation and configuration** of software.
  - Keeping the **machines** in compliance, in a certain state.
- Terraform can automate provisioning of the **infrastructure itself.**
  - Example: Using the AWS, DigitalOcean, Azure API.
  - Works well with automation software like ansible to install software after the infrastructure is provisioned.
- **Terraform is not fit to do configuration management on the software on your machines.**

# 2. First steps in terraform

- Spinning up an instance on AWS:
  - Open AWS Account.
  - Create IAM admin `arn:aws:iam::aws:policy/AdministratorAccess `user.
  - Create terraform file to spin up `t2.micro` instance.
  - Run `terraform apply`.

# 3. Terraform HCL - Basic

- Terraform HCL (HashiCorp Configuration Language) syntax.

## 3.1. Variables Types

- Terraform variables were completely reworked for the terraform 0.12 release.
- You can now have **more control over the variables**, and have **for and for-each loops**, which where not possible with earlier versions.
- You don't have to specify the type in variables, but it's recommended.
- Everything in one file is not great.
- Use variables to **hide secrets**.
  - You don't want the AWS credentials in your git repository.
- Use variables for elements that **might change**.
  - AMIs are different per region.
- Use variables to make it yourself easier to reuse terraform files.

### 3.1.1. Simple types

- Terraform's simple variable types:
  - `String`
  - `Number`
  - `Bool`
- Examples:

  ```
    # var.a-string OR "${var.a-string}"
    variable "a-string" {
      type    = string
      default = "Hello World!"
    }

    # var.this-is-a-number
    variable "this-is-a-number" {
      type    = number
      default = 10
    }

    # var.true-or-false
    variable "true-or-false" {
      type    = bool
      default = true
    }
  ```

### 3.1.2. Complex types

- Terraform's complex types:
  - `List(type)`
    - A `list` is always ordered, it'll always return 0, 1, 5, 2 and not 5, 1, 2, 0.
  - `Set(type)`
    - A `set` is like a list, but it doesn't keep the order you put it in, and can only contain unique values.
    - A `list` that has [5, 1, 1, 2] becomes [1, 2, 5] in a `set` (when you output it, terraform will sort it).
  - `Map(type)`
  - `Object({<ATTR NAME> = <TYPE>, ... })`
    - An `object` is like a `map`, but each element can have a different type.
  - `Tuple([<TYPE>, ...])`
    - An `tuple` is like a `list`, but each element can have a different type.
- The most common types are `list` and `map`, the other ones are only used sporadically.
- The ones you should remember are the simple variable types `string`, `number`, `bool` and the `list` & `map`.
- Examples:

  ```
    # var.this-is-a-list
    # var.this-is-a-list[0]
    # element(var.this-is-a-list, 2)
    # slice(var.this-is-a-list, 0, 2)
    variable "this-is-a-list" {
      type    = list(number)
      default = [12, 21, 32]
    }

    # var.this-is-a-map OR "${var.this-is-a-map}"
    # var.this-is-a-map["mykey1"]
    variable "this-is-a-map" {
      type = map(string)
      default = {
        mykey1 = "my_value_1",
        mykey2 = "my_value_2",
      }
    }

    # var.AWS_REGION
    variable "AWS_REGION" {
      type = string
    }

    # var.AMIS[var.AWS_REGION]
    variable "AMIS" {
      type = map(string)
      default = {
        "eu-west-1" = "my_ami_1",
        "sa-east-1" = "my_ami_2"
      }
    }

    # var.this-is-an-object
    # var.this-is-an-object.firstname
    variable "this-is-an-object" {
      type = object({
        firstname   = string,
        housenumber = number
      })
      default = {
        firstname   = "Jefté",
        housenumber = 112
      }
    }

    # var.this-is-a-tuple
    # var.this-is-a-tuple[1]
    variable "this-is-a-tuple" {
      type    = tuple([number, string, bool])
      default = [0, "test", false]
    }
  ```

## 3.2. Outputting attributes

- Terraform keeps **attributes** of all the **resources** you create.
  - Example: the `aws_instance` resource has the **attribute** `public_ip`.
- Those attributes can be **queried** and **outputted**.
- This can be useful just to output valuable information or to feed information to external software.
- Use **output** to display the public IP address of an AWS resource:

  ```
    resource "aws_instance" "my_ec2_via_terraform" {
      ami           = lookup(var.AMIS, var.AWS_REGION)
      instance_type = "t2.micro"
    }

    output "my_ip" {
      value = aws_instance.my_ec2_via_terraform.public_ip
    }
  ```

- You can refer to any attribute by specifying the following elements in your variable:
  - The resource type: `aws_instance`.
  - The resource name: `example`.
  - The attribute name: `public_ip`.
- You can also use the attributes in a script:

  ```
    resource "aws_instance" "my_ec2_via_terraform" {
      ami           = lookup(var.AMIS, var.AWS_REGION)
      instance_type = "t2.micro"

      provisioner "local-exec" {
        command = "echo ${aws_instance.my_ec2_via_terraform.private_ip} >> private_ips.txt"
      }
    }
  ```

- Useful for instance to start automation scripts after infrastructure provisioning.
- You can populate the IP addresses in an **ansible host** file.
- Or another possibility: execute a script (with attributes as argument) which will take care of a mapping of resource name and the IP address.

# 4. Provisioning software

- There are 2 ways to provision software on your instances:
  1. You can build your own custom AMI and bundle your software with the image.
     - **Packer** is a great tool to do this.
  2. Another way is to boot standardized AMIs, and then install the software on it you need:
     - Using file uploads.
     - Using `remote-exec`.
     - Using automation tools like **Chef**, **Puppet**, **Ansible**.
- **Current state** for terraform with automation (Q4 2016):
  - Chef is integrated within terraform, you can add chef statements.
  - You can run **puppet agent** using `remote-exec`.
- For **Ansible**, you can first run terraform, and output the IP addresses, then run `ansible-playbook` on those hosts.
  - This can be automated in a workflow script.
  - There are 3rd party initiatives integrating **Ansible** with terraform.

# 5. Scenarios

| Scenario                              | Description                                |
| ------------------------------------- | ------------------------------------------ |
| [Scenario_1](/Laboratory/Scenario_1/) | Small example with good practices.         |
| [Scenario_2](/Laboratory/Scenario_2/) | Provisioning software (like EC2 User Data) |
| [Scenario_3](/Laboratory/Scenario_3/) | Provisioning Microsoft Windows Server      |
| [Scenario_4](/Laboratory/Scenario_4/) | Outputting attributes                      |

# 6. Packer

- Packer is a commandline tool that can build AWS AMIs based on templates.
- Instead of installing the software after booting up an instance, you can create an AMI with all the necessary software on.
- This can speed up boot times of instances
- It's a common approach when you run a horizontally scaled app layer or a cluster of something.
- It might not be very useful to do this on single instances that cannot be terminated (e.g. a database).

# 7. DevOps using terraform

- Terraform is a great fit in a DevOps minded organization.
- Tools like Terraform and Packer can be used in the Software Development Lifecycle:

# 8. CDK Terraform

- CDKTF is a **new way to provisioning using terraform**.
- Instead of writing code in .tf files using HCL (the HashiCorp Configuration Language), you can use a **programming language to write the provisioning code**.
  - Supported languages are currently:
    - TypeScript
    - Python
    - Java
    - C#
    - GO.
- In the same way you write application code, you can write code that **when executed with CDKTF, it will provision your infrastructure** (just like you are used to do with terraform apply).
  - To do this, CDKTF will translate (synthesize) your application code into terraform files that can then be deployed by terraform.
- Using CDKTF opens the way for developers to **write provisioning code** in **the same way as they develop their applicaiton**.
  - They can use the same tools (like their IDE) to write provisioning code.
  - They can add more logic to the code provisioning, by leveraging the existing tools of the programming language (conditionals, specific input/outputs, testing, abstractions).
- CDKTF is based on the **same technology as the AWS Cloud Development Kit (AWS CDK)**.

# 9. Commands

- Try Terraform expressions at an interactive command prompt.
  - `terraform console`
- Prepare your working directory for other commands.
  - `terraform init`
- Create or update infrastructure.
  - `terraform apply`
- Destroy previously-created infrastructure.
  - `terraform destroy`
- Show changes required by the current configuration.
  - `terraform plan`

```

```
