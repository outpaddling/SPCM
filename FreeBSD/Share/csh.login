if ( ! -e ~/.ssh/authorized_keys ) then
    if ( ! -e ~/.ssh/id_rsa.pub ) then
	ssh-keygen -f ~/.ssh/id_rsa -N ''
    endif
    cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys 
    chmod 600 ~/.ssh/authorized_keys
endif

