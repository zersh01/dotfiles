
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
#reload alias or functions without relogin shell
alias reload='source ~/.bashrc'
#find only files
alias ffind="find . -type f"
#find only dirs
alias dfind="find . -type d"
#fast check network connection
alias conn="ping -c 3 google.com"

#Terminal
EDITOR=/usr/bin/vim
PAGER=/usr/bin/less

export EDITOR PAGER PS1
export TERM=xterm-256color
export PERLDOC_POD2="ru"
export PYGMENTIZE_STYLE='paraiso-dark'
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'
#http://bashrcgenerator.com/
export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[01;37m\]@\H\[\e[0m\]\[\e[00;37m\] \W\[\e[0m\]\[\e[01;37m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

#A simple function for checking the hostname in multiple DNS servers
check_dns(){
	echo "========ON default  DNS ======="
	dig $1
	echo "========ON Other-1,2,3======="
	#Google
	dig +nocomments @8.8.8.8 $1
	#Cloudflare
	dig +nocomments @1.1.1.1 $1
	#Yandex
	dig +nocomments @77.88.8.8 $1
}

#restart network by one command
netrestart(){
    sudo ifconfig enp4s0 down
    sleep 2
    sudo ifconfig enp4s0 up
    sleep 5 
    ifconfig enp4s0
}

#ipmi serial-over-lan function
isol() {
   if [ -n "$1" ]; then

     if [ $2 == "sol" ];then
        ipmitool -I lanplus -U ADMIN -H $1 sol activate
     fi
     if [ $2 == "shell" ];then
        ipmitool -I lanplus -U ADMIN -H $1 shell
     fi
   else
       echo "Usage:  isol ip_address sol | shell
"
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

#list installed kernel - ubuntu|centos
listkernel(){
        apt-get -v &> /dev/null && sudo dpkg --list | egrep -i --color 'linux-image|linux-headers'
        which yum &> /dev/null && rpm -qa kernel
        #may use one line
        #python -mplatform | grep -qi Ubuntu && echo ubuntu || echo centos
}

#clone git and cd project folder
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

mem2page(){
        if [ $1 ]; then
                for i in $@; do 
                        echo "$i * 1024 * 1024 / 4096" |bc 
                done
        else
                echo "Usage: mem2page NUM-in-MB 

calculate how many pages of memory (4kB each) in megabytes. 
E.q. for net.ipv4.tcp_mem"
        fi
}


page2mem() {
        if [ $1 ]; then
                for i in $@; do 
            	    echo "$i / 1024 / 1024 * 4096"|bc -l |awk -F. '{print $1}'
		done
        else
                echo "Usage: page2mem NUM-in-MB 

calculate how many memory (megabytes) in page (4kB each). 
E.q. for net.ipv4.tcp_mem"
        fi
}

#check dates and dns names in https server
ssl-check(){
        if [ $# -eq 0 ];then
                echo "Usage:
Short check:
        ssl-check doman:port

Check on specific host:
        ssl-check domain ip:port
               "
        fi

        if [ $2 ];then
            openssl s_client -servername $1 -connect $2 -showcerts -prexit </dev/null 2>/dev/null |sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -text 2>/dev/null |grep "Not Before\|Not After\|DNS:"
        else
            openssl s_client -showcerts -connect $1 -showcerts -prexit </dev/null 2>/dev/null |sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -text 2>/dev/null |grep "Not Before\|Not After\|DNS"
        fi
}

#print column by number
awkt() { awk "{print \$${1:-1}}"; }
