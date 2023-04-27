#!/bin/bash
CAT1=$(cat ~/.ssh/known_hosts)
SUBSTR=("localhost]:2222" "localhost]:2200")
LCLHST=$(cat ~/.ssh/known_hosts | grep $SUBSTR)
for i in "${SUBSTR[@]}"; do
    if [[ $LCLHST == *"$SUBSTR"* ]]; then {
        sed -i.bak "/$SUBSTR/d" ~/.ssh/known_hosts # Удаляем запись если есть
        echo "Из файла ~/.ssh/known_hosts удалена строка содержащая localhost, создан файл бэкапа"
    }
    fi
done
ssh -o StrictHostKeyChecking=no -q vagrant@localhost -p 2222