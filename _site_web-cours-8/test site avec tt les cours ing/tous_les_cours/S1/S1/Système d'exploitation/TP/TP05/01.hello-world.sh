#!/bin/bash
clear

##########################################################################
## Programme : 01.hello-world.sh                                        ##
## Acces     : SE                                                       ##
## But       : Installation docker                                      ##
##                                                                      ##
## Arguments                                                            ##
## - IN      : neant                                                    ##
## - IN#OUT  : neant                                                    ##
## - OUT     : neant                                                    ##
## Retour    : neant                                                    ##
##                                                                      ##
## Historique                       Date        Version  par            ##
## Création de 01.hello-world.sh    25/11/2022  1.0.00   Alain          ##
##########################################################################

sudo docker run hello-world
sudo docker images

#docker rmi $(docker images -a -q) -f
#docker rm $(docker ps -a -q) -f
