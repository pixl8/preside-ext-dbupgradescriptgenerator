<cfscript>
	generatedScript = rc.script ?: "";
</cfscript>

<cfoutput>
	<p class="alert alert-success"><i class="fa fa-fw fa-check"></i> #translateResource( "cms:dbupgradescriptgenerator.success.message" )#</p>

	<pre><code>#generatedScript#</code></pre>
</cfoutput>