# Introduction   


**High Availability:**   
La haute disponibilité permet d'assurer et de garantir le bon fonctionnement des services ou applications et ce 7j/7 et 24h/24.
La disponibilité est aujourd'hui un enjeu important pour les infrastructures informatiques. 
Deux moyens complémentaires sont utilisés pour améliorer la disponibilité :   
- la mise en place d'une infrastructure matérielle spécialisée, généralement en se basant sur de la redondance matérielle. 
Est alors créé un cluster de haute-disponibilité; une grappe d'ordinateurs dont le but est d'assurer un service en évitant au maximum les indisponibilités;
- la mise en place de processus adaptés permettant de réduire les erreurs, et d'accélérer la reprise en cas d'erreur. 


**Fault tolerance:**   
Fault Tolerance est une fonctionnalité qui va permettre de donner de la haute disponibilité voir de la disponibilité quasi total d'une machine virtuelle critique. Conçu pour qu'une machine virtuelle secondaire puisse reprendre immédiatement sans aucune perte de service lorsque survient une panne.      
Quand Fault Tolerance est activée, vCenter Server réinitialise la limite de mémoire de la VM et définit la réservation de mémoire en fonction de la taille de la mémoire de la VM.   
Si Fault Tolerance reste activée, il n'est pas possible de modifier la réservation de mémoire, sa taille, la limite, le nombre de vCPU ou les partages.   
Il est également impossible d'ajouter ou de supprimer des disques pour la machine virtuelle. Quand Fault Tolerance est désactivée, les valeurs d'origine de tous les paramètres qui ont été modifiés ne sont pas restaurées.   

# Prérequis:
L'option permettant d'activer Fault Tolerance n'est pas disponible si l'une de ces conditions s'applique :   
- La machine virtuelle réside sur un hôte qui n'a pas de licence pour la fonction.   
- La machine virtuelle réside sur un hôte qui est dans le mode maintenance ou le mode standby.   
- La machine virtuelle est déconnectée ou orpheline (son fichier .vmx n'est pas accessible).   
- L'utilisateur n'a pas l'autorisation d'activer la fonction.


# Procédure   

1. Dans vSphere Client, accédez à la VM pour laquelle vous souhaitez activer Fault Tolerance   
2. Cliquez avec le bouton droit sur la machine virtuelle et sélectionnez Fault Tolerance > Activer Fault Tolerance.
3. Cliquez sur Yes.   
4. Choisissez une banque de données sur laquelle placer les fichiers de configuration de la machine virtuelle secondaire. Puis cliquez sur Suivant.   
5. Choisissez un hôte sur lequel placer la machine virtuelle secondaire. Puis cliquez sur Suivant.   
6. Passez vos sélections en revue et cliquez sur Terminer.   
