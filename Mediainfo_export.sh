#!/bin/bash
############################################################################## 
#                                                                            #
#	SHELL: !/bin/bash       version 1	                                     #
#									                                         #
#	NOM: u2pitchjami						                                 #
#									                                         #
#							  					                             #
#									                                         #
#	DATE: 02/10/2024	           				                             #
#									                                         #
#	BUT: Contrôle intégrité des fichiers + durée                 		     #
#									                                         #
############################################################################## 

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ${SCRIPT_DIR}/.config.cfg
if [ ! -f $EXPORT_FILE ]
	then
	touch $EXPORT_FILE
    cat ${SCRIPT_DIR}/export_titles.txt >> $EXPORT_FILE
fi
echo -e "[`date`] - Démarrage du script" | tee -a "${LOG}"
NBFILMS=$(find "${BASE}" -type f -iname "*.mp4" -o -iname "*.mkv" | wc -l)
echo -e "$NBFILMS films à analyser" | tee -a "${LOG}"
for ((a=1; a<=$NBFILMS; a++))
do
FILMS=$(find "${BASE}" -type f -iname "*.mp4" -o -iname "*.mkv" | sort -d | head -$a | tail +$a)
FILMS_NAME=$(echo "$FILMS" | rev | cut -d "/" -f 1 | rev)
echo -e "Traitement du film $FILMS_NAME" | tee -a "${LOG}"
TEST_FILM=$(mediainfo --Inform="General;%CompleteName%" "${FILMS}" | rev | cut -d "/" -f 1 | rev)
TEST_FILM2=$(echo "$TEST_FILM" | cut -d "[" -f 1)

FILMIN=$(grep "^${TEST_FILM2}" "${EXPORT_FILE}")
    if [[ -n $FILMIN ]]
        then
        echo -e "Film déjà présent dans le fichier, au suivant..." | tee -a "${LOG}"
        else
        DATA=$(mediainfo --Inform=file://"${TEMPLATE}" "${FILMS}")
        echo "$TEST_FILM2,$DATA" >> $EXPORT_FILE
        echo -e "Film ajouté au fichier d'export" | tee -a "${LOG}"
    fi
done