#!/bin/bash
  for row in `cat $1`
  do
      if [ $(id -u) -eq 0 ]; then
          username=${row%:*}
          password=${row#*:}
          echo "Creando usuario: $username"
          #echo password
          egrep "^$username" /etc/passwd >/dev/null


          if [ $? -eq 0 ]; then
              echo "$username ya existe en el sistema"
              exit 1
          else
              #encriptamos el pasword para que cumpla los requisitos
              pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
              useradd -m -p $pass $username
              #obligamos a que el usuario cambie la password en la proxima entrada
              passwd -e $username
              [ $? -eq 0 ] && echo "$username ha sido añadido al sistema" || echo "Fallo al añadir $username al sistema"
          fi


      else
          echo "Solo el root puede añadir usuarios al sistema"
          exit 2
      fi
  done