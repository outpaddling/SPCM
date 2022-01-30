{
    if ( $0 ~ "DirectoryIndex index.html" )
    {
	print "    DirectoryIndex index.php";
	print $0;
    }
    else if ( $0 ~ "AddOutputFilter INCLUDES .shtml" )
    {
	print $0;
	print "AddType application/x-httpd-php .php";
	print "AddType application/x-httpd-php-source .phps";
    }
    else
	print $0;
}

