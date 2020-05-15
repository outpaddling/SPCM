{
    if ( $0 ~ "DirectoryIndex index.html" )
    {
	print "    DirectoryIndex index.php";
	print $0;
    }
    else if ( $0 ~ "ScriptAlias /cgi-bin/" )
    {
	print $0;
	print "    Alias /ganglia/ \"/usr/local/www/ganglia/\"";
    }
    else if ( $0 ~ "<IfModule mime_module>" )
    {
	print "<Directory \"/usr/local/www/ganglia\">";
	print "    Options Indexes FollowSymlinks MultiViews";
	print "    AllowOverride None";
	print "    Require all granted";
	print "</Directory>";
	print "";
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

