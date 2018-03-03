#!/bin/bash

#######################################################
# Date       | Auteur | Description                   
# DD/MM/YYYY | MJA    | Initialisation du script      
#######################################################

# Verification de l utilisateur
user=$(whoami)

# Definition des variables
var1="var1"
var2="var2"

# Fonctions
ma_fonction() {
echo "ma fonction"
}

# Logs
NOW=$(date +"%d/%m/%Y-%H:%M:%S")
echo "[${NOW}][INFO] :" | tee -a $fichier_log

# IF
if [ $? -ne 0 ]                            # Test du code retour
if [ "$var" != "var" ]                     # Test chaine de caractere

# FOR
for valeur in $liste                       # Parcourir valeurs d'une variable 
for valeur in ${tab[*]}                    # Parcourir valeurs d'un tableau

# Redirection
echo "redirection" > mon_fichier           # Ecrasement du fichier
echo "redirection" >> mon_fichier          # Ajout a la fin du fichier
echo "redirection" > /dev/null 2>&1        # Redirection des 2 sorties dans null

# Affichage
printf "ligne 1 \nligne 2"                 # Passage a la ligne

# Decompression
tar xjf /tmp/fichier.tar.bz2 -C /tmp > /dev/null 2>&1

# MySQL
mysql -u $sql_user -p$sql_pass -e "select...;"

# SED
sed -i -e "s/a remplacer/le remplacant/g" mon_fichier    # Remplacer une chaine par une autre

# Tableaux
echo ${mon_tab[$index]}                         # Afficher valeur associée à l'index