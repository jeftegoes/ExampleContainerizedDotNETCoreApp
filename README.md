# Terraform Overview & Examples<!-- omit in toc -->

## Contents <!-- omit in toc -->

- [1. What's Terraform?](#1-whats-terraform)
- [2. Terraform HCL](#2-terraform-hcl)
  - [2.1. Variables Types](#21-variables-types)
    - [2.1.1. Simple types](#211-simple-types)
    - [2.1.2. Complex types](#212-complex-types)
    - [2.1.3. List variable](#213-list-variable)
- [3. Commands](#3-commands)

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

# 2. Terraform HCL

- Terraform HCL (HashiCorp Configuration Language) syntax.

## 2.1. Variables Types

- Terraform variables were completely reworked for the terraform 0.12 release.
- You can now have **more control over the variables**, and have **for and for-each loops**, which where not possible with earlier versions.
- You don't have to specify the type in variables, but it's recommended.

### 2.1.1. Simple types

- Terraform's simple variable types:
  - `String`
  - `Number`
  - `Bool`
- Examples:

  ```
    variable "a-string" {
      type = string
    }

    variable "this-is-a-number" {
      type = number
    }

    variable "true-or-false" {
      type = bool
    }

    # var.myvar OR "${var.myvar}"
    variable "myvar" {
      type    = string
      default = "Hello Terraform!"
    }
  ```

### 2.1.2. Complex types

- Terraform’s complex types:

  - `List(type)`
  - `Set(type)`
  - `Map(type)`
  - `Object({<ATTR NAME> = <TYPE>, ... })`
  - `Tuple([<TYPE>, ...])`

- Examples:

```
  # var.mymap OR "${var.mymap}"
  # var.mymap["mykey1"]
  variable "mymap" {
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
```

### 2.1.3. List variable

```
  # var.mylist
  # var.mylist[0]
  # element(var.mylist, 2)
  # slice(var.mylist, 0, 2)
  variable "mylist" {
    type    = list(number)
    default = [1, 2, 3]
  }
```

# 3. Commands

- Try Terraform expressions at an interactive command prompt
- `terraform console`
- Prepare your working directory for other commands
- `terraform init`

```

```
