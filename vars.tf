#Definição de variáveis para o ambiente da VPCCIDR
  #Defione a Região
variable "region" {}

  #Defione o Range da rede a ser desmembrada
variable "main_vpc_cidr" {}

  #Defione as Redes Publicas
variable "public_subnets" {}

    #Defione as Redes Privadas
variable "private_subnets" {}
