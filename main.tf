Create the VPC
 resource "aws_vpc" "Main" {                # Criando VPC 
   cidr_block       = var.main_vpc_cidr     # Aqui Definimos o Range de Ip da Rede a Ser Segmentada 10.0.0.0/24 
   instance_tenancy = "default"
 }
 Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    # Cria Internet Gateway
    vpc_id =  aws_vpc.Main.id               # Insere o vpc_id Da vpc Main após a sua Criação
 }
 Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    # Cria Subnet Publica
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.public_subnets}"        # Insere a variável para criação do bloco de rede publica
 }
 Create a Private Subnet                   # Cria rede Priovada
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnets}"          #  Insere a variável para criação do bloco de rede privada
 }
 Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    # Creating Route Table da rede publica
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               # Rota padrão de saida pelo internet gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
 }
 Route table for Private Subnet's
 resource "aws_route_table" "PrivateRT" {    # Creating Route Table da rede Privada
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Rota padrão daz rede privada via Nat Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }
 Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
 resource "aws_eip" "nateIP" {
   vpc   = true
 }
 Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
 }
