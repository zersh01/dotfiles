
#ALIASES
alias tailf='tail -f'
alias rscp='rsync -aP'
alias rsmv='rsync -aP --remove-source-files'
#apt install ipcalc
alias ipcalc='ipcalc -n '
alias gitc='git commit -a -m '
alias gitr='git reset HEAD~ '
#apt install lazygit
alias lg='lazygit'

#Terminal
EDITOR=/usr/bin/vim
PAGER=/usr/bin/less

export EDITOR PAGER PS1
export TERM=xterm-256color
export PERLDOC_POD2="ru"
export PYGMENTIZE_STYLE='paraiso-dark'
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'
export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[01;37m\]@\H\[\e[0m\]\[\e[00;37m\] \W\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

#Function
check_dnsbal(){
	echo "========ON default  DNS ======="
	dig $1
	echo "========ON Other-1,2,3======="
	dig +nocomments @NS1 $1
	dig +nocomments @NS2 $1
	dig +nocomments @NS3 $1
}

#restart network by one command
netrestart(){
    sudo ifconfig enp4s0 down
    sleep 2
    sudo ifconfig enp4s0 up
    sleep 5 
    ifconfig enp4s0
}

# ipmi serial-over-lan function
isol() {
   if [ -n "$1" ]; then
	echo "If you not connect to CONSOLE, run command manualy with option -P Password like:
>ipmitool -I lanplus -U ADMINUSER -P PASSWORD -H IP_ADDRESS sol activate

"
	ipmitool -I lanplus -U ADMINUSER -H $1 sol activate
   else
       echo "usage: isol <sol_ip>"
   fi
}

#Connect and forward window from remote libvirt server
vm(){
	ssh -X $1 "virt-manager --no-fork --connect=qemu:///system"
}

#Generate MAC by network name, or not
getmac(){
	if [ $1 ]; then
	  echo $1|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'
	else
	  echo -n 02; od -t x1 -An -N 5 /dev/urandom | tr ' ' ':'
	fi
}

grephost (){
	grep $1 /etc/hosts
}

#remove line by num from known_hosts
sedr(){
	sed -i "$1d" /home/zersh/.ssh/known_hosts
}

#Test logon to remote server
newkey (){
        ssh -i ~/.ssh/id_rsa_new_key $1 
}

#View the most important information about disks
smartview(){
        for i in $(lsblk --nodeps|grep -v "NAME" |awk '{print $1}'); do echo $i ;smartctl -a /dev/$i | grep "Reallocated_Sector_Ct\|Power_On_Hours\|Current_Pending_Sector\|rema" ;done
}

#list installed kernel - ubuntu
listkernel(){
        sudo dpkg --list | egrep -i --color 'linux-image|linux-headers'
}

