<html xml:lang="en" lang="en">
<head> 
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>%%HOSTNAME%% HPC Cluster</title>
    <link type="text/css" rel="stylesheet" href="global_styles.css">
</head>

<body class="grd">

<hr>

<h1>Welcome to the %%HOSTNAME%% HPC Cluster</h1>

<hr>

<h2>Current %%HOSTNAME%% Status</h2>

<p>
Below are links to optional monitoring suites such as Nagios.
</p>

<?php if ( is_dir("%%LOCALBASE%%/www/nagios") ): ?>
    <p><a href="nagios/">Nagios Resource Monitor</a></p>
<?php endif; ?>

<?php if ( is_dir("%%LOCALBASE%%/www/ganglia") ): ?>
    <p><a href="ganglia/">Ganglia Resource Monitor</a></p>
<?php endif; ?>

<?php if ( is_dir("%%LOCALBASE%%/www/munin") ): ?>
    <p><a href="munin/">Munin Resource Monitor</a></p>
<?php endif; ?>

<h2>FreeBSD Ports Collection</h2>

<p>
%%HOSTNAME%% runs a Unix variant called FreeBSD, which has one of the most
extensive pre-packaged software collections of any operating system, known
as the "FreeBSD ports" collection.  Most mainstream open source software
can be installed in seconds using FreeBSD ports.  For more information,
please visit the ports web page:

<p>
<a href="http://www.freebsd.org/ports/">https://www.freebsd.org/ports/</a>

<p>
Software not currently included in the FreeBSD ports collection can also
be installed manually or using other tools such as pkgsrc, pip, conda, or
install.packages() of BiocManager::install() under R.

<p>
<img style="float:right" src="powerlogo.gif" alt="[Powered by FreeBSD]">

</body>
</html>
